import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playon/core/models/response/star_player_model.dart';
import 'package:playon/core/service/tv_section.dart';
import 'package:playon/feature/home/bloc/star_player/star_payer_cubit.dart';
import 'package:playon/feature/podcast/bloc/podcast/podcast_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:playon/core/models/response/series_detail_model.dart';
import 'package:playon/core/models/response/series_model.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/core/widgets/bottom_view.dart';
import 'package:playon/feature/highlights/bloc/highlight/highlight_bloc.dart';
import 'package:playon/feature/home/bloc/banner_ads/banner_ads_bloc.dart';
import 'package:playon/feature/home/presentation/widgets/highlight_card.dart';
import 'package:playon/feature/home/presentation/widgets/podcast_card.dart';
import 'package:playon/feature/home/presentation/widgets/reel_highlight_card.dart';
import 'package:playon/feature/series/bloc/series/series_bloc.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_image.dart';
import 'package:playon/static/app_navigation.dart';

class SportsView extends StatefulWidget {
  final String? sportFilter;

  const SportsView({super.key, this.sportFilter});

  @override
  State<SportsView> createState() => _SportsViewState();
}

class _SportsViewState extends State<SportsView> {
  final FocusNode _bottomSentinelFocus = FocusNode(
    debugLabel: 'bottomSentinel',
  );

  // Fixed order constants — NOT a mutable counter. BlocBuilders rebuild
  // independently of each other (e.g. SeriesBloc emitting a new state
  // only rebuilds its own BlocBuilder, not the whole SportsView), so a
  // shared incrementing counter gets corrupted across those partial
  // rebuilds. Fixed values stay stable no matter which bloc fires.
  static const int _orderBanner = 0;
  static const int _orderTrending = 1;
  static const int _orderSeriesMatchesBase = 2; // + index per series row
  static const int _orderHighlights = 1000; // big gap so any number of
  static const int _orderReels = 1001; // series-match rows fit safely
  static const int _orderPodcasts = 1002;

  final ScrollController _bannerScroll = ScrollController();
  final ScrollController _trendingScroll = ScrollController();
  final ScrollController _highlightsScroll = ScrollController();
  final ScrollController _reelsScroll = ScrollController();
  final ScrollController _podcastsScroll = ScrollController();

  @override
  void initState() {
    context.read<SeriesBloc>().add(SeriesEvent.getSeriesList());
    context.read<HighlightBloc>().add(HighlightEvent.fetchHighLight());
    context.read<StarPayerCubit>().allStarPlayer();
    context.read<PodcastBloc>().add(PodcastEvent.allPodcast());
    _bottomSentinelFocus.addListener(_onBottomSentinelFocusChange);

    super.initState();
  }

