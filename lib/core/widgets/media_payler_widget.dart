import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:playon/core/widgets/video_control_overlay.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;

/// True if [url] is a YouTube link in any common form (watch,
/// youtu.be, or embed) — these need YoutubeExplode to resolve a
/// direct stream URL first, since video_player can't play a YouTube
/// webpage URL directly.
bool isYoutubeUrl(String url) {
  final lower = url.toLowerCase();
  return lower.contains('youtube.com') || lower.contains('youtu.be');
}

// ---------------------------------------------------------------------------
// Captions
// ---------------------------------------------------------------------------

class _CaptionCue {
  _CaptionCue(this.start, this.end, this.text);
  final Duration start;
  final Duration end;
  final String text;
}

/// Minimal SRT parser — good enough for the common case of a plain
/// .srt subtitle file. If you need WebVTT too, strip a leading
/// "WEBVTT" header from [data] before calling this; the timestamp
/// regex accepts both `,` and `.` as the millisecond separator so it
/// already matches VTT's `00:00:01.000` style timestamps.
List<_CaptionCue> _parseSrt(String data) {
  final cues = <_CaptionCue>[];
  final blocks = data.replaceAll('\r\n', '\n').split(RegExp(r'\n\n+'));
  final timeRe = RegExp(
    r'(\d{2}):(\d{2}):(\d{2})[,.](\d{3})\s*-->\s*(\d{2}):(\d{2}):(\d{2})[,.](\d{3})',
  );
  for (final block in blocks) {
    final lines = block.trim().split('\n');
    if (lines.isEmpty) continue;
    final i = lines.indexWhere((l) => timeRe.hasMatch(l));
    if (i == -1) continue;
    final m = timeRe.firstMatch(lines[i])!;
    Duration d(int a, int b, int c, int ms) =>
        Duration(hours: a, minutes: b, seconds: c, milliseconds: ms);
    final start =
        d(int.parse(m[1]!), int.parse(m[2]!), int.parse(m[3]!), int.parse(m[4]!));
    final end =
        d(int.parse(m[5]!), int.parse(m[6]!), int.parse(m[7]!), int.parse(m[8]!));
    final text = lines.sublist(i + 1).join('\n').trim();
    if (text.isNotEmpty) cues.add(_CaptionCue(start, end, text));
  }
  return cues;
}

// ---------------------------------------------------------------------------
// Public widget
// ---------------------------------------------------------------------------

class MediaPlayerWidget extends StatefulWidget {
  const MediaPlayerWidget({
    super.key,
    required this.url,
    this.autoPlay = true,
    this.looping = false,
    this.showControls = true,
    this.aspectRatio,
    this.title,
    this.onError,
    this.onControllerReady,
    required this.isFullscreen,
    required this.onFullscreenChanged,
    this.isBack = true,
    this.showFullscreenButton = true,
    this.subtitleUrl, // NEW — optional .srt URL for burned-in captions
  });

  final String url;
  final bool autoPlay;
  final bool looping;
  final bool showControls;
  final double? aspectRatio;
  final bool isFullscreen;
  final ValueChanged<bool> onFullscreenChanged;
  final bool isBack;
  final bool showFullscreenButton;
  final String? title;
  final String? subtitleUrl; // NEW
  final void Function(String message)? onError;
  final void Function(
    VideoPlayerController controller,
    ChewieController chewieController,
  )?
  onControllerReady;

  @override
  State<MediaPlayerWidget> createState() => _MediaPlayerWidgetState();
}

class _MediaPlayerWidgetState extends State<MediaPlayerWidget> {
  bool get _isYoutube => isYoutubeUrl(widget.url);

