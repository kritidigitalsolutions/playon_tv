// ignore_for_file: prefer_final_fields, unused_field, unused_element_parameter

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/core/widgets/video_setting_sheet.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_navigation.dart';

const _kAccent = AppColors.primary;
const _kAccentSoft = Color(0xFFFF6B5B);
const _kEdgePadding = 48.0;

/// TV-optimized video controls overlay with full D-pad/remote support
class VideoControlsOverlay extends StatefulWidget {
  const VideoControlsOverlay({
    super.key,
    this.title,
    required this.isFullscreen,
    required this.onFullscreenChanged,
  });

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

  // Make these nullable and initialize them properly
  VideoPlayerController? _controller;
  ChewieController? _chewieController;

  // Focus nodes.
  // NOTE: `_rootFocusNode` is intentionally NOT autofocused and has
  // `canRequestFocus: false` (see build()). It exists purely so its
  // `onKeyEvent` can intercept back/escape and "wake up" the overlay
  // on any key press via bubbling — it must never actually hold
  // focus itself, or D-pad arrow keys get swallowed here instead of
  // reaching whichever button is actually focused (that was the
  // previous bug: this node and `_playPauseFocusNode` both requested
  // autofocus, and whichever won left arrow keys going nowhere).
  final _rootFocusNode = FocusNode(debugLabel: 'root-controls');
  final _backFocusNode = FocusNode(debugLabel: 'back-button');
  final _playPauseFocusNode = FocusNode(debugLabel: 'play-pause');
  final _rewindFocusNode = FocusNode(debugLabel: 'rewind');
  final _forwardFocusNode = FocusNode(debugLabel: 'forward');
  final _speedFocusNode = FocusNode(debugLabel: 'speed');
  final _fullscreenFocusNode = FocusNode(debugLabel: 'fullscreen');
  final _progressFocusNode = FocusNode(debugLabel: 'progress');

