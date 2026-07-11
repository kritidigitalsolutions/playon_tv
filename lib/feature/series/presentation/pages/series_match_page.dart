// ignore_for_file: deprecated_member_use, unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playon/core/models/response/series_detail_model.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/core/widgets/animated.dart';
import 'package:playon/core/widgets/app_tab_bar.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/core/widgets/media_payler_widget.dart';
import 'package:playon/feature/series/bloc/series/series_bloc.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_image.dart';
import 'package:playon/static/app_navigation.dart';

// Fallback used only if a match genuinely has no streamUrl yet (e.g. still
// being tested against a placeholder backend). Once every match record has
// a real streamUrl this can be deleted.
const String _placeholderStreamUrl =
    'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8';//DEMO

class SeriesMatchPage extends StatefulWidget {
  const SeriesMatchPage({super.key, required this.id});
  final String id;

  @override
  State<SeriesMatchPage> createState() => _SeriesMatchPageState();
}

class _SeriesMatchPageState extends State<SeriesMatchPage> {
  bool _isFullscreen = false;
  int _selectedTabIndex = 0;

  final List<String> _tabs = [
    'Highlights',
    'Squad',
    'Scorecard',
    'Stats',
    'Performers',
    'Event',
    'Comments',
  ];

  void _handleFullscreenChanged(bool fullscreen) {
    setState(() => _isFullscreen = fullscreen);
    SystemChrome.setEnabledSystemUIMode(
      fullscreen ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge,
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  MatchModel? _findMatch(SeriesState state) {
    final matches = state.seriesDetail?.matches;
    if (matches == null) return null;
    for (final m in matches) {
      if (m.id == widget.id) return m;
    }
    return null;
  }

  String _formatMatchDate(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final local = dt.toLocal();
    final hour12 = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final period = local.hour >= 12 ? 'PM' : 'AM';
    final minute = local.minute.toString().padLeft(2, '0');
    return '${local.day} ${months[local.month - 1]}, $hour12:$minute $period';
  }

  String _titleCase(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SeriesBloc, SeriesState>(
      builder: (context, state) {
        final match = _findMatch(state);

        if (match == null && state.seriesDetailStatus == Status.loading) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (match == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => AppNavigation.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Match not found",
                        style: text17(color: AppColors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return _MatchContent(
          match: match,
          seriesTitle: state.seriesDetail?.series.title,
          seriesLogo: state.seriesDetail?.series.tournamentLogo,
          isFullscreen: _isFullscreen,
          selectedTabIndex: _selectedTabIndex,
          tabs: _tabs,
          formatMatchDate: _formatMatchDate,
          titleCase: _titleCase,
          onFullscreenChanged: _handleFullscreenChanged,
          onTabChanged: (index) => setState(() => _selectedTabIndex = index),
        );
      },
    );
  }
}

class _MatchContent extends StatelessWidget {
  const _MatchContent({
    required this.match,
    required this.seriesTitle,
    required this.seriesLogo,
    required this.isFullscreen,
    required this.selectedTabIndex,
    required this.tabs,
    required this.formatMatchDate,
    required this.titleCase,
    required this.onFullscreenChanged,
    required this.onTabChanged,
  });

  final MatchModel match;
  final String? seriesTitle;
  final String? seriesLogo;
  final bool isFullscreen;
  final int selectedTabIndex;
  final List<String> tabs;
  final String Function(String iso) formatMatchDate;
  final String Function(String value) titleCase;
  final ValueChanged<bool> onFullscreenChanged;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final title = match.title.isNotEmpty
        ? match.title
        : '${match.teamA} vs ${match.teamB}';

    final streamUrl = _placeholderStreamUrl;

    final player = MediaPlayerWidget(
      url: streamUrl,
      autoPlay: true,
      isFullscreen: isFullscreen,
      onFullscreenChanged: onFullscreenChanged,
      title: title,
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
    final formattedDate = formatMatchDate(match.matchDate);
    final status = match.status.isNotEmpty ? titleCase(match.status) : '';

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
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Sport + status chips, venue/date on their own line
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      if (match.sport.isNotEmpty)
                        _Chip(text: match.sport.toUpperCase()),
                      if (status.isNotEmpty)
                        _Chip(
                          text: status.toUpperCase(),
                          color: _statusColor(match.status),
                        ),
                    ],
                  ),
                  if (match.venue.isNotEmpty || formattedDate.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        if (match.venue.isNotEmpty) ...[
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.white54,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              match.venue,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                        if (match.venue.isNotEmpty &&
                            formattedDate.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              '•',
                              style: TextStyle(color: Colors.white38),
                            ),
                          ),
                        if (formattedDate.isNotEmpty) ...[
                          const Icon(
                            Icons.schedule,
                            size: 16,
                            color: Colors.white54,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                  const SizedBox(height: 20),

                  // Description
                  if (match.description.isNotEmpty)
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
                        match.description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                    ),
                  if (match.description.isNotEmpty) const SizedBox(height: 20),

                  // League info
                  if (seriesTitle != null && seriesTitle!.isNotEmpty)
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
                            borderRadius: BorderRadius.circular(10),
                            child: (seriesLogo != null && seriesLogo!.isNotEmpty)
                                ? Image.network(
                                    seriesLogo!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      AppImage.background,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image.asset(
                                    AppImage.background,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            seriesTitle!,
                            style: text20(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  if (seriesTitle != null && seriesTitle!.isNotEmpty)
                    const SizedBox(height: 20),

                  // Match vs card
                  if (match.teamA.isNotEmpty && match.teamB.isNotEmpty)
                    Center(
                      child: AnimatedBox(
                        padding: const EdgeInsets.all(12),
                        width: MediaQuery.sizeOf(context).width * 0.4,
                        color: AppColors.background.withAlpha(60),
                        border: Border.all(color: AppColors.background),
                        borderRadius: BorderRadius.circular(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: _MatchVersus(
                                image: match.teamALogo,
                                teamName: match.teamA,
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
                                if (status.isNotEmpty)
                                  Text(status, style: text16()),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _MatchVersus(
                                image: match.teamBLogo,
                                teamName: match.teamB,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (match.teamA.isNotEmpty && match.teamB.isNotEmpty)
                    const SizedBox(height: 20),

                  // AppTabBar
                  AppTabBar(
                    tabs: tabs,
                    selectedIndex: selectedTabIndex,
                    onChanged: onTabChanged,
                  ),
                  const SizedBox(height: 16),

                  // Tab Content
                  //
                  // NOTE: none of these tabs have a backing data model yet
                  // (no squad/scorecard/stats/performers/event/comments
                  // fields exist on MatchModel or anywhere else you've
                  // shared), so they're still illustrative mock content.
                  // The team names in the Squad tab are now real
                  // (match.teamA / match.teamB); everything else in these
                  // tabs will need real endpoints + models before it can
                  // be wired up the same way the header above now is.
                  _buildTabContent(selectedTabIndex, match),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'live':
        return const Color(0xFFE53935);
      case 'upcoming':
        return AppColors.primary;
      case 'completed':
        return Colors.white24;
      default:
        return Colors.white.withOpacity(0.15);
    }
  }

  Widget _buildTabContent(int index, MatchModel match) {
    switch (index) {
      case 0:
        return _HighlightsTab();
      case 1:
        return _SquadTab(teamA: match.teamA, teamB: match.teamB);
      case 2:
        return _ScorecardTab(teamA: match.teamA, teamB: match.teamB);
      case 3:
        return _StatsTab();
      case 4:
        return _PerformersTab();
      case 5:
        return _EventTab();
      case 6:
        return _CommentsTab();
      default:
        return const SizedBox.shrink();
    }
  }
}

/// Small pill-shaped label used for the sport/status tags
class _Chip extends StatelessWidget {
  final String text;
  final Color? color;
  const _Chip({required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: (color ?? Colors.white).withOpacity(color != null ? 0.85 : 0.15),
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
            borderRadius: BorderRadius.circular(200),
            child: image.isNotEmpty
                ? Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      AppImage.tornamentlogo,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(AppImage.tornamentlogo, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 10),
        Text(textAlign: TextAlign.center, teamName, style: text16()),
      ],
    );
  }
}

// ==================== TAB CONTENT WIDGETS ====================
// These remain mock content — see the NOTE above build() for why.

/// Highlights Tab
class _HighlightsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _VideoHighlightCard(
          title: 'Match Highlights',
          duration: '12:34',
          thumbnail: AppImage.background,
        ),
        const SizedBox(height: 12),
        _VideoHighlightCard(
          title: 'Best Moments',
          duration: '08:20',
          thumbnail: AppImage.background,
        ),
        const SizedBox(height: 12),
        _VideoHighlightCard(
          title: 'Post Match Analysis',
          duration: '15:45',
          thumbnail: AppImage.background,
        ),
      ],
    );
  }
}

class _VideoHighlightCard extends StatelessWidget {
  final String title;
  final String duration;
  final String thumbnail;

  const _VideoHighlightCard({
    required this.title,
    required this.duration,
    required this.thumbnail,
  });

  @override
  Widget build(BuildContext context) {
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
                  Image.asset(
                    thumbnail,
                    fit: BoxFit.cover,
                    width: 120,
                    height: 68,
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
                        duration,
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
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Squad Tab
class _SquadTab extends StatelessWidget {
  final String teamA;
  final String teamB;

  const _SquadTab({required this.teamA, required this.teamB});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SquadSection(
          teamName: teamA.isNotEmpty ? teamA : 'Team A',
          // Mock roster — no players endpoint exists yet.
          players: const [
            'Player 1 (C)',
            'Player 2 (WK)',
            'Player 3',
            'Player 4',
            'Player 5',
            'Player 6',
            'Player 7',
            'Player 8',
            'Player 9',
            'Player 10',
            'Player 11',
          ],
        ),
        const SizedBox(height: 16),
        _SquadSection(
          teamName: teamB.isNotEmpty ? teamB : 'Team B',
          players: const [
            'Player 1 (C)',
            'Player 2 (WK)',
            'Player 3',
            'Player 4',
            'Player 5',
            'Player 6',
            'Player 7',
            'Player 8',
            'Player 9',
            'Player 10',
            'Player 11',
          ],
        ),
      ],
    );
  }
}

class _SquadSection extends StatelessWidget {
  final String teamName;
  final List<String> players;

  const _SquadSection({required this.teamName, required this.players});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            teamName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: players.map((player) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  player,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Scorecard Tab
class _ScorecardTab extends StatelessWidget {
  final String teamA;
  final String teamB;

  const _ScorecardTab({required this.teamA, required this.teamB});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ScorecardCard(
          teamName: teamA.isNotEmpty ? teamA : 'Team A',
          runs: '—',
          overs: '—',
          rr: '—',
          topScorer: '—',
          topBowler: '—',
        ),
        const SizedBox(height: 16),
        _ScorecardCard(
          teamName: teamB.isNotEmpty ? teamB : 'Team B',
          runs: '—',
          overs: '—',
          rr: '—',
          topScorer: '—',
          topBowler: '—',
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Match Summary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Scorecard data isn\'t available from the API yet.',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScorecardCard extends StatelessWidget {
  final String teamName;
  final String runs;
  final String overs;
  final String rr;
  final String topScorer;
  final String topBowler;

  const _ScorecardCard({
    required this.teamName,
    required this.runs,
    required this.overs,
    required this.rr,
    required this.topScorer,
    required this.topBowler,
  });

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            teamName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _StatLabel(label: 'Runs', value: runs),
              _StatLabel(label: 'Overs', value: overs),
              _StatLabel(label: 'Run Rate', value: rr),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _StatLabel(label: 'Top Scorer', value: topScorer, isSmall: true),
              const SizedBox(width: 16),
              _StatLabel(label: 'Top Bowler', value: topBowler, isSmall: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatLabel extends StatelessWidget {
  final String label;
  final String value;
  final bool isSmall;

  const _StatLabel({
    required this.label,
    required this.value,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: isSmall ? 10 : 12,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmall ? 12 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Stats Tab
class _StatsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text(
            'Stats aren\'t available from the API yet.',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

/// Performers Tab
class _PerformersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text(
            'Performer data isn\'t available from the API yet.',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

/// Event Tab
class _EventTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text(
            'Event timeline isn\'t available from the API yet.',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

/// Comments Tab
class _CommentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text(
            'Comments aren\'t available from the API yet.',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ),
      ],
    );
  }
}