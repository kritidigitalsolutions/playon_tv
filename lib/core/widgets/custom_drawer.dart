import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playon/core/service/storage_service.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/feature/auth/bloc/auth/auth_bloc.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_image.dart';
import 'package:playon/static/app_navigation.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    this.collapsedWidth = 100,
    this.expandedWidth = 260,
  });

  final List<DrawerItemData> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final double collapsedWidth;
  final double expandedWidth;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool mouseHover = false;
  // Tracks which item indices currently hold remote/keyboard focus.
  final Set<int> _focusedIndices = {};
  // Tracks focus on the footer (avatar/logout) row separately, since
  // it isn't one of `widget.items` — without this, moving D-pad focus
  // down onto the logout button collapsed the drawer and hid it and
  // the username at the same time.
  bool _footerFocused = false;

  bool get expanded =>
      mouseHover || _focusedIndices.isNotEmpty || _footerFocused;

  void _setItemFocused(int index, bool isFocused) {
    setState(() {
      if (isFocused) {
        _focusedIndices.add(index);
      } else {
        _focusedIndices.remove(index);
      }
    });
  }

  void _setFooterFocused(bool isFocused) {
    setState(() => _footerFocused = isFocused);
  }

  initState() {
    context.read<AuthBloc>().add(AuthEvent.fetchUser());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => mouseHover = true),
      onExit: (_) => setState(() => mouseHover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        width: expanded ? widget.expandedWidth : widget.collapsedWidth,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.background.withOpacity(0.96),
              AppColors.black,
            ],
          ),
          border: Border(
            right: BorderSide(
              color: AppColors.white.withOpacity(0.06),
              width: 1,
            ),
          ),
        ),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final user = state.user;
            return SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,
                      border: Border.all(
                        color: AppColors.white,
                        width: 1.2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(21),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Image.asset(AppImage.logo, fit: BoxFit.contain),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: expanded ? 1 : 0,
                    child: expanded
                        ? Text(
                            "PLAYON",
                            style: TextStyle(
                              color: AppColors.white.withOpacity(0.9),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 30),
                  Divider(
                    color: AppColors.white.withOpacity(0.08),
                    height: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  const SizedBox(height: 20),

                  // Nav items — scoped traversal group so up/down arrows
                  // move only within this list.
                  Expanded(
                    child: FocusTraversalGroup(
                      policy: ReadingOrderTraversalPolicy(),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          return _DrawerItem(
                            data: widget.items[index],
                            selected: widget.selectedIndex == index,
                            expanded: expanded,
                            onTap: () => widget.onItemSelected(index),
                            onFocusChanged: (isFocused) =>
                                _setItemFocused(index, isFocused),
                          );
                        },
                      ),
                    ),
                  ),

                  _FooterAccount(
                    userName: user?.fullName ?? "Your account",
                    expanded: expanded,
                    onFocusChanged: _setFooterFocused,
                    onLogout: () {
                      StorageService.logout();
                      AppNavigation.pushReplacement(context, "/loginTv");
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class DrawerItemData {
  final IconData icon;
  final String label;
  const DrawerItemData({required this.icon, required this.label});
}

/// Avatar + username + logout row. Pulled out into its own widget so
/// the logout button can hold a proper focus node and report its own
/// focus state up to [_CustomDrawerState] — without this, D-pad focus
/// reaching the logout button had no way to keep the drawer expanded.
class _FooterAccount extends StatefulWidget {
  const _FooterAccount({
    required this.userName,
    required this.expanded,
    required this.onFocusChanged,
    required this.onLogout,
  });

  final String userName;
  final bool expanded;
  final ValueChanged<bool> onFocusChanged;
  final VoidCallback onLogout;

  @override
  State<_FooterAccount> createState() => _FooterAccountState();
}

class _FooterAccountState extends State<_FooterAccount> {
  final FocusNode _logoutFocusNode = FocusNode(debugLabel: 'drawer-logout');

  @override
  void initState() {
    super.initState();
    _logoutFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    widget.onFocusChanged(_logoutFocusNode.hasFocus);
  }

  @override
  void dispose() {
    _logoutFocusNode.removeListener(_onFocusChange);
    _logoutFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withOpacity(0.08),
              border: Border.all(color: AppColors.white.withOpacity(0.15)),
            ),
            child: Icon(
              Icons.person_rounded,
              color: AppColors.white.withOpacity(0.7),
              size: 20,
            ),
          ),
          if (widget.expanded) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.userName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.7),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // TvFocusable instead of a bare IconButton — this is
                  // what makes it reachable and activatable via D-pad
                  // select, with the same focus-glow language used
                  // everywhere else in the app.
                  TvFocusable(
                    focusNode: _logoutFocusNode,
                    borderRadius: BorderRadius.circular(20),
                    onSelect: widget.onLogout,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.logout,
                        color: AppColors.white.withOpacity(0.7),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DrawerItem extends StatefulWidget {
  const _DrawerItem({
    required this.data,
    required this.selected,
    required this.expanded,
    required this.onTap,
    required this.onFocusChanged,
  });

  final DrawerItemData data;
  final bool selected;
  final bool expanded;
  final VoidCallback onTap;
  final ValueChanged<bool> onFocusChanged;

  @override
  State<_DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<_DrawerItem> {
  bool hovering = false;
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
    final bool highlighted = widget.selected || hovering || focused;
    final Color fg = highlighted
        ? AppColors.primary
        : AppColors.white.withOpacity(0.55);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Focus(
        onFocusChange: (v) {
          setState(() => focused = v);
          widget.onFocusChanged(v);
        },
        onKeyEvent: _onKey,
        child: MouseRegion(
          onEnter: (_) => setState(() => hovering = true),
          onExit: (_) => setState(() => hovering = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if (widget.selected)
                  Positioned(
                    left: -12,
                    top: 6,
                    bottom: 6,
                    child: Container(
                      width: 4,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.6),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: highlighted
                        ? AppColors.primary.withOpacity(0.14)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: focused
                          ? Colors.white.withOpacity(0.8)
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: highlighted
                              ? AppColors.primary.withOpacity(0.18)
                              : AppColors.white.withOpacity(0.06),
                        ),
                        child: Icon(widget.data.icon, color: fg, size: 18),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        child: widget.expanded
                            ? Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  widget.data.label,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: fg,
                                    fontSize: 14.5,
                                    fontWeight: highlighted
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
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