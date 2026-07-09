import 'package:flutter/material.dart';
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
        child: Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      AppNavigation.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: AppColors.white),
                  ),
                  SizedBox(width: 20),
                  Text("Notification", style: text20()),
                  Spacer(),
                  Row(
                    children: [
                      Icon(Icons.done_all, color: AppColors.white),
                      Text(
                        "Mark all read",
                        style: TextStyle(color: AppColors.white),
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
