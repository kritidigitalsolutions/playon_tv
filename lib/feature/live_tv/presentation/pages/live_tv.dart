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

  // Debounce so we don't fire a request on every keystroke.
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
      // `_Search` just updates state.search; `_AllChannels` is what
      // actually re-fetches using that value, so both are dispatched
      // together. Bloc processes events sequentially by default, so
      // the fetch below is guaranteed to see the updated search term.
      context.read<ChannelsBloc>()
        ..add(ChannelsEvent.search(query))
        ..add(const ChannelsEvent.allChannels());
    });
  }

  void _clearSearch() {
    _searchController.clear();
    // clear() already notifies listeners -> _onSearchChanged runs and
    // debounces a re-fetch with an empty query, so nothing else needed.
  }

 void _openChannel(BuildContext context, ChannelModel channel) {
  AppNavigation.push(context, "liveChannelDetail/${channel.slug}");
}

  List<ChannelModel> _filter(List<ChannelModel> channels, String selectedTab) {
    if (selectedTab == "ALL") return channels;
    return channels
        .where(
          (c) => (c.category).toUpperCase() == selectedTab.toUpperCase(),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final channelCategories =
        context.watch<ChannelCatagoryBloc>().state.channelCatagoryList;

    final selectedTab = channelCategories.isNotEmpty &&
            selectedIndex < channelCategories.length
        ? channelCategories[selectedIndex].name
        : "ALL";

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BackgroundWithOneLight(
        child: SafeArea(
          child: Column(
            children: [
              // Fixed header row (title + search) — sits outside any
              // scrollable, so it never moves.
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Text("Live TV Channels", style: text24()),
                    SizedBox(width: 20),
                    Expanded(
                      child: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _searchController,
                        builder: (context, value, _) {
                          return AppTextField(
                            controller: _searchController,
                            // This is the screen's single autofocus target —
                            // the grid below no longer also claims it.
                            autofocus: true,
                            hintText: "Search Channel",
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 14, right: 10),
                              child: Icon(
                                Icons.search,
                                size: 22,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            suffixIcon: value.text.isEmpty
                                ? null
                                : IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      size: 20,
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
              // Category tabs — also fixed
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
              // Everything below this point scrolls.
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<BannerAdsBloc, BannerAdsState>(
                        builder: (context, state) {
                          if (state.bannerStatus == Status.loading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state.bannerAds.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.55,
                            child: FocusTraversalGroup(
                              policy: ReadingOrderTraversalPolicy(),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: state.bannerAds.length,
                                itemBuilder: (context, index) {
                                  final banner = state.bannerAds[index];

                                  return TvFocusable(
                                    autofocus: index == 0,
                                    borderRadius: BorderRadius.circular(20),
                                    onSelect: () {
                                      if (banner.link.isNotEmpty) {
                                        // Open banner.link or navigate
                                      }
                                    },
                                    child: Container(
                                      width:
                                          MediaQuery.sizeOf(context).width *
                                              0.85,
                                      margin: const EdgeInsets.only(right: 16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.network(
                                        banner.image,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, progress) {
                                          if (progress == null) return child;

                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Center(
                                            child: Icon(
                                              Icons.broken_image,
                                              size: 40,
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
                      SizedBox(height: 20),
                      BlocBuilder<ChannelsBloc, ChannelsState>(
                        builder: (context, state) {
                          if (state.channelsStatus == Status.loading &&
                              state.channels.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 60),
                              child:
                                  Center(child: CircularProgressIndicator()),
                            );
                          }

                          if (state.channelsStatus == Status.error &&
                              state.channels.isEmpty) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 60),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Something went wrong",
                                      style: text17(color: AppColors.white),
                                    ),
                                    const SizedBox(height: 8),
                                    TextButton(
                                      onPressed: () {
                                        context.read<ChannelsBloc>().add(
                                              const ChannelsEvent
                                                  .allChannels(),
                                            );
                                      },
                                      child: const Text("Retry"),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          final filteredChannels =
                              _filter(state.channels, selectedTab);

                          if (filteredChannels.isEmpty) {
                            final hasSearch = state.search.isNotEmpty;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 60),
                              child: Center(
                                child: Text(
                                  hasSearch
                                      ? 'No channels found for "${state.search}"'
                                      : "No channels in this category",
                                  textAlign: TextAlign.center,
                                  style: text17(
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
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.7,
                              ),
                              itemBuilder: (context, index) {
                                final channel = filteredChannels[index];

                                return TvFocusable(
                                  borderRadius: BorderRadius.circular(10),
                                  onSelect: () =>
                                      _openChannel(context, channel),
                                  child: AnimatedBox(
                                    padding: const EdgeInsets.all(8),
                                    width: double.infinity,
                                    color: AppColors.background.withAlpha(60),
                                    border:
                                        Border.all(color: AppColors.primary),
                                    borderRadius: BorderRadius.circular(10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 48,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.white
                                                    .withOpacity(0.08),
                                                border: Border.all(
                                                  color: AppColors.white
                                                      .withOpacity(0.2),
                                                ),
                                              ),
                                              child: ClipOval(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: channel
                                                              .logo.isNotEmpty &&
                                                          channel
                                                              .logo.isNotEmpty
                                                      ? Image.network(
                                                          channel.logo,
                                                          fit: BoxFit.contain,
                                                          errorBuilder: (
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
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    channel.name,
                                                    style: text17(
                                                      color: AppColors.white,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    channel.category,
                                                    style: text14(
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
                                        const SizedBox(height: 12),
                                        IgnorePointer(
                                          child: AppButton(
                                            title: "Watch",
                                            height: 36,
                                            radius: 20,
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