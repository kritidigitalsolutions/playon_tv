import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/core/widgets/animated.dart';
import 'package:playon/feature/home/bloc/social_media/social_media_cubit.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_image.dart';

class BottomView extends StatefulWidget {
  const BottomView({super.key});

  @override
  State<BottomView> createState() => _BottomViewState();
}

class _BottomViewState extends State<BottomView> {
  @override
  void initState() {
    super.initState();
    context.read<SocialMediaCubit>().getSocialMedia();
  }

  @override
  Widget build(BuildContext context) {
    FaIconData _getIcon(String platform) {
      switch (platform.toLowerCase()) {
        case 'youtube':
          return FontAwesomeIcons.youtube;

        case 'twitter':
        case 'x':
          return FontAwesomeIcons.xTwitter;

        case 'facebook':
          return FontAwesomeIcons.facebookF;

        case 'instagram':
          return FontAwesomeIcons.instagram;

        case 'linkedin':
          return FontAwesomeIcons.linkedinIn;

        case 'email':
          return FontAwesomeIcons.envelope;

        default:
          return FontAwesomeIcons.globe;
      }
    }

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

          BlocBuilder<SocialMediaCubit, SocialMediaState>(
            builder: (context, state) {
              if (state.socialMediaStatus == Status.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.socialMediaStatus == Status.error) {
                return const Center(
                  child: Text(
                    "Failed to load social media",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: state.socialMedia.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: PlatformApps(
                      icon: _getIcon(item.platform),
                      onTap: () {
                        // launchUrlString(item.url);
                      },
                    ),
                  );
                }).toList(),
              );
            },
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
