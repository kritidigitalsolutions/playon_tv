import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playon/core/widgets/media_payler_widget.dart';
import 'package:playon/static/app_color.dart';

class LiveChannelDatailPage extends StatefulWidget {
  const LiveChannelDatailPage({super.key, required this.id});
  final int id;

  @override
  State<LiveChannelDatailPage> createState() => _LiveChannelDatailPageState();
}

class _LiveChannelDatailPageState extends State<LiveChannelDatailPage> {
  String? _streamUrl;
  bool _loadingChannel = true;
  String? _channelError;
  bool isFullscreen = true;

  @override
  void initState() {
    super.initState();
    _fetchChannelUrl();
  }

  @override
  void dispose() {
    _restoreSystemUi();
    super.dispose();
  }

  Future<void> _fetchChannelUrl() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _streamUrl = 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8';
        _loadingChannel = false;
      });
    } catch (e) {
      setState(() {
        _channelError = e.toString();
        _loadingChannel = false;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    // FULLSCREEN: bypass Scaffold's decorative body wrapper and SafeArea
    // entirely. SafeArea reserves insets for status/nav bars that no
    // longer exist once immersiveSticky hides them, and doing so during
    // the async gap right after rotation was pushing everything toward
    // the top. In fullscreen we want a raw surface exactly the size of
    // the screen — nothing else in the tree gets to add padding.
    if (isFullscreen) {
      return _buildFullscreenBody();
    }

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BackgroundWithOneLight(
        child: SafeArea(
          child: Builder(
            builder: (_) {
              if (_loadingChannel) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_channelError != null) {
                return Center(
                  child: Text(
                    'Failed to load channel\n$_channelError',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              if (_streamUrl == null) {
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
                      url: _streamUrl!,
                      title: 'Channel ${widget.id}',
                      isFullscreen: false,
                      onFullscreenChanged: _setFullscreen,
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: const [
                        // Channel details
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
  }

  Widget _buildFullscreenBody() {
    if (_loadingChannel || _channelError != null || _streamUrl == null) {
      // These states shouldn't normally be reachable while fullscreen
      // (you can't enter fullscreen before a stream exists), but guard
      // anyway rather than showing a blank black screen.
      return ColoredBox(
        color: AppColors.background,
        child: Center(
          child: _channelError != null
              ? Text(
                  'Failed to load channel\n$_channelError',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                )
              : const CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return SizedBox.expand(
      child: MediaPlayerWidget(
        isBack: true,
        url: _streamUrl!,
        title: 'Channel ${widget.id}',
        isFullscreen: true,
        onFullscreenChanged: _setFullscreen,
      ),
    );
  }
}