  @override
  Widget build(BuildContext context) {
    if (_isYoutube) {
      return _YoutubeResolvingPlayer(
        url: widget.url,
        autoPlay: widget.autoPlay,
        looping: widget.looping,
        showControls: widget.showControls,
        title: widget.title,
        isBack: widget.isBack,
        isFullscreen: widget.isFullscreen,
        onFullscreenChanged: widget.onFullscreenChanged,
        onError: widget.onError,
        onControllerReady: widget.onControllerReady,
        showFullscreenButton: widget.showFullscreenButton,
        subtitleUrl: widget.subtitleUrl, // NEW
      );
    }

    return _NativeMediaPlayer(
      url: widget.url,
      autoPlay: widget.autoPlay,
      looping: widget.looping,
      showControls: widget.showControls,
      title: widget.title,
      isBack: widget.isBack,
      isFullscreen: widget.isFullscreen,
      onFullscreenChanged: widget.onFullscreenChanged,
      onError: widget.onError,
      onControllerReady: widget.onControllerReady,
      showFullscreenButton: widget.showFullscreenButton,
      subtitleUrl: widget.subtitleUrl, // NEW
    );
  }
}

/// Resolves a YouTube URL into a direct playable stream URL via
/// YoutubeExplode, then hands that URL to the same native
/// video_player/chewie player used for every other stream — so
/// YouTube content gets the identical TV-native controls/overlay.
class _YoutubeResolvingPlayer extends StatefulWidget {
  const _YoutubeResolvingPlayer({
    required this.url,
    required this.autoPlay,
    required this.looping,
    required this.showControls,
    required this.isFullscreen,
    required this.onFullscreenChanged,
    required this.isBack,
    this.title,
    this.onError,
    this.onControllerReady,
    this.showFullscreenButton = true,
    this.subtitleUrl, // NEW
  });

  final String url;
  final bool autoPlay;
  final bool looping;
  final bool showControls;
  final bool isFullscreen;
  final ValueChanged<bool> onFullscreenChanged;
  final bool isBack;
  final bool showFullscreenButton;
  final String? title;
  final String? subtitleUrl; // NEW
  final void Function(String message)? onError;
  final void Function(
    VideoPlayerController controller,
    ChewieController chewieController,
  )?
  onControllerReady;

  @override
  State<_YoutubeResolvingPlayer> createState() =>
      _YoutubeResolvingPlayerState();
}

class _YoutubeResolvingPlayerState extends State<_YoutubeResolvingPlayer> {
  final yt.YoutubeExplode _yt = yt.YoutubeExplode();
  String? _resolvedUrl;
  String? _errorMessage;
  bool _isResolving = true;

  @override
  void initState() {
    super.initState();
    _resolve();
  }

  @override
  void didUpdateWidget(covariant _YoutubeResolvingPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _resolvedUrl = null;
      _errorMessage = null;
      _resolve();
    }
  }

  Future<void> _resolve() async {
    setState(() {
      _isResolving = true;
      _errorMessage = null;
    });

    try {
      final videoId = yt.VideoId.parseVideoId(widget.url);
      if (videoId == null) {
        throw Exception('Could not read this YouTube video.');
      }

      final manifest = await _yt.videos.streamsClient.getManifest(videoId);

      // Prefer a muxed (video+audio combined) stream so video_player
      // gets a single playable URL, same as any other stream.
      final streamInfo = manifest.muxed.isNotEmpty
          ? manifest.muxed.withHighestBitrate()
          : manifest.videoOnly.withHighestBitrate();

      if (!mounted) return;
      setState(() {
        _resolvedUrl = streamInfo.url.toString();
        _isResolving = false;
      });
    } catch (e) {
      final msg = 'This YouTube video is unavailable.';
      if (!mounted) return;
      setState(() {
        _errorMessage = msg;
        _isResolving = false;
      });
      widget.onError?.call(msg);
    }
  }

  @override
  void dispose() {
    _yt.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return _ErrorView(message: _errorMessage!, onRetry: _resolve);
    }

    if (_isResolving || _resolvedUrl == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return _NativeMediaPlayer(
      // Re-keying on the resolved URL forces a clean rebuild of the
      // native player state when switching between YouTube videos.
      key: ValueKey(_resolvedUrl),
      url: _resolvedUrl!,
      autoPlay: widget.autoPlay,
      looping: widget.looping,
      showControls: widget.showControls,
      title: widget.title,
      isBack: widget.isBack,
      isFullscreen: widget.isFullscreen,
      onFullscreenChanged: widget.onFullscreenChanged,
      onError: widget.onError,
      onControllerReady: widget.onControllerReady,
      showFullscreenButton: widget.showFullscreenButton,
      subtitleUrl: widget.subtitleUrl, // NEW
    );
  }
}

