import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/core/widgets/live_tv_media_player_widget.dart';
import 'package:playon/feature/live_tv/bloc/channels/channels_bloc.dart';
import 'package:playon/feature/live_tv/bloc/watch_live/watch_live_bloc.dart';
import 'package:playon/static/app_color.dart';

class LiveChannelDetailPage extends StatefulWidget {
  const LiveChannelDetailPage({super.key, required this.slug});
  final String slug;

  @override
  State<LiveChannelDetailPage> createState() => _LiveChannelDetailPageState();
}

class _LiveChannelDetailPageState extends State<LiveChannelDetailPage> {
  String currentSlug = '';

  // Channel list for navigation
  List<ChannelInfo> _channelList = [];
  int _currentIndex = 0;
  bool _isLoadingChannels = true;

  @override
  void initState() {
    super.initState();
    currentSlug = widget.slug;
    _loadAllChannels();
    _enterFullscreenUi();
  }

  void _loadAllChannels() {
    // Get all channels from the ChannelsBloc
    final channelsState = context.read<ChannelsBloc>().state;
    if (channelsState.channels.isNotEmpty) {
      _channelList = channelsState.channels.map((channel) => ChannelInfo(
        slug: channel.slug,
        name: channel.name,
        channelNumber: channel.channelNumber,
        isLive: true,
      )).toList();
      
      // Find the current channel index
      _currentIndex = _channelList.indexWhere((c) => c.slug == currentSlug);
      if (_currentIndex == -1) _currentIndex = 0;
      
      _isLoadingChannels = false;
      _loadChannelData();
    } else {
      // If channels not loaded yet, wait for them
      _isLoadingChannels = true;
      // Trigger channel load if needed
      context.read<ChannelsBloc>().add(const ChannelsEvent.allChannels());
      _loadChannelData();
    }
  }

  void _loadChannelData() {
    context.read<WatchLiveBloc>().add(
      WatchLiveEvent.watchLiveChannel(slug: currentSlug),
    );
  }

  @override
  void dispose() {
    _restoreSystemUi();
    super.dispose();
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
    context.read<WatchLiveBloc>().add(
      WatchLiveEvent.watchLiveChannel(slug: currentSlug),
    );
  }

  // FIXED: Channel Up should go to NEXT channel (forward)
  void _onChannelUp() {
    if (_channelList.isEmpty) return;
    // Go to next channel, wrap to first if at last
    final newIndex = (_currentIndex + 1) % _channelList.length;
    _navigateToChannel(newIndex);
  }

  // FIXED: Channel Down should go to PREVIOUS channel (backward)
  void _onChannelDown() {
    if (_channelList.isEmpty) return;
    // Go to previous channel, wrap to last if at first
    final newIndex = _currentIndex == 0 ? _channelList.length - 1 : _currentIndex - 1;
    _navigateToChannel(newIndex);
  }

  void _onChannelSelect(int index) {
    if (index < 0 || index >= _channelList.length) return;
    _navigateToChannel(index);
  }

  void _navigateToChannel(int index) {
    final channel = _channelList[index];
    setState(() {
      _currentIndex = index;
      currentSlug = channel.slug;
    });
    context.read<WatchLiveBloc>().add(
      WatchLiveEvent.watchLiveChannel(slug: channel.slug),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listen for channel list updates
        BlocListener<ChannelsBloc, ChannelsState>(
          listener: (context, state) {
            if (state.channels.isNotEmpty && _channelList.isEmpty) {
              _channelList = state.channels.map((channel) => ChannelInfo(
                slug: channel.slug,
                name: channel.name,
                channelNumber: channel.channelNumber,
                isLive: true,
              )).toList();
              
              _currentIndex = _channelList.indexWhere((c) => c.slug == currentSlug);
              if (_currentIndex == -1) _currentIndex = 0;
              _isLoadingChannels = false;
              setState(() {});
            }
          },
        ),
      ],
      child: BlocBuilder<WatchLiveBloc, WatchLiveState>(
        builder: (context, state) {
          // Show loading if channels are still loading
          if (_isLoadingChannels || _channelList.isEmpty) {
            return const ColoredBox(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Loading channels...',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state.isLiveWatch == Status.loading) {
            return const ColoredBox(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            );
          }

          if (state.isLiveWatch == Status.error) {
            return ColoredBox(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.white.withOpacity(0.7),
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _retry,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.15),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.white.withOpacity(0.2)),
                        ),
                      ),
                      child: const Text(
                        'Try Again',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final streamUrl = state.channelStreamResponse?.stream.streamUrl ?? '';
          final channel = state.channelStreamResponse?.channel;

          if (streamUrl.isEmpty) {
            return const ColoredBox(
              color: Colors.black,
              child: Center(
                child: Text(
                  'No Stream Found',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }

          // Update current channel info from response
          if (channel != null) {
            final index = _channelList.indexWhere((c) => c.slug == channel.slug);
            if (index != -1 && _currentIndex != index) {
              _currentIndex = index;
            }
          }

          return SizedBox.expand(
            child: LiveTVMediaPlayerWidget(
              url: streamUrl,
              channelNumber: _channelList.isNotEmpty 
                  ? _channelList[_currentIndex].channelNumber 
                  : 1,
              totalChannels: _channelList.length,
              onChannelUp: _onChannelUp,
              onChannelDown: _onChannelDown,
              onChannelSelect: () {
                _showChannelList();
              },
              title: channel?.name ?? currentSlug,
              isBack: true,
            ),
          );
        },
      ),
    );
  }

  void _showChannelList() {
    if (_channelList.isEmpty) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'All Channels',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _channelList.length,
                itemBuilder: (context, index) {
                  final channel = _channelList[index];
                  final isSelected = index == _currentIndex;
                  return ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.2)
                            : Colors.white.withOpacity(0.05),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${channel.channelNumber}',
                          style: TextStyle(
                            color: isSelected ? AppColors.primary : Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      channel.name,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    trailing: isSelected
                        ? Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            ),
                          )
                        : null,
                    onTap: () {
                      Navigator.pop(context);
                      _onChannelSelect(index);
                    },
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

/// Helper class for channel information
class ChannelInfo {
  final String slug;
  final String name;
  final int channelNumber;
  final bool isLive;

  ChannelInfo({
    required this.slug,
    required this.name,
    required this.channelNumber,
    this.isLive = false,
  });
}