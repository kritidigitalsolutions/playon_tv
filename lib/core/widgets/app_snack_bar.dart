import 'package:flutter/material.dart';

class AppSnackbar {
  static OverlayEntry? _overlayEntry;

  static void _show(
    BuildContext context,
    String message, {
    required Color color,
    required IconData icon,
    Duration duration = const Duration(seconds: 4),
  }) {
    _overlayEntry?.remove();
    _overlayEntry = null;

    final overlay = Overlay.of(context);
    final mediaQuery = MediaQuery.of(context);
    
    // Position at bottom center with safe margins
    final double bottomMargin = mediaQuery.size.height * 0.05;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: bottomMargin,
        left: 0,
        right: 0,
        child: Center(
          child: GestureDetector(
            onTap: () => _dismiss(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 24,
                    spreadRadius: 4,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: color.withOpacity(0.15),
                    blurRadius: 40,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Colored icon with subtle background
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Message text - clean and readable
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);

    Future.delayed(duration, _dismiss);
  }

  static void _dismiss() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  static void success(BuildContext context, String message) {
    _show(
      context,
      message,
      color: const Color(0xFF22C55E),
      icon: Icons.check_circle_rounded,
    );
  }

  static void error(BuildContext context, String message) {
    _show(
      context,
      message,
      color: const Color(0xFFEF4444),
      icon: Icons.error_rounded,
    );
  }

  static void info(BuildContext context, String message) {
    _show(
      context,
      message,
      color: const Color(0xFF3B82F6),
      icon: Icons.info_rounded,
    );
  }

  static void warning(BuildContext context, String message) {
    _show(
      context,
      message,
      color: const Color(0xFFF59E0B),
      icon: Icons.warning_rounded,
    );
  }
}