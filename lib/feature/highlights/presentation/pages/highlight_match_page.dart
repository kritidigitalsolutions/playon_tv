// ignore_for_file: unnecessary_null_comparison, deprecated_member_use, unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playon/core/models/response/high_light_detail_model.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/core/widgets/animated.dart';
import 'package:playon/core/widgets/app_tab_bar.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/core/widgets/bottom_view.dart';
import 'package:playon/core/widgets/media_payler_widget.dart';
import 'package:playon/feature/highlights/bloc/highlight/highlight_bloc.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_image.dart';

class HighlightMatchPage extends StatefulWidget {
  const HighlightMatchPage({super.key, required this.id});
  final String id;

  @override
  State<HighlightMatchPage> createState() => _HighlightMatchPageState();
}

class _HighlightMatchPageState extends State<HighlightMatchPage> {
  bool _isFullscreen = false;
  int _selectedTabIndex = 0;
  final FocusNode _bottomSentinelFocus = FocusNode(
    debugLabel: 'bottomSentinel',
  );

  final List<String> _tabs = const [
    'Highlights',
    'Squad',
    'Scorecard',
    'Stats',
    'Performers',
    'Event',
    'Comments',
  ];

  @override
  void initState() {
    super.initState();
    context.read<HighlightBloc>().add(
      HighlightEvent.highlightDetail(id: widget.id),
    );
    _bottomSentinelFocus.addListener(_onBottomSentinelFocusChange);
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

  void _handleFullscreenChanged(bool fullscreen) {
    setState(() => _isFullscreen = fullscreen);
    SystemChrome.setEnabledSystemUIMode(
      fullscreen ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge,
    );
  }

  @override
  void dispose() {
    _bottomSentinelFocus.removeListener(_onBottomSentinelFocusChange);
    _bottomSentinelFocus.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HighlightBloc, HighlightState>(
      builder: (context, state) {
        if (state.highlightDetailStatus == Status.loading) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.highlightDetailStatus == Status.error) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Something went wrong while loading this match.",
                    style: text16(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HighlightBloc>().add(
                        HighlightEvent.highlightDetail(id: widget.id),
                      );
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
          );
        }

        final highlight = state.highlightDetail;
        if (highlight == null) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: SizedBox.shrink(),
          );
        }

        return _HighlightMatchContent(
          highlight: highlight,
          isFullscreen: _isFullscreen,
          selectedTabIndex: _selectedTabIndex,
          tabs: _tabs,
          onFullscreenChanged: _handleFullscreenChanged,
          onTabChanged: (index) => setState(() => _selectedTabIndex = index),
          bottomSentinelFocus: _bottomSentinelFocus,
        );
      },
    );
  }
}

/// Split out so the fullscreen/PopScope branch and the scrollable
/// detail view are both driven by the same fetched [highlight] data.
class _HighlightMatchContent extends StatelessWidget {
  const _HighlightMatchContent({
    required this.highlight,
    required this.isFullscreen,
    required this.selectedTabIndex,
    required this.tabs,
    required this.onFullscreenChanged,
    required this.onTabChanged,
    required this.bottomSentinelFocus,
  });

  final HighlightDetailResponse highlight;
  final bool isFullscreen;
  final int selectedTabIndex;
  final List<String> tabs;
  final ValueChanged<bool> onFullscreenChanged;
  final ValueChanged<int> onTabChanged;
  final FocusNode bottomSentinelFocus;

