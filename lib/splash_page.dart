import 'dart:async';

import 'package:flutter/material.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_image.dart';
import 'package:playon/static/app_navigation.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // Kept as a field (not a local inside build) so we can cancel it in
  // dispose() if the user/OS tears this page down before the 5s fires —
  // otherwise a stray callback could try to navigate from a disposed
  // widget's context.
  Timer? _redirectTimer;

  @override
  void initState() {
    super.initState();
    debugPrint("🌊 [UI] SplashScreen mounted — will redirect to LoginTv in 5s");
    _redirectTimer = Timer(const Duration(seconds: 5), _goToLogin);
  }

  void _goToLogin() {
    if (!mounted) return;
    // pushReplacement (not push) so the splash screen is removed from the
    // stack — otherwise pressing Back on the TV remote from the login
    // page would return to the splash screen, which is never what you want.
    AppNavigation.pushReplacement(context, "/loginTv");
  }

  @override
  void dispose() {
    _redirectTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("🌊 [UI] Building SplashScreen");
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: BackgroundWithImg(
        child: SafeArea(
          child: Center(
            // Cap the content width on very wide TV screens so the logo
            // and copy don't stretch edge-to-edge — keeps everything
            // readable and visually centered like a proper TV splash.
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: size.width * 0.55),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Larger logo for couch-distance viewing on a TV.
                    SizedBox(
                      height: size.height * 0.22,
                      child: Image.asset(AppImage.logo, fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      "Live matches, real-time action, and everything sports",
                      style: text16(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "all in one place",
                      style: text18(color: AppColors.primary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
