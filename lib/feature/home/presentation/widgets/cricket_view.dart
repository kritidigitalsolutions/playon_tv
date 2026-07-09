import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/core/widgets/bottom_view.dart';
import 'package:playon/feature/home/presentation/widgets/highlight_card.dart';
import 'package:playon/feature/home/presentation/widgets/podcast_card.dart';
import 'package:playon/feature/home/presentation/widgets/reel_highlight_card.dart';
import 'package:playon/feature/home/presentation/widgets/tornament_card.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_image.dart';
import 'package:playon/static/app_navigation.dart';

class CricketView extends StatefulWidget {
  const CricketView({super.key});

  @override
  State<CricketView> createState() => _CricketViewState();
}

class _CricketViewState extends State<CricketView> {
  final List images = [
    {"id": 1, "images": AppImage.background},
    {"id": 2, "images": AppImage.background},
    {"id": 3, "images": AppImage.background},
    {"id": 4, "images": AppImage.background},
  ];
  final List<Map<String, String>> highlights = [
    {
      "image": AppImage.background,
      "logo": AppImage.logo,
      "tournamentName": "Ghaziabad Premier League 2026",
      "teamA": "SAI KINGS",
      "teamB": "GLADIATORS",
    },
    {
      "image": AppImage.background,
      "logo": AppImage.logo,
      "tournamentName": "Meerut T20 Trophy 2026",
      "teamA": "CHAMPIONS",
      "teamB": "WARRIORS",
    },
    {
      "image": AppImage.background,
      "logo": AppImage.logo,
      "tournamentName": "GPL 2026 Cricket Action",
      "teamA": "MINGSUN CHAMPIONS",
      "teamB": "GLADIATOURS",
    },
    {
      "image": AppImage.background,
      "logo": AppImage.logo,
      "tournamentName": "UP Super League 2026",
      "teamA": "TITANS",
      "teamB": "STRIKERS",
    },
    {
      "image": AppImage.background,
      "logo": AppImage.logo,
      "tournamentName": "Noida Cricket Cup 2026",
      "teamA": "ROYALS",
      "teamB": "SAI KINGS",
    },
  ];
  final List<Map<String, String>> reels = [
    {
      "image": AppImage.background,
      "sport": "Cricket",
      "topicName": "Last-ball thriller",
      "topicContent": "SAI Kings edge Gladiators",
    },
    {
      "image": AppImage.background,
      "sport": "Football",
      "topicName": "Hat-trick heroics",
      "topicContent": "Champions dominate 4-1",
    },
    {
      "image": AppImage.background,
      "sport": "Kabaddi",
      "topicName": "Raid of the match",
      "topicContent": "Titans stun Warriors",
    },
    {
      "image": AppImage.background,
      "sport": "Cricket",
      "topicName": "Century in style",
      "topicContent": "Royals seal the series",
    },
  ];
  final List<Map<String, String>> podcasts = [
    {
      "image": AppImage.background,
      "title": "Match day breakdown",
      "duration": "24 min",
    },
    {
      "image": AppImage.background,
      "title": "Behind the scenes",
      "duration": "18 min",
    },
    {
      "image": AppImage.background,
      "title": "Player interview special",
      "duration": "32 min",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Slider — not remote-focusable, it's a swipe carousel.
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.55,
            child: FocusTraversalGroup(
              policy: ReadingOrderTraversalPolicy(),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return TvFocusable(
                    autofocus:
                        index == 0, // first banner is the page's landing focus
                    borderRadius: BorderRadius.circular(20),
                    onSelect: () {
                      AppNavigation.push(
                        context,
                        "/trending/${images[index]['id']}",
                      );
                    },
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 0.85,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(images[index]["images"]!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("Trending Series", style: text24()),
          ),

          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: FocusTraversalGroup(
              policy:
                  ReadingOrderTraversalPolicy(), // was OrderedTraversalPolicy()
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return TvFocusable(
                    onSelect: () {
                      AppNavigation.push(
                        context,
                        "/trending/${images[index]['id']}",
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
                            Image.asset(
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
                                      color: AppColors.white.withOpacity(0.15),
                                      border: Border.all(
                                        color: AppColors.white.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Image.asset(
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
                                "Ghaziabad Premier League 2026",
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
          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text("Ghaziabad Premier League 2026", style: text24()),
                Spacer(),
                TvFocusable(
                  onSelect: () {
                    AppNavigation.push(context, "/trending/1");
                  },
                  child: Text(
                    "View All",
                    style: text18(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 250,
            child: FocusTraversalGroup(
              policy: WidgetOrderTraversalPolicy(),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return TvFocusable(
                    onSelect: () {},
                    child: TornamentCard(location: 'UP'),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text("CC&FC T10 CRICKET PREMIER LEADUE 2025", style: text24()),
                Spacer(),
                TvFocusable(
                  onSelect: () {
                    AppNavigation.push(context, "/trending/1");
                  },
                  child: Text(
                    "View All",
                    style: text18(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 250,
            child: FocusTraversalGroup(
              policy: WidgetOrderTraversalPolicy(),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return TvFocusable(
                    onSelect: () {},
                    child: TornamentCard(location: 'CCFC'),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Match Highights", style: text24()),
          ),
          SizedBox(
            height: 250,
            child: FocusTraversalGroup(
              policy: WidgetOrderTraversalPolicy(),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: highlights.length,
                itemBuilder: (context, index) {
                  final item = highlights[index];
                  return TvFocusable(
                    onSelect: () {
                      // navigate to highlight detail if needed
                    },
                    child: HighlightCard(
                      image: item['image']!,
                      logo: item['logo'] ?? AppImage.logo,
                      tournamentName: item['tournamentName']!,
                      teamA: item['teamA']!,
                      teamB: item['teamB']!,
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Star Player Edition", style: text24()),
          ),
          SizedBox(
            height: 260,
            child: FocusTraversalGroup(
              policy: WidgetOrderTraversalPolicy(),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: reels.length,
                itemBuilder: (context, index) {
                  final item = reels[index];
                  return TvFocusable(
                    onSelect: () {
                      // navigate to reel/video player
                    },
                    child: ReelHighlightCard(
                      image: item['image']!,
                      sport: item['sport']!,
                      topicName: item['topicName']!,
                      topicContent: item['topicContent']!,
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text("Latest Podcasts", style: text24()),
                Spacer(),
                TvFocusable(
                  onSelect: () {},
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
                      AppNavigation.push(context, "/podcast/1");
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
          SizedBox(height: 20),
          BottomView(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
