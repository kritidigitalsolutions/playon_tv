// lib/feature/home/presentation/widgets/sports_view.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playon/core/models/response/star_player_model.dart';
import 'package:playon/feature/home/bloc/star_player/star_payer_cubit.dart';
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
  @override
  void initState() {
    context.read<SeriesBloc>().add(SeriesEvent.getSeriesList());
    context.read<HighlightBloc>().add(HighlightEvent.fetchHighLight());
    context.read<StarPayerCubit>().allStarPlayer();
    super.initState();
  }

  /// Applies the current sport tab filter to a list of series.
  /// `null` or `HOME` means "show everything".
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
                child: FocusTraversalGroup(
                  policy: ReadingOrderTraversalPolicy(),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                          width: MediaQuery.sizeOf(context).width * 0.85,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          clipBehavior: Clip.antiAlias,
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
                      );
                    },
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
                    child: FocusTraversalGroup(
                      policy: ReadingOrderTraversalPolicy(),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: trending.length,
                        itemBuilder: (context, index) {
                          final series = trending[index];

                          return TvFocusable(
                            autofocus: index == 0,
                            onSelect: () {
                              AppNavigation.push(
                                context,
                                "/trending/${series.id}",
                              );
                            },
                            child: Container(
                              width: 220,
                              margin: const EdgeInsets.only(right: 16),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
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
                ],
              );
            },
          ),
          const SizedBox(height: 30),

          // All Series with their real Matches (fetched per-series via
          // SeriesDetailUsecase). Replaces the old fake index-based
          // Tournament Section.
          BlocBuilder<SeriesBloc, SeriesState>(
            builder: (context, state) {
              if (state.allSeriesStatus == Status.loading &&
                  state.series.isEmpty) {
                return const SizedBox.shrink(); // already shown above
              }

              final sportFiltered = _filterBySport(state.series);
              // Skip series that have no matches at all - SeriesModel
              // already carries totalMatches from the all-series API, so
              // this filters without any extra network calls.
              final withMatches = sportFiltered
                  .where((s) => s.totalMatches > 0)
                  .toList();

              if (withMatches.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final series in withMatches)
                    _SeriesMatchesRow(series: series),
                ],
              );
            },
          ),
          const SizedBox(height: 20),

          // Match Highlights
          _buildHighlightsSection(context, sport: widget.sportFilter),
          const SizedBox(height: 20),

          // Star Player Edition (Reels) - real API data
          _buildReelsSection(context, sport: widget.sportFilter),
          const SizedBox(height: 20),

          // Latest Podcasts (TODO: wire to real API when available)
          _buildPodcastsSection(context, sport: widget.sportFilter),
          const SizedBox(height: 20),

          // Bottom View
          BottomView(),
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
              child: FocusTraversalGroup(
                policy: WidgetOrderTraversalPolicy(),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return TvFocusable(
                      autofocus: index == 0,
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
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Star Player Edition (Reels). Backed entirely by
  /// `StarPayerCubit.allStarPlayer()` — a single `StarPlayerResponse`
  /// whose `highlights` list feeds every card. No mock/demo fallback:
  /// loading shows a spinner, error shows a retry, empty just collapses
  /// the section.
  Widget _buildReelsSection(BuildContext context, {String? sport}) {
    return BlocBuilder<StarPayerCubit, StarPayerState>(
      builder: (context, state) {
        // Loading state
        if (state.allPlayerStatus == Status.loading) {
          return const SizedBox(
            height: 260,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        // Error state
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

        // Filter by the active sport tab, if any.
        List<StarPlayerModel> filteredHighlights = allHighlights;
        if (sport != null && sport != 'HOME') {
          filteredHighlights = allHighlights
              .where((h) => h.sport?.name.toUpperCase() == sport)
              .toList();
        }

        // Empty state
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
              child: FocusTraversalGroup(
                policy: WidgetOrderTraversalPolicy(),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredHighlights.length,
                  itemBuilder: (context, index) {
                    final highlight = filteredHighlights[index];
                    return TvFocusable(
                      autofocus: index == 0,
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
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPodcastsSection(BuildContext context, {String? sport}) {
    // TODO: Replace with real data from API filtered by sport
    final podcasts = _getPodcasts(sport);

    if (podcasts.isEmpty) {
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
                child: Text("Explore", style: text18(color: AppColors.primary)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 290,
          child: FocusTraversalGroup(
            policy: WidgetOrderTraversalPolicy(),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: podcasts.length,
              itemBuilder: (context, index) {
                final item = podcasts[index];
                return TvFocusable(
                  onSelect: () {
                    AppNavigation.push(context, "/podcast/$index");
                  },
                  child: PodcastCard(
                    image: item['image']!,
                    title: item['title']!,
                    duration: item['duration']!,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // Mock data - replace with real API calls once the backend exposes a
  // podcasts endpoint. (Highlights and Star Players are already wired to
  // their real APIs above.)
  List<Map<String, String>> _getPodcasts(String? sport) {
    final allPodcasts = [
      {
        "image": AppImage.background,
        "title": "Match day breakdown",
        "duration": "24 min",
        "sport": "CRICKET",
      },
      {
        "image": AppImage.background,
        "title": "Behind the scenes",
        "duration": "18 min",
        "sport": "FOOTBALL",
      },
      {
        "image": AppImage.background,
        "title": "Player interview special",
        "duration": "32 min",
        "sport": "HOCKEY",
      },
      {
        "image": AppImage.background,
        "title": "Cricket analysis",
        "duration": "28 min",
        "sport": "CRICKET",
      },
    ];

    if (sport == null || sport == 'HOME') {
      return allPodcasts;
    }

    return allPodcasts.where((item) => item['sport'] == sport).toList();
  }
}

/// Reusable shimmer placeholder used for every loading state on this
/// screen (banner, trending series cards, series-detail match cards, and
/// individual network-image loads), so all loading states look
/// consistent instead of mixing spinners and shimmer.
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
///
/// Dispatches `getSeriesDetail` on SeriesBloc once in initState. Because
/// the bloc only holds a single shared `seriesDetail` field (not keyed by
/// series id), this row only renders matches when
/// `state.seriesDetail?.series.id` matches its own series id - otherwise
/// it shows a loading state. If several rows are visible at once, only
/// the most recently completed fetch's row will show matches at any
/// given moment; the others go back to loading until their own fetch is
/// the latest one in state again.
class _SeriesMatchesRow extends StatefulWidget {
  final SeriesModel series;

  const _SeriesMatchesRow({required this.series});

  @override
  State<_SeriesMatchesRow> createState() => _SeriesMatchesRowState();
}

class _SeriesMatchesRowState extends State<_SeriesMatchesRow> {
  @override
  void initState() {
    super.initState();
    context.read<SeriesBloc>().add(
      SeriesEvent.getSeriesDetail(id: widget.series.id),
    );
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
                  // Either nothing loaded yet, or the shared state
                  // currently holds a different row's result.
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

                return FocusTraversalGroup(
                  policy: WidgetOrderTraversalPolicy(),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: matches.length,
                    itemBuilder: (context, index) {
                      final match = matches[index];
                      return TvFocusable(
                        autofocus: index == 0,
                        onSelect: () {
                          AppNavigation.push(context, "matchVideo/${match.id}");
                        },
                        child: _MatchCard(match: match),
                      );
                    },
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
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
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
      ),
    );
  }
}
