// ignore_for_file: deprecated_member_use, unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playon/core/models/response/high_light_detail_model.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/core/widgets/animated.dart';
import 'package:playon/core/widgets/app_tab_bar.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/core/widgets/media_payler_widget.dart';
import 'package:playon/feature/highlights/bloc/highlight/highlight_bloc.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_image.dart';

class HighlightMatchPage extends StatefulWidget {
  const HighlightMatchPage({super.key, required this.id});
  final String id; // was `int` — switched to match route/usecase types

  @override
  State<HighlightMatchPage> createState() => _HighlightMatchPageState();
}

class _HighlightMatchPageState extends State<HighlightMatchPage> {
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

  @override
  void initState() {
    super.initState();
    context.read<HighlightBloc>().add(
          HighlightEvent.highlightDetail(id: widget.id),
        );
  }

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
          highlight:highlight ,
          isFullscreen: _isFullscreen,
          selectedTabIndex: _selectedTabIndex,
          tabs: _tabs,
          onFullscreenChanged: _handleFullscreenChanged,
          onTabChanged: (index) => setState(() => _selectedTabIndex = index),
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
  });

  final HighlightDetailResponse highlight;
  final bool isFullscreen;
  final int selectedTabIndex;
  final List<String> tabs;
  final ValueChanged<bool> onFullscreenChanged;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final player = MediaPlayerWidget(
      url: highlight.highlight.videoUrl,
      autoPlay: true,
      isFullscreen: isFullscreen,
      onFullscreenChanged: onFullscreenChanged,
      title: highlight.highlight.title,
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
                    highlight.highlight.title,
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
                      if (highlight.highlight. series.sport.isNotEmpty)
                        _Chip(text: highlight .highlight.series.sport.toUpperCase()),
                      if (highlight .highlight.series.sport.isNotEmpty &&
                          highlight. highlight. category.isNotEmpty)
                        const SizedBox(width: 10),
                      if (highlight.highlight.category.isNotEmpty)
                        _Chip(text: highlight.highlight.category.toUpperCase()),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description
                  if (highlight.highlight.description.isNotEmpty)
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
                        highlight.highlight.description,
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
                            highlight.highlight.series.tournamentLogo,
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
                          highlight.highlight.series.title,
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
                              image: highlight.highlight.teamA.logo,
                              teamName: highlight.highlight.teamA.name,
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
                                highlight.highlight.series.status.isNotEmpty
                                    ? highlight.highlight.series.status
                                    : "Completed",
                                style: text16(),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _MatchVersus(
                              image: highlight.highlight.teamB.logo,
                              teamName: highlight.highlight.teamB.name,
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

                  // Tab Content
                  _buildTabContent(selectedTabIndex),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(int index) {
    switch (index) {
      case 0:
        return _HighlightsTab();
      case 1:
        return _SquadTab();
      case 2:
        return _ScorecardTab();
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
  const _MatchVersus({
    super.key,
    required this.image,
    required this.teamName,
  });
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
              errorBuilder: (_, __, ___) => Image.asset(
                AppImage.tornamentlogo,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(textAlign: TextAlign.center, teamName, style: text16()),
      ],
    );
  }
}

// ==================== TAB CONTENT WIDGETS ====================

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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SquadSection(
          teamName: 'Raina Superkings',
          players: [
            'Raina (C)',
            'Dhoni (WK)',
            'Jadeja',
            'Bravo',
            'Watson',
            'Rayudu',
            'Chahar',
            'Thakur',
            'Tahir',
            'Harbhajan',
            'Morkel',
          ],
        ),
        const SizedBox(height: 16),
        _SquadSection(
          teamName: 'Migsun Champions',
          players: [
            'Kohli (C)',
            'Buttler (WK)',
            'Maxwell',
            'Miller',
            'Russell',
            'Hasan',
            'Bumrah',
            'Shami',
            'Chahal',
            'Rashid',
            'Boult',
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ScorecardCard(
          teamName: 'Raina Superkings',
          runs: '245/4',
          overs: '42.3',
          rr: '5.78',
          topScorer: 'Dhoni 68* (45)',
          topBowler: 'Bumrah 2/32',
        ),
        const SizedBox(height: 16),
        _ScorecardCard(
          teamName: 'Migsun Champions',
          runs: '210/8',
          overs: '40.0',
          rr: '5.25',
          topScorer: 'Kohli 54 (38)',
          topBowler: 'Chahar 3/28',
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
                'Raina Superkings won by 35 runs',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                'Player of the Match: Dhoni',
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
    return Column(
      children: [
        _StatsGrid(),
        const SizedBox(height: 16),
        _StatItemCard(
          title: 'Batting Stats',
          stats: ['Most Runs: Dhoni - 128', 'Best Avg: Kohli - 56.5'],
        ),
        const SizedBox(height: 12),
        _StatItemCard(
          title: 'Bowling Stats',
          stats: ['Most Wickets: Bumrah - 8', 'Best Economy: Chahar - 4.2'],
        ),
      ],
    );
  }
}

class _StatItemCard extends StatelessWidget {
  final String title;
  final List<String> stats;

  const _StatItemCard({required this.title, required this.stats});

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
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...stats.map(
            (stat) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                stat,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Performers Tab
class _PerformersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PerformerCard(
          name: 'Dhoni',
          role: 'WK-Batsman',
          team: 'Raina Superkings',
          stat: '68* runs • 45 balls',
          image: AppImage.background,
        ),
        const SizedBox(height: 12),
        _PerformerCard(
          name: 'Bumrah',
          role: 'Bowler',
          team: 'Migsun Champions',
          stat: '2/32 • Economy: 4.2',
          image: AppImage.background,
        ),
        const SizedBox(height: 12),
        _PerformerCard(
          name: 'Kohli',
          role: 'Batsman',
          team: 'Migsun Champions',
          stat: '54 runs • 38 balls',
          image: AppImage.background,
        ),
      ],
    );
  }
}

