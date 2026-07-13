import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Shared remote/D-pad focus wrapper used by every interactive control
/// in the TV player UI.
class TvFocusable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onSelect;
  final FocusNode? focusNode;
  final bool autofocus;
  final double focusScale;
  final BorderRadius? borderRadius;
  final Color? focusBackgroundColor;

  const TvFocusable({
    super.key,
    required this.child,
    this.onSelect,
    this.focusNode,
    this.autofocus = false,
    this.focusScale = 1.04,
    this.borderRadius,
    this.focusBackgroundColor,
  });

  @override
  State<TvFocusable> createState() => _TvFocusableState();
}

class _TvFocusableState extends State<TvFocusable> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode(debugLabel: 'TvFocusable');
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant TvFocusable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_onFocusChange);
      if (oldWidget.focusNode == null) _focusNode.dispose();
      _focusNode = widget.focusNode ?? FocusNode(debugLabel: 'TvFocusable');
      _focusNode.addListener(_onFocusChange);
    }
  }

  void _onFocusChange() {
    if (!mounted) return;
    setState(() => _isFocused = _focusNode.hasFocus);
    if (_isFocused) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final ctx = context;
        Scrollable.maybeOf(ctx)?.position.ensureVisible(
          ctx.findRenderObject()!,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          alignment: 0.5,
        );
      });
    }
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    final isActionable = event is KeyDownEvent || event is KeyRepeatEvent;
    if (!isActionable) return KeyEventResult.ignored;

    final key = event.logicalKey;

    // Activation
    if (key == LogicalKeyboardKey.select ||
        key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter ||
        key == LogicalKeyboardKey.gameButtonA ||
        key == LogicalKeyboardKey.space) {
      if (event is KeyDownEvent) {
        widget.onSelect?.call();
      }
      return KeyEventResult.handled;
    }

    // Directional navigation
    TraversalDirection? direction;
    switch (key) {
      case LogicalKeyboardKey.arrowUp:
        direction = TraversalDirection.up;
        break;
      case LogicalKeyboardKey.arrowDown:
        direction = TraversalDirection.down;
        break;
      case LogicalKeyboardKey.arrowLeft:
        direction = TraversalDirection.left;
        break;
      case LogicalKeyboardKey.arrowRight:
        direction = TraversalDirection.right;
        break;
      default:
        direction = null;
    }

    if (direction != null) {
      final moved = node.focusInDirection(direction);
      return moved ? KeyEventResult.handled : KeyEventResult.ignored;
    }

    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(14);
    final focusBgColor =
        widget.focusBackgroundColor ?? Colors.white.withOpacity(0.1);

    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      canRequestFocus: true,
      skipTraversal: false,
      onKeyEvent: _onKey,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (!_focusNode.hasFocus) {
            _focusNode.requestFocus();
          }
          widget.onSelect?.call();
        },
        child: AnimatedScale(
          scale: _isFocused ? widget.focusScale : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: radius,
              color: _isFocused ? focusBgColor : Colors.transparent,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
