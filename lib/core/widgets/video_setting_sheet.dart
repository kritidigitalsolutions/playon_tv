import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/static/app_color.dart';

const _kAccent = AppColors.primary;
const _kAccentSoft = Color(0xFFFF6B5B);
const _kPanelBg = Color(0xFF0F0F14);
const _kPanelWidth = 400.0;

enum TVSettingsCategory { speed, quality, subtitlesAudio }

class TVSettingsPanel extends StatefulWidget {
  const TVSettingsPanel({
    super.key,
    required this.category,
    required this.player,
    required this.onClose,
  });

  final TVSettingsCategory category;
  final Player player;
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
      case TVSettingsCategory.quality:
        return 'Video Quality';
      case TVSettingsCategory.subtitlesAudio:
        return 'Subtitles & Audio';
    }
  }

  IconData get _titleIcon {
    switch (widget.category) {
      case TVSettingsCategory.speed:
        return Icons.speed_rounded;
      case TVSettingsCategory.quality:
        return Icons.high_quality_rounded;
      case TVSettingsCategory.subtitlesAudio:
        return Icons.subtitles_rounded;
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
        return _SpeedList(player: widget.player);
      case TVSettingsCategory.quality:
        return _QualityList(player: widget.player);
      case TVSettingsCategory.subtitlesAudio:
        return _SubtitleAudioList(player: widget.player);
    }
  }
}

class _SpeedList extends StatefulWidget {
  const _SpeedList({required this.player});
  final Player player;

  @override
  State<_SpeedList> createState() => _SpeedListState();
}

class _SpeedListState extends State<_SpeedList> {
  static const _speeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  Widget build(BuildContext context) {
    final player = widget.player;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      itemCount: _speeds.length,
      itemBuilder: (context, i) {
        final s = _speeds[i];
        final selected = player.state.rate == s;
        return _TVOptionRow(
          autofocus: selected,
          icon: Icons.speed_rounded,
          label: s == 1.0 ? 'Normal' : '${s}x',
          selected: selected,
          onSelect: () => setState(() => player.setRate(s)),
        );
      },
    );
  }
}

class _QualityList extends StatefulWidget {
  const _QualityList({required this.player});
  final Player player;

  @override
  State<_QualityList> createState() => _QualityListState();
}

class _QualityListState extends State<_QualityList> {
  @override
  Widget build(BuildContext context) {
    final player = widget.player;
    final tracks = player.state.tracks;
    final currentTrack = player.state.track;
    final videoTracks = tracks.video
        .where((t) => t.id != 'auto' && t.id != 'no')
        .toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      children: [
        _TVOptionRow(
          autofocus: currentTrack.video.id == 'auto',
          icon: Icons.auto_awesome_rounded,
          label: 'Auto',
          selected: currentTrack.video.id == 'auto',
          onSelect: () =>
              setState(() => player.setVideoTrack(VideoTrack.auto())),
        ),
        ...videoTracks.map((t) {
          final label = t.h != null && t.w != null
              ? '${t.h}p${t.codec != null ? " • ${t.codec}" : ""}'
              : (t.title ?? t.id);
          return _TVOptionRow(
            icon: Icons.hd_rounded,
            label: label,
            selected: currentTrack.video.id == t.id,
            onSelect: () => setState(() => player.setVideoTrack(t)),
          );
        }),
      ],
    );
  }
}

class _SubtitleAudioList extends StatefulWidget {
  const _SubtitleAudioList({required this.player});
  final Player player;

  @override
  State<_SubtitleAudioList> createState() => _SubtitleAudioListState();
}

class _SubtitleAudioListState extends State<_SubtitleAudioList> {
  @override
  Widget build(BuildContext context) {
    final player = widget.player;
    final tracks = player.state.tracks;
    final currentTrack = player.state.track;
    final subtitleTracks = tracks.subtitle.where((t) => t.id != 'no').toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      children: [
        const _SectionLabel('Subtitles'),
        _TVOptionRow(
          autofocus: currentTrack.subtitle.id == 'no',
          icon: Icons.subtitles_off_rounded,
          label: 'Off',
          selected: currentTrack.subtitle.id == 'no',
          onSelect: () =>
              setState(() => player.setSubtitleTrack(SubtitleTrack.no())),
        ),
        ...subtitleTracks.map((t) {
          final label = t.title ?? t.language ?? t.id;
          return _TVOptionRow(
            icon: Icons.subtitles_rounded,
            label: label,
            selected: currentTrack.subtitle.id == t.id,
            onSelect: () => setState(() => player.setSubtitleTrack(t)),
          );
        }),
        if (tracks.audio.length > 1) ...[
          const _SectionLabel('Audio'),
          ...tracks.audio.map((t) {
            final label = t.title ?? t.language ?? t.id;
            return _TVOptionRow(
              icon: Icons.graphic_eq_rounded,
              label: label,
              selected: currentTrack.audio.id == t.id,
              onSelect: () => setState(() => player.setAudioTrack(t)),
            );
          }),
        ],
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: _kAccent.withOpacity(0.85),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
        ),
      ),
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
