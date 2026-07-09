import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/core/widgets/animated.dart';
import 'package:playon/core/widgets/app_tab_bar.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_image.dart';
import 'package:playon/static/app_navigation.dart';

class TrendingDetailPage extends StatefulWidget {
  const TrendingDetailPage({super.key, required this.id});
  final int id;
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
      firstFocus!.requestFocus();
    });
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
                            Image.asset(AppImage.background, fit: BoxFit.cover),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          color: AppColors.white.withOpacity(
                                            0.15,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            200,
                                          ),
                                          border: Border.all(
                                            color: AppColors.white.withOpacity(
                                              0.3,
                                            ),
                                            width: 1,
                                          ),
                                        ),
                                        child: Image.asset(
                                          AppImage.logo,
                                          width: 48,
                                          height: 48,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Raina Superkings vs Migsun Champions",
                                    style: text18(),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "24 Jun 2026 - 30 Jun 2026",
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
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: IndexedStack(
                            index: selectedIndex,
                            children: [
                              Focus(
                                focusNode: _tabRootNodes[0],
                                canRequestFocus: false,
                                skipTraversal: true,
                                child: const _HomeTab(),
                              ),
                              Focus(
                                focusNode: _tabRootNodes[1],
                                canRequestFocus: false,
                                skipTraversal: true,
                                child: const _UpcomingTab(),
                              ),
                              Focus(
                                focusNode: _tabRootNodes[2],
                                canRequestFocus: false,
                                skipTraversal: true,
                                child: const _HighlightsTab(),
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
                                child: const _TeamsTab(),
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
  }
}

// Placeholder tab content widgets — replace with your actual content

class _HomeTab extends StatelessWidget {
  const _HomeTab();
  @override
  Widget build(BuildContext context) {
    final recents = [
      {
        "image": AppImage.background,
        "title": "CRICKET",
        "content": "Raina Superkings vs Migsun Champions",
        "date": "24 Jun 2026",
      },
      {
        "image": AppImage.background,
        "title": "CRICKET",
        "content": "Raina Superkings vs Migsun Champions",
        "date": "24 Jun 2026",
      },
      {
        "image": AppImage.background,
        "title": "CRICKET",
        "content": "Raina Superkings vs Migsun Champions",
        "date": "24 Jun 2026",
      },
    ];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Recent Results", style: text18()),
          const SizedBox(height: 8),
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
                              child: Image.asset(
                                item['image']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item['title']!,
                                style: text20(color: AppColors.primary),
                              ),
                              Text(
                                item['content']!,
                                style: text17(color: AppColors.white),
                              ),
                              Text(
                                item['date']!,
                                style: text17(
                                  color: AppColors.white.withAlpha(60),
                                ),
                              ),
                            ],
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
  const _UpcomingTab();
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Upcoming Content'));
  }
}

class _HighlightsTab extends StatelessWidget {
  const _HighlightsTab();
  @override
  Widget build(BuildContext context) {
    final highlights = [
      {
        "image": AppImage.background,
        "title": "CRICKET",
        "content": "GPL 2026 Cricket Action",
        "date": "24 Jun 2026",
        "matches": "MINGSUN CHAMPIONS vs GLADIATOURS",
      },
      {
        "image": AppImage.background,
        "title": "CRICKET",
        "content": "GPL 2026 Cricket Action",
        "date": "24 Jun 2026",
        "matches": "MINGSUN CHAMPIONS vs GLADIATOURS",
      },
      {
        "image": AppImage.background,
        "title": "CRICKET",
        "content": "GPL 2026 Cricket Action",
        "date": "24 Jun 2026",
        "matches": "MINGSUN CHAMPIONS vs GLADIATOURS",
      },
      {
        "image": AppImage.background,
        "title": "CRICKET",
        "content": "GPL 2026 Cricket Action",
        "date": "24 Jun 2026",
        "matches": "MINGSUN CHAMPIONS vs GLADIATOURS",
      },
      {
        "image": AppImage.background,
        "title": "CRICKET",
        "content": "GPL 2026 Cricket Action",
        "date": "24 Jun 2026",
        "matches": "MINGSUN CHAMPIONS vs GLADIATOURS",
      },
      {
        "image": AppImage.background,
        "title": "CRICKET",
        "content": "GPL 2026 Cricket Action",
        "date": "24 Jun 2026",
        "matches": "MINGSUN CHAMPIONS vs GLADIATOURS",
      },
    ];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FocusTraversalGroup(
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
            final teams = item['matches']!.split(' vs ');
            final teamA = teams.isNotEmpty ? teams[0].trim() : '';
            final teamB = teams.length > 1 ? teams[1].trim() : '';

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
                            Image.asset(item['image']!, fit: BoxFit.cover),
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
                            teamA,
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
                            teamB,
                            style: text17(color: AppColors.white),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item['content'] ?? '',
                            style: text17(
                              color: AppColors.white.withAlpha(150),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item['date'] ?? '',
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
      ),
    );
  }
}

class _PointsTab extends StatelessWidget {
  const _PointsTab();
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Points Content'));
  }
}

class _TeamsTab extends StatelessWidget {
  const _TeamsTab();
  @override
  Widget build(BuildContext context) {
    final teams = [
      {"logo": AppImage.logo, "name": "SAI KINGS", "country": "INDIA"},
      {"logo": AppImage.logo, "name": "GLADIATORS", "country": "INDIA"},
      {"logo": AppImage.logo, "name": "CHAMPIONS", "country": "INDIA"},
      {"logo": AppImage.logo, "name": "WARRIORS", "country": "INDIA"},
      {"logo": AppImage.logo, "name": "TITANS", "country": "INDIA"},
      {"logo": AppImage.logo, "name": "STRIKERS", "country": "INDIA"},
      {"logo": AppImage.logo, "name": "ROYALS", "country": "INDIA"},
    ];
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
                      child: Center(
                        child: Image.asset(
                          item['logo']!,
                          width: 28,
                          height: 28,
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
                            item['name'] ?? '',
                            style: text17(color: AppColors.white),
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item['country'] ?? '',
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
