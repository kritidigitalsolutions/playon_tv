// ignore_for_file: unused_element_parameter

import 'dart:ui';

import 'package:flutter/material.dart';
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

        if (status == Status.loading && detail == null) {
          return Scaffold(
            backgroundColor: AppColors.black,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

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
                      child: Text(
                        "Retry",
                        style: text17(color: AppColors.white),
                      ),
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
                                      Text(series.title, style: text18()),
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
                                    child: _HomeTab(
                                      matches: matches,
                                      seriesId: widget.id,
                                    ),
                                  ),
                                  Focus(
                                    focusNode: _tabRootNodes[1],
                                    canRequestFocus: false,
                                    skipTraversal: true,
                                    child: _UpcomingTab(
                                      matches: matches,
                                      seriesId: widget.id,
                                    ),
                                  ),
                                  Focus(
                                    focusNode: _tabRootNodes[2],
                                    canRequestFocus: false,
                                    skipTraversal: true,
                                    child: _HighlightsTab(
                                      matches: matches,
                                      seriesId: widget.id,
                                    ),
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
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
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
// Shared focus-glow shell
// ---------------------------------------------------------------------------
class _FocusCard extends StatefulWidget {
  const _FocusCard({
    required this.child,
    required this.onSelect,
    this.autofocus = false,
    this.borderRadius = 20,
  });

  final Widget child;
  final VoidCallback onSelect;
  final bool autofocus;
  final double borderRadius;

  @override
  State<_FocusCard> createState() => _FocusCardState();
}

class _FocusCardState extends State<_FocusCard> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(widget.borderRadius);
    return TvFocusable(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      borderRadius: radius,
      focusBackgroundColor: Colors.transparent,
      onSelect: widget.onSelect,
      child: AnimatedScale(
        scale: _isFocused ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: _isFocused
                  ? AppColors.primary
                  : AppColors.primary.withOpacity(0.15),
              width: _isFocused ? 3 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isFocused
                    ? AppColors.primary.withOpacity(0.45)
                    : Colors.black.withOpacity(0.25),
                blurRadius: _isFocused ? 24 : 8,
                spreadRadius: _isFocused ? 1 : 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(borderRadius: radius, child: widget.child),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tabs
// ---------------------------------------------------------------------------

const kAccent = Color(0xFF2FE6C4);
const kGold = Color(0xFFF3B94D);

class _HomeTab extends StatelessWidget {
  const _HomeTab({required this.matches, required this.seriesId});
  final List<MatchModel> matches;
  final String seriesId;

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
                    child: _FocusCard(
                      autofocus: index == 0,
                      onSelect: () {
                        // FIX: Use the correct navigation path
                        AppNavigation.push(context, "seriesMatch/${item.id}");
                      },
                      child: AnimatedBox(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.background.withAlpha(60),
                        child: Row(
                          children: [
                            Stack(
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
                                if (item.isPremium)
                                  Positioned(
                                    top: 6,
                                    left: 6,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: kGold.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'PREMIUM',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 10),
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
  const _UpcomingTab({required this.matches, required this.seriesId});
  final List<MatchModel> matches;
  final String seriesId;

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
            child: _FocusCard(
              autofocus: index == 0,
              onSelect: () {
                // FIX: Use the correct navigation path
                AppNavigation.push(context, "seriesMatch/${item.id}");
              },
              child: AnimatedBox(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                borderRadius: BorderRadius.circular(20),
                color: AppColors.background.withAlpha(60),
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
                            style: text17(color: AppColors.white.withAlpha(80)),
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
  const _HighlightsTab({required this.matches, required this.seriesId});
  final List<MatchModel> matches;
  final String seriesId;

  @override
  Widget build(BuildContext context) {
    // Filter matches that have actual highlights
    // You can adjust this logic based on your data model
    var highlights = matches
        .where(
          (m) =>
              m.isFeatured ||
              m.isTrending ||
              (m.thumbnail.isNotEmpty && m.status.toLowerCase() == 'completed'),
        )
        .toList();

    // If no featured/trending highlights, show all matches as highlights
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: highlights.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final item = highlights[index];

            // Check if this is a "real" highlight (has thumbnail and is completed)
            final isRealHighlight =
                item.thumbnail.isNotEmpty &&
                item.status.toLowerCase() == 'completed';

            return _FocusCard(
              autofocus: index == 0,
              borderRadius: 14,
              onSelect: () {
                // Navigate to match page
                AppNavigation.push(context, "seriesMatch/${item.id}");
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.background.withAlpha(40),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Thumbnail with play button overlay
                    Expanded(
                      flex: 4,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Thumbnail image
                            _NetworkOrAsset(
                              url: item.thumbnail.isNotEmpty
                                  ? item.thumbnail
                                  : item.banner,
                              fallbackAsset: AppImage.background,
                            ),

                            // Gradient overlay
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: const [0.4, 1.0],
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.5),
                                  ],
                                ),
                              ),
                            ),

                            // Premium badge if applicable
                            if (item.isPremium)
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFF3B94D,
                                    ).withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'PREMIUM',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ),

                            // Status badge
                            if (item.status.isNotEmpty && !isRealHighlight)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    item.status.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                            // Play button - only show for actual highlights
                            if (isRealHighlight)
                              const Center(
                                child: Icon(
                                  Icons.play_circle_filled,
                                  color: Colors.white,
                                  size: 48,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    // Match info
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Teams
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  item.teamA,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'VS',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  item.teamB,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 4),

                          // Match title or sport
                          Text(
                            item.title.isNotEmpty ? item.title : item.sport,
                            style: TextStyle(
                              color: Colors.white.withAlpha(150),
                              fontSize: 11,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 2),

                          // Match date
                          Text(
                            _formatDate(item.matchDate),
                            style: TextStyle(
                              color: Colors.white.withAlpha(80),
                              fontSize: 10,
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
            return _FocusCard(
              autofocus: index == 0,
              onSelect: () {
                AppNavigation.push(context, "team/${item.id}");
              },
              child: AnimatedBox(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                color: AppColors.background.withAlpha(40),
                borderRadius: BorderRadius.circular(20),
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
