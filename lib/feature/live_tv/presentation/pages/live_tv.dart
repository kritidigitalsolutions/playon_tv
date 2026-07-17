import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playon/core/models/response/channel_model.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/core/widgets/animated.dart';
import 'package:playon/core/widgets/app_button.dart';
import 'package:playon/core/widgets/app_tab_bar.dart';
import 'package:playon/core/widgets/app_text_field.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/feature/home/bloc/banner_ads/banner_ads_bloc.dart';
import 'package:playon/feature/live_tv/bloc/channel_catagory/channel_catagory_bloc.dart';
import 'package:playon/feature/live_tv/bloc/channels/channels_bloc.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_image.dart';
import 'package:playon/static/app_navigation.dart';

class LiveTv extends StatefulWidget {
  const LiveTv({super.key});

  @override
  State<LiveTv> createState() => _LiveTvState();
}

class _LiveTvState extends State<LiveTv> {
  late final TextEditingController _searchController;
  int selectedIndex = 0;

  Timer? _searchDebounce;
  static const _searchDebounceDuration = Duration(milliseconds: 450);

  // --- Classic TV-style channel number entry (remote control digits) ---
  final FocusNode _channelInputFocusNode = FocusNode(
    debugLabel: 'ChannelNumberInput',
  );
  String _channelNumberBuffer = '';
  Timer? _channelNumberBufferTimer;
  static const _channelNumberBufferTimeout = Duration(seconds: 2);
  static const _maxChannelDigits = 4; // adjust to your longest channel number
  // ----------------------------------------------------------------------

  final List images = [
    {"id": 1, "images": AppImage.background},
    {"id": 2, "images": AppImage.background},
    {"id": 3, "images": AppImage.background},
    {"id": 4, "images": AppImage.background},
  ];

  @override
  void initState() {
    super.initState();
    context.read<ChannelCatagoryBloc>().add(
      ChannelCatagoryEvent.allChannelCategory(),
    );
    context.read<ChannelsBloc>().add(const ChannelsEvent.allChannels());
    context.read<BannerAdsBloc>().add(const BannerAdsEvent.fetchBannerAds());

    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchDebounce?.cancel();
    _channelNumberBufferTimer?.cancel();
    _channelInputFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();

    _searchDebounce?.cancel();
    _searchDebounce = Timer(_searchDebounceDuration, () {
      if (!mounted) return;
      context.read<ChannelsBloc>()
        ..add(ChannelsEvent.search(query))
        ..add(const ChannelsEvent.allChannels());
    });
  }

  void _clearSearch() {
    _searchController.clear();
  }

  void _openChannel(BuildContext context, ChannelModel channel) {
    AppNavigation.push(context, "liveChannelDetail/${channel.slug}");
  }

  List<ChannelModel> _filter(List<ChannelModel> channels, String selectedTab) {
    if (selectedTab == "ALL") return channels;
    return channels
        .where((c) => (c.category).toUpperCase() == selectedTab.toUpperCase())
        .toList();
  }

  // --- Remote digit key -> channel number buffer handling ---
  static final Map<LogicalKeyboardKey, String> _digitKeys = {
    LogicalKeyboardKey.digit0: '0',
    LogicalKeyboardKey.digit1: '1',
    LogicalKeyboardKey.digit2: '2',
    LogicalKeyboardKey.digit3: '3',
    LogicalKeyboardKey.digit4: '4',
    LogicalKeyboardKey.digit5: '5',
    LogicalKeyboardKey.digit6: '6',
    LogicalKeyboardKey.digit7: '7',
    LogicalKeyboardKey.digit8: '8',
    LogicalKeyboardKey.digit9: '9',
    LogicalKeyboardKey.numpad0: '0',
    LogicalKeyboardKey.numpad1: '1',
    LogicalKeyboardKey.numpad2: '2',
    LogicalKeyboardKey.numpad3: '3',
    LogicalKeyboardKey.numpad4: '4',
    LogicalKeyboardKey.numpad5: '5',
    LogicalKeyboardKey.numpad6: '6',
    LogicalKeyboardKey.numpad7: '7',
    LogicalKeyboardKey.numpad8: '8',
    LogicalKeyboardKey.numpad9: '9',
  };

  KeyEventResult _handleChannelNumberKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final digit = _digitKeys[event.logicalKey];

