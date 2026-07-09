// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/core/widgets/app_textstyle.dart';

import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_image.dart';
import 'package:playon/static/app_navigation.dart';

class HighlightTornamentPage extends StatelessWidget {
  const HighlightTornamentPage({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BackgroundWithOneLight(
        child: Column(
          children: [
            // Custom AppBar for TV
            _TVAppBar(
              title: 'Tournament Highlights',
              onBack: () => AppNavigation.pop(context),
            ),
            // Body content with TV-optimized grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // 4 columns for TV
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: _getMatches().length,
                  itemBuilder: (context, index) {
                    final match = _getMatches()[index];
                    return _TVMatchCard(
                      match: match,
                      // First card in the grid gets initial remote
                      // focus so the D-pad has somewhere to start.
                      autofocus: index == 0,
                      onTap: () {
                        AppNavigation.push(context, "/highlightMatch/1");
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getMatches() {
    return [
      {
        'id': 1,
        'image': AppImage.background,
        'seriesName': 'Ghaziabad Premier League',
        'team1': 'Raina Superkings',
        'team2': 'Migsun Champions',
        'state': 'UP',
        'logo': AppImage.logo,
        'date': 'Today, 7:30 PM',
        'venue': 'Green Park Stadium',
      },
      {
        'id': 2,
        'image': AppImage.background,
        'seriesName': 'Ghaziabad Premier League',
        'team1': 'Delhi Capitals',
        'team2': 'Mumbai Indians',
        'state': 'DL',
        'logo': AppImage.logo,
        'date': 'Today, 3:30 PM',
        'venue': 'Arun Jaitley Stadium',
      },
      {
        'id': 3,
        'image': AppImage.background,
        'seriesName': 'Ghaziabad Premier League',
        'team1': 'Chennai Super Kings',
        'team2': 'Kolkata Knight Riders',
        'state': 'TN',
        'logo': AppImage.logo,
        'date': 'Tomorrow, 7:30 PM',
        'venue': 'M.A. Chidambaram Stadium',
      },
      {
        'id': 4,
        'image': AppImage.background,
        'seriesName': 'Ghaziabad Premier League',
        'team1': 'Royal Challengers',
        'team2': 'Sunrisers Hyderabad',
        'state': 'KA',
        'logo': AppImage.logo,
        'date': 'Tomorrow, 3:30 PM',
        'venue': 'M. Chinnaswamy Stadium',
      },
      {
        'id': 5,
        'image': AppImage.background,
        'seriesName': 'Ghaziabad Premier League',
        'team1': 'Rajasthan Royals',
        'team2': 'Punjab Kings',
        'state': 'RJ',
        'logo': AppImage.logo,
        'date': 'Day after, 7:30 PM',
        'venue': 'Sawai Mansingh Stadium',
      },
      {
        'id': 6,
        'image': AppImage.background,
        'seriesName': 'Ghaziabad Premier League',
        'team1': 'Lucknow Super Giants',
        'team2': 'Gujarat Titans',
        'state': 'UP',
        'logo': AppImage.logo,
        'date': 'Day after, 3:30 PM',
        'venue': 'Ekana Stadium',
      },
      {
        'id': 7,
        'image': AppImage.background,
        'seriesName': 'Ghaziabad Premier League',
        'team1': 'Raina Superkings',
        'team2': 'Delhi Capitals',
        'state': 'UP',
        'logo': AppImage.logo,
        'date': 'Dec 15, 7:30 PM',
        'venue': 'Green Park Stadium',
      },
      {
        'id': 8,
        'image': AppImage.background,
        'seriesName': 'Ghaziabad Premier League',
        'team1': 'Mumbai Indians',
        'team2': 'Chennai Super Kings',
        'state': 'MH',
        'logo': AppImage.logo,
        'date': 'Dec 16, 7:30 PM',
        'venue': 'Wankhede Stadium',
      },
    ];
  }
}

// TV Optimized AppBar
class _TVAppBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _TVAppBar({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Back button with TV focus
          _TVFocusableIcon(
            icon: Icons.arrow_back_rounded,
            onSelect: onBack,
            size: 28,
          ),
          const SizedBox(width: 16),
          // Title
          Expanded(
            child: Text(
              title,
              style: text24(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Filter/Search buttons for TV
          _TVFocusableIcon(
            icon: Icons.search_rounded,
            onSelect: () {},
            size: 24,
          ),
          const SizedBox(width: 12),
          _TVFocusableIcon(
            icon: Icons.filter_list_rounded,
            onSelect: () {},
            size: 24,
          ),
        ],
      ),
    );
  }
}

// TV Focusable Icon Button — now backed by TvFocusable so it
// participates in D-pad directional traversal (arrow keys previously
// did nothing here; only Select/Enter worked before).
class _TVFocusableIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback onSelect;
  final double size;
  final bool autofocus;

  const _TVFocusableIcon({
    required this.icon,
    required this.onSelect,
    this.size = 24,
    this.autofocus = false,
  });

  @override
  State<_TVFocusableIcon> createState() => _TVFocusableIconState();
}

class _TVFocusableIconState extends State<_TVFocusableIcon> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TvFocusable(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      borderRadius: BorderRadius.circular(100),
      onSelect: widget.onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isFocused
              ? Colors.white.withOpacity(0.15)
              : Colors.transparent,
        ),
        child: Icon(
          widget.icon,
          color: _isFocused ? Colors.white : Colors.white70,
          size: widget.size,
        ),
      ),
    );
  }
}

// TV Match Card — now backed by TvFocusable so arrow keys move focus
// between cards in the grid, not just Select/Enter to activate one.
class _TVMatchCard extends StatefulWidget {
  final Map<String, dynamic> match;
  final VoidCallback? onTap;
  final bool autofocus;

  const _TVMatchCard({required this.match, this.onTap, this.autofocus = false});

  @override
  State<_TVMatchCard> createState() => _TVMatchCardState();
}

class _TVMatchCardState extends State<_TVMatchCard> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final match = widget.match;
    final team1 = match['team1'] ?? '';
    final team2 = match['team2'] ?? '';
    final state = match['state'] ?? '';
    final venue = match['venue'] ?? '';
    final date = match['date'] ?? '';

    return TvFocusable(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      borderRadius: BorderRadius.circular(16),
      // This card draws its own border/glow highlight below, so skip
      // TvFocusable's default flat background tint.
      focusBackgroundColor: Colors.transparent,
      onSelect: widget.onTap,
      child: AnimatedScale(
        scale: _isFocused ? 1.06 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: _isFocused
                ? AppColors.background.withOpacity(0.8)
                : AppColors.background.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isFocused
                  ? AppColors.primary
                  : AppColors.primary.withOpacity(0.2),
              width: _isFocused ? 3 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isFocused
                    ? AppColors.primary.withOpacity(0.4)
                    : Colors.black.withOpacity(0.3),
                blurRadius: _isFocused ? 25 : 10,
                spreadRadius: _isFocused ? 2 : 0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section
                Expanded(
                  flex: 6,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        match['image'] ?? AppImage.background,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[850],
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.sports_cricket,
                              size: 40,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                      // Gradient overlay
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.5, 1.0],
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // State badge
                      if (state.isNotEmpty)
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              state,
                              style: text11(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      // Venue and date at bottom of image
                      Positioned(
                        bottom: 8,
                        left: 10,
                        right: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              venue,
                              style: text11(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(date, style: text10()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Content footer
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Series name with logo
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                match['logo'] ?? AppImage.logo,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.sports_cricket,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              match['seriesName'] ?? '',
                              style: text12(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Teams VS
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              team1,
                              textAlign: TextAlign.right,
                              style: text12(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('VS', style: text10()),
                          ),
                          Expanded(
                            child: Text(
                              team2,
                              style: text12(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
