import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/static/app_color.dart';

const _kAccent = AppColors.primary;
const _kAccentSoft = Color(0xFFFF6B5B);
const _kPanelBg = Color(0xFF0F0F14);
const _kPanelWidth = 400.0;

enum LiveSettingsCategory { channelList }

class LiveTVSettingsPanel extends StatefulWidget {
  const LiveTVSettingsPanel({
    super.key,
    required this.category,
    required this.controller,
    required this.onClose,
    this.onChannelSelect,
  });

  final LiveSettingsCategory category;
  final VideoPlayerController controller;
  final VoidCallback onClose;
  final VoidCallback? onChannelSelect;

  @override
  State<LiveTVSettingsPanel> createState() => _LiveTVSettingsPanelState();
}

class _LiveTVSettingsPanelState extends State<LiveTVSettingsPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  )..forward();
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(1, 0),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _title {
    switch (widget.category) {
      case LiveSettingsCategory.channelList:
        return 'Channel List';
    }
  }

  IconData get _titleIcon {
    switch (widget.category) {
      case LiveSettingsCategory.channelList:
        return Icons.list_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: FadeTransition(
            opacity: _fade,
            child: GestureDetector(
              onTap: widget.onClose,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(color: Colors.black.withOpacity(0.45)),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: SlideTransition(
            position: _slide,
            child: Container(
              width: _kPanelWidth,
              height: double.infinity,
              decoration: BoxDecoration(
                color: _kPanelBg.withOpacity(0.94),
                border: Border(
                  left: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 40,
                    spreadRadius: -6,
                  ),
                ],
              ),
              child: SafeArea(
                child: FocusScope(
                  debugLabel: 'live-channel-panel-scope',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(28, 28, 28, 16),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [_kAccentSoft, _kAccent],
                                ),
                              ),
                              child: Icon(
                                _titleIcon,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Text(
                              _title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _kAccent.withOpacity(0.5),
                                Colors.white.withOpacity(0.05),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(child: _buildBody()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    switch (widget.category) {
      case LiveSettingsCategory.channelList:
        return _ChannelList(
          onClose: widget.onClose,
          onChannelSelect: widget.onChannelSelect,
        );
    }
  }
}

/// Channel list that would be populated from your channel data
class _ChannelList extends StatefulWidget {
  const _ChannelList({required this.onClose, this.onChannelSelect});
  final VoidCallback onClose;
  final VoidCallback? onChannelSelect;

  @override
  State<_ChannelList> createState() => _ChannelListState();
}

class _ChannelListState extends State<_ChannelList> {
  // Sample channel data - replace with your actual channel list
  final List<_ChannelItem> _channels = List.generate(
    20,
    (i) => _ChannelItem(
      number: i + 1,
      name: 'Channel ${i + 1}',
      isLive: i % 3 == 0,
    ),
  );

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      itemCount: _channels.length,
      itemBuilder: (context, i) {
        final channel = _channels[i];
        final selected = i == _selectedIndex;
        return _ChannelRow(
          channelNumber: channel.number,
          channelName: channel.name,
          isLive: channel.isLive,
          selected: selected,
          autofocus: i == 0,
          onSelect: () {
            setState(() => _selectedIndex = i);
            // Navigate to selected channel
            widget.onChannelSelect?.call();
            widget.onClose();
          },
        );
      },
    );
  }
}

class _ChannelItem {
  final int number;
  final String name;
  final bool isLive;

  _ChannelItem({
    required this.number,
    required this.name,
    required this.isLive,
  });
}

class _ChannelRow extends StatefulWidget {
  const _ChannelRow({
    required this.channelNumber,
    required this.channelName,
    required this.isLive,
    required this.selected,
    required this.onSelect,
    this.autofocus = false,
  });

  final int channelNumber;
  final String channelName;
  final bool isLive;
  final bool selected;
  final VoidCallback onSelect;
  final bool autofocus;

  @override
  State<_ChannelRow> createState() => _ChannelRowState();
}

class _ChannelRowState extends State<_ChannelRow> {
  final _node = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _node.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (mounted) setState(() => _focused = _node.hasFocus);
  }

  @override
  void dispose() {
    _node.removeListener(_handleFocusChange);
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TvFocusable(
      focusNode: _node,
      autofocus: widget.autofocus,
      onSelect: widget.onSelect,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _focused
              ? _kAccent.withOpacity(0.2)
              : (widget.selected
                    ? Colors.white.withOpacity(0.05)
                    : Colors.transparent),
          borderRadius: BorderRadius.circular(12),
          border: widget.selected
              ? Border(left: BorderSide(color: _kAccent, width: 3))
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isLive ? _kAccent.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                border: Border.all(
                  color: widget.isLive ? _kAccent : Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  '${widget.channelNumber}',
                  style: TextStyle(
                    color: widget.isLive ? _kAccent : Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.channelName,
                    style: TextStyle(
                      color: widget.selected || _focused
                          ? Colors.white
                          : Colors.white70,
                      fontSize: 15,
                      fontWeight: widget.selected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                  if (widget.isLive)
                    Text(
                      'LIVE',
                      style: TextStyle(
                        color: _kAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            if (widget.selected)
              AnimatedScale(
                scale: widget.selected ? 1 : 0,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOutBack,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: _kAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 14, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}