import 'package:flutter/material.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/core/widgets/app_tab_bar.dart';
import 'package:playon/core/widgets/app_text_field.dart';
import 'package:playon/feature/home/presentation/widgets/cricket_view.dart';
import 'package:playon/feature/home/presentation/widgets/football_view.dart';
import 'package:playon/feature/home/presentation/widgets/hockey_view.dart';
import 'package:playon/feature/home/presentation/widgets/home_view.dart';
import 'package:playon/feature/home/presentation/widgets/khoko_view.dart';
import 'package:playon/feature/home/presentation/widgets/tennis_view.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_image.dart';
import 'package:playon/static/app_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final views = [
    HomeView(),
    CricketView(),
    FootballView(),
    HockeyView(),
    KhokoView(),
    TennisView(),
  ];
  final tabs = const [
    "HOME",
    "CRICKET",
    "FOOTBALL",
    "HOCKEY",
    "KHOKHO",
    "KABADDI",
  ];

  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BackgroundWithOneLight(
        // Whole page is one traversal group so D-pad up/down/left/right
        // moves focus in reading order across top bar -> tabs -> content.
        child: FocusTraversalGroup(
          policy: OrderedTraversalPolicy(),
          child: Column(
            children: [
              _buildTopBar(controller: searchController),

              Expanded(
                child: Column(
                  children: [
                    // If AppTabBar isn't focus-aware yet, share its source
                    // and I'll wrap each tab in TvFocusable too. For now
                    // remote select still works via mouse/touch fallback.
                    AppTabBar(
                      tabs: tabs,
                      selectedIndex: selectedIndex,
                      onChanged: (index) {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                    ),

                    Expanded(
                      child: IndexedStack(
                        index: selectedIndex,
                        children: views,
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
  }

  Widget _buildTopBar({required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          Image.asset(AppImage.logo, width: 120, height: 55, fit: BoxFit.cover),

          const SizedBox(width: 30),

          // Search field: TV remotes can open the keyboard on select.
          // autofocus true so the page always starts with something focused.
          Expanded(
            child: TvFocusable(
              autofocus: true,
              borderRadius: BorderRadius.circular(30),
              onSelect: () {
                FocusScope.of(context).requestFocus(FocusNode());
                // opens the on-screen keyboard for the text field
                _searchFieldFocus.requestFocus();
              },
              child: AppTextField(
                controller: controller,
                focusNode: _searchFieldFocus,
                hintText: "Search Matches",
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 14, right: 10),
                  child: Icon(
                    Icons.search,
                    size: 22,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          TvFocusable(
            borderRadius: BorderRadius.circular(50),
            onSelect: () {},
            child: CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.textSecondary.withAlpha(40),
              child: const Icon(Icons.person),
            ),
          ),

          const SizedBox(width: 15),

          TvFocusable(
            borderRadius: BorderRadius.circular(50),
            onSelect: () {
              AppNavigation.push(context, "notification");
            },
            child: CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.warning.withAlpha(40),
              child: const Icon(Icons.notifications, color: AppColors.warning),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
    );
  }

  final FocusNode _searchFieldFocus = FocusNode();
}