  // Track if we're seeking to prevent conflicts
  bool _isSeeking = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      final chewieController = ChewieController.of(context);
      _chewieController = chewieController;
      _controller = chewieController.videoPlayerController;
    } catch (e) {
      // Handle case where ChewieController is not available
      _chewieController = null;
      _controller = null;
    }
  }

  @override
  void initState() {
    super.initState();
    _scheduleHide();
  }

  void _scheduleHide() {
    _hideTimer?.cancel();
    if (_activePanel != null) return;
    _hideTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && _activePanel == null) {
        setState(() => _visible = false);
      }
    });
  }

  void _keepAlive() {
    if (!_visible) setState(() => _visible = true);
    _scheduleHide();
  }

  Future<void> _seekBy(int seconds) async {
    if (_isSeeking || _controller == null) return;
    _isSeeking = true;

    try {
      final current = _controller!.value.position;
      final duration = _controller!.value.duration;
      var target = current + Duration(seconds: seconds);

      if (target < Duration.zero) target = Duration.zero;
      if (duration > Duration.zero && target > duration) target = duration;

      await _controller!.seekTo(target);

      // Show flash animation
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
    } finally {
      _isSeeking = false;
    }
  }

  void _openPanel(TVSettingsCategory category) {
    setState(() => _activePanel = category);
    _hideTimer?.cancel();
  }

  void _closePanel() {
    setState(() => _activePanel = null);
    _scheduleHide();
    // Return focus to speed button after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _speedFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _flashTimer?.cancel();
    _rootFocusNode.dispose();
    _backFocusNode.dispose();
    _playPauseFocusNode.dispose();
    _rewindFocusNode.dispose();
    _forwardFocusNode.dispose();
    _speedFocusNode.dispose();
    _fullscreenFocusNode.dispose();
    _progressFocusNode.dispose();
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

    // Handle back/escape
    if (key == LogicalKeyboardKey.goBack || key == LogicalKeyboardKey.escape) {
      if (_activePanel != null) {
        _closePanel();
        return KeyEventResult.handled;
      }
      if (widget.isFullscreen) {
        widget.onFullscreenChanged(false);
        return KeyEventResult.handled;
      }
      // Let back button go to previous page
      return KeyEventResult.ignored;
    }

    // Wake up controls on any key press. This still fires even though
    // this node never holds focus itself — unhandled key events bubble
    // up through every ancestor Focus node's onKeyEvent, and this node
    // sits above all the buttons below.
    _keepAlive();
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    // If controller is not available yet, show loading
    if (_controller == null || _chewieController == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Focus(
      focusNode: _rootFocusNode,
      // This node must never actually hold focus (see field doc above),
      // only observe bubbled key events — otherwise D-pad input gets
      // captured here instead of reaching the real buttons.
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: _handleRootKey,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Clickable area to show controls on tap
          GestureDetector(
            onTap: () {
              setState(() => _visible = !_visible);
              if (_visible) _scheduleHide();
            },
            child: Container(color: Colors.transparent),
          ),
          // Background gradient overlay
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
                      Colors.black87,
                    ],
                    stops: [0.0, 0.3, 0.55, 1.0],
                  ),
                ),
                // Single traversal group for the whole overlay. Every
                // button below — back, rewind, play/pause, forward,
                // speed, fullscreen, progress bar — now lives in ONE
                // focus scope, so D-pad Up/Down/Left/Right can move
                // freely between the top bar, center transport
                // controls, and bottom row. (Previously the center
                // and bottom rows were each wrapped in their own
                // `FocusScope(node: FocusScopeNode(), ...)`, which
                // (a) rebuilt a brand-new scope node on every single
                // build — losing focus state constantly — and (b)
                // walled each row off into its own directional-
                // traversal island, so Up/Down couldn't cross between
                // sections at all.)
                child: FocusTraversalGroup(
                  policy: ReadingOrderTraversalPolicy(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Top bar
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
                              // Back button
                              TvFocusable(
                                focusNode: _backFocusNode,
                                borderRadius: BorderRadius.circular(8),
                                onSelect: () => AppNavigation.pop(context),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.arrow_back_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
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
                                  "Live",
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
                      const Spacer(),
                      // Center controls
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Rewind
                            TvFocusable(
                              focusNode: _rewindFocusNode,
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
                            // Play/Pause — this is the single autofocus
                            // target in the whole overlay now.
                            AnimatedBuilder(
                              animation: _controller!,
                              builder: (context, _) {
                                final playing = _controller!.value.isPlaying;
                                return TvFocusable(
                                  focusNode: _playPauseFocusNode,
                                  autofocus: true,
                                  focusScale: 1.12,
                                  borderRadius: BorderRadius.circular(100),
                                  onSelect: () {
                                    if (playing) {
                                      _controller!.pause();
                                    } else {
                                      _controller!.play();
                                    }
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
                            // Forward
                            TvFocusable(
                              focusNode: _forwardFocusNode,
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
                      // Bottom controls
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Speed
                                  _AccessoryItem(
                                    focusNode: _speedFocusNode,
                                    icon: Icons.speed_rounded,
                                    label: _getSpeedLabel(),
                                    onSelect: () =>
                                        _openPanel(TVSettingsCategory.speed),
                                  ),
                                  const SizedBox(width: 28),
                                  // Fullscreen
                                  TvFocusable(
                                    focusNode: _fullscreenFocusNode,
                                    borderRadius: BorderRadius.circular(8),
                                    onSelect: () {
                                      widget.onFullscreenChanged(
                                        !widget.isFullscreen,
                                      );
                                      _keepAlive();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        widget.isFullscreen
                                            ? Icons.fullscreen_exit_rounded
                                            : Icons.fullscreen_rounded,
                                        color: Colors.white,
                                        size: 26,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              // Progress bar
                              _TVProgressBar(
                                controller: _controller!,
                                focusNode: _progressFocusNode,
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
          ),
          // Settings panel
          if (_activePanel != null)
            Positioned.fill(
              child: TVSettingsPanel(
                category: _activePanel!,
                controller: _controller!,
                onClose: _closePanel,
              ),
            ),
        ],
      ),
    );
  }

  String _getSpeedLabel() {
    if (_controller == null) return 'Speed';
    final speed = _controller!.value.playbackSpeed;
    return speed == 1.0 ? 'Speed' : '${speed}x';
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
    widget.focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TvFocusable(
      focusNode: widget.focusNode,
      borderRadius: BorderRadius.circular(8),
      onSelect: widget.onSelect,
      child: AnimatedOpacity(
        opacity: _focused ? 1.0 : 0.85,
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

class _TVProgressBar extends StatefulWidget {
  const _TVProgressBar({
    required this.controller,
    required this.focusNode,
    required this.formatDuration,
    required this.onKeepAlive,
  });

  final VideoPlayerController controller;
  final FocusNode focusNode;
  final String Function(Duration) formatDuration;
  final VoidCallback onKeepAlive;

  @override
  State<_TVProgressBar> createState() => _TVProgressBarState();
}

class _TVProgressBarState extends State<_TVProgressBar> {
  bool _focused = false;
  bool _isSeeking = false;
  double _dragValue = 0.0;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _seekBySeconds(int seconds) {
    if (_isSeeking) return;
    _isSeeking = true;

    try {
      final controller = widget.controller;
      final duration = controller.value.duration;
      var target = controller.value.position + Duration(seconds: seconds);
      if (target < Duration.zero) target = Duration.zero;
      if (duration > Duration.zero && target > duration) target = duration;
      controller.seekTo(target);
      widget.onKeepAlive();
    } finally {
      _isSeeking = false;
    }
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.arrowLeft) {
      _seekBySeconds(-10);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowRight) {
      _seekBySeconds(10);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final value = widget.controller.value;
        final duration = value.duration;
        final position = value.position;
        final buffered = value.buffered.isNotEmpty
            ? value.buffered.last.end
            : Duration.zero;

        final total = duration.inMilliseconds > 0 ? duration.inMilliseconds : 1;
        final playedRatio = (position.inMilliseconds / total).clamp(0.0, 1.0);
        final bufferedRatio = (buffered.inMilliseconds / total).clamp(0.0, 1.0);

        return Focus(
          focusNode: widget.focusNode,
          onKeyEvent: _handleKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Time display
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.formatDuration(position),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                    Text(
                      '-${widget.formatDuration(duration - position)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
              // Progress bar
              SizedBox(
                height: 32,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // Background
                    Container(
                      height: _focused ? 6 : 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    // Buffered
                    FractionallySizedBox(
                      widthFactor: bufferedRatio,
                      child: Container(
                        height: _focused ? 6 : 4,
                        decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    // Played
                    FractionallySizedBox(
                      widthFactor: playedRatio,
                      child: Container(
                        height: _focused ? 6 : 4,
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
                    // Handle
                    Align(
                      alignment: Alignment((playedRatio * 2) - 1, 0),
                      child: Container(
                        width: _focused ? 22 : 16,
                        height: _focused ? 22 : 16,
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
            ],
          ),
        );
      },
    );
  }
}