class _PerformerCard extends StatelessWidget {
  final String name;
  final String role;
  final String team;
  final String stat;
  final String image;

  const _PerformerCard({
    required this.name,
    required this.role,
    required this.team,
    required this.stat,
    required this.image,
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
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(image),
            backgroundColor: Colors.grey[800],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  role,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
                Text(
                  team,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              stat,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Event Tab
class _EventTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _EventCard(
          title: 'Opening Ceremony',
          time: '7:00 PM',
          description: 'Spectacular opening ceremony with fireworks',
        ),
        const SizedBox(height: 12),
        _EventCard(
          title: 'Match Start',
          time: '7:30 PM',
          description: 'First ball of the match',
        ),
        const SizedBox(height: 12),
        _EventCard(
          title: 'First Innings',
          time: '8:30 PM',
          description: 'Raina Superkings batting',
        ),
        const SizedBox(height: 12),
        _EventCard(
          title: 'Second Innings',
          time: '9:45 PM',
          description: 'Migsun Champions batting',
        ),
        const SizedBox(height: 12),
        _EventCard(
          title: 'Post Match Presentation',
          time: '11:00 PM',
          description: 'Awards and player interviews',
        ),
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  final String title;
  final String time;
  final String description;

  const _EventCard({
    required this.title,
    required this.time,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              time,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Comments Tab
class _CommentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CommentCard(
          user: 'SportsFan99',
          comment: 'What a match! Dhoni is still the best finisher! 🔥',
          time: '2 min ago',
          likes: '24',
        ),
        const SizedBox(height: 12),
        _CommentCard(
          user: 'CricketLover',
          comment: 'Amazing innings from Kohli. Class act! 👏',
          time: '15 min ago',
          likes: '18',
        ),
        const SizedBox(height: 12),
        _CommentCard(
          user: 'CricketAnalyst',
          comment: 'Great bowling performance from Bumrah at the death.',
          time: '1 hour ago',
          likes: '9',
        ),
        const SizedBox(height: 12),
        _CommentCard(
          user: 'FanBoy',
          comment:
              'Best match of the season so far! Can\'t wait for the next one.',
          time: '2 hours ago',
          likes: '15',
        ),
      ],
    );
  }
}

class _CommentCard extends StatelessWidget {
  final String user;
  final String comment;
  final String time;
  final String likes;

  const _CommentCard({
    required this.user,
    required this.comment,
    required this.time,
    required this.likes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary.withOpacity(0.3),
                child: Text(
                  user[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                user,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                time,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 14,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.favorite_border,
                color: Colors.white38,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                likes,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.reply_rounded, color: Colors.white38, size: 16),
              const SizedBox(width: 4),
              Text(
                'Reply',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================== STATS GRID ====================

class _StatsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 6,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 4,
      children: const [
        _StatItem(label: 'Runs', value: '245/4'),
        _StatItem(label: 'Overs', value: '42.3'),
        _StatItem(label: 'Run Rate', value: '5.78'),
        _StatItem(label: 'Fours', value: '24'),
        _StatItem(label: 'Sixes', value: '8'),
        _StatItem(label: 'Wickets', value: '4'),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}