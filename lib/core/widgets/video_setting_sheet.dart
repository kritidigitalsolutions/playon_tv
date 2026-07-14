import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/static/app_color.dart';

const _kAccent = AppColors.primary;
const _kAccentSoft = Color(0xFFFF6B5B);
const _kPanelBg = Color(0xFF0F0F14);
const _kPanelWidth = 400.0;

/// video_player/chewie only expose a public `setPlaybackSpeed` API —
/// there's no equivalent of media_kit's VideoTrack/SubtitleTrack/
/// AudioTrack lists to manually switch quality or embedded subtitle/
/// audio tracks (ExoPlayer/AVPlayer negotiate that internally and
/// don't surface it through the plugin). So this panel only covers
/// speed; quality and subtitles/audio categories were removed rather
/// than wired up to nothing. (Captions in this app are now handled
/// separately — see the CC button in video_control_overlay.dart —
/// since they're driven by our own SRT loader, not a Chewie track.)
enum TVSettingsCategory { speed }

class TVSettingsPanel extends StatefulWidget {
  const TVSettingsPanel({
    super.key,
    required this.category,
    required this.controller,
    required this.onClose,
  });

  final TVSettingsCategory category;
  final VideoPlayerController controller;
  final VoidCallback onClose;

  @override
  State<TVSettingsPanel> createState() => _TVSettingsPanelState();
}

class _TVSettingsPanelState extends State<TVSettingsPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  )..forward();
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(1, 0),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _title {
    switch (widget.category) {
      case TVSettingsCategory.speed:
        return 'Playback Speed';
    }
  }

  IconData get _titleIcon {
    switch (widget.category) {
      case TVSettingsCategory.speed:
        return Icons.speed_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: FadeTransition(
            opacity: _fade,
            child: GestureDetector(
              onTap: widget.onClose,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(color: Colors.black.withOpacity(0.45)),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: SlideTransition(
            position: _slide,
            child: Container(
              width: _kPanelWidth,
              height: double.infinity,
              decoration: BoxDecoration(
                color: _kPanelBg.withOpacity(0.94),
                border: Border(
                  left: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 40,
                    spreadRadius: -6,
                  ),
                ],
              ),
              child: SafeArea(
                // New focus scope boundary. Without this, the
                // selected row's `autofocus: true` below silently
                // does nothing, because autofocus only fires when the
                // *nearest enclosing scope* has no focused child yet
                // — and without a boundary here, that nearest scope
                // is shared with the video controls behind this
                // panel, which still hold focus from whichever pill
                // opened this panel. Wrapping in FocusScope gives the
                // row a fresh scope to successfully autofocus into
                // (which also correctly steals global focus away from
                // the hidden pill), and additionally keeps D-pad
                // traversal contained inside the panel instead of
                // being able to jump focus out into those hidden
                // controls.
                //
                // Note this FocusScope does NOT pass an explicit
                // `node:` — it's left for the widget to manage its own
                // internal FocusScopeNode across rebuilds. (Passing a
                // freshly-constructed `FocusScopeNode()` here on every
                // build, the way the video controls overlay used to,
                // would tear the scope down and rebuild it on every
                // rebuild instead of keeping it stable.)
                child: FocusScope(
                  debugLabel: 'tv-settings-panel-scope',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(28, 28, 28, 16),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [_kAccentSoft, _kAccent],
                                ),
                              ),
                              child: Icon(
                                _titleIcon,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Text(
                              _title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _kAccent.withOpacity(0.5),
                                Colors.white.withOpacity(0.05),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(child: _buildBody()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    switch (widget.category) {
      case TVSettingsCategory.speed:
        // `onClose` is threaded through so picking a speed can close
        // the panel automatically instead of requiring a separate
        // back/escape press.
        return _SpeedList(
          controller: widget.controller,
          onClose: widget.onClose,
        );
    }
  }
}

class _SpeedList extends StatefulWidget {
  const _SpeedList({required this.controller, required this.onClose});
  final VideoPlayerController controller;
  final VoidCallback onClose;

  @override
  State<_SpeedList> createState() => _SpeedListState();
}

class _SpeedListState extends State<_SpeedList> {
  static const _speeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          itemCount: _speeds.length,
          itemBuilder: (context, i) {
            final s = _speeds[i];
            final selected = controller.value.playbackSpeed == s;
            return _TVOptionRow(
              autofocus: selected,
              icon: Icons.speed_rounded,
              label: s == 1.0 ? 'Normal' : '${s}x',
              selected: selected,
              onSelect: () {
                controller.setPlaybackSpeed(s);
                // Brief delay so the checkmark visibly lands on the
                // newly-selected row before the panel closes itself —
                // feels intentional rather than instant/jarring.
                Future.delayed(const Duration(milliseconds: 220), () {
                  if (mounted) widget.onClose();
                });
              },
            );
          },
        );
      },
    );
  }
}

class _TVOptionRow extends StatefulWidget {
  const _TVOptionRow({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onSelect,
    this.autofocus = false,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onSelect;
  final bool autofocus;

  @override
  State<_TVOptionRow> createState() => _TVOptionRowState();
}

class _TVOptionRowState extends State<_TVOptionRow> {
  final _node = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _node.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (mounted) setState(() => _focused = _node.hasFocus);
  }

  @override
  void dispose() {
    _node.removeListener(_handleFocusChange);
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TvFocusable(
      focusNode: _node,
      autofocus: widget.autofocus,
      onSelect: widget.onSelect,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _focused
              ? _kAccent.withOpacity(0.2)
              : (widget.selected
                    ? Colors.white.withOpacity(0.05)
                    : Colors.transparent),
          borderRadius: BorderRadius.circular(12),
          border: widget.selected
              ? Border(left: BorderSide(color: _kAccent, width: 3))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              widget.icon,
              size: 18,
              color: widget.selected || _focused ? _kAccent : Colors.white54,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                widget.label,
                style: TextStyle(
                  color: widget.selected || _focused
                      ? Colors.white
                      : Colors.white70,
                  fontSize: 15,
                  fontWeight: widget.selected
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
            ),
            AnimatedScale(
              scale: widget.selected ? 1 : 0,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOutBack,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: _kAccent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}