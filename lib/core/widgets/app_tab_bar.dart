// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playon/static/app_color.dart';

class AppTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final Color backgroundColor;
  final Color selectColor;
  final Color unSelectColor;
  const AppTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    this.backgroundColor = AppColors.background,
    this.selectColor = AppColors.white,
    this.unSelectColor = Colors.white70,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      // Scopes arrow-left/right traversal to just this row of tabs.
      child: FocusTraversalGroup(
        policy: ReadingOrderTraversalPolicy(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            tabs.length,
            (index) => _TabItem(
              selectColor: selectColor,
              unSelectColor: unSelectColor,
              title: tabs[index],
              selected: selectedIndex == index,
              onTap: () => onChanged(index),
              // First tab grabs focus by default so remote users
              // always land somewhere sensible on this row.
              autofocus: index == 0,
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatefulWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;
  final Color selectColor;
  final Color unSelectColor;
  final bool autofocus;
  const _TabItem({
    required this.title,
    required this.selected,
    required this.onTap,
    required this.selectColor,
    required this.unSelectColor,
    this.autofocus = false,
  });

  @override
  State<_TabItem> createState() => _TabItemState();
}

class _TabItemState extends State<_TabItem> {
  bool focused = false;

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.select ||
          key == LogicalKeyboardKey.enter ||
          key == LogicalKeyboardKey.gameButtonA) {
        widget.onTap();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: widget.autofocus,
      onFocusChange: (v) => setState(() => focused = v),
      onKeyEvent: _onKey,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            // Neutral focus indicator, no bright/colored fill — a soft
            // rounded highlight behind the label, only visible on TV nav.
            color: focused
                ? Colors.white.withOpacity(0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.title == "Live") ...[
                    const Text(
                      "Live",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ] else
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: widget.selected
                            ? widget.selectColor
                            : widget.unSelectColor,
                        fontWeight: widget.selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),

                  if (widget.title == "Sports") ...[
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 6),

              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: widget.selected ? 28 : 0,
                height: 3,
                decoration: BoxDecoration(
                  color: widget.selectColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