    // Digit pressed -> append to buffer, (re)start the 2-second timer
    if (digit != null) {
      _channelNumberBufferTimer?.cancel();
      setState(() {
        _channelNumberBuffer += digit;
        if (_channelNumberBuffer.length > _maxChannelDigits) {
          _channelNumberBuffer = _channelNumberBuffer.substring(
            _channelNumberBuffer.length - _maxChannelDigits,
          );
        }
      });
      _channelNumberBufferTimer = Timer(
        _channelNumberBufferTimeout,
        _submitChannelNumberBuffer,
      );
      return KeyEventResult.handled;
    }

    // OK/Enter/Select on remote -> confirm immediately, don't wait 2 sec
    if (_channelNumberBuffer.isNotEmpty &&
        (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.numpadEnter ||
            event.logicalKey == LogicalKeyboardKey.select)) {
      _channelNumberBufferTimer?.cancel();
      _submitChannelNumberBuffer();
      return KeyEventResult.handled;
    }

    // Back/Escape -> clear whatever was typed so far
    if (_channelNumberBuffer.isNotEmpty &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      _channelNumberBufferTimer?.cancel();
      setState(() => _channelNumberBuffer = '');
      return KeyEventResult.handled;
    }

    // Anything else (arrow keys etc.) -> let normal TV focus navigation handle it
    return KeyEventResult.ignored;
  }

  void _submitChannelNumberBuffer() {
    if (_channelNumberBuffer.isEmpty) return;
    final typed = _channelNumberBuffer;
    final typedAsInt = int.tryParse(typed);

    final allChannels = context.read<ChannelsBloc>().state.channels;
    ChannelModel? match;
    for (final c in allChannels) {
      final chNum = c.channelNumber.toString();
      if (chNum == typed ||
          (typedAsInt != null && int.tryParse(chNum) == typedAsInt)) {
        match = c;
        break;
      }
    }

    setState(() => _channelNumberBuffer = '');

    if (match != null) {
      _openChannel(context, match);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Text('Channel $typed not found'),
        ),
      );
    }
  }
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isTV = size.width > 1280 || size.height > 720;

    final channelCategories = context
        .watch<ChannelCatagoryBloc>()
        .state
        .channelCatagoryList;

    // Manually add "ALL" at the beginning of the tab list
    final List<String> tabNames = ['ALL'];
    tabNames.addAll(channelCategories.map((e) => e.name).toList());

    // Ensure selectedIndex is valid
    if (selectedIndex >= tabNames.length) {
      selectedIndex = 0;
    }

    final selectedTab = tabNames.isNotEmpty ? tabNames[selectedIndex] : "ALL";

    // TV-optimized grid dimensions.
    // NOTE: childAspectRatio is NOT fixed anymore — it's computed at
    // build time inside a LayoutBuilder from the real available width,
    // targeting a fixed card content height. That keeps card height
    // constant/responsive across phones, tablets, and TVs instead of
    // stretching taller as the screen gets wider.
    final crossAxisCount = isTV ? 6 : 3; // 3 columns on mobile/tablet
    final crossAxisSpacing = isTV ? 22.0 : 12.0;
    final mainAxisSpacing = isTV ? 20.0 : 12.0;
    // Fixed target height for a card's content (logo row + name +
    // category + Watch button + CH number + internal paddings).
    // Tune this single number to make every card taller/shorter.
    final cardContentHeight = isTV ? 210.0 : 150.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Focus(
        focusNode: _channelInputFocusNode,
        onKeyEvent: _handleChannelNumberKey,
        child: Stack(
          children: [
            BackgroundWithOneLight(
              child: SafeArea(
                child: Column(
                  children: [
                    // Fixed header with TV-optimized spacing
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTV ? 32 : 16,
                        vertical: isTV ? 20 : 12,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Live TV Channels",
                            style: TextStyle(
                              fontSize: isTV ? 28 : 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white
                            ),
                          ),
                          SizedBox(width: isTV ? 40 : 20),
                          Expanded(
                            child: ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _searchController,
                              builder: (context, value, _) {
                                return AppTextField(
                                  
                                  controller: _searchController,
                                  autofocus: !isTV,
                                  hintText: "Search Channel",
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 14,
                                      right: 10,
                                    ),
                                    child: Icon(
                                      Icons.search,
                                      size: isTV ? 28 : 22,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  suffixIcon: value.text.isEmpty
                                      ? null
                                      : IconButton(
                                          icon: Icon(
                                            Icons.close,
                                            size: isTV ? 28 : 20,
                                            color: AppColors.textSecondary,
                                          ),
                                          onPressed: _clearSearch,
                                        ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Category tabs with "ALL" manually added
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTV ? 32 : 16,
                        vertical: isTV ? 12 : 0,
                      ),
                      child: BlocBuilder<ChannelCatagoryBloc, ChannelCatagoryState>(
                        builder: (context, state) {
                          final channelCategories = state.channelCatagoryList;

                          // Manually add "ALL" at the beginning
                          final List<String> tabs = ['ALL'];
                          tabs.addAll(channelCategories.map((e) => e.name).toList());

                          return AppTabBar(
                            tabs: tabs,
                            selectedIndex: selectedIndex,
                            onChanged: (value) {
                              setState(() => selectedIndex = value);
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Scrollable content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTV ? 32 : 16,
                          vertical: isTV ? 16 : 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Banner Ads - TV optimized
                            BlocBuilder<BannerAdsBloc, BannerAdsState>(
                              builder: (context, state) {
                                if (state.bannerStatus == Status.loading) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 40,
                                      ),
                                      child: CircularProgressIndicator(
                                        strokeWidth: isTV ? 4 : 3,
                                      ),
                                    ),
                                  );
                                }

                                if (state.bannerAds.isEmpty) {
                                  return const SizedBox.shrink();
                                }

                                return SizedBox(
                                  width: double.infinity,
                                  height: isTV
                                      ? size.height * 0.45
                                      : size.height * 0.55,
                                  child: FocusTraversalGroup(
                                    policy: WidgetOrderTraversalPolicy(),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isTV ? 24 : 16,
                                        vertical: isTV ? 8 : 0,
                                      ),
                                      itemCount: state.bannerAds.length,
                                      itemBuilder: (context, index) {
                                        final banner = state.bannerAds[index];

                                        return TvFocusable(
                                          autofocus: index == 0 && isTV,
                                          borderRadius: BorderRadius.circular(
                                            isTV ? 24 : 20,
                                          ),
                                          onSelect: () {
                                            if (banner.link.isNotEmpty) {
                                              // Open banner.link or navigate
                                            }
                                          },
                                          child: Container(
                                            width: isTV
                                                ? size.width * 0.65
                                                : size.width * 0.85,
                                            margin: EdgeInsets.only(
                                              right: isTV ? 24 : 16,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                isTV ? 24 : 20,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(
                                                    0.3,
                                                  ),
                                                  blurRadius: 10,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            child: Image.network(
                                              banner.image,
                                              fit: BoxFit.cover,
                                              loadingBuilder:
                                                  (context, child, progress) {
                                                    if (progress == null) {
                                                      return child;
                                                    }
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth:
                                                            isTV ? 4 : 3,
                                                      ),
                                                    );
                                                  },
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Container(
                                                      color: Colors.grey[900],
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.broken_image,
                                                          size: isTV ? 60 : 40,
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: isTV ? 32 : 20),
                            // Channels Grid
                            BlocBuilder<ChannelsBloc, ChannelsState>(
                              builder: (context, state) {
                                if (state.channelsStatus == Status.loading &&
                                    state.channels.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 60),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: isTV ? 4 : 3,
                                      ),
                                    ),
                                  );
                                }

                                if (state.channelsStatus == Status.error &&
                                    state.channels.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 60),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Something went wrong",
                                            style: TextStyle(
                                              fontSize: isTV ? 18 : 17,
                                              color: AppColors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          TvFocusable(
                                            borderRadius: BorderRadius.circular(8),
                                            onSelect: () {
                                              context.read<ChannelsBloc>().add(
                                                const ChannelsEvent.allChannels(),
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 32,
                                                vertical: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius: BorderRadius.circular(
                                                  8,
                                                ),
                                              ),
                                              child: Text(
                                                "Retry",
                                                style: TextStyle(
                                                  fontSize: isTV ? 18 : 17,
                                                  color: AppColors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                final filteredChannels = _filter(
                                  state.channels,
                                  selectedTab,
                                );

                                if (filteredChannels.isEmpty) {
                                  final hasSearch = state.search.isNotEmpty;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 60),
                                    child: Center(
                                      child: Text(
                                        hasSearch
                                            ? 'No channels found for "${state.search}"'
                                            : "No channels in this category",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: isTV ? 18 : 17,
                                          color: AppColors.white.withAlpha(150),
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                // LayoutBuilder gives the true available
                                // width for the grid at this point in the
                                // tree, so the aspect ratio can be derived
                                // from it. This keeps the card HEIGHT fixed
                                // (cardContentHeight) while the WIDTH per
                                // column simply follows the screen size —
                                // i.e. proper responsive behaviour instead
                                // of a static aspect ratio stretching cards
                                // tall on wider screens.
                                return LayoutBuilder(
                                  builder: (context, constraints) {
                                    final totalSpacing = crossAxisSpacing *
                                        (crossAxisCount - 1);
                                    final itemWidth =
                                        (constraints.maxWidth - totalSpacing) /
                                            crossAxisCount;
                                    final aspectRatio =
                                        itemWidth / cardContentHeight;

                                    return FocusTraversalGroup(
                                      policy: ReadingOrderTraversalPolicy(),
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: filteredChannels.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: crossAxisCount,
                                          crossAxisSpacing: crossAxisSpacing,
                                          mainAxisSpacing: mainAxisSpacing,
                                          childAspectRatio: aspectRatio,
                                        ),
                                        itemBuilder: (context, index) {
                                          final channel = filteredChannels[index];

                                          return TvFocusable(
                                            borderRadius: BorderRadius.circular(
                                              isTV ? 12 : 10,
                                            ),
                                            onSelect: () =>
                                                _openChannel(context, channel),
                                            child: AnimatedBox(
                                              padding: EdgeInsets.all(isTV ? 12 : 8),
                                              width: double.infinity,
                                              color: AppColors.background
                                                  .withAlpha(60),
                                              border: Border.all(
                                                color: AppColors.primary,
                                                width: isTV ? 2 : 1,
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                isTV ? 12 : 10,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: isTV ? 56 : 40,
                                                        height: isTV ? 56 : 40,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: AppColors.white
                                                              .withOpacity(0.08),
                                                          border: Border.all(
                                                            color: AppColors.white
                                                                .withOpacity(0.2),
                                                            width: isTV ? 2 : 1,
                                                          ),
                                                        ),
                                                        child: ClipOval(
                                                          child: Padding(
                                                            padding: EdgeInsets.all(
                                                              isTV ? 10 : 6,
                                                            ),
                                                            child: channel
                                                                    .logo.isNotEmpty
                                                                ? Image.network(
                                                                    channel.logo,
                                                                    fit: BoxFit
                                                                        .contain,
                                                                    errorBuilder: (
                                                                      context,
                                                                      error,
                                                                      stackTrace,
                                                                    ) {
                                                                      return Image
                                                                          .asset(
                                                                        AppImage
                                                                            .logo,
                                                                        fit: BoxFit
                                                                            .contain,
                                                                      );
                                                                    },
                                                                  )
                                                                : Image.asset(
                                                                    AppImage.logo,
                                                                    fit: BoxFit
                                                                        .contain,
                                                                  ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: isTV ? 12 : 8),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              channel.name,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    isTV ? 18 : 14,
                                                                color:
                                                                    AppColors.white,
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            SizedBox(
                                                              height: isTV ? 4 : 2,
                                                            ),
                                                            Text(
                                                              channel.category,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    isTV ? 14 : 11,
                                                                color: AppColors
                                                                    .white
                                                                    .withAlpha(150),
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: isTV ? 16 : 10),
                                                  IgnorePointer(
                                                    child: AppButton(
                                                     
                                                      title: "Watch",
                                                      radius: 10,
                                                      fonSize: isTV ? 16 : 13,
                                                      onTap: () {},
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                      left: 6.0,
                                                    ),
                                                    child: Text(
                                                      "CH ${channel.channelNumber}",
                                                      style: text18(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            // Bottom spacing for TV
                            SizedBox(height: isTV ? 40 : 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- Classic TV-style channel number overlay ---
            if (_channelNumberBuffer.isNotEmpty)
              Positioned(
                top: isTV ? 28 : 20,
                right: isTV ? 40 : 20,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: 1,
                  child: Container(
                    constraints: BoxConstraints(minWidth: isTV ? 120 : 90),
                    padding: EdgeInsets.symmetric(
                      horizontal: isTV ? 28 : 18,
                      vertical: isTV ? 14 : 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Text(
                      _channelNumberBuffer,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isTV ? 44 : 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                ),
              ),
            // -------------------------------------------------
          ],
        ),
      ),
    );
  }
}