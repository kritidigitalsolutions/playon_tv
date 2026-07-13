import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/static/app_color.dart';

class HighlightCard extends StatelessWidget {
  const HighlightCard({
    super.key,
    required this.image,
    required this.logo,
    required this.tournamentName,
    required this.teamA,
    required this.teamB,
  });

  final String image;
  final String logo;
  final String tournamentName;
  final String teamA;
  final String teamB;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320, // ← wider (was 220)
      height: 150, // ← shorter card overall
      margin: const EdgeInsets.only(right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.network(image, fit: BoxFit.cover),

            // Overall dark tint — stronger blackish look
            Container(color: Colors.black.withOpacity(0.55)), // ← was 0.25
            // Gradient for readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.45), // ← slightly darker
                    Colors.transparent,
                    Colors.black.withOpacity(0.85), // ← slightly darker
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),

            // Logo — glassy circle, top-left
            Positioned(
              top: 10,
              left: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white.withOpacity(0.15),
                      border: Border.all(
                        color: AppColors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint("Image Error: $error");
                        debugPrint("Image URL: $image");
                        return const Center(
                          child: Icon(Icons.broken_image, color: Colors.white),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Play button — centered
            Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.9),
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: AppColors.white,
                  size: 22,
                ),
              ),
            ),

            // Tournament name + teams vs — bottom
            Positioned(
              left: 12,
              right: 12,
              bottom: 10,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tournamentName,
                    style: text17(
                      color: AppColors.white,
                    ).copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          teamA,
                          style: text14(color: AppColors.white.withAlpha(200)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        " vs ",
                        style: text14(
                          color: AppColors.primary,
                        ).copyWith(fontWeight: FontWeight.w600),
                      ),
                      Expanded(
                        child: Text(
                          teamB,
                          style: text14(color: AppColors.white.withAlpha(200)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
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