/// video_player + chewie player. chewie's `customControls` slot is
/// handed the same TV-styled VideoControlsOverlay you had before, so
/// Chewie manages the playback surface/lifecycle while your D-pad UI
/// stays exactly as designed. See video_control_overlay.dart for how
/// it reads the VideoPlayerController via ChewieController.of(context).
class _NativeMediaPlayer extends StatefulWidget {
  const _NativeMediaPlayer({
    super.key,
    required this.url,
    required this.autoPlay,
    required this.looping,
    required this.showControls,
    required this.isFullscreen,
    required this.onFullscreenChanged,
    required this.isBack,
    this.title,
    this.onError,
    this.onControllerReady,
    this.showFullscreenButton = true,
    this.subtitleUrl, // NEW
  });

  final String url;
  final bool autoPlay;
  final bool looping;
  final bool showControls;
  final bool isFullscreen;
  final ValueChanged<bool> onFullscreenChanged;
  final bool isBack;
  final bool showFullscreenButton;
  final String? title;
  final String? subtitleUrl; // NEW
  final void Function(String message)? onError;
  final void Function(
    VideoPlayerController controller,
    ChewieController chewieController,
  )?
  onControllerReady;

  @override
  State<_NativeMediaPlayer> createState() => _NativeMediaPlayerState();
}

class _NativeMediaPlayerState extends State<_NativeMediaPlayer> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  bool _isLoading = true;
  String? _errorMessage;
  int _retryCount = 0;
  final int _maxRetries = 3;

  // NEW — captions. Chewie/video_player expose no runtime API to
  // switch subtitle tracks, so captions are handled entirely outside
  // Chewie: fetch + parse the SRT ourselves, then draw the active
  // cue as our own overlay text, driven by playback position.
  List<_CaptionCue> _captions = [];
  final ValueNotifier<bool> _captionsAvailable = ValueNotifier(false);
  final ValueNotifier<bool> _captionsEnabled = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    _initStream();
    _loadCaptions();
  }

  Future<void> _loadCaptions() async {
    final url = widget.subtitleUrl;
    if (url == null) return;
    try {
      final resp = await http.get(Uri.parse(url));
      if (resp.statusCode == 200 && mounted) {
        final cues = _parseSrt(utf8.decode(resp.bodyBytes));
        setState(() => _captions = cues);
        _captionsAvailable.value = cues.isNotEmpty;
      }
    } catch (_) {
      // Captions are optional — fail silently rather than
      // interrupting playback over a missing/broken subtitle file.
    }
  }

  String? _currentCaptionText(Duration position) {
    if (!_captionsEnabled.value || _captions.isEmpty) return null;
    for (final c in _captions) {
      if (position >= c.start && position <= c.end) return c.text;
    }
    return null;
  }

  String _userMessageFor(String raw) {
    final errorMsg = raw.toLowerCase();
    if (errorMsg.contains('unsupported') ||
        errorMsg.contains('codec') ||
        errorMsg.contains('format')) {
      return 'Video format not supported on this TV device';
    } else if (errorMsg.contains('network') ||
        errorMsg.contains('connection') ||
        errorMsg.contains('timeout')) {
      return 'Network error - please check your connection';
    } else if (errorMsg.contains('decoder') || errorMsg.contains('decode')) {
      return 'Video decoding error - try a different stream';
    } else if (errorMsg.contains('404') || errorMsg.contains('not found')) {
      return 'Stream not found - please try again later';
    }
    return raw;
  }

  void _onControllerUpdate() {
    final controller = _controller;
    if (controller == null || !mounted) return;
    if (controller.value.hasError && _errorMessage == null) {
      final msg = _userMessageFor(
        controller.value.errorDescription ?? 'Playback error',
      );
      setState(() => _errorMessage = msg);
      widget.onError?.call(msg);

      if (_retryCount < _maxRetries) {
        _retryCount++;
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) _initStream();
        });
      }
    }
  }

  Future<void> _initStream() async {
    _disposeControllers();
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
        httpHeaders: {
          'User-Agent': 'PlayOnTV/1.0',
          'Accept-Encoding': 'identity',
        },
      );

      await controller.initialize();
      await controller.setLooping(widget.looping);
      controller.addListener(_onControllerUpdate);

      if (widget.autoPlay) {
        await controller.play();
      }

      final chewieController = ChewieController(
        videoPlayerController: controller,
        autoPlay: widget.autoPlay,
        looping: widget.looping,
        showControls: widget.showControls,
        allowFullScreen: false, // fullscreen is handled by the parent
        customControls: widget.showControls
            ? VideoControlsOverlay(
                isFullscreen: widget.isFullscreen,
                onFullscreenChanged: widget.onFullscreenChanged,
                title: widget.isBack ? widget.title : null,
                showFullscreenButton: widget.showFullscreenButton,
                captionsAvailable: _captionsAvailable, // NEW
                captionsEnabled: _captionsEnabled, // NEW
                onCaptionsToggle: () => // NEW
                    _captionsEnabled.value = !_captionsEnabled.value,
              )
            : const SizedBox.shrink(),
      );

      if (!mounted) {
        controller.removeListener(_onControllerUpdate);
        chewieController.dispose();
        controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
        _chewieController = chewieController;
        _isLoading = false;
      });

      widget.onControllerReady?.call(controller, chewieController);
    } catch (e) {
      if (!mounted) return;
      final msg = _userMessageFor(e.toString());
      setState(() {
        _errorMessage = msg;
        _isLoading = false;
      });
      widget.onError?.call(msg);

      if (_retryCount < _maxRetries) {
        _retryCount++;
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) _initStream();
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant _NativeMediaPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _retryCount = 0;
      _initStream();
    }
    if (oldWidget.subtitleUrl != widget.subtitleUrl) {
      _captions = [];
      _captionsAvailable.value = false;
      _loadCaptions();
    }
  }

  void _disposeControllers() {
    _controller?.removeListener(_onControllerUpdate);
    _chewieController?.dispose();
    _controller?.dispose();
    _controller = null;
    _chewieController = null;
  }

  @override
  void dispose() {
    _disposeControllers();
    _captionsAvailable.dispose();
    _captionsEnabled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return _ErrorView(
        message: _errorMessage!,
        onRetry: () {
          setState(() {
            _errorMessage = null;
            _retryCount = 0;
          });
          _initStream();
        },
      );
    }

    if (_isLoading || _chewieController == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(child: Chewie(controller: _chewieController!)),
        AnimatedBuilder(
          animation: _controller!,
          builder: (context, _) {
            if (!_controller!.value.isBuffering) return const SizedBox();
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            );
          },
        ),
        // NEW — burned-in caption text, redrawn as playback advances.
        AnimatedBuilder(
          animation: Listenable.merge([_controller!, _captionsEnabled]),
          builder: (context, _) {
            final text = _currentCaptionText(_controller!.value.position);
            if (text == null) return const SizedBox.shrink();
            return Positioned(
              left: 40,
              right: 40,
              bottom: 110,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.72),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      height: 1.3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.white.withOpacity(0.7),
              size: 48,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.15),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.white.withOpacity(0.2)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}