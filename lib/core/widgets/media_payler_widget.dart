import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:playon/core/widgets/video_control_overlay.dart';

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
  late final Player _player;
  late final VideoController _controller;
  bool _isLoading = true;
  String? _errorMessage;
  int _retryCount = 0;
  final int _maxRetries = 3;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    try {
      // Create player with default configuration
      _player = Player();
      _controller = VideoController(_player);
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

      // Prepare media with proper headers for TV
      final media = Media(
        widget.url,
        httpHeaders: {
          'User-Agent': 'PlayOnTV/1.0',
          'Accept-Encoding': 'identity',
        },
      );

      await _player.open(media, play: widget.autoPlay);

      // Set playlist mode
      await _player.setPlaylistMode(
        widget.looping ? PlaylistMode.single : PlaylistMode.none,
      );

      // Listen for errors with better handling
      _player.stream.error.listen((err) {
        // Check if it's a known TV error
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

        // Auto-retry on error for TV
        if (_retryCount < _maxRetries) {
          _retryCount++;
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) _initStream();
          });
        }
      });

      // Listen for buffering state
      _player.stream.buffering.listen((buffering) {
        if (mounted) {
          setState(() => _isLoading = buffering);
        }
      });

      // Listen for completed state
      _player.stream.completed.listen((_) {
        if (widget.looping) {
          _player.seek(Duration.zero);
          _player.play();
        }
      });

      // Listen for playback state changes
      _player.stream.playing.listen((isPlaying) {
        if (isPlaying && mounted) {
          setState(() => _isLoading = false);
        }
      });

      // Check if stream is playable with timeout
      try {
        final duration = await _player.stream.duration.first;
        if (duration == Duration.zero) {
          // Stream might be live or HLS
          debugPrint('Live stream detected');
        }
      } catch (_) {
        // Some streams don't provide duration immediately
        debugPrint('Stream duration not available');
      }

      if (mounted) {
        setState(() => _isLoading = false);
      }
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
  void didUpdateWidget(covariant MediaPlayerWidget oldWidget) {
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
