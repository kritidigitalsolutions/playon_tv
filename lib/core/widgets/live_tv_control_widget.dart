// ignore_for_file: unused_element_parameter, unused_element

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chewie/chewie.dart';
import 'package:playon/core/widgets/live_channel_panel.dart';
import 'package:video_player/video_player.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_navigation.dart';

const _kAccent = AppColors.primary;
const _kAccentSoft = Color(0xFFFF6B5B);
const _kEdgePadding = 48.0;

/// TV-optimized live video controls overlay with channel up/down support
class LiveTVControlsOverlay extends StatefulWidget {
  const LiveTVControlsOverlay({
    super.key,
    this.title,
    this.onChannelSelect,
    this.captionsAvailable,
    this.captionsEnabled,
    this.onCaptionsToggle,
    required this.onChannelUp,
    required this.onChannelDown,
    required this.currentChannelNumber,
    required this.totalChannels,
  });

  final String? title;
  final VoidCallback onChannelUp;
  final VoidCallback onChannelDown;
  final int currentChannelNumber;
  final int totalChannels;
  final VoidCallback? onChannelSelect;
  final ValueNotifier<bool>? captionsAvailable;
  final ValueNotifier<bool>? captionsEnabled;
  final VoidCallback? onCaptionsToggle;

  @override
  State<LiveTVControlsOverlay> createState() => _LiveTVControlsOverlayState();
}

class _LiveTVControlsOverlayState extends State<LiveTVControlsOverlay> {
  bool _visible = true;
  Timer? _hideTimer;
  bool _showChannelUpFlash = false;
  bool _showChannelDownFlash = false;
  Timer? _flashTimer;
  LiveSettingsCategory? _activePanel;

  VideoPlayerController? _controller;
  ChewieController? _chewieController;

  final _rootFocusNode = FocusNode(debugLabel: 'root-controls');
  final _backFocusNode = FocusNode(debugLabel: 'back-button');
  final _playPauseFocusNode = FocusNode(debugLabel: 'play-pause');
  final _channelUpFocusNode = FocusNode(debugLabel: 'channel-up');
  final _channelDownFocusNode = FocusNode(debugLabel: 'channel-down');
  final _channelListFocusNode = FocusNode(debugLabel: 'channel-list');
  final _captionsFocusNode = FocusNode(debugLabel: 'captions');
  final _progressFocusNode = FocusNode(debugLabel: 'progress');

  late final List<FocusNode> _allFocusNodes = [
    _backFocusNode,
    _playPauseFocusNode,
    _channelUpFocusNode,
    _channelDownFocusNode,
    _channelListFocusNode,
    _captionsFocusNode,
    _progressFocusNode,
  ];
  FocusNode? _lastKnownFocus;

  final ValueNotifier<bool> _fallbackCaptionsEnabled = ValueNotifier(false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      final chewieController = ChewieController.of(context);
      _chewieController = chewieController;
      _controller = chewieController.videoPlayerController;
    } catch (e) {
      _chewieController = null;
      _controller = null;
    }
  }

  @override
  void initState() {
    super.initState();
    _scheduleHide();
    FocusManager.instance.addListener(_trackFocus);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _playPauseFocusNode.requestFocus();
    });
  }

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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final target = _lastKnownFocus ?? _playPauseFocusNode;
        if (target.canRequestFocus) target.requestFocus();
      });
    }
    _scheduleHide();
  }

  void _channelUp() {
    _flashTimer?.cancel();
    setState(() {
      _showChannelUpFlash = true;
      _showChannelDownFlash = false;
    });
    _flashTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showChannelUpFlash = false;
        });
      }
    });
    widget.onChannelUp();
    _keepAlive();
  }

  void _channelDown() {
    _flashTimer?.cancel();
    setState(() {
      _showChannelDownFlash = true;
      _showChannelUpFlash = false;
    });
    _flashTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showChannelDownFlash = false;
        });
      }
    });
    widget.onChannelDown();
    _keepAlive();
  }

  void _openPanel(LiveSettingsCategory category) {
    setState(() => _activePanel = category);
    _hideTimer?.cancel();
  }

  void _closePanel() {
    setState(() => _activePanel = null);
    _scheduleHide();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _channelListFocusNode.requestFocus();
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
    _channelUpFocusNode.dispose();
    _channelDownFocusNode.dispose();
    _channelListFocusNode.dispose();
    _captionsFocusNode.dispose();
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

  FocusNode? _neighbor(FocusNode? current, LogicalKeyboardKey key) {
    final up = key == LogicalKeyboardKey.arrowUp;
    final down = key == LogicalKeyboardKey.arrowDown;
    final left = key == LogicalKeyboardKey.arrowLeft;
    final right = key == LogicalKeyboardKey.arrowRight;

    final hasCaptions = _captionsShown;

    if (current == _backFocusNode) {
      if (down) return _playPauseFocusNode;
    } else if (current == _channelDownFocusNode) {
      if (right) return _playPauseFocusNode;
      if (up) return _backFocusNode;
      if (down) return _channelListFocusNode;
    } else if (current == _playPauseFocusNode) {
      if (left) return _channelDownFocusNode;
      if (right) return _channelUpFocusNode;
      if (up) return _backFocusNode;
      if (down) return _channelListFocusNode;
    } else if (current == _channelUpFocusNode) {
      if (left) return _playPauseFocusNode;
      if (up) return _backFocusNode;
      if (down) return _channelListFocusNode;
    } else if (current == _channelListFocusNode) {
      if (up) return _playPauseFocusNode;
      if (down) return _progressFocusNode;
      if (right && hasCaptions) return _captionsFocusNode;
    } else if (current == _captionsFocusNode) {
      if (up) return _playPauseFocusNode;
      if (down) return _progressFocusNode;
      if (left) return _channelListFocusNode;
    } else if (current == _progressFocusNode) {
      if (up) return _channelListFocusNode;
    }
    return null;
  }

  KeyEventResult _handleRootKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.goBack || key == LogicalKeyboardKey.escape) {
      if (_activePanel != null) {
        _closePanel();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    _keepAlive();

    final arrows = {
      LogicalKeyboardKey.arrowUp,
      LogicalKeyboardKey.arrowDown,
      LogicalKeyboardKey.arrowLeft,
      LogicalKeyboardKey.arrowRight,
    };
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
    if (_controller == null || _chewieController == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Focus(
      focusNode: _rootFocusNode,
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: _handleRootKey,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () {
              setState(() => _visible = !_visible);
              if (_visible) _scheduleHide();
            },
            child: Container(color: Colors.transparent),
          ),
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
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
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
                                      const SizedBox(height: 4),
                                     
                                    ],
                                  ),
                                ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [_kAccentSoft, _kAccent],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _kAccent.withOpacity(0.3),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  "LIVE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Center controls - Channel navigation with enhanced UI
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Channel Down
                            _ChannelNavButton(
                              focusNode: _channelDownFocusNode,
                              icon: Icons.skip_previous,
                              channelNumber: widget.currentChannelNumber - 1,
                              onSelect: _channelDown,
                              flash: _showChannelDownFlash,
                              isUp: false,
                            ),
                            const SizedBox(width: 32),
                            // Play/Pause
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
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [_kAccentSoft, _kAccent],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _kAccent.withOpacity(0.5),
                                          blurRadius: 30,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      playing
                                          ? Icons.pause_rounded
                                          : Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 44,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 32),
                            // Channel Up
                            _ChannelNavButton(
                              focusNode: _channelUpFocusNode,
                              icon: Icons.skip_next,
                              channelNumber: widget.currentChannelNumber + 1,
                              onSelect: _channelUp,
                              flash: _showChannelUpFlash,
                              isUp: true,
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
                             
                                  // Channel List
                                  
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
              child: LiveTVSettingsPanel(
                category: _activePanel!,
                controller: _controller!,
                onClose: _closePanel,
                onChannelSelect: widget.onChannelSelect,
              ),
            ),
        ],
      ),
    );
  }
}