  @override
  Widget build(BuildContext context) {
    final data = highlight.highlight;

    final player = MediaPlayerWidget(
      url: data.videoUrl,
      autoPlay: true,
      isFullscreen: isFullscreen,
      onFullscreenChanged: onFullscreenChanged,
      title: data.title,
      isBack: !isFullscreen,
      onError: (msg) {
        debugPrint('Player error: $msg');
      },
    );

    if (isFullscreen) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) onFullscreenChanged(false);
        },
        child: Scaffold(backgroundColor: Colors.black, body: player),
      );
    }

    final size = MediaQuery.sizeOf(context);
    final overscanPadding = size.width * 0.03;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BackgroundWithOneLight(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: overscanPadding,
              vertical: 16,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Video
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: player,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Match title
                  Text(
                    data.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Sport + category chips
                  Row(
                    children: [
                      if (data.series.sport.isNotEmpty)
                        _Chip(text: data.series.sport.toUpperCase()),
                      if (data.series.sport.isNotEmpty &&
                          data.category.isNotEmpty)
                        const SizedBox(width: 10),
                      if (data.category.isNotEmpty)
                        _Chip(text: data.category.toUpperCase()),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description
                  if (data.description.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.25),
                        ),
                      ),
                      child: Text(
                        data.description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),

                  // League info
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.background.withAlpha(60),
                          border: Border.all(color: AppColors.background),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(10),
                          child: Image.network(
                            data.series.tournamentLogo,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset(
                              AppImage.background,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          data.series.title,
                          style: text20(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Match vs card
                  Center(
                    child: AnimatedBox(
                      padding: const EdgeInsets.all(8),
                      width: MediaQuery.sizeOf(context).width * 0.3,
                      color: AppColors.background.withAlpha(60),
                      border: Border.all(color: AppColors.background),
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: _MatchVersus(
                              image: data.teamA.logo,
                              teamName: data.teamA.name,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              Text(
                                "VS",
                                style: text18(
                                  color: AppColors.white.withAlpha(60),
                                ),
                              ),
                              Text(
                                data.series.status.isNotEmpty
                                    ? data.series.status
                                    : "Completed",
                                style: text16(),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _MatchVersus(
                              image: data.teamB.logo,
                              teamName: data.teamB.name,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // AppTabBar
                  AppTabBar(
                    tabs: tabs,
                    selectedIndex: selectedTabIndex,
                    onChanged: onTabChanged,
                  ),
                  const SizedBox(height: 16),

                  // Tab Content — only real data, no mock data
                  _buildTabContent(selectedTabIndex, data),
                  const SizedBox(height: 20),

                  // Bottom View — wrapped in Focus so TV D-pad "down" from the
                  // last content has somewhere to land, which forces the
                  // outer scroll view to reveal it.
                  Focus(
                    focusNode: bottomSentinelFocus,
                    skipTraversal: false,
                    canRequestFocus: true,
                    onKeyEvent: (node, event) => KeyEventResult.ignored,
                    child: BottomView(),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(int index, HighLightDetailModel data) {
    switch (index) {
      case 0:
        return _HighlightsTab(data: data);
      case 1:
        return _SquadTab(data: data);
      case 2:
        return const _NoDataFound(title: 'Scorecard');
      case 3:
        return _StatsTab(data: data);
      case 4:
        return const _NoDataFound(title: 'Performers');
      case 5:
        return const _NoDataFound(title: 'Event');
      case 6:
        return const _NoDataFound(title: 'Comments');
      default:
        return const SizedBox.shrink();
    }
  }
}

/// Shared empty state for any tab without real backing data.
class _NoDataFound extends StatelessWidget {
  const _NoDataFound({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Text(
          "No $title found",
          style: text16(color: AppColors.white.withOpacity(0.5)),
        ),
      ),
    );
  }
}

/// Small pill-shaped label used for the sport/category tags
class _Chip extends StatelessWidget {
  final String text;
  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MatchVersus extends StatelessWidget {
  const _MatchVersus({super.key, required this.image, required this.teamName});
  final String image;
  final String teamName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBox(
          height: 60,
          width: 60,
          borderRadius: BorderRadius.circular(200),
          color: AppColors.background.withAlpha(60),
          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(200),
            child: Image.network(
              image,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Image.asset(AppImage.tornamentlogo, fit: BoxFit.cover),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(textAlign: TextAlign.center, teamName, style: text16()),
      ],
    );
  }
}

// ==================== TAB CONTENT WIDGETS (real data only) ====================

/// Highlights Tab — shows the single fetched video's own info
class _HighlightsTab extends StatelessWidget {
  final HighLightDetailModel data;
  const _HighlightsTab({required this.data});

  @override
  Widget build(BuildContext context) {
    // Only show if there's real data
    if (data.title.isEmpty && data.thumbnail.isEmpty && data.duration == 0) {
      return const _NoDataFound(title: 'Highlights');
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 120,
              height: 68,
              color: Colors.grey[800],
              child: Stack(
                alignment: Alignment.center,
                children: [
                  data.thumbnail.isNotEmpty
                      ? Image.network(
                          data.thumbnail,
                          fit: BoxFit.cover,
                          width: 120,
                          height: 68,
                          errorBuilder: (_, __, ___) => Image.asset(
                            AppImage.background,
                            fit: BoxFit.cover,
                            width: 120,
                            height: 68,
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  if (data.duration > 0)
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _formatDuration(data.duration),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (data.views > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    "${data.views} views",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return "$m:${s.toString().padLeft(2, '0')}";
  }
}

/// Squad Tab — only team names + logos are real
class _SquadTab extends StatelessWidget {
  final HighLightDetailModel data;
  const _SquadTab({required this.data});

  @override
  Widget build(BuildContext context) {
    // Check if there's real squad data
    final hasTeamA = data.teamA.name.isNotEmpty || data.teamA.logo.isNotEmpty;
    final hasTeamB = data.teamB.name.isNotEmpty || data.teamB.logo.isNotEmpty;

    if (!hasTeamA && !hasTeamB) {
      return const _NoDataFound(title: 'Squad');
    }

    return Row(
      children: [
        if (hasTeamA) Expanded(child: _SquadTeamCard(team: data.teamA)),
        if (hasTeamA && hasTeamB) const SizedBox(width: 16),
        if (hasTeamB) Expanded(child: _SquadTeamCard(team: data.teamB)),
      ],
    );
  }
}

class _SquadTeamCard extends StatelessWidget {
  final HighlightTeam team;
  const _SquadTeamCard({required this.team});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              team.logo,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Image.asset(
                AppImage.tornamentlogo,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            team.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (team.shortName.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              team.shortName,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Stats Tab — built entirely from real scalar fields on the model
class _StatsTab extends StatelessWidget {
  final HighLightDetailModel data;
  const _StatsTab({required this.data});

  @override
  Widget build(BuildContext context) {
    final items = <MapEntry<String, String>>[
      if (data.duration > 0)
        MapEntry('Duration', _formatDuration(data.duration)),
      if (data.views > 0) MapEntry('Views', '${data.views}'),
      if (data.category.isNotEmpty) MapEntry('Category', data.category),
      if (data.sourceType.isNotEmpty) MapEntry('Source', data.sourceType),
      if (data.isPremium != null)
        MapEntry('Premium', data.isPremium ? 'Yes' : 'No'),
      if (data.isFeatured != null)
        MapEntry('Featured', data.isFeatured ? 'Yes' : 'No'),
    ];

    // Only show if there's real data
    if (items.isEmpty && data.tags.isEmpty) {
      return const _NoDataFound(title: 'Stats');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (items.isNotEmpty)
          Column(
            children: items
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e.key,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            e.value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        if (data.tags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: data.tags
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return "$m:${s.toString().padLeft(2, '0')}";
  }
}