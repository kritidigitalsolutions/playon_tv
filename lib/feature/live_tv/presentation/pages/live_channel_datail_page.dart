import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/core/widgets/media_payler_widget.dart';
import 'package:playon/feature/live_tv/bloc/watch_live/watch_live_bloc.dart';
import 'package:playon/static/app_color.dart';

class LiveChannelDatailPage extends StatefulWidget {
  const LiveChannelDatailPage({super.key, required this.slug});
  final String slug;

  @override
  State<LiveChannelDatailPage> createState() => _LiveChannelDatailPageState();
}

class _LiveChannelDatailPageState extends State<LiveChannelDatailPage> {
  bool isFullscreen = true;

  @override
  void initState() {
    super.initState();
    context.read<WatchLiveBloc>().add(WatchLiveEvent.watchLiveChannel(slug: widget.slug));
  }

  @override
  void dispose() {
    _restoreSystemUi();
    super.dispose();
  }

  void _setFullscreen(bool value) {
    setState(() => isFullscreen = value);
    if (value) {
      _enterFullscreenUi();
    } else {
      _restoreSystemUi();
    }
  }

  Future<void> _enterFullscreenUi() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> _restoreSystemUi() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: SystemUiOverlay.values,
    );
  }

  void _retry() {
    context.read<WatchLiveBloc>().add(WatchLiveEvent.watchLiveChannel(slug:  widget.slug));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchLiveBloc, WatchLiveState>(
      builder: (context, state) {
        // FULLSCREEN: bypass Scaffold's decorative body wrapper and
        // SafeArea entirely — see original comment on why SafeArea
        // must not be in this subtree while immersiveSticky is active.
        if (isFullscreen) {
          return _buildFullscreenBody(state);
        }

        final size = MediaQuery.of(context).size;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: BackgroundWithOneLight(
            child: SafeArea(
              child: Builder(
                builder: (_) {
                  if (state.isLiveWatch == Status.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.isLiveWatch == Status.error) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Failed to load channel',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: _retry,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final streamUrl =
                      state.channelStreamResponse?.stream.streamUrl ?? '';
                  final channel = state.channelStreamResponse?.channel;

                  if (streamUrl.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Stream Found',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: size.height * 0.45,
                        child: MediaPlayerWidget(
                          showFullscreenButton: false,
                          url: streamUrl,
                          title: channel?.name ?? widget.slug,
                          isFullscreen: false,
                          onFullscreenChanged: _setFullscreen,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            if (channel != null) ...[
                              Text(
                                channel.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              if (channel.category.isNotEmpty)
                                Text(
                                  channel.category,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 14,
                                  ),
                                ),
                              if (channel.description.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Text(
                                  channel.description,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ],
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFullscreenBody(WatchLiveState state) {
    if (state.isLiveWatch == Status.loading) {
      return ColoredBox(
        color: AppColors.background,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (state.isLiveWatch == Status.error) {
      return ColoredBox(
        color: AppColors.background,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Failed to load channel',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              TextButton(onPressed: _retry, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    final streamUrl = state.channelStreamResponse?.stream.streamUrl ?? '';
    final channel = state.channelStreamResponse?.channel;

    if (streamUrl.isEmpty) {
      return ColoredBox(
        color: AppColors.background,
        child: const Center(
          child: Text(
            'No Stream Found',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return SizedBox.expand(
      child: MediaPlayerWidget(
        isBack: true,
        url: streamUrl,
        title: channel?.name ?? widget.slug,
        isFullscreen: true,
        onFullscreenChanged: _setFullscreen,
      ),
    );
  }
}