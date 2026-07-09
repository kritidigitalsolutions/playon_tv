// ignore_for_file: unused_element_parameter

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/core/widgets/video_setting_sheet.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_navigation.dart';

const _kAccent = AppColors.primary;
const _kAccentSoft = Color(0xFFFF6B5B);
const _kEdgePadding = 48.0;

class VideoControlsOverlay extends StatefulWidget {
  const VideoControlsOverlay({
    super.key,
    required this.state,
    this.title,
    required this.isFullscreen,
    required this.onFullscreenChanged,
  });
  final VideoState state;
  final String? title;
  final bool isFullscreen;
  final ValueChanged<bool> onFullscreenChanged;
  @override
  State<VideoControlsOverlay> createState() => _VideoControlsOverlayState();
}

class _VideoControlsOverlayState extends State<VideoControlsOverlay> {
  bool _visible = true;
  Timer? _hideTimer;

  bool _showRewindFlash = false;
  bool _showForwardFlash = false;
  Timer? _flashTimer;

  TVSettingsCategory? _activePanel;

  final _speedFocus = FocusNode(debugLabel: 'speed-pill');
  final _qualityFocus = FocusNode(debugLabel: 'quality-pill');
  final _subtitleFocus = FocusNode(debugLabel: 'subtitle-pill');
  final _playPauseFocus = FocusNode(debugLabel: 'play-pause');
  final _rewindFocus = FocusNode(debugLabel: 'rewind');
  final _forwardFocus = FocusNode(debugLabel: 'forward');

  @override
  void initState() {
    super.initState();
    _scheduleHide();
  }

  void _scheduleHide() {
    _hideTimer?.cancel();
    if (_activePanel != null) return;
    _hideTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) setState(() => _visible = false);
    });
  }

  void _keepAlive() {
    if (!_visible) setState(() => _visible = true);
    _scheduleHide();
  }

  Future<void> _seekBy(int seconds) async {
    final player = widget.state.widget.controller.player;
    final current = player.state.position;
    final duration = player.state.duration;
    var target = current + Duration(seconds: seconds);
    if (target < Duration.zero) target = Duration.zero;
    if (duration > Duration.zero && target > duration) target = duration;
    await player.seek(target);

    _flashTimer?.cancel();
    setState(() {
      _showRewindFlash = seconds < 0;
      _showForwardFlash = seconds > 0;
    });
    _flashTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showRewindFlash = false;
          _showForwardFlash = false;
        });
      }
    });
    _keepAlive();
  }

  void _openPanel(TVSettingsCategory category) {
    setState(() => _activePanel = category);
    _hideTimer?.cancel();
  }

  void _closePanel({FocusNode? returnFocusTo}) {
    setState(() => _activePanel = null);
    returnFocusTo?.requestFocus();
    _scheduleHide();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _flashTimer?.cancel();
    _speedFocus.dispose();
    _qualityFocus.dispose();
    _subtitleFocus.dispose();
    _playPauseFocus.dispose();
    _rewindFocus.dispose();
    _forwardFocus.dispose();
    super.dispose();
  }

  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return h > 0 ? '$h:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
  }

  KeyEventResult _handleRootKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.goBack || key == LogicalKeyboardKey.escape) {
      if (_activePanel != null) {
        _closePanel(returnFocusTo: _focusNodeFor(_activePanel!));
        return KeyEventResult.handled;
      }
      if (widget.isFullscreen) {
        widget.onFullscreenChanged(false);
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    final wakeKeys = {
      LogicalKeyboardKey.arrowUp,
      LogicalKeyboardKey.arrowDown,
      LogicalKeyboardKey.arrowLeft,
      LogicalKeyboardKey.arrowRight,
      LogicalKeyboardKey.select,
      LogicalKeyboardKey.enter,
      LogicalKeyboardKey.gameButtonA,
    };
    if (wakeKeys.contains(key)) _keepAlive();

    return KeyEventResult.ignored;
  }

  FocusNode _focusNodeFor(TVSettingsCategory c) {
    switch (c) {
      case TVSettingsCategory.speed:
        return _speedFocus;
      case TVSettingsCategory.quality:
        return _qualityFocus;
      case TVSettingsCategory.subtitlesAudio:
        return _subtitleFocus;
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.state.widget.controller.player;

    return Focus(
      onKeyEvent: _handleRootKey,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedOpacity(
            opacity: _visible ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !_visible,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black87,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black,
                    ],
                    stops: [0.0, 0.3, 0.55, 1.0],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Top bar: back button + title
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          _kEdgePadding,
                          24,
                          _kEdgePadding,
                          24,
                        ),
                        child: Row(
                          children: [
                            _PlainIconButton(
                              icon: Icons.arrow_back_rounded,
                              onSelect: () => AppNavigation.pop(context),
                            ),
                            const SizedBox(width: 20),
                            if (widget.title != null)
                              Expanded(
                                child: Text(
                                  widget.title!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.2,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black54,
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            // Channel info
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              child: const Text(
                                "Channel 12",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Center section: Rewind - Play - Forward in center
                    const Spacer(),

                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Rewind 10s button
                          TvFocusable(
                            focusNode: _rewindFocus,
                            borderRadius: BorderRadius.circular(100),
                            onSelect: () => _seekBy(-10),
                            child: AnimatedScale(
                              scale: _showRewindFlash ? 1.3 : 1.0,
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeOutBack,
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.1),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.replay_10_rounded,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 40),

                          // Play/Pause button (centered)
                          StreamBuilder<bool>(
                            stream: player.stream.playing,
                            initialData: player.state.playing,
                            builder: (context, snapshot) {
                              final playing = snapshot.data ?? false;
                              return TvFocusable(
                                focusNode: _playPauseFocus,
                                autofocus: true,
                                focusScale: 1.12,
                                borderRadius: BorderRadius.circular(100),
                                onSelect: () {
                                  playing ? player.pause() : player.play();
                                  _keepAlive();
                                },
                                child: Container(
                                  width: 88,
                                  height: 88,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [_kAccentSoft, _kAccent],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _kAccent.withOpacity(0.45),
                                        blurRadius: 24,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    playing
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 48,
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(width: 40),

                          // Forward 10s button
                          TvFocusable(
                            focusNode: _forwardFocus,
                            borderRadius: BorderRadius.circular(100),
                            onSelect: () => _seekBy(10),
                            child: AnimatedScale(
                              scale: _showForwardFlash ? 1.3 : 1.0,
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeOutBack,
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.1),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.forward_10_rounded,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Bottom section: accessory row + progress bar
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          _kEdgePadding,
                          0,
                          _kEdgePadding,
                          28,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _AccessoryRow(
                              player: player,
                              speedFocus: _speedFocus,
                              qualityFocus: _qualityFocus,
                              subtitleFocus: _subtitleFocus,
                              onOpenPanel: _openPanel,
                              isFullscreen: widget.isFullscreen,
                              onFullscreenChanged: (v) {
                                widget.onFullscreenChanged(v);
                                _keepAlive();
                              },
                            ),
                            const SizedBox(height: 14),
                            _ProgressRow(
                              player: player,
                              formatDuration: _fmt,
                              onKeepAlive: _keepAlive,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_activePanel != null)
            Positioned.fill(
              child: TVSettingsPanel(
                category: _activePanel!,
                player: player,
                onClose: () =>
                    _closePanel(returnFocusTo: _focusNodeFor(_activePanel!)),
              ),
            ),
        ],
      ),
    );
  }
}

class _PlainIconButton extends StatelessWidget {
  const _PlainIconButton({
    required this.icon,
    required this.onSelect,
    this.size = 26,
  });
  final IconData icon;
  final VoidCallback onSelect;
  final double size;

  @override
  Widget build(BuildContext context) {
    return TvFocusable(
      borderRadius: BorderRadius.circular(8),
      onSelect: onSelect,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, color: Colors.white, size: size),
      ),
    );
  }
}

/// Right-aligned row: Speed · Quality · Subtitles · Fullscreen
class _AccessoryRow extends StatelessWidget {
  const _AccessoryRow({
    required this.player,
    required this.speedFocus,
    required this.qualityFocus,
    required this.subtitleFocus,
    required this.onOpenPanel,
    required this.isFullscreen,
    required this.onFullscreenChanged,
  });

  final dynamic player;
  final FocusNode speedFocus;
  final FocusNode qualityFocus;
  final FocusNode subtitleFocus;
  final ValueChanged<TVSettingsCategory> onOpenPanel;
  final bool isFullscreen;
  final ValueChanged<bool> onFullscreenChanged;

  @override
  Widget build(BuildContext context) {
    final rate = player.state.rate as double;
    final track = player.state.track;
    final qualityLabel = (track.video.id == 'auto' || track.video.id.isEmpty)
        ? 'Auto'
        : (track.video.h != null ? '${track.video.h}p' : 'Custom');
    final subLabel = track.subtitle.id == 'no'
        ? 'Off'
        : (track.subtitle.title ?? track.subtitle.language ?? 'On');

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _AccessoryItem(
          focusNode: speedFocus,
          icon: Icons.speed_rounded,
          label: rate == 1.0 ? 'Speed' : '${rate}x',
          onSelect: () => onOpenPanel(TVSettingsCategory.speed),
        ),
        const SizedBox(width: 28),
        _AccessoryItem(
          focusNode: qualityFocus,
          icon: Icons.high_quality_rounded,
          label: qualityLabel,
          onSelect: () => onOpenPanel(TVSettingsCategory.quality),
        ),
        const SizedBox(width: 28),
        _AccessoryItem(
          focusNode: subtitleFocus,
          icon: Icons.subtitles_rounded,
          label: subLabel,
          onSelect: () => onOpenPanel(TVSettingsCategory.subtitlesAudio),
        ),
        const SizedBox(width: 28),
        _PlainIconButton(
          icon: isFullscreen
              ? Icons.fullscreen_exit_rounded
              : Icons.fullscreen_rounded,
          onSelect: () => onFullscreenChanged(!isFullscreen),
        ),
      ],
    );
  }
}

class _AccessoryItem extends StatefulWidget {
  const _AccessoryItem({
    required this.focusNode,
    required this.icon,
    required this.label,
    required this.onSelect,
  });

  final FocusNode focusNode;
  final IconData icon;
  final String label;
  final VoidCallback onSelect;

  @override
  State<_AccessoryItem> createState() => _AccessoryItemState();
}

class _AccessoryItemState extends State<_AccessoryItem> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocus);
  }

  void _onFocus() {
    if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TvFocusable(
      focusNode: widget.focusNode,
      borderRadius: BorderRadius.circular(8),
      onSelect: widget.onSelect,
      child: AnimatedOpacity(
        opacity: _focused ? 1 : 0.85,
        duration: const Duration(milliseconds: 150),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: _focused ? FontWeight.w700 : FontWeight.w500,
                decoration: _focused
                    ? TextDecoration.underline
                    : TextDecoration.none,
                decorationColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Elapsed time (left) — progress bar (fills remaining width) —
/// -remaining time (right).
class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.player,
    required this.formatDuration,
    required this.onKeepAlive,
  });

  final dynamic player;
  final String Function(Duration) formatDuration;
  final VoidCallback onKeepAlive;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: player.stream.position,
      initialData: player.state.position,
      builder: (context, posSnap) {
        final pos = posSnap.data ?? Duration.zero;
        final dur = player.state.duration;
        final remaining = dur > pos ? dur - pos : Duration.zero;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 56,
              child: Text(
                formatDuration(pos),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _TVProgressBar(player: player, onKeepAlive: onKeepAlive),
              ),
            ),
            SizedBox(
              width: 56,
              child: Text(
                '-${formatDuration(remaining)}',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TVProgressBar extends StatefulWidget {
  const _TVProgressBar({required this.player, required this.onKeepAlive});
  final dynamic player;
  final VoidCallback onKeepAlive;

  @override
  State<_TVProgressBar> createState() => _TVProgressBarState();
}

class _TVProgressBarState extends State<_TVProgressBar> {
  final _focusNode = FocusNode(debugLabel: 'progress-bar');
  bool _focused = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _seekBySeconds(int seconds) {
    final player = widget.player;
    final duration = player.state.duration;
    var target = player.state.position + Duration(seconds: seconds);
    if (target < Duration.zero) target = Duration.zero;
    if (duration > Duration.zero && target > duration) target = duration;
    player.seek(target);
    widget.onKeepAlive();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      _seekBySeconds(-10);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      _seekBySeconds(10);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: widget.player.stream.position,
      initialData: widget.player.state.position,
      builder: (context, posSnap) {
        return StreamBuilder<Duration>(
          stream: widget.player.stream.buffer,
          initialData: widget.player.state.buffer,
          builder: (context, bufSnap) {
            final duration = widget.player.state.duration;
            final position = posSnap.data ?? Duration.zero;
            final buffered = bufSnap.data ?? Duration.zero;

            final total = duration.inMilliseconds > 0
                ? duration.inMilliseconds
                : 1;
            final playedRatio = (position.inMilliseconds / total).clamp(
              0.0,
              1.0,
            );
            final bufferedRatio = (buffered.inMilliseconds / total).clamp(
              0.0,
              1.0,
            );

            return Focus(
              focusNode: _focusNode,
              onFocusChange: (f) => setState(() => _focused = f),
              onKeyEvent: _onKey,
              child: SizedBox(
                height: 22,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: _focused ? 7 : 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: bufferedRatio,
                      child: Container(
                        height: _focused ? 7 : 4,
                        decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: playedRatio,
                      child: Container(
                        height: _focused ? 7 : 4,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [_kAccentSoft, _kAccent],
                          ),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: _focused
                              ? [
                                  BoxShadow(
                                    color: _kAccent.withOpacity(0.6),
                                    blurRadius: 10,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment((playedRatio * 2) - 1, 0),
                      child: Container(
                        width: _focused ? 20 : 14,
                        height: _focused ? 20 : 14,
                        decoration: BoxDecoration(
                          color: _kAccent,
                          shape: BoxShape.circle,
                          border: _focused
                              ? Border.all(color: Colors.white, width: 2)
                              : null,
                          boxShadow: _focused
                              ? [
                                  BoxShadow(
                                    color: _kAccent.withOpacity(0.6),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
