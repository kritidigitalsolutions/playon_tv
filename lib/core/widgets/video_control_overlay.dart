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
    this.showFullscreenButton = true, // lets a page hide just this button
    // NEW — captions
    this.captionsAvailable,
    this.captionsEnabled,
    this.onCaptionsToggle,
  });

  final String? title;
  final bool isFullscreen;
  final ValueChanged<bool> onFullscreenChanged;
  final bool showFullscreenButton;

  /// NEW — pass ValueNotifiers so this button can react live without
  /// needing to rebuild the ChewieController (which owns this widget
  /// as a fixed `customControls` instance).
  final ValueNotifier<bool>? captionsAvailable;
  final ValueNotifier<bool>? captionsEnabled;
  final VoidCallback? onCaptionsToggle;

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
  // `onKeyEvent` can intercept back/escape and arrow keys and route
  // them explicitly — it must never actually hold focus itself, or
  // D-pad input gets swallowed here instead of reaching whichever
  // button is actually focused.
  final _rootFocusNode = FocusNode(debugLabel: 'root-controls');
  final _backFocusNode = FocusNode(debugLabel: 'back-button');
  final _playPauseFocusNode = FocusNode(debugLabel: 'play-pause');
  final _rewindFocusNode = FocusNode(debugLabel: 'rewind');
  final _forwardFocusNode = FocusNode(debugLabel: 'forward');
  final _speedFocusNode = FocusNode(debugLabel: 'speed');
  final _captionsFocusNode = FocusNode(debugLabel: 'captions'); // NEW
  final _fullscreenFocusNode = FocusNode(debugLabel: 'fullscreen');
  final _progressFocusNode = FocusNode(debugLabel: 'progress');

  // All focus nodes this overlay owns, used to figure out which one
  // was last focused so `_keepAlive()` can restore it instead of
  // always snapping back to Play/Pause.
  late final List<FocusNode> _allFocusNodes = [
    _backFocusNode,
    _playPauseFocusNode,
    _rewindFocusNode,
    _forwardFocusNode,
    _speedFocusNode,
    _captionsFocusNode,
    _fullscreenFocusNode,
    _progressFocusNode,
  ];
  FocusNode? _lastKnownFocus;

  // Fallback notifier used only if the caller never supplies
  // `captionsEnabled` — avoids ever constructing a fresh ValueNotifier
  // mid-build (which would break equality/listening every frame).
  final ValueNotifier<bool> _fallbackCaptionsEnabled = ValueNotifier(false);

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
    FocusManager.instance.addListener(_trackFocus);
    // Focus Play/Pause exactly once, on first build — not via
    // `autofocus: true` on the widget itself, which would re-claim
    // focus every time this overlay rebuilds (e.g. on every
    // AnimatedBuilder tick), overriding wherever the user had
    // actually navigated to.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _playPauseFocusNode.requestFocus();
    });
  }

  /// Records whichever of our own controls currently holds primary
  /// focus, so it can be restored later instead of defaulting back
  /// to Play/Pause every time the controls fade back in.
  void _trackFocus() {
    final primary = FocusManager.instance.primaryFocus;
    if (primary != null && _allFocusNodes.contains(primary)) {
      _lastKnownFocus = primary;
    }
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
    final wasHidden = !_visible;
    if (wasHidden) {
      setState(() => _visible = true);
      // Controls just re-appeared — restore whichever control the
      // user was last on (Speed/CC/Fullscreen/Progress/etc.) instead
      // of always jumping back to Play/Pause.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final target = _lastKnownFocus ?? _playPauseFocusNode;
        if (target.canRequestFocus) target.requestFocus();
      });
    }
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
    FocusManager.instance.removeListener(_trackFocus);
    _hideTimer?.cancel();
    _flashTimer?.cancel();
    _rootFocusNode.dispose();
    _backFocusNode.dispose();
    _playPauseFocusNode.dispose();
    _rewindFocusNode.dispose();
    _forwardFocusNode.dispose();
    _speedFocusNode.dispose();
    _captionsFocusNode.dispose();
    _fullscreenFocusNode.dispose();
    _progressFocusNode.dispose();
    _fallbackCaptionsEnabled.dispose();
    super.dispose();
  }

  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return h > 0 ? '$h:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
  }

  bool get _captionsShown => widget.captionsAvailable?.value ?? false;

  /// Explicit D-pad routing between the known controls.
  ///
  /// `ReadingOrderTraversalPolicy` (still used as a fallback below)
  /// infers direction from widget *geometry*, and gets confused by
  /// the `Spacer()`s between the top bar / center transport row /
  /// bottom row / progress bar — that's what made moving into
  /// Speed/CC/Fullscreen feel unreliable. This hand-written map is
  /// deterministic instead: each control only ever jumps to a
  /// specific named neighbour, so behaviour can't drift as the layout
  /// changes.
  FocusNode? _neighbor(FocusNode? current, LogicalKeyboardKey key) {
    final up = key == LogicalKeyboardKey.arrowUp;
    final down = key == LogicalKeyboardKey.arrowDown;
    final left = key == LogicalKeyboardKey.arrowLeft;
    final right = key == LogicalKeyboardKey.arrowRight;

    final hasCaptions = _captionsShown;
    final hasFullscreen = widget.showFullscreenButton;

    if (current == _backFocusNode) {
      if (down) return _playPauseFocusNode;
    } else if (current == _rewindFocusNode) {
      if (right) return _playPauseFocusNode;
      if (up) return _backFocusNode;
      if (down) return _speedFocusNode;
    } else if (current == _playPauseFocusNode) {
      if (left) return _rewindFocusNode;
      if (right) return _forwardFocusNode;
      if (up) return _backFocusNode;
      if (down) return _speedFocusNode;
    } else if (current == _forwardFocusNode) {
      if (left) return _playPauseFocusNode;
      if (up) return _backFocusNode;
      if (down) return _speedFocusNode;
    } else if (current == _speedFocusNode) {
      if (up) return _playPauseFocusNode;
      if (down) return _progressFocusNode;
      if (right) {
        if (hasCaptions) return _captionsFocusNode;
        if (hasFullscreen) return _fullscreenFocusNode;
      }
    } else if (current == _captionsFocusNode) {
      if (up) return _playPauseFocusNode;
      if (down) return _progressFocusNode;
      if (left) return _speedFocusNode;
      if (right && hasFullscreen) return _fullscreenFocusNode;
    } else if (current == _fullscreenFocusNode) {
      if (up) return _forwardFocusNode;
      if (down) return _progressFocusNode;
      if (left) return hasCaptions ? _captionsFocusNode : _speedFocusNode;
    } else if (current == _progressFocusNode) {
      if (up) return _speedFocusNode;
    }
    return null;
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

    final arrows = {
      LogicalKeyboardKey.arrowUp,
      LogicalKeyboardKey.arrowDown,
      LogicalKeyboardKey.arrowLeft,
      LogicalKeyboardKey.arrowRight,
    };
    // The progress bar owns left/right itself (for seeking) and
    // marks those as handled there, so only its unhandled up/down
    // ever reach this point while it's focused.
    if (arrows.contains(key)) {
      final current = FocusManager.instance.primaryFocus;
      final next = _neighbor(current, key);
      if (next != null && next.canRequestFocus) {
        next.requestFocus();
        return KeyEventResult.handled;
      }
    }

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
                // Single traversal group for the whole overlay. Kept
                // as a fallback path (e.g. Tab on a remote with a
                // keyboard attached) — real D-pad movement is routed
                // explicitly through `_handleRootKey` / `_neighbor`
                // above, so it no longer depends on this policy
                // guessing direction from widget position.
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
                            // Rewind — now focus-aware via
                            // _TransportButton (accent border + glow
                            // when focused, same as Speed/CC/Fullscreen).
                            _TransportButton(
                              focusNode: _rewindFocusNode,
                              icon: Icons.replay_10_rounded,
                              onSelect: () => _seekBy(-10),
                              flash: _showRewindFlash,
                            ),
                            const SizedBox(width: 40),
                            // Play/Pause.
                            // NOTE: no `autofocus: true` here anymore —
                            // initial focus is requested exactly once
                            // in initState() instead, so this stops
                            // re-stealing focus on every rebuild.
                            AnimatedBuilder(
                              animation: _controller!,
                              builder: (context, _) {
                                final playing = _controller!.value.isPlaying;
                                return TvFocusable(
                                  focusNode: _playPauseFocusNode,
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
                            // Forward — same focus-aware treatment as Rewind.
                            _TransportButton(
                              focusNode: _forwardFocusNode,
                              icon: Icons.forward_10_rounded,
                              onSelect: () => _seekBy(10),
                              flash: _showForwardFlash,
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
                                  _ControlChip(
                                    focusNode: _speedFocusNode,
                                    icon: Icons.speed_rounded,
                                    label: _getSpeedLabel(),
                                    onSelect: () =>
                                        _openPanel(TVSettingsCategory.speed),
                                  ),
                                  // NEW — Captions (CC), only shown once
                                  // a subtitle track has actually loaded.
                                  if (widget.captionsAvailable != null)
                                    ValueListenableBuilder<bool>(
                                      valueListenable:
                                          widget.captionsAvailable!,
                                      builder: (context, available, _) {
                                        if (!available) {
                                          return const SizedBox.shrink();
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            left: 16,
                                          ),
                                          child: ValueListenableBuilder<bool>(
                                            valueListenable:
                                                widget.captionsEnabled ??
                                                _fallbackCaptionsEnabled,
                                            builder: (context, enabled, _) {
                                              return _ControlChip(
                                                focusNode: _captionsFocusNode,
                                                icon: enabled
                                                    ? Icons
                                                          .closed_caption_rounded
                                                    : Icons
                                                          .closed_caption_off_rounded,
                                                label: 'CC',
                                                active: enabled,
                                                onSelect: () {
                                                  widget.onCaptionsToggle
                                                      ?.call();
                                                  _keepAlive();
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  if (widget.showFullscreenButton) ...[
                                    const SizedBox(width: 16),
                                    // Fullscreen
                                    _ControlIconButton(
                                      focusNode: _fullscreenFocusNode,
                                      icon: widget.isFullscreen
                                          ? Icons.fullscreen_exit_rounded
                                          : Icons.fullscreen_rounded,
                                      onSelect: () {
                                        widget.onFullscreenChanged(
                                          !widget.isFullscreen,
                                        );
                                        _keepAlive();
                                      },
                                    ),
                                  ],
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

/// Rewind/Forward transport button. Same visual language as
/// `_ControlChip`/`_ControlIconButton` below (accent border + glow
/// on focus) so all controls in this overlay look consistent when
/// navigated to via TV remote — previously these two only reacted to
/// the seek "flash" pulse and had no focus indicator at all, which is
/// why they were invisible when focused via D-pad.
class _TransportButton extends StatefulWidget {
  const _TransportButton({
    required this.focusNode,
    required this.icon,
    required this.onSelect,
    this.size = 60,
    this.iconSize = 32,
    this.flash = false,
  });

  final FocusNode focusNode;
  final IconData icon;
  final VoidCallback onSelect;
  final double size;
  final double iconSize;

  /// Brief scale pulse triggered by an actual seek action (kept
  /// separate from the focus glow so both can be visible together).
  final bool flash;

  @override
  State<_TransportButton> createState() => _TransportButtonState();
}

class _TransportButtonState extends State<_TransportButton> {
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
      borderRadius: BorderRadius.circular(100),
      // No flat background tint — the Container border/glow below is
      // the focus indicator, matching _ControlChip/_ControlIconButton.
      focusBackgroundColor: Colors.transparent,
      onSelect: widget.onSelect,
      child: AnimatedScale(
        scale: widget.flash ? 1.3 : (_focused ? 1.1 : 1.0),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _focused
                ? _kAccent.withOpacity(0.22)
                : Colors.white.withOpacity(0.1),
            border: Border.all(
              color: _focused ? _kAccent : Colors.white.withOpacity(0.2),
              width: _focused ? 3 : 1,
            ),
            boxShadow: _focused
                ? [
                    BoxShadow(
                      color: _kAccent.withOpacity(0.55),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Icon(widget.icon, color: Colors.white, size: widget.iconSize),
        ),
      ),
    );
  }
}

/// Icon + label pill (Speed, CC). Focus is now always visually
/// obvious: accent border + glow + tinted fill, instead of the old
/// faint opacity/underline change that was hard to spot on a TV.
class _ControlChip extends StatefulWidget {
  const _ControlChip({
    required this.focusNode,
    required this.icon,
    required this.label,
    required this.onSelect,
    this.active = false,
  });

  final FocusNode focusNode;
  final IconData icon;
  final String label;
  final VoidCallback onSelect;
  final bool active;

  @override
  State<_ControlChip> createState() => _ControlChipState();
}

class _ControlChipState extends State<_ControlChip> {
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
    final highlighted = _focused || widget.active;
    return TvFocusable(
      focusNode: widget.focusNode,
      borderRadius: BorderRadius.circular(24),
      onSelect: widget.onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: _focused
              ? _kAccent.withOpacity(0.22)
              : (widget.active
                    ? Colors.white.withOpacity(0.16)
                    : Colors.white.withOpacity(0.06)),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _focused
                ? _kAccent
                : (widget.active
                      ? Colors.white70
                      : Colors.white.withOpacity(0.25)),
            width: _focused ? 2 : 1,
          ),
          boxShadow: _focused
              ? [
                  BoxShadow(
                    color: _kAccent.withOpacity(0.5),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
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
                fontWeight: highlighted ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Icon-only button (Fullscreen). Same visible focus treatment as
/// `_ControlChip`, just without the label.
class _ControlIconButton extends StatefulWidget {
  const _ControlIconButton({
    required this.focusNode,
    required this.icon,
    required this.onSelect,
  });

  final FocusNode focusNode;
  final IconData icon;
  final VoidCallback onSelect;

  @override
  State<_ControlIconButton> createState() => _ControlIconButtonState();
}

class _ControlIconButtonState extends State<_ControlIconButton> {
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
      borderRadius: BorderRadius.circular(10),
      onSelect: widget.onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: _focused
              ? _kAccent.withOpacity(0.22)
              : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _focused ? _kAccent : Colors.white.withOpacity(0.25),
            width: _focused ? 2 : 1,
          ),
          boxShadow: _focused
              ? [
                  BoxShadow(
                    color: _kAccent.withOpacity(0.5),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Icon(widget.icon, color: Colors.white, size: 26),
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