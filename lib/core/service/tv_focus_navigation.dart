import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Shared remote/D-pad focus wrapper used by every interactive control
/// in the TV player UI (transport buttons, settings pills, panel rows).
///
/// Handles:
///  - Focus highlight (scale + subtle background)
///  - Select / Enter / GameButtonA / Space activation
///  - Explicit D-pad Up/Down/Left/Right focus traversal via
///    `FocusNode.focusInDirection`, which is the piece that was missing
///    before — without it, arrow keys never move focus between controls
///    on real TV remotes / TV emulators.
///  - Auto-scrolling itself into view when it gains focus inside a
///    scrollable list.
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
      // Give the frame a beat to lay out before scrolling into view.
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
    // React to both the initial press and (for smooth repeated
    // navigation when a remote button is held down) key-repeat events.
    final isActionable = event is KeyDownEvent || event is KeyRepeatEvent;
    if (!isActionable) return KeyEventResult.ignored;

    final key = event.logicalKey;

    // --- Activation --------------------------------------------------
    if (key == LogicalKeyboardKey.select ||
        key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter ||
        key == LogicalKeyboardKey.gameButtonA ||
        key == LogicalKeyboardKey.space) {
      // Only fire the callback once per physical press, not on repeats.
      if (event is KeyDownEvent) {
        widget.onSelect?.call();
      }
      return KeyEventResult.handled;
    }

    // --- Directional D-pad navigation --------------------------------
    // This is the key fix: explicitly ask Flutter's focus traversal
    // policy to move focus in the pressed direction, rather than
    // relying on it bubbling up to an ancestor Shortcuts widget (which
    // is inconsistent across TV platforms/emulators).
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
      // If we couldn't move (e.g. at the edge of the layout), let the
      // event bubble up in case a parent wants to handle it (e.g. to
      // close a panel or move focus into a different focus scope).
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
      // Make sure this node can actually take focus and isn't skipped
      // by the traversal policy.
      canRequestFocus: true,
      skipTraversal: false,
      onKeyEvent: _onKey,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // Tapping (mouse/touch/remote OK button emulated as tap)
          // should also grab focus so keyboard/remote nav continues
          // from here.
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
