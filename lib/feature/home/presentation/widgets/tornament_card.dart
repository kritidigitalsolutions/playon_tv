import 'package:flutter/material.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_image.dart';

class TornamentCard extends StatelessWidget {
  const TornamentCard({super.key, required this.location});
  final String location;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(AppImage.background, fit: BoxFit.cover),

            // Overall dark tint so image is a bit dimmer everywhere
            Container(color: Colors.black.withOpacity(0.25)),

            // Dark gradient so button/text stay readable
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

            // Custom "COMPLETED" status button — top-left
            Positioned(
              bottom: 50,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "COMPLETED",
                  style: text17(color: AppColors.white).copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            // Location row — bottom
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, color: AppColors.white, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    location,
                    style: text14(
                      color: AppColors.white,
                    ).copyWith(letterSpacing: 0.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
