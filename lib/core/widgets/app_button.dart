import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/static/app_color.dart';

/// Shared TV remote key handling: select/enter/gameButtonA -> onTap.
/// Enter/space are left "ignored" for Material buttons since Material's
/// own ActivateIntent shortcuts already handle those; we only need to
/// add the extra "select" key TV remotes send.
KeyEventResult _handleTvKey(
  KeyEvent event,
  VoidCallback? onTap, {
  bool alsoHandleEnter = false,
}) {
  if (event is KeyDownEvent) {
    final key = event.logicalKey;
    final isSelect =
        key == LogicalKeyboardKey.select ||
        key == LogicalKeyboardKey.gameButtonA;
    final isEnter = alsoHandleEnter && key == LogicalKeyboardKey.enter;
    if (isSelect || isEnter) {
      onTap?.call();
      return KeyEventResult.handled;
    }
  }
  return KeyEventResult.ignored;
}

class AppButton extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final bool isLoading;
  final Color? color;
  final double height;
  final double radius;
  final TextStyle? textStyle;

  const AppButton({
    super.key,
    required this.title,
    required this.onTap,
    this.isLoading = false,
    this.color,
    this.height = 45,
    this.radius = 30,
    this.textStyle,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (v) => setState(() => focused = v),
      // InkWell already handles Enter/Space itself via Material's
      // default ActivateIntent — we only add the remote's "select" key.
      onKeyEvent: (node, event) =>
          _handleTvKey(event, widget.isLoading ? null : widget.onTap),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          border: Border.all(
            color: focused ? Colors.white.withOpacity(0.9) : Colors.transparent,
            width: 2,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.radius),
          onTap: widget.isLoading ? null : widget.onTap,
          child: Container(
            height: widget.height,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.isLoading
                  ? (widget.color ?? AppColors.button).withOpacity(0.7)
                  : widget.color ?? AppColors.button,
              borderRadius: BorderRadius.circular(widget.radius),
            ),
            child: widget.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    widget.title,
                    style:
                        widget.textStyle ?? text15(fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ),
    );
  }
}

class AppOutlineButton extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final Color? color;
  final double height;
  final double radius;
  final TextStyle? textStyle;

  const AppOutlineButton({
    super.key,
    required this.title,
    required this.onTap,
    this.color,
    this.height = 45,
    this.radius = 30,
    this.textStyle,
  });

  @override
  State<AppOutlineButton> createState() => _AppOutlineButtonState();
}

class _AppOutlineButtonState extends State<AppOutlineButton> {
  bool focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (v) => setState(() => focused = v),
      onKeyEvent: (node, event) => _handleTvKey(event, widget.onTap),
      child: Container(
        height: widget.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: focused ? Colors.white : AppColors.button,
            width: focused ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(widget.radius),
          child: Center(
            child: Text(
              widget.title,
              style: widget.textStyle ?? text14(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

class AppIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = Colors.blue,
  });

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  bool focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (v) => setState(() => focused = v),
      onKeyEvent: (node, event) => _handleTvKey(event, widget.onTap),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: focused ? Colors.white.withOpacity(0.9) : Colors.transparent,
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(widget.icon, color: widget.color),
          ),
        ),
      ),
    );
  }
}

class CustomElevatedButton extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final bool isLoading;
  final Color? color;
  final double height;
  final double radius;
  final TextStyle? textStyle;

  const CustomElevatedButton({
    super.key,
    required this.title,
    required this.onTap,
    this.isLoading = false,
    this.color,
    this.height = 50,
    this.radius = 30,
    this.textStyle,
  });

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  bool focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (v) => setState(() => focused = v),
      onKeyEvent: (node, event) =>
          _handleTvKey(event, widget.isLoading ? null : widget.onTap),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          border: Border.all(
            color: focused ? Colors.white.withOpacity(0.9) : Colors.transparent,
            width: 2,
          ),
        ),
        child: SizedBox(
          height: widget.height,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : widget.onTap,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              backgroundColor: widget.color ?? AppColors.button,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.radius),
              ),
              elevation: 2,
            ),
            child: widget.isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    widget.title,
                    style:
                        widget.textStyle ??
                        text15(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
          ),
        ),
      ),
    );
  }
}

class CustomElevatedIconButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final double height;
  final double iconSize;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;

  const CustomElevatedIconButton({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 30,
    this.height = 45,
    this.iconSize = 20,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  State<CustomElevatedIconButton> createState() =>
      _CustomElevatedIconButtonState();
}

class _CustomElevatedIconButtonState extends State<CustomElevatedIconButton> {
  bool focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (v) => setState(() => focused = v),
      onKeyEvent: (node, event) =>
          _handleTvKey(event, widget.isLoading ? null : widget.onPressed),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: focused ? Colors.white.withOpacity(0.9) : Colors.transparent,
            width: 2,
          ),
        ),
        child: SizedBox(
          height: widget.height,
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.isLoading
                  ? (widget.backgroundColor ?? AppColors.button).withOpacity(
                      0.7,
                    )
                  : widget.backgroundColor ?? AppColors.button,
              padding: widget.padding,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              elevation: 2,
            ),
            child: widget.isLoading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          size: widget.iconSize,
                          color: widget.textColor ?? AppColors.white,
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        widget.text,
                        style:
                            widget.textStyle ??
                            text15(
                              color: widget.textColor ?? AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
