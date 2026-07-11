import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playon/core/models/response/channel_model.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/core/widgets/animated.dart';
import 'package:playon/core/widgets/app_button.dart';
import 'package:playon/core/widgets/app_tab_bar.dart';
import 'package:playon/core/widgets/app_text_field.dart';
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isTV = size.width > 1280 || size.height > 720;

    final channelCategories = context
        .watch<ChannelCatagoryBloc>()
        .state
        .channelCatagoryList;

    final selectedTab =
        channelCategories.isNotEmpty && selectedIndex < channelCategories.length
        ? channelCategories[selectedIndex].name
        : "ALL";

    // TV-optimized grid dimensions for 32" TV and above
    final crossAxisCount = isTV
        ? 6
        : 4; // 6 columns on TV for better use of space
    final childAspectRatio = isTV ? 1.4 : 1.5; // Slightly taller on TV
    final crossAxisSpacing = isTV ? 22.0 : 12.0; // More spacing on TV
    final mainAxisSpacing = isTV ? 20.0 : 12.0; // More spacing on TV

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BackgroundWithOneLight(
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
                        color: AppColors.white,
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
              // Category tabs with TV optimization
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTV ? 32 : 16,
                  vertical: isTV ? 12 : 0,
                ),
                child: BlocBuilder<ChannelCatagoryBloc, ChannelCatagoryState>(
                  builder: (context, state) {
                    final channelCategories = state.channelCatagoryList;
                    return AppTabBar(
                      tabs: channelCategories.map((e) => e.name).toList(),
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
                            height: isTV
                                ? size.height * 0.45
                                : size.height * 0.55,
                            child: FocusTraversalGroup(
                              policy: ReadingOrderTraversalPolicy(),
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
                                              if (progress == null)
                                                return child;
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: isTV ? 4 : 3,
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

                          return FocusTraversalGroup(
                            policy: ReadingOrderTraversalPolicy(),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredChannels.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: crossAxisSpacing,
                                    mainAxisSpacing: mainAxisSpacing,
                                    childAspectRatio: childAspectRatio,
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
                                    color: AppColors.background.withAlpha(60),
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
                                              width: isTV ? 56 : 48,
                                              height: isTV ? 56 : 48,
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
                                                    isTV ? 10 : 8,
                                                  ),
                                                  child: channel.logo.isNotEmpty
                                                      ? Image.network(
                                                          channel.logo,
                                                          fit: BoxFit.contain,
                                                          errorBuilder:
                                                              (
                                                                context,
                                                                error,
                                                                stackTrace,
                                                              ) {
                                                                return Image.asset(
                                                                  AppImage.logo,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                );
                                                              },
                                                        )
                                                      : Image.asset(
                                                          AppImage.logo,
                                                          fit: BoxFit.contain,
                                                        ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: isTV ? 12 : 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    channel.name,
                                                    style: TextStyle(
                                                      fontSize: isTV ? 18 : 16,
                                                      color: AppColors.white,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(
                                                    height: isTV ? 4 : 2,
                                                  ),
                                                  Text(
                                                    channel.category,
                                                    style: TextStyle(
                                                      fontSize: isTV ? 14 : 12,
                                                      color: AppColors.white
                                                          .withAlpha(150),
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: isTV ? 16 : 12),
                                        IgnorePointer(
                                          child: AppButton(
                                            title: "Watch",
                                            
                                            radius: 20,
                                            fonSize: isTV ? 16 : 14,
                                            onTap: () {},
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
    );
  }
}