  void _onBottomSentinelFocusChange() {
    if (_bottomSentinelFocus.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Scrollable.ensureVisible(
          _bottomSentinelFocus.context ?? context,
          alignment: 1.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _bottomSentinelFocus.removeListener(_onBottomSentinelFocusChange);
    _bottomSentinelFocus.dispose();
    _bannerScroll.dispose();
    _trendingScroll.dispose();
    _highlightsScroll.dispose();
    _reelsScroll.dispose();
    _podcastsScroll.dispose();
    super.dispose();
  }

  List<SeriesModel> _filterBySport(List<SeriesModel> all) {
    if (widget.sportFilter == null || widget.sportFilter == 'HOME') {
      return all;
    }
    return all
        .where((s) => s.sport.toUpperCase() == widget.sportFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Slider - Shows on ALL tabs
          BlocBuilder<BannerAdsBloc, BannerAdsState>(
            builder: (context, state) {
              if (state.bannerStatus == Status.loading) {
                return SizedBox(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 0.55,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: 3,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: _ShimmerBox(
                        width: MediaQuery.sizeOf(context).width * 0.85,
                        height: double.infinity,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                );
              }

              if (state.bannerAds.isEmpty) {
                return const SizedBox.shrink();
              }

              return SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.55,
                child: TvSectionScope(
                  order: _orderBanner,
                  scrollController: _bannerScroll,
                  child: FocusTraversalGroup(
                    policy: ReadingOrderTraversalPolicy(),
                    child: ListView.builder(
                      controller: _bannerScroll,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.bannerAds.length,
                      itemBuilder: (context, index) {
                        final banner = state.bannerAds[index];

                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: _GlowFocusCard(
                            autofocus: index == 0,
                            borderRadius: BorderRadius.circular(20),
                            onSelect: () {
                              if (banner.link.isNotEmpty) {
                                // Open banner.link or navigate
                              }
                            },
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.85,
                              height: double.infinity,
                              child: Image.network(
                                banner.image,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return const _ShimmerBox(
                                    width: double.infinity,
                                    height: double.infinity,
                                    borderRadius: BorderRadius.zero,
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(Icons.broken_image, size: 40),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // Trending Series (real API data)
          BlocBuilder<SeriesBloc, SeriesState>(
            builder: (context, state) {
              if (state.allSeriesStatus == Status.loading &&
                  state.series.isEmpty) {
                return SizedBox(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: 4,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: _ShimmerBox(
                        width: 220,
                        height: 250,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                );
              }

              if (state.allSeriesStatus == Status.error &&
                  state.series.isEmpty) {
                return SizedBox(
                  height: 250,
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
                            context.read<SeriesBloc>().add(
                              SeriesEvent.getSeriesList(),
                            );
                          },
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final sportFiltered = _filterBySport(state.series);
              final trending = sportFiltered
                  .where((s) => s.isTrending)
                  .toList();

              if (trending.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      widget.sportFilter == null || widget.sportFilter == 'HOME'
                          ? "Trending Series"
                          : "${widget.sportFilter} Trending Series",
                      style: text24(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 250,
                    child: TvSectionScope(
                      order: _orderTrending,
                      scrollController: _trendingScroll,
                      child: FocusTraversalGroup(
                        policy: ReadingOrderTraversalPolicy(),
                        child: ListView.builder(
                          controller: _trendingScroll,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: trending.length,
                          itemBuilder: (context, index) {
                            final series = trending[index];

                            return Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: _GlowFocusCard(
                                autofocus: index == 0,
                                borderRadius: BorderRadius.circular(16),
                                onSelect: () {
                                  AppNavigation.push(
                                    context,
                                    "/trending/${series.id}",
                                  );
                                },
                                child: SizedBox(
                                  width: 220,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      series.banner.isNotEmpty
                                          ? Image.network(
                                              series.banner,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Image.asset(
                                                      AppImage.tornamentlogo,
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                              loadingBuilder:
                                                  (context, child, progress) {
                                                    if (progress == null) {
                                                      return child;
                                                    }
                                                    return const _ShimmerBox(
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      borderRadius:
                                                          BorderRadius.zero,
                                                    );
                                                  },
                                            )
                                          : Image.asset(
                                              AppImage.tornamentlogo,
                                              fit: BoxFit.cover,
                                            ),
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.35),
                                              Colors.transparent,
                                              Colors.black.withOpacity(0.75),
                                            ],
                                            stops: const [0.0, 0.5, 1.0],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 12,
                                        left: 12,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                              sigmaX: 10,
                                              sigmaY: 10,
                                            ),
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.white
                                                    .withOpacity(0.15),
                                                border: Border.all(
                                                  color: AppColors.white
                                                      .withOpacity(0.3),
                                                  width: 1,
                                                ),
                                              ),
                                              child:
                                                  series.tournamentLogo.isNotEmpty
                                                  ? Image.network(
                                                      series.tournamentLogo,
                                                      width: 32,
                                                      height: 32,
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) {
                                                            return Image.asset(
                                                              AppImage.logo,
                                                              width: 32,
                                                              height: 32,
                                                            );
                                                          },
                                                    )
                                                  : Image.asset(
                                                      AppImage.logo,
                                                      width: 32,
                                                      height: 32,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 12,
                                        right: 12,
                                        bottom: 12,
                                        child: Text(
                                          series.title,
                                          style: text17(color: AppColors.white),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 30),

          // All Series with their real Matches
          BlocBuilder<SeriesBloc, SeriesState>(
            builder: (context, state) {
              if (state.allSeriesStatus == Status.loading &&
                  state.series.isEmpty) {
                return const SizedBox.shrink();
              }

              final sportFiltered = _filterBySport(state.series);
              final withMatches = sportFiltered
                  .where((s) => s.totalMatches > 0)
                  .toList();

              if (withMatches.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final entry in withMatches.asMap().entries)
                    _SeriesMatchesRow(
                      key: ValueKey('series_matches_${entry.value.id}'),
                      series: entry.value,
                      order: _orderSeriesMatchesBase + entry.key,
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),

          // Match Highlights
          _buildHighlightsSection(context, sport: widget.sportFilter),
          const SizedBox(height: 20),

          // Star Player Edition (Reels)
          _buildReelsSection(context, sport: widget.sportFilter),
          const SizedBox(height: 20),

          // Latest Podcasts
          _buildPodcastsSection(context, sport: widget.sportFilter),
          const SizedBox(height: 20),

          // Bottom View
          Focus(
            focusNode: _bottomSentinelFocus,
            skipTraversal: false,
            canRequestFocus: true,
            onKeyEvent: (node, event) => KeyEventResult.ignored,
            child: BottomView(),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildHighlightsSection(BuildContext context, {String? sport}) {
    return BlocBuilder<HighlightBloc, HighlightState>(
      builder: (context, state) {
        if (state.allHighLightStatus == Status.loading &&
            state.highlights.isEmpty) {
          return SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 4,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: _ShimmerBox(
                  width: 220,
                  height: 250,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          );
        }

        if (state.allHighLightStatus == Status.error &&
            state.highlights.isEmpty) {
          return SizedBox(
            height: 250,
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
                      context.read<HighlightBloc>().add(
                        HighlightEvent.fetchHighLight(),
                      );
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
          );
        }

        final filtered = (sport == null || sport == 'HOME')
            ? state.highlights
            : state.highlights
                  .where((h) => h.series.sport.toUpperCase() == sport)
                  .toList();

        if (filtered.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                sport == null || sport == 'HOME'
                    ? "Match Highlights"
                    : "$sport Match Highlights",
                style: text24(),
              ),
            ),
            SizedBox(
              height: 250,
              child: TvSectionScope(
                order: _orderHighlights,
                scrollController: _highlightsScroll,
                child: FocusTraversalGroup(
                  policy: WidgetOrderTraversalPolicy(),
                  child: ListView.builder(
                    controller: _highlightsScroll,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _GlowFocusCard(
                          autofocus: index == 0,
                          borderRadius: BorderRadius.circular(16),
                          onSelect: () {
                            AppNavigation.push(
                              context,
                              "/highlightMatch/${item.id}",
                            );
                          },
                          child: HighlightCard(
                            image: item.thumbnail,
                            logo: item.series.tournamentLogo.isNotEmpty
                                ? item.series.tournamentLogo
                                : AppImage.logo,
                            tournamentName: item.series.title,
                            teamA: item.teamA.shortName.isNotEmpty
                                ? item.teamA.shortName
                                : item.teamA.name,
                            teamB: item.teamB.shortName.isNotEmpty
                                ? item.teamB.shortName
                                : item.teamB.name,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReelsSection(BuildContext context, {String? sport}) {
    return BlocBuilder<StarPayerCubit, StarPayerState>(
      builder: (context, state) {
        if (state.allPlayerStatus == Status.loading) {
          return const SizedBox(
            height: 260,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (state.allPlayerStatus == Status.error) {
          return SizedBox(
            height: 260,
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
                      context.read<StarPayerCubit>().allStarPlayer();
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
          );
        }

        final allHighlights = state.starPlayers?.highlights ?? [];

        List<StarPlayerModel> filteredHighlights = allHighlights;
        if (sport != null && sport != 'HOME') {
          filteredHighlights = allHighlights
              .where((h) => h.sport?.name.toUpperCase() == sport)
              .toList();
        }

        if (filteredHighlights.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                sport == null || sport == 'HOME'
                    ? "Star Player Edition"
                    : "$sport Star Players",
                style: text24(),
              ),
            ),
            SizedBox(
              height: 260,
              child: TvSectionScope(
                order: _orderReels,
                scrollController: _reelsScroll,
                child: FocusTraversalGroup(
                  policy: WidgetOrderTraversalPolicy(),
                  child: ListView.builder(
                    controller: _reelsScroll,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredHighlights.length,
                    itemBuilder: (context, index) {
                      final highlight = filteredHighlights[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _GlowFocusCard(
                          autofocus: index == 0,
                          borderRadius: BorderRadius.circular(16),
                          onSelect: () {
                            AppNavigation.push(
                              context,
                              "starPlayerVideo/${highlight.id}",
                            );
                          },
                          child: ReelHighlightCard(
                            starPlayerResponse: StarPlayerResponse(
                              success: true,
                              count: 1,
                              highlights: [highlight],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPodcastsSection(BuildContext context, {String? sport}) {
    return BlocBuilder<PodcastBloc, PodcastState>(
      builder: (context, state) {
        final podcasts = state.podcastResponse?.podcasts ?? [];

        if (state.allPodcastStatus == Status.loading && podcasts.isEmpty) {
          return SizedBox(
            height: 290,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 4,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: _ShimmerBox(
                  width: 220,
                  height: 290,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          );
        }

        if (state.allPodcastStatus == Status.error && podcasts.isEmpty) {
          return SizedBox(
            height: 290,
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
                      context.read<PodcastBloc>().add(
                        PodcastEvent.allPodcast(),
                      );
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
          );
        }

        final filtered = (sport == null || sport == 'HOME')
            ? podcasts
            : podcasts
                  .where((p) => p.sportId?.name.toUpperCase() == sport)
                  .toList();

        if (filtered.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    sport == null || sport == 'HOME'
                        ? "Latest Podcasts"
                        : "$sport Podcasts",
                    style: text24(),
                  ),
                  const Spacer(),
                  TvFocusable(
                    onSelect: () {
                      AppNavigation.push(context, "/podcasts");
                    },
                    child: Text(
                      "Explore",
                      style: text18(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 290,
              child: TvSectionScope(
                order: _orderPodcasts,
                scrollController: _podcastsScroll,
                child: FocusTraversalGroup(
                  policy: WidgetOrderTraversalPolicy(),
                  child: ListView.builder(
                    controller: _podcastsScroll,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _GlowFocusCard(
                          autofocus: index == 0,
                          borderRadius: BorderRadius.circular(16),
                          onSelect: () {
                            AppNavigation.push(context, "/podcast/${item.id}");
                          },
                          child: PodcastCard(
                            image: item.thumbnail,
                            title: item.title,
                            duration: item.duration,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Wraps any child with the same focus-glow treatment as SeriesCard
class _GlowFocusCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onSelect;
  final bool autofocus;
  final BorderRadius borderRadius;

  const _GlowFocusCard({
    required this.child,
    this.onSelect,
    this.autofocus = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  State<_GlowFocusCard> createState() => _GlowFocusCardState();
}

class _GlowFocusCardState extends State<_GlowFocusCard> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!mounted) return;
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TvFocusable(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      borderRadius: widget.borderRadius,
      focusBackgroundColor: Colors.transparent,
      onSelect: widget.onSelect,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          border: Border.all(
            color: _isFocused
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.3),
            width: _isFocused ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isFocused
                  ? AppColors.primary.withOpacity(0.5)
                  : Colors.black.withOpacity(0.3),
              blurRadius: _isFocused ? 22 : 8,
              spreadRadius: _isFocused ? 2 : 0,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Reusable shimmer placeholder
class _ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  const _ShimmerBox({
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.white.withOpacity(0.08),
      highlightColor: AppColors.white.withOpacity(0.22),
      period: const Duration(milliseconds: 1200),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

/// Renders one series' title as a header, and its real matches in a
/// horizontal scroller beneath it.
class _SeriesMatchesRow extends StatefulWidget {
  final SeriesModel series;
  final int order;

  const _SeriesMatchesRow({
    super.key,
    required this.series,
    required this.order,
  });

  @override
  State<_SeriesMatchesRow> createState() => _SeriesMatchesRowState();
}

class _SeriesMatchesRowState extends State<_SeriesMatchesRow> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<SeriesBloc>().add(
      SeriesEvent.getSeriesDetail(id: widget.series.id),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _retry() {
    context.read<SeriesBloc>().add(
      SeriesEvent.getSeriesDetail(id: widget.series.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final seriesId = widget.series.id;

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.series.title,
                    style: text24(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TvFocusable(
                  onSelect: () {
                    AppNavigation.push(context, "/trending/$seriesId");
                  },
                  child: Text(
                    "View All",
                    style: text18(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: BlocBuilder<SeriesBloc, SeriesState>(
              builder: (context, state) {
                final detail = state.seriesDetail;
                final isForThisSeries = detail?.series.id == seriesId;

                if (!isForThisSeries) {
                  if (state.seriesDetailStatus == Status.error) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: _retry,
                          child: const Text("Couldn't load matches — Retry"),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: 3,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: _ShimmerBox(
                        width: 260,
                        height: 220,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  );
                }

                final matches = detail!.matches;

                if (matches.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "No matches available yet",
                        style: text17(color: AppColors.white.withOpacity(0.6)),
                      ),
                    ),
                  );
                }

                return TvSectionScope(
                  order: widget.order,
                  scrollController: _scrollController,
                  child: FocusTraversalGroup(
                    policy: WidgetOrderTraversalPolicy(),
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: matches.length,
                      itemBuilder: (context, index) {
                        final match = matches[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: _GlowFocusCard(
                            autofocus: index == 0,
                            borderRadius: BorderRadius.circular(16),
                            onSelect: () {
                              AppNavigation.push(
                                context,
                                "matchVideo/${match.id}",
                              );
                            },
                            child: _MatchCard(match: match),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final MatchModel match;

  const _MatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Stack(
        fit: StackFit.expand,
        children: [
          match.thumbnail.isNotEmpty
              ? Image.network(
                  match.thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      AppImage.tornamentlogo,
                      fit: BoxFit.cover,
                    );
                  },
                )
              : Image.asset(AppImage.tornamentlogo, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.2),
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          if (match.status.isNotEmpty)
            Positioned(
              left: 12,
              right: 12,
              top: 12,
              child: Text(
                match.status,
                style: text14(color: AppColors.primary),
              ),
            ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${match.teamA} vs ${match.teamB}",
                  style: text17(color: AppColors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (match.venue.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    match.venue,
                    style: text14(color: AppColors.white.withOpacity(0.7)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}