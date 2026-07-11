// ignore_for_file: unused_element_parameter

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playon/core/models/response/series_detail_model.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/core/widgets/animated.dart';
import 'package:playon/core/widgets/app_tab_bar.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/feature/series/bloc/series/series_bloc.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_image.dart';
import 'package:playon/static/app_navigation.dart';

class TrendingDetailPage extends StatefulWidget {
  const TrendingDetailPage({super.key, required this.id});
  final String id;
  @override
  State<TrendingDetailPage> createState() => _TrendingDetailPageState();
}

class _TrendingDetailPageState extends State<TrendingDetailPage> {
  final List<String> tabs = const [
    'Home',
    'Upcoming',
    'Highlights',
    'Points',
    'Teams',
  ];

  int selectedIndex = 0;

  // One focus node per tab's content root, so we can programmatically
  // hand focus to the newly-selected tab. IndexedStack keeps every tab
  // mounted, so autofocus alone only ever fires once — this is what
  // actually moves the remote's focus when tabs change.
  final List<FocusNode> _tabRootNodes = List.generate(
    5,
    (_) => FocusNode(skipTraversal: true),
  );

  void _focusIntoTab(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final policy = ReadingOrderTraversalPolicy();
      final firstFocus = policy.findFirstFocus(_tabRootNodes[index]);
      firstFocus?.requestFocus();
    });
  }

  void _fetchDetail() {
    context.read<SeriesBloc>().add(SeriesEvent.getSeriesDetail(id: widget.id));
  }

  @override
  void initState() {
    _fetchDetail();
    super.initState();
  }

  @override
  void dispose() {
    for (final node in _tabRootNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SeriesBloc, SeriesState>(
      builder: (context, state) {
        final status = state.seriesDetailStatus;
        final detail = state.seriesDetail;

        // Initial / refetch loading with nothing to show yet
        if (status == Status.loading && detail == null) {
          return Scaffold(
            backgroundColor: AppColors.black,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        // Error with nothing cached to fall back on
        if (status == Status.error && detail == null) {
          return Scaffold(
            backgroundColor: AppColors.black,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Something went wrong",
                    style: text18(color: AppColors.white),
                  ),
                  const SizedBox(height: 12),
                  TvFocusable(
                    autofocus: true,
                    borderRadius: BorderRadius.circular(20),
                    onSelect: _fetchDetail,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text("Retry", style: text17(color: AppColors.white)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (detail == null) {
          return Scaffold(
            backgroundColor: AppColors.black,
            body: const SizedBox.shrink(),
          );
        }

        final series = detail.series;
        final matches = detail.matches;

        return Scaffold(
          backgroundColor: AppColors.black,
          body: BackgroundWithOneLight(
            child: FocusTraversalGroup(
              policy: ReadingOrderTraversalPolicy(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Fixed back arrow — stays at top, never scrolls
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TvFocusable(
                          autofocus: true,
                          borderRadius: BorderRadius.circular(50),
                          onSelect: () => AppNavigation.pop(context),
                          child: Icon(Icons.arrow_back, color: AppColors.white),
                        ),
                      ),
                    ],
                  ),

                  // Everything else scrolls
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 10),
                          AnimatedBox(
                            width: double.infinity,
                            height: MediaQuery.sizeOf(context).height * 0.5,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                _NetworkOrAsset(
                                  url: series.banner,
                                  fallbackAsset: AppImage.background,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 16,
                                  right: 16,
                                  bottom: 16,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 10,
                                            sigmaY: 10,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                              color: AppColors.white
                                                  .withOpacity(0.15),
                                              borderRadius:
                                                  BorderRadius.circular(200),
                                              border: Border.all(
                                                color: AppColors.white
                                                    .withOpacity(0.3),
                                                width: 1,
                                              ),
                                            ),
                                            child: ClipOval(
                                              child: SizedBox(
                                                width: 48,
                                                height: 48,
                                                child: _NetworkOrAsset(
                                                  url: series.tournamentLogo,
                                                  fallbackAsset: AppImage.logo,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        series.title,
                                        style: text18(),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${_formatDate(series.startDate)} - ${_formatDate(series.endDate)}",
                                        style: TextStyle(
                                          color: AppColors.white.withAlpha(180),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppTabBar(
                            selectColor: AppColors.primary,
                            unSelectColor: AppColors.white,
                            backgroundColor: AppColors.black,
                            tabs: tabs,
                            selectedIndex: selectedIndex,
                            onChanged: (value) {
                              setState(() {
                                selectedIndex = value;
                              });
                              _focusIntoTab(value);
                            },
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: IndexedStack(
                                index: selectedIndex,
                                children: [
                                  Focus(
                                    focusNode: _tabRootNodes[0],
                                    canRequestFocus: false,
                                    skipTraversal: true,
                                    child: _HomeTab(matches: matches),
                                  ),
                                  Focus(
                                    focusNode: _tabRootNodes[1],
                                    canRequestFocus: false,
                                    skipTraversal: true,
                                    child: _UpcomingTab(matches: matches),
                                  ),
                                  Focus(
                                    focusNode: _tabRootNodes[2],
                                    canRequestFocus: false,
                                    skipTraversal: true,
                                    child: _HighlightsTab(matches: matches),
                                  ),
                                  Focus(
                                    focusNode: _tabRootNodes[3],
                                    canRequestFocus: false,
                                    skipTraversal: true,
                                    child: const _PointsTab(),
                                  ),
                                  Focus(
                                    focusNode: _tabRootNodes[4],
                                    canRequestFocus: false,
                                    skipTraversal: true,
                                    child: _TeamsTab(teams: series.teams),
                                  ),
                                ],
                              ),
                            ),
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
      },
    );
  }
}

class _NetworkOrAsset extends StatelessWidget {
  const _NetworkOrAsset({
    required this.url,
    required this.fallbackAsset,
    this.fit = BoxFit.cover,
  });

  final String url;
  final String fallbackAsset;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return Image.asset(fallbackAsset, fit: fit);
    }
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (context, error, stackTrace) =>
          Image.asset(fallbackAsset, fit: fit),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: AppColors.background.withAlpha(40),
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
          ),
        );
      },
    );
  }
}

const _kMonths = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String _formatDate(String iso) {
  if (iso.isEmpty) return '';
  final date = DateTime.tryParse(iso);
  if (date == null) return iso;
  final local = date.toLocal();
  return '${local.day} ${_kMonths[local.month - 1]} ${local.year}';
}

String _formatDateTime(String iso) {
  if (iso.isEmpty) return '';
  final date = DateTime.tryParse(iso);
  if (date == null) return iso;
  final local = date.toLocal();
  final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
  final minute = local.minute.toString().padLeft(2, '0');
  final period = local.hour >= 12 ? 'PM' : 'AM';
  return '${local.day} ${_kMonths[local.month - 1]} ${local.year} • $hour:$minute $period';
}

bool _isCompleted(String status) {
  final s = status.toLowerCase();
  return s == 'completed' || s == 'finished' || s == 'result';
}

bool _isUpcoming(String status) {
  final s = status.toLowerCase();
  return s == 'upcoming' || s == 'scheduled' || s == 'not started';
}

// ---------------------------------------------------------------------------
// Tabs
// ---------------------------------------------------------------------------

class _HomeTab extends StatelessWidget {
  const _HomeTab({required this.matches});
  final List<MatchModel> matches;

  @override
  Widget build(BuildContext context) {
    final recents = matches.where((m) => _isCompleted(m.status)).toList()
      ..sort((a, b) => b.matchDate.compareTo(a.matchDate));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Recent Results", style: text18()),
          const SizedBox(height: 8),
          if (recents.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                "No recent results yet",
                style: text17(color: AppColors.white.withAlpha(150)),
              ),
            )
          else
            FocusTraversalGroup(
              policy: ReadingOrderTraversalPolicy(),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recents.length,
                itemBuilder: (context, index) {
                  final item = recents[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TvFocusable(
                      onSelect: () {
                        // navigate to result detail
                      },
                      child: AnimatedBox(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.background.withAlpha(60),
                        border: Border.all(color: AppColors.background),
                        child: Row(
                          children: [
                            AnimatedBox(
                              height: 100,
                              width: 150,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: AppColors.white),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: _NetworkOrAsset(
                                  url: item.thumbnail.isNotEmpty
                                      ? item.thumbnail
                                      : item.banner,
                                  fallbackAsset: AppImage.background,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item.sport.isNotEmpty
                                        ? item.sport.toUpperCase()
                                        : 'MATCH',
                                    style: text20(color: AppColors.primary),
                                  ),
                                  Text(
                                    item.title.isNotEmpty
                                        ? item.title
                                        : "${item.teamA} vs ${item.teamB}",
                                    style: text17(color: AppColors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    _formatDate(item.matchDate),
                                    style: text17(
                                      color: AppColors.white.withAlpha(60),
                                    ),
                                  ),
                                ],
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
        ],
      ),
    );
  }
}

class _UpcomingTab extends StatelessWidget {
  const _UpcomingTab({required this.matches});
  final List<MatchModel> matches;

  @override
  Widget build(BuildContext context) {
    final upcoming = matches.where((m) => _isUpcoming(m.status)).toList()
      ..sort((a, b) => a.matchDate.compareTo(b.matchDate));

    if (upcoming.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            "No upcoming matches",
            style: text17(color: AppColors.white.withAlpha(150)),
          ),
        ),
      );
    }

    return FocusTraversalGroup(
      policy: ReadingOrderTraversalPolicy(),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: upcoming.length,
        itemBuilder: (context, index) {
          final item = upcoming[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TvFocusable(
              onSelect: () {
                // navigate to match detail
              },
              child: AnimatedBox(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                borderRadius: BorderRadius.circular(20),
                color: AppColors.background.withAlpha(60),
                border: Border.all(color: AppColors.background),
                child: Row(
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 36,
                        height: 36,
                        child: _NetworkOrAsset(
                          url: item.teamALogo,
                          fallbackAsset: AppImage.logo,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${item.teamA} vs ${item.teamB}",
                            style: text17(color: AppColors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (item.venue.isNotEmpty)
                            Text(
                              item.venue,
                              style: text17(
                                color: AppColors.white.withAlpha(120),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          Text(
                            _formatDateTime(item.matchDate),
                            style: text17(
                              color: AppColors.white.withAlpha(80),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ClipOval(
                      child: SizedBox(
                        width: 36,
                        height: 36,
                        child: _NetworkOrAsset(
                          url: item.teamBLogo,
                          fallbackAsset: AppImage.logo,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HighlightsTab extends StatelessWidget {
  const _HighlightsTab({required this.matches});
  final List<MatchModel> matches;

  @override
  Widget build(BuildContext context) {
    // Prefer explicitly featured/trending matches; fall back to all matches
    // if the series has none flagged.
    var highlights =
        matches.where((m) => m.isFeatured || m.isTrending).toList();
    if (highlights.isEmpty) highlights = matches;

    if (highlights.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            "No highlights yet",
            style: text17(color: AppColors.white.withAlpha(150)),
          ),
        ),
      );
    }

    return FocusTraversalGroup(
      policy: ReadingOrderTraversalPolicy(),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: highlights.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          final item = highlights[index];

          return TvFocusable(
            onSelect: () {
              // navigate to highlight/video player
            },
            child: AnimatedBox(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: AppColors.background.withAlpha(40),
              border: Border.all(color: AppColors.background),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _NetworkOrAsset(
                            url: item.thumbnail.isNotEmpty
                                ? item.thumbnail
                                : item.banner,
                            fallbackAsset: AppImage.background,
                          ),
                          Container(color: Colors.black.withOpacity(0.25)),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary.withOpacity(0.9),
                              ),
                              child: Icon(
                                Icons.play_arrow_rounded,
                                color: AppColors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.teamA,
                          style: text17(color: AppColors.white),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "VS",
                            style: text17(color: AppColors.white),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.teamB,
                          style: text17(color: AppColors.white),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.title.isNotEmpty ? item.title : item.sport,
                          style: text17(
                            color: AppColors.white.withAlpha(150),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _formatDate(item.matchDate),
                          style: text17(
                            color: AppColors.white.withAlpha(100),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PointsTab extends StatelessWidget {
  const _PointsTab();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          "Points table coming soon",
          style: text17(color: AppColors.white.withAlpha(150)),
        ),
      ),
    );
  }
}

class _TeamsTab extends StatelessWidget {
  const _TeamsTab({required this.teams});
  final List<Team> teams;

  @override
  Widget build(BuildContext context) {
    if (teams.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            "No teams listed",
            style: text17(color: AppColors.white.withAlpha(150)),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FocusTraversalGroup(
        policy: ReadingOrderTraversalPolicy(),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: teams.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 4,
          ),
          itemBuilder: (context, index) {
            final item = teams[index];
            return TvFocusable(
              onSelect: () {
                // navigate to team detail
              },
              child: AnimatedBox(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                color: AppColors.background.withAlpha(40),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.background),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedBox(
                      color: AppColors.background.withAlpha(60),
                      borderRadius: BorderRadius.circular(200),
                      height: 50,
                      width: 50,
                      child: ClipOval(
                        child: _NetworkOrAsset(
                          url: item.logo,
                          fallbackAsset: AppImage.logo,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.shortName.isNotEmpty
                                ? item.shortName
                                : item.name,
                            style: text17(color: AppColors.white),
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item.country,
                            style: text10(
                              color: AppColors.white.withAlpha(120),
                            ),
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}