import 'package:flutter/material.dart';
import 'package:playon/static/app_image.dart';

class BackgroundWithImg extends StatelessWidget {
  final Widget child;
  const BackgroundWithImg({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          AppImage.background,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.secPrimary.withOpacity(0.8),
          ),
        ),

        Positioned(right: -50, top: -50, child: _softBlueGlow()),

        Positioned(left: -50, bottom: -50, child: _softBlueGlow()),
        child,
      ],
    );
  }
}

class BackgroundWithOutImg extends StatelessWidget {
  final Widget child;
  const BackgroundWithOutImg({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.secPrimary.withOpacity(0.2),
          ),
        ),

        Positioned(right: -50, top: -50, child: _softBlueGlow()),

        Positioned(left: -50, bottom: -50, child: _softBlueGlow()),
        child,
      ],
    );
  }
}

class BackgroundWithOneLight extends StatelessWidget {
  final Widget child;
  const BackgroundWithOneLight({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.secPrimary.withOpacity(0.2),
          ),
        ),
        Positioned(left: -50, bottom: -50, child: _softBlueGlow()),
        child,
      ],
    );
  }
}

Widget _softBlueGlow() {
  return Container(
    width: 250,
    height: 250,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(
        colors: [Colors.blue.withOpacity(0.12), Colors.transparent],
      ),
    ),
  );
}

class AppColors {
  // static const Color background = Color(0xFF040B23);
  static const Color background = Color(0xFF040B23);

  // Primary Colors
  static const Color primary = Color(0xFF0084FF);
  static const Color secPrimary = Color(0xFF040B23);
  static const Color blackCard = Color(0xFF010512);

  // button color
  static const Color button = primary;
  static const Color secButton = Color(0xFF860B0B);

  // BLACK (opacity based like Flutter)
  static const Color black = Colors.black;
  static const Color black87 = Colors.black87;
  static const Color black54 = Colors.black54;
  static const Color black26 = Colors.black26;

  // WHITE
  static const Color white = Colors.white;
  static const Color white70 = Colors.white70;
  static const Color white60 = Colors.white60;
  static const Color white38 = Colors.white38;
  static const Color white24 = Colors.white24;
  static const Color white12 = Colors.white12;

  // TEXT (Always White Theme)
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textHint = Colors.white38;

  // GREY SHADES (Material style)
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // DIVIDER / BORDER
  static const Color divider = grey300;
  static const Color border = grey400;

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color redAccent = Colors.redAccent;
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Transparent
  static const Color transparent = Colors.transparent;
}
