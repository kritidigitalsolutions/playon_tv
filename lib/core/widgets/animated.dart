import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// 1. REUSABLE ANIMATED COLUMN (FIXED)
// ─────────────────────────────────────────────
//
// Staggered fade+slide animation for each child.
//
// Usage:
//   AnimatedColumn(
//     staggerDelay: Duration(milliseconds: 100),
//     itemAnimationDuration: Duration(milliseconds: 400),
//     children: [
//       Text('Hello'),
//       Text('World'),
//     ],
//   )

class AnimatedColumn extends StatefulWidget {
  const AnimatedColumn({
    super.key,
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 100),
    this.itemAnimationDuration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOut,
    this.slideOffset = const Offset(0, 30),
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
  });

  /// Widgets to display with staggered animation.
  final List<Widget> children;

  /// Delay between each child's animation start.
  final Duration staggerDelay;

  /// Duration of each child's animation.
  final Duration itemAnimationDuration;

  /// Animation curve for each child.
  final Curve curve;

  /// How far each child slides in from (in logical pixels).
  final Offset slideOffset;

  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  @override
  State<AnimatedColumn> createState() => _AnimatedColumnState();
}

class _AnimatedColumnState extends State<AnimatedColumn>
    with TickerProviderStateMixin {
  List<AnimationController> _controllers = [];
  List<Animation<double>> _fadeAnimations = [];
  List<Animation<Offset>> _slideAnimations = [];

  // Becomes true once the stagger sequence has finished a single time.
  // After that, this widget instance NEVER animates again — not on
  // rebuild, not on didUpdateWidget, not ever — for its entire lifetime.
  bool _hasPlayed = false;

  // Tracks the original child count the animation was built for, purely
  // so build() can render new/extra children (if any are ever added
  // after the animation already finished) without crashing — they just
  // appear statically, no animation.
  int _animatedChildCount = 0;

  @override
  void initState() {
    super.initState();
    _buildControllers(widget.children.length);
    _startStaggeredOnce();
  }

  // Intentionally no meaningful work in didUpdateWidget for animation
  // purposes — once `_hasPlayed` is true, controllers are gone and
  // build() always renders plain static children. This guarantees the
  // animation is permanent and can never be re-triggered by parent
  // rebuilds, setState calls elsewhere, list updates, etc.
  @override
  void didUpdateWidget(covariant AnimatedColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
    // No-op by design. See comment above.
  }

  void _buildControllers(int count) {
    _animatedChildCount = count;
    _controllers = List.generate(
      count,
      (i) => AnimationController(
        vsync: this,
        duration: widget.itemAnimationDuration,
      ),
    );

    _fadeAnimations = _controllers
        .map((c) => CurvedAnimation(parent: c, curve: widget.curve))
        .toList();

    _slideAnimations = _controllers.map((c) {
      return Tween<Offset>(
        begin: widget.slideOffset,
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: c, curve: widget.curve));
    }).toList();
  }

  void _disposeControllers() {
    for (final c in _controllers) {
      c.dispose();
    }
    _controllers = [];
    _fadeAnimations = [];
    _slideAnimations = [];
  }

  Future<void> _startStaggeredOnce() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(widget.staggerDelay);

      // Widget gone — stop immediately, never touch controllers again.
      if (!mounted) return;

      // Defensive: state was somehow reset/disposed mid-loop.
      if (i >= _controllers.length) return;

      _controllers[i].forward();
    }

    // Wait for the slowest controller's full animation to actually
    // finish before freezing, so we don't cut the tail end of the
    // animation off by disposing too early.
    if (_controllers.isNotEmpty) {
      await Future.delayed(widget.itemAnimationDuration);
    }

    if (!mounted) return;

    // Permanently mark as played, dispose controllers, and rebuild once
    // into the static (non-animated) final state. From this point on
    // this State object will never animate again, regardless of how
    // many times the parent rebuilds it.
    setState(() {
      _disposeControllers();
      _hasPlayed = true;
    });
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ── Permanent final state: plain static Column, no animation ──
    if (_hasPlayed) {
      return Column(
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        mainAxisSize: widget.mainAxisSize,
        children: widget.children,
      );
    }

    // ── First-and-only play-through ──
    return Column(
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      mainAxisSize: widget.mainAxisSize,
      children: List.generate(widget.children.length, (i) {
        // If somehow a child index falls outside the originally-built
        // controllers (e.g. children list grew before first play
        // finished), just render it statically rather than crash.
        if (i >= _animatedChildCount || i >= _controllers.length) {
          return widget.children[i];
        }
        // Wrapped in ClipRect: Transform.translate only affects paint,
        // not layout, so a child sliding in from slideOffset can be
        // painted outside its reserved box on early frames (e.g.
        // poking past a bottom sheet's rounded top corners). ClipRect
        // keeps the slide-in contained to the child's own bounds.
        return ClipRect(
          child: AnimatedBuilder(
            animation: _controllers[i],
            builder: (context, child) {
              return Transform.translate(
                offset: _slideAnimations[i].value,
                child: Opacity(
                  opacity: _fadeAnimations[i].value.clamp(0.0, 1.0),
                  child: child,
                ),
              );
            },
            child: widget.children[i],
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────
// 2. REUSABLE ANIMATED BOX (unchanged — already safe)
// ─────────────────────────────────────────────
//
// Toggle size, color, border-radius, padding, and shadow
// with smooth implicit animation.
//
// Usage:
//   AnimatedBox(
//     width: isExpanded ? 300 : 150,
//     height: isExpanded ? 200 : 100,
//     color: isExpanded ? Colors.blue : Colors.grey,
//     borderRadius: BorderRadius.circular(isExpanded ? 24 : 8),
//     duration: Duration(milliseconds: 350),
//     child: Text('Tap me'),
//   )

class AnimatedBox extends StatelessWidget {
  const AnimatedBox({
    super.key,
    this.width,
    this.height,
    this.color,
    this.borderRadius,
    this.padding,
    this.margin,
    this.boxShadow,
    this.alignment,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.child,
    this.onTap,
    this.border,
  });

  final double? width;
  final double? height;
  final Color? color;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final List<BoxShadow>? boxShadow;
  final AlignmentGeometry? alignment;
  final Duration duration;
  final Curve curve;
  final Widget? child;
  final VoidCallback? onTap;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: duration,
        curve: curve,
        width: width,
        height: height,
        alignment: alignment,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          boxShadow: boxShadow,
          border: border,
        ),
        child: child,
      ),
    );
  }
}
