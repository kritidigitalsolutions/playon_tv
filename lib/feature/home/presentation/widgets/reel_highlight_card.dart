import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/static/app_color.dart';

class ReelHighlightCard extends StatelessWidget {
  const ReelHighlightCard({
    super.key,
    required this.image,
    required this.sport,
    required this.topicName,
    required this.topicContent,
  });

  final String image;
  final String sport;
  final String topicName;
  final String topicContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 260,
      margin: const EdgeInsets.only(right: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(image, fit: BoxFit.cover),

            // Single gradient layer only — no extra flat black tint
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.55),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.85),
                  ],
                  stops: const [0.0, 0.3, 0.55, 1.0],
                ),
              ),
            ),

            // Sport tag — top-left pill, distinct accent color (not black)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  sport.toUpperCase(),
                  style: text14(color: AppColors.white).copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),

            // Play button — glassy, centered
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white.withOpacity(0.15),
                      border: Border.all(
                        color: AppColors.white.withOpacity(0.35),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),

            // Topic name + content — bottom
            Positioned(
              left: 10,
              right: 10,
              bottom: 12,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topicName,
                    style: text17(
                      color: AppColors.white,
                    ).copyWith(fontWeight: FontWeight.w600, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    topicContent,
                    style: text14(color: AppColors.white.withAlpha(180)),
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
  }
}
