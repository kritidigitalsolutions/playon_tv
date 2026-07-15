import 'package:flutter/material.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/static/app_color.dart';

class PodcastCard extends StatelessWidget {
  const PodcastCard({
    super.key,
    required this.image,
    required this.title,
    required this.duration,
  });

  final String image;
  final String title;
  final String duration; // e.g. "24 min"

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image section — sized by aspect ratio, not a hardcoded height
          AspectRatio(
            aspectRatio:
                3/3.6, 
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image
                  Image.network(image, fit: BoxFit.cover),

                  Container(color: Colors.black.withOpacity(0.4)),

                  // Play button — bottom-right circular container
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Title + subtitle strip — sizes to its own content
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: text17(
                    color: AppColors.white,
                  ).copyWith(fontWeight: FontWeight.w600, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  duration,
                  style: text14(color: AppColors.white.withAlpha(150)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
