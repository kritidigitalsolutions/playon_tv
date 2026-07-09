import 'package:flutter/material.dart';
import 'package:playon/core/widgets/app_button.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/core/widgets/media_payler_widget.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_navigation.dart';

class PodcastPage extends StatefulWidget {
  const PodcastPage({super.key, required this.id});
  final int id;

  @override
  State<PodcastPage> createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage> {
  String? _streamUrl;
  bool _loadingChannel = true;
  String? _channelError;
  @override
  void initState() {
    super.initState();
    _fetchChannelUrl();
  }

  Future<void> _fetchChannelUrl() async {
    try {
      // Example: final data = await ChannelRepository().getById(widget.id);
      // setState(() => _streamUrl = data.streamUrl);
      await Future.delayed(const Duration(milliseconds: 300)); // simulate fetch
      setState(() {
        // _streamUrl = 'https://your-stream-source.com/channel_${widget.id}.m3u8';
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

  bool isFullscreen = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BackgroundWithOneLight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      AppNavigation.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: AppColors.white),
                  ),
                  SizedBox(width: 10),
                  Text("Podcast", style: text20()),
                ],
              ),
            ),
            Expanded(
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

                  if (isFullscreen) {
                    return SizedBox.expand(
                      child: MediaPlayerWidget(
                        isBack: false,
                        url: _streamUrl!,
                        isFullscreen: false,
                        onFullscreenChanged: (value) {
                          setState(() => isFullscreen = value);
                        },
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: size.height * 0.45, // 45% of screen height

                        child: MediaPlayerWidget(
                          url: _streamUrl!,
                          title: 'Channel ${widget.id}',
                          isFullscreen: false,
                          onFullscreenChanged: (value) {
                            setState(() => isFullscreen = value);
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Test Podcast", style: text30()),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: AppButton(
                                    radius: 5,
                                    title: 'Football',
                                    onTap: () {},
                                  ),
                                ),
                                SizedBox(width: 20),
                                Text(
                                  "00:00",
                                  style: text15(color: AppColors.textPrimary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Description", style: text20()),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("testing/..", style: text16()),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
