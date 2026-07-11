import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:playon/core/widgets/video_control_overlay.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;
/// True if [url] is a YouTube link in any common form (watch,
/// youtu.be, or embed) — these need YoutubeExplode to resolve a
/// direct stream URL first, since media_kit can't play a YouTube
/// webpage URL directly.
bool isYoutubeUrl(String url) {
  final lower = url.toLowerCase();
  return lower.contains('youtube.com') || lower.contains('youtu.be');
}

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
  });

  final String url;
  final bool autoPlay;
  final bool looping;
  final bool showControls;
  final double? aspectRatio;
  final bool isFullscreen;
  final ValueChanged<bool> onFullscreenChanged;
  final bool isBack;
  final String? title;
  final void Function(String message)? onError;
  final void Function(Player player, VideoController controller)?
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
    );
  }
}

/// Resolves a YouTube URL into a direct playable stream URL via
/// YoutubeExplode, then hands that URL to the same native
/// media_kit player used for every other stream — so YouTube
/// content gets the identical TV-native controls/overlay.
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
  });

  final String url;
  final bool autoPlay;
  final bool looping;
  final bool showControls;
  final bool isFullscreen;
  final ValueChanged<bool> onFullscreenChanged;
  final bool isBack;
  final String? title;
  final void Function(String message)? onError;
  final void Function(Player player, VideoController controller)?
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

      // Prefer a muxed (video+audio combined) stream so media_kit
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
    );
  }
}

/// Your original media_kit-based player, with an Android-TV-specific
/// rendering fix applied (see [_buildVideoControllerConfiguration]).
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
  });

  final String url;
  final bool autoPlay;
  final bool looping;
  final bool showControls;
  final bool isFullscreen;
  final ValueChanged<bool> onFullscreenChanged;
  final bool isBack;
  final String? title;
  final void Function(String message)? onError;
  final void Function(Player player, VideoController controller)?
  onControllerReady;

  @override
  State<_NativeMediaPlayer> createState() => _NativeMediaPlayerState();
}

class _NativeMediaPlayerState extends State<_NativeMediaPlayer> {
  late final Player _player;
  late final VideoController _controller;
  bool _isLoading = true;
  String? _errorMessage;
  int _retryCount = 0;
  final int _maxRetries = 3;

  // Some Android TV boxes (common on Amlogic/Rockchip chipsets) fail
  // to composite mpv's hardware-decoded video texture to the screen:
  // audio plays fine but the picture stays black. Forcing software
  // rendering on Android sidesteps that broken GPU compositing path.
  // Desktop keeps hardware acceleration since it already renders fine.
  VideoControllerConfiguration _videoControllerConfiguration() {
    if (Platform.isAndroid) {
      return const VideoControllerConfiguration(
        enableHardwareAcceleration: false,
      );
    }
    return const VideoControllerConfiguration();
  }

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    try {
      _player = Player();
      _controller = VideoController(
        _player,
        configuration: _videoControllerConfiguration(),
      );
      _initStream();
      widget.onControllerReady?.call(_player, _controller);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize player: $e';
        _isLoading = false;
      });
      widget.onError?.call(_errorMessage!);
    }
  }

  Future<void> _initStream() async {
    try {
      setState(() => _isLoading = true);

      final media = Media(
        widget.url,
        httpHeaders: {
          'User-Agent': 'PlayOnTV/1.0',
          'Accept-Encoding': 'identity',
        },
      );

      await _player.open(media, play: widget.autoPlay);

      await _player.setPlaylistMode(
        widget.looping ? PlaylistMode.single : PlaylistMode.none,
      );

      _player.stream.error.listen((err) {
        final errorMsg = err.toString().toLowerCase();
        String userMessage = err.toString();

        if (errorMsg.contains('unsupported') ||
            errorMsg.contains('codec') ||
            errorMsg.contains('format')) {
          userMessage = 'Video format not supported on this TV device';
        } else if (errorMsg.contains('network') ||
            errorMsg.contains('connection') ||
            errorMsg.contains('timeout')) {
          userMessage = 'Network error - please check your connection';
        } else if (errorMsg.contains('decoder') ||
            errorMsg.contains('decode')) {
          userMessage = 'Video decoding error - try a different stream';
        } else if (errorMsg.contains('404') || errorMsg.contains('not found')) {
          userMessage = 'Stream not found - please try again later';
        }

        setState(() {
          _errorMessage = userMessage;
          _isLoading = false;
        });
        widget.onError?.call(userMessage);

        if (_retryCount < _maxRetries) {
          _retryCount++;
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) _initStream();
          });
        }
      });

      _player.stream.buffering.listen((buffering) {
        if (mounted) setState(() => _isLoading = buffering);
      });

      _player.stream.completed.listen((_) {
        if (widget.looping) {
          _player.seek(Duration.zero);
          _player.play();
        }
      });

      _player.stream.playing.listen((isPlaying) {
        if (isPlaying && mounted) setState(() => _isLoading = false);
      });

      try {
        final duration = await _player.stream.duration.first;
        if (duration == Duration.zero) {
          debugPrint('Live stream detected');
        }
      } catch (_) {
        debugPrint('Stream duration not available');
      }

      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
      widget.onError?.call(e.toString());
    }
  }

  @override
  void didUpdateWidget(covariant _NativeMediaPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _retryCount = 0;
      _initStream();
    }
  }

  @override
  void dispose() {
    _player.dispose();
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

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: Video(
            controller: _controller,
            controls: widget.showControls
                ? (state) => VideoControlsOverlay(
                    isFullscreen: widget.isFullscreen,
                    onFullscreenChanged: widget.onFullscreenChanged,
                    state: state,
                    title: widget.isBack ? widget.title : null,
                  )
                : NoVideoControls,
          ),
        ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
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