import 'package:flutter/material.dart';

/// Represents one horizontally-scrolling row of focusable items.
/// Up/Down navigation always lands on [firstNode] of the target
/// section instead of Flutter's default nearest-neighbour focus.
class TvSectionController {
  final List<FocusNode> nodes = [];
  ScrollController? scrollController;

  /// Refreshed every build so ordering stays correct even when rows
  /// show/hide (shimmer, error, empty states).
  int order = 0;

  void registerNode(FocusNode node) {
    if (!nodes.contains(node)) nodes.add(node);
  }

  void unregisterNode(FocusNode node) {
    nodes.remove(node);
  }

  FocusNode? get firstNode => nodes.isNotEmpty ? nodes.first : null;

  void resetScrollToStart() {
    final sc = scrollController;
    if (sc != null && sc.hasClients) {
      sc.jumpTo(0);
    }
  }
}

/// Global registry of all mounted [TvSectionController]s, always
/// queried in top-to-bottom [TvSectionController.order].
class TvSectionRegistry {
  TvSectionRegistry._();
  static final TvSectionRegistry instance = TvSectionRegistry._();

  final List<TvSectionController> _sections = [];

  void register(TvSectionController controller) {
    if (!_sections.contains(controller)) _sections.add(controller);
  }

  void unregister(TvSectionController controller) {
    _sections.remove(controller);
  }

  TvSectionController? sectionForNode(FocusNode node) {
    for (final s in _sections) {
      if (s.nodes.contains(node)) return s;
    }
    return null;
  }

  List<TvSectionController> _sorted() {
    final list = List<TvSectionController>.from(_sections);
    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }

  TvSectionController? next(TvSectionController current) {
    final list = _sorted();
    final idx = list.indexOf(current);
    if (idx == -1 || idx + 1 >= list.length) return null;
    return list[idx + 1];
  }

  TvSectionController? previous(TvSectionController current) {
    final list = _sorted();
    final idx = list.indexOf(current);
    if (idx <= 0) return null;
    return list[idx - 1];
  }
}

/// Wrap every horizontally-scrolling row (banner slider, trending list,
/// series-matches row, highlights, reels, podcasts, etc.) with this.
class TvSectionScope extends StatefulWidget {
  final Widget child;
  final int order;
  final ScrollController? scrollController;

  const TvSectionScope({
    super.key,
    required this.child,
    required this.order,
    this.scrollController,
  });

  static TvSectionController? controllerOf(BuildContext context) {
    final element = context
        .getElementForInheritedWidgetOfExactType<_TvSectionInherited>();
    return (element?.widget as _TvSectionInherited?)?.controller;
  }

  @override
  State<TvSectionScope> createState() => _TvSectionScopeState();
}

class _TvSectionScopeState extends State<TvSectionScope> {
  late final TvSectionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TvSectionController()
      ..scrollController = widget.scrollController
      ..order = widget.order;
    TvSectionRegistry.instance.register(_controller);
  }

  @override
  void didUpdateWidget(covariant TvSectionScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.order = widget.order;
    _controller.scrollController = widget.scrollController;
  }

  @override
  void dispose() {
    TvSectionRegistry.instance.unregister(_controller);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Refresh order every build too — covers rows rebuilt with a new
    // order value without going through didUpdateWidget.
    _controller.order = widget.order;
    return _TvSectionInherited(controller: _controller, child: widget.child);
  }
}

class _TvSectionInherited extends InheritedWidget {
  final TvSectionController controller;

  const _TvSectionInherited({
    required this.controller,
    required super.child,
  });

  @override
  bool updateShouldNotify(_TvSectionInherited oldWidget) =>
      oldWidget.controller != controller;
}