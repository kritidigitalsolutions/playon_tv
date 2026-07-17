import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/core/widgets/app_dilog.dart';
import 'package:playon/core/widgets/app_tab_bar.dart';
import 'package:playon/core/widgets/app_text_field.dart';
import 'package:playon/feature/home/presentation/widgets/sports_view.dart';
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

  final tabs = const [
    "HOME",
    "CRICKET",
    "FOOTBALL",
    "HOCKEY",
    "KHOKHO",
    "KABADDI",
  ];

  // Map tabs to their sport filter values
  String _getSportFilter(int index) {
    switch (index) {
      case 0:
        return 'HOME';
      case 1:
        return 'CRICKET';
      case 2:
        return 'FOOTBALL';
      case 3:
        return 'HOCKEY';
      case 4:
        return 'KHOKHO';
      case 5:
        return 'KABADDI';
      default:
        return 'HOME';
    }
  }

  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // intercept every pop attempt on this screen
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await showExitConfirmationDialog(context);
        if (shouldExit == true) {
          SystemNavigator.pop(); // closes the app
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BackgroundWithOneLight(
          child: FocusTraversalGroup(
            policy: OrderedTraversalPolicy(),
            child: Column(
              children: [
                _buildTopBar(controller: searchController),
                Expanded(
                  child: Column(
                    children: [
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
                        child: SportsView(
                          sportFilter: _getSportFilter(selectedIndex),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final FocusNode _searchFieldFocus = FocusNode();

  Widget _buildTopBar({required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Image.asset(AppImage.logo, width: 120, height: 55, fit: BoxFit.cover),
          const SizedBox(width: 30),

          Expanded(
            child: TvFocusable(
              
              autofocus: true,
              borderRadius: BorderRadius.circular(30),
              onSelect: () {
                _searchFieldFocus.requestFocus();
                AppNavigation.push(context, "/searchPage");
              },
              child: IgnorePointer(
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
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}