/// Enhanced Channel up/down button with better UI
class _ChannelNavButton extends StatefulWidget {
  const _ChannelNavButton({
    required this.focusNode,
    required this.icon,
    required this.channelNumber,
    required this.onSelect,
    required this.flash,
    required this.isUp,
  });

  final FocusNode focusNode;
  final IconData icon;
  final int channelNumber;
  final VoidCallback onSelect;
  final bool flash;
  final bool isUp;

  @override
  State<_ChannelNavButton> createState() => _ChannelNavButtonState();
}

class _ChannelNavButtonState extends State<_ChannelNavButton> {
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
    final isActive = widget.channelNumber > 0;
    
    return TvFocusable(
      focusNode: widget.focusNode,
      borderRadius: BorderRadius.circular(16),
      focusBackgroundColor: Colors.transparent,
      onSelect: isActive ? widget.onSelect : null,
      child: AnimatedScale(
        scale: widget.flash ? 1.2 : (_focused ? 1.08 : 1.0),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _focused
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _kAccent.withOpacity(0.4),
                      _kAccent.withOpacity(0.15),
                    ],
                  )
                : null,
            color: _focused
                ? null
                : (widget.flash
                    ? _kAccent.withOpacity(0.3)
                    : Colors.white.withOpacity(0.08)),
            border: Border.all(
              color: _focused
                  ? _kAccent
                  : (widget.flash
                      ? _kAccent.withOpacity(0.6)
                      : Colors.white.withOpacity(0.15)),
              width: _focused ? 3 : 1.5,
            ),
            boxShadow: _focused
                ? [
                    BoxShadow(
                      color: _kAccent.withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: isActive ? Colors.white : Colors.white38,
                size: 28,
              ),
              const SizedBox(height: 4),
              Text(
                isActive ? 'CH ${widget.channelNumber}' : '---',
                style: TextStyle(
                  color: isActive ? Colors.white70 : Colors.white38,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Icon + label pill for controls
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        decoration: BoxDecoration(
          color: _focused
              ? _kAccent.withOpacity(0.25)
              : (widget.active
                    ? Colors.white.withOpacity(0.15)
                    : Colors.white.withOpacity(0.06)),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _focused
                ? _kAccent
                : (widget.active
                      ? Colors.white60
                      : Colors.white.withOpacity(0.2)),
            width: _focused ? 2 : 1,
          ),
          boxShadow: _focused
              ? [
                  BoxShadow(
                    color: _kAccent.withOpacity(0.4),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              color: _focused || widget.active ? _kAccent : Colors.white70,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(
                color: _focused || widget.active ? Colors.white : Colors.white70,
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

/// Progress bar
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
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
              SizedBox(
                height: 32,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: _focused ? 6 : 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
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