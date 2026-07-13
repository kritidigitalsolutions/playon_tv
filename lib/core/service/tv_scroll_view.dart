// lib/core/widgets/tv_scroll_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playon/static/app_color.dart';

/// A TV-friendly scroll view that properly handles focus navigation
class TvScrollView extends StatefulWidget {
  final Widget child;
  final EdgeInsets padding;
  final ScrollController? controller;
  final double scrollAmount;

  const TvScrollView({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.controller,
    this.scrollAmount = 100.0,
  });

  @override
  State<TvScrollView> createState() => _TvScrollViewState();
}

class _TvScrollViewState extends State<TvScrollView> {
  late ScrollController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ScrollController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    
    final key = event.logicalKey;
    final offset = _controller.offset;
    final maxExtent = _controller.position.maxScrollExtent;
    final minExtent = _controller.position.minScrollExtent;

    // Up/Down arrow keys scroll the view
    if (key == LogicalKeyboardKey.arrowDown) {
      if (offset < maxExtent) {
        _controller.animateTo(
          (offset + widget.scrollAmount).clamp(minExtent, maxExtent),
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        );
        return KeyEventResult.handled;
      }
      // At bottom, let focus move to next element
      return KeyEventResult.ignored;
    } else if (key == LogicalKeyboardKey.arrowUp) {
      if (offset > minExtent) {
        _controller.animateTo(
          (offset - widget.scrollAmount).clamp(minExtent, maxExtent),
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        );
        return KeyEventResult.handled;
      }
      // At top, let focus move to previous element
      return KeyEventResult.ignored;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: RawScrollbar(
        controller: _controller,
        thumbColor: AppColors.primary,
        thickness: 6,
        radius: const Radius.circular(3),
        child: SingleChildScrollView(
          controller: _controller,
          padding: widget.padding,
          physics: const BouncingScrollPhysics(),
          child: widget.child,
        ),
      ),
    );
  }
}