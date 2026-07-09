import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playon/core/widgets/custom_drawer.dart';
import 'package:playon/feature/auth/bloc/auth/auth_bloc.dart';
import 'package:playon/feature/highlights/presentation/pages/highlights.dart';
import 'package:playon/feature/home/presentation/page/home_page.dart';
import 'package:playon/feature/live_tv/presentation/pages/live_tv.dart';
import 'package:playon/feature/series/presentation/pages/series.dart';
import 'package:playon/static/app_color.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  initState() {
    context.read<AuthBloc>().add(AuthEvent.fetchUser());
    super.initState();
  }

  int selectedIndex = 0;

  final items = const [
    DrawerItemData(icon: Icons.home, label: "Home"),
    DrawerItemData(icon: Icons.sports_cricket, label: "Live Tv"),
    DrawerItemData(icon: Icons.emoji_events, label: "Series"),
    DrawerItemData(icon: Icons.person, label: "Highlights"),
  ];

  // Map each drawer index to its actual page widget
  final List<Widget> pages = const [
    HomePage(),
    LiveTv(),
    Series(),
    Highlights(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.black,
          body: Row(
            children: [
              CustomDrawer(
                items: items,
                selectedIndex: selectedIndex,
                onItemSelected: (index) {
                  setState(() => selectedIndex = index);
                },
              ),
              // Page content fills the rest of the screen
              Expanded(
                child: IndexedStack(index: selectedIndex, children: pages),
              ),
            ],
          ),
        );
      },
    );
  }
}
