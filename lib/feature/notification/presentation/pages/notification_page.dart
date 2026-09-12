import 'package:flutter/material.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_navigation.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BackgroundWithOneLight(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: FocusTraversalGroup(
              policy: ReadingOrderTraversalPolicy(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TvFocusable(
                        autofocus: true,
                        borderRadius: BorderRadius.circular(50),
                        onSelect: () => AppNavigation.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text("Notifications", style: text24()),
                      const Spacer(),
                      TvFocusable(
                        borderRadius: BorderRadius.circular(20),
                        onSelect: () {
                          // Mark all read action
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.done_all,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Mark all read",
                                style: text14(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.notifications_none_rounded,
                            size: 64,
                            color: Colors.white.withOpacity(0.35),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No new notifications",
                            style: text17(color: Colors.white.withOpacity(0.7)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
