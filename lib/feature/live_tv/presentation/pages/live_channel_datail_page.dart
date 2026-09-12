import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/core/widgets/live_tv_media_player_widget.dart';
import 'package:playon/feature/live_tv/bloc/channels/channels_bloc.dart';
import 'package:playon/feature/live_tv/bloc/watch_live/watch_live_bloc.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_navigation.dart';

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
    final channelsState = context.read<ChannelsBloc>().state;
    if (channelsState.channels.isNotEmpty) {
      _channelList = channelsState.channels
          .map((channel) => ChannelInfo(
                slug: channel.slug,
                name: channel.name,
                channelNumber: channel.channelNumber,
                isLive: true,
              ))
          .toList();

      _currentIndex = _channelList.indexWhere((c) => c.slug == currentSlug);
      if (_currentIndex == -1) _currentIndex = 0;

      _isLoadingChannels = false;
      _loadChannelData();
    } else {
      _isLoadingChannels = true;
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
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _retry() {
    _loadChannelData();
  }

  void _onChannelUp() {
    if (_channelList.isEmpty) return;
    final newIndex = (_currentIndex + 1) % _channelList.length;
    _navigateToChannel(newIndex);
  }

  void _onChannelDown() {
    if (_channelList.isEmpty) return;
    final newIndex =
        _currentIndex == 0 ? _channelList.length - 1 : _currentIndex - 1;
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

  KeyEventResult _handleRootKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.goBack || key == LogicalKeyboardKey.escape) {
      AppNavigation.pop(context);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.channelUp ||
        key == LogicalKeyboardKey.mediaTrackNext) {
      _onChannelUp();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.channelDown ||
        key == LogicalKeyboardKey.mediaTrackPrevious) {
      _onChannelDown();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) AppNavigation.pop(context);
      },
      child: Focus(
        autofocus: true,
        canRequestFocus: false,
        onKeyEvent: _handleRootKeyEvent,
        child: MultiBlocListener(
          listeners: [
            BlocListener<ChannelsBloc, ChannelsState>(
              listener: (context, state) {
                if (state.channels.isNotEmpty && _channelList.isEmpty) {
                  _channelList = state.channels
                      .map((channel) => ChannelInfo(
                            slug: channel.slug,
                            name: channel.name,
                            channelNumber: channel.channelNumber,
                            isLive: true,
                          ))
                      .toList();

                  _currentIndex =
                      _channelList.indexWhere((c) => c.slug == currentSlug);
                  if (_currentIndex == -1) _currentIndex = 0;
                  _isLoadingChannels = false;
                  setState(() {});
                }
              },
            ),
          ],
          child: BlocBuilder<WatchLiveBloc, WatchLiveState>(
            builder: (context, state) {
              final currentInfo = (_channelList.isNotEmpty &&
                      _currentIndex >= 0 &&
                      _currentIndex < _channelList.length)
                  ? _channelList[_currentIndex]
                  : null;

              final channelFromResponse = state.channelStreamResponse?.channel;
              final displayName = (channelFromResponse?.name.isNotEmpty == true)
                  ? channelFromResponse!.name
                  : (currentInfo?.name ?? currentSlug);
              final displayChannelNumber = (channelFromResponse != null &&
                      channelFromResponse.channelNumber > 0)
                  ? channelFromResponse.channelNumber
                  : (currentInfo?.channelNumber ?? 1);

              // 1. Loading state
              if (_isLoadingChannels ||
                  _channelList.isEmpty ||
                  state.isLiveWatch == Status.loading) {
                return _LoadingChannelView(
                  channelName: displayName,
                  channelNumber: displayChannelNumber,
                  onBack: () => AppNavigation.pop(context),
                );
              }

              final isLocked = (state.channelStreamResponse?.locked == true) ||
                  (state.channelStreamResponse?.message
                          .toLowerCase()
                          .contains('subscription') ==
                      true) ||
                  (state.channelStreamResponse?.message
                          .toLowerCase()
                          .contains('locked') ==
                      true);

              final streamUrl =
                  state.channelStreamResponse?.stream.streamUrl ?? '';

              // 2. Locked / Subscription required state
              if (isLocked) {
                final message =
                    (state.channelStreamResponse?.message.isNotEmpty == true)
                        ? state.channelStreamResponse!.message
                        : 'Active subscription required to watch this channel.';
                return _SubscriptionLockedView(
                  channelName: displayName,
                  channelNumber: displayChannelNumber,
                  message: message,
                  onBack: () => AppNavigation.pop(context),
                  onNextChannel: _onChannelUp,
                  onPreviousChannel: _onChannelDown,
                  onBrowseChannels: _showChannelList,
                );
              }

              // 3. Error state or Empty Stream state
              if (state.isLiveWatch == Status.error || streamUrl.isEmpty) {
                final errorMsg =
                    (state.channelStreamResponse?.message.isNotEmpty == true)
                        ? state.channelStreamResponse!.message
                        : 'Unable to load channel stream.';
                return _ChannelErrorView(
                  channelName: displayName,
                  channelNumber: displayChannelNumber,
                  message: errorMsg,
                  onRetry: _retry,
                  onBack: () => AppNavigation.pop(context),
                  onNextChannel: _onChannelUp,
                  onPreviousChannel: _onChannelDown,
                  onBrowseChannels: _showChannelList,
                );
              }

              // 4. Update index if channel slug matches
              if (channelFromResponse != null &&
                  channelFromResponse.slug.isNotEmpty) {
                final index = _channelList
                    .indexWhere((c) => c.slug == channelFromResponse.slug);
                if (index != -1 && _currentIndex != index) {
                  _currentIndex = index;
                }
              }

              // 5. Active Player
              return SizedBox.expand(
                child: LiveTVMediaPlayerWidget(
                  url: streamUrl,
                  channelNumber: displayChannelNumber,
                  totalChannels: _channelList.length,
                  onChannelUp: _onChannelUp,
                  onChannelDown: _onChannelDown,
                  onChannelSelect: _showChannelList,
                  title: displayName,
                  isBack: true,
                ),
              );
            },
          ),
        ),
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
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Color(0xFF14141B),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black87,
              blurRadius: 24,
              spreadRadius: 8,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
              child: Row(
                children: [
                  const Text(
                    'All Channels',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_channelList.length} Channels',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white12, height: 1),
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _channelList.length,
                itemBuilder: (context, index) {
                  final channel = _channelList[index];
                  final isSelected = index == _currentIndex;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TvFocusable(
                      autofocus: isSelected,
                      borderRadius: BorderRadius.circular(10),
                      onSelect: () {
                        Navigator.pop(context);
                        _onChannelSelect(index);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.25)
                              : Colors.white.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.white.withOpacity(0.08),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.white.withOpacity(0.08),
                              ),
                              child: Center(
                                child: Text(
                                  '${channel.channelNumber}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                channel.name,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white70,
                                  fontSize: 16,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'PLAYING',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
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

/// Loading View with Top Bar & Channel Info
class _LoadingChannelView extends StatelessWidget {
  const _LoadingChannelView({
    required this.channelName,
    required this.channelNumber,
    required this.onBack,
  });

  final String channelName;
  final int channelNumber;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: Row(
                children: [
                  TvFocusable(
                    borderRadius: BorderRadius.circular(50),
                    onSelect: onBack,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Text(
                      'CH $channelNumber',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    channelName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 3.5,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Tuning to $channelName...',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Subscription Locked View for Leanback TV
class _SubscriptionLockedView extends StatelessWidget {
  const _SubscriptionLockedView({
    required this.channelName,
    required this.channelNumber,
    required this.message,
    required this.onBack,
    required this.onNextChannel,
    required this.onPreviousChannel,
    required this.onBrowseChannels,
  });

  final String channelName;
  final int channelNumber;
  final String message;
  final VoidCallback onBack;
  final VoidCallback onNextChannel;
  final VoidCallback onPreviousChannel;
  final VoidCallback onBrowseChannels;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      body: Stack(
        children: [
          // Background ambient gradient
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.2),
                  radius: 1.0,
                  colors: [
                    Colors.amber.shade900.withOpacity(0.18),
                    Colors.black.withOpacity(0.95),
                  ],
                ),
              ),
            ),
          ),
          // Top bar with Back button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: Row(
                children: [
                  TvFocusable(
                    borderRadius: BorderRadius.circular(50),
                    onSelect: onBack,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.amber.shade600),
                    ),
                    child: Text(
                      'CH $channelNumber',
                      style: TextStyle(
                        color: Colors.amber.shade300,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    channelName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Centered subscription card
          Center(
            child: Container(
              width: 580,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF171722),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.amber.withOpacity(0.35),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.12),
                    blurRadius: 36,
                    spreadRadius: 2,
                  ),
                  const BoxShadow(
                    color: Colors.black87,
                    blurRadius: 24,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.amber.shade500, Colors.orange.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.4),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.lock_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Subscription Required',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Action buttons
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 10,
                    children: [
                      _ActionButton(
                        autofocus: true,
                        label: 'Next Channel',
                        icon: Icons.skip_next_rounded,
                        isPrimary: true,
                        onSelect: onNextChannel,
                      ),
                      _ActionButton(
                        label: 'Previous',
                        icon: Icons.skip_previous_rounded,
                        isPrimary: false,
                        onSelect: onPreviousChannel,
                      ),
                      _ActionButton(
                        label: 'All Channels',
                        icon: Icons.view_list_rounded,
                        isPrimary: false,
                        onSelect: onBrowseChannels,
                      ),
                      _ActionButton(
                        label: 'Back',
                        icon: Icons.arrow_back_rounded,
                        isPrimary: false,
                        onSelect: onBack,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Generic Error View with Channel Surfing Options
class _ChannelErrorView extends StatelessWidget {
  const _ChannelErrorView({
    required this.channelName,
    required this.channelNumber,
    required this.message,
    required this.onRetry,
    required this.onBack,
    required this.onNextChannel,
    required this.onPreviousChannel,
    required this.onBrowseChannels,
  });

  final String channelName;
  final int channelNumber;
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onBack;
  final VoidCallback onNextChannel;
  final VoidCallback onPreviousChannel;
  final VoidCallback onBrowseChannels;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E14),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: Row(
                children: [
                  TvFocusable(
                    borderRadius: BorderRadius.circular(50),
                    onSelect: onBack,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Text(
                      'CH $channelNumber',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    channelName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              width: 560,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF181824),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.12),
                  width: 1.5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black87,
                    blurRadius: 24,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withOpacity(0.15),
                      border: Border.all(color: Colors.red.withOpacity(0.4)),
                    ),
                    child: const Icon(
                      Icons.error_outline_rounded,
                      color: Color(0xFFFF5252),
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Stream Unavailable',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 10,
                    children: [
                      _ActionButton(
                        autofocus: true,
                        label: 'Try Again',
                        icon: Icons.refresh_rounded,
                        isPrimary: true,
                        onSelect: onRetry,
                      ),
                      _ActionButton(
                        label: 'Next Channel',
                        icon: Icons.skip_next_rounded,
                        isPrimary: false,
                        onSelect: onNextChannel,
                      ),
                      _ActionButton(
                        label: 'All Channels',
                        icon: Icons.view_list_rounded,
                        isPrimary: false,
                        onSelect: onBrowseChannels,
                      ),
                      _ActionButton(
                        label: 'Back',
                        icon: Icons.arrow_back_rounded,
                        isPrimary: false,
                        onSelect: onBack,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable TV-focusable action button for detail screens
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.onSelect,
    this.autofocus = false,
  });

  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onSelect;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TvFocusable(
      autofocus: autofocus,
      borderRadius: BorderRadius.circular(10),
      onSelect: onSelect,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: isPrimary
              ? AppColors.primary
              : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isPrimary ? Colors.white : Colors.white24,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}