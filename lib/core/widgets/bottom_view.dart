import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:playon/core/widgets/animated.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_image.dart';

class BottomView extends StatelessWidget {
  const BottomView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Image.asset(
              AppImage.logo,
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
          ),

          // Social platform icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PlatformApps(
                icon: FontAwesomeIcons.youtube,
                onTap: () {
                  // launch YouTube link
                },
              ),
              PlatformApps(
                icon: FontAwesomeIcons.xTwitter,
                onTap: () {
                  // launch X link
                },
              ),
              PlatformApps(
                icon: FontAwesomeIcons.facebookF,
                onTap: () {
                  // launch Facebook link
                },
              ),
              PlatformApps(
                icon: FontAwesomeIcons.instagram,
                onTap: () {
                  // launch Instagram link
                },
              ),
              PlatformApps(
                icon: FontAwesomeIcons.envelope,
                onTap: () {
                  // launch mail
                },
              ),
              PlatformApps(
                icon: FontAwesomeIcons.linkedinIn,
                onTap: () {
                  // launch LinkedIn link
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Copyright text
          Center(
            child: Text(
              "\u00A9 2026 PlayOn. All rights reserved.",
              style: TextStyle(
                color: AppColors.white.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Footer links with dividers between them
          Center(
            child: RichText(
              selectionColor: AppColors.primary,
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
                children: [
                  TextSpan(
                    text: "Privacy Policy",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // navigate to Privacy Policy
                      },
                  ),
                  const TextSpan(text: "  |  "),
                  TextSpan(
                    text: "Refund Policy",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // navigate to Refund Policy
                      },
                  ),
                  const TextSpan(text: "  |  "),
                  TextSpan(
                    text: "Term of Use",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // navigate to Term of Use
                      },
                  ),
                  const TextSpan(text: "  |  "),
                  TextSpan(
                    text: "About us",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // navigate to About us
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlatformApps extends StatelessWidget {
  const PlatformApps({super.key, required this.icon, required this.onTap});

  final FaIconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBox(
        height: 50,
        width: 50,
        color: AppColors.background.withAlpha(60),
        borderRadius: BorderRadius.circular(200),
        child: Center(child: FaIcon(icon, color: AppColors.white, size: 20)),
      ),
    );
  }
}
