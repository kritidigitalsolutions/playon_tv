// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playon/core/models/response/high_light_model.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/feature/highlights/bloc/highlight/highlight_bloc.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_navigation.dart';

class HighlightTornamentPage extends StatefulWidget {
  const HighlightTornamentPage({
    super.key,
    required this.id,
    required this.title,
  });

  final String id;
  final String title; // series/tournament title from the previous page

  @override
  State<HighlightTornamentPage> createState() => _HighlightTornamentPageState();
}

class _HighlightTornamentPageState extends State<HighlightTornamentPage> {
  @override
  void initState() {
    super.initState();
    context.read<HighlightBloc>().add(const HighlightEvent.fetchHighLight());
  }

  // Only keep highlights whose series title contains the tournament
  // title passed in from the previous page (case-insensitive).
  List<HighlightModel> _filteredHighlights(List<HighlightModel> highlights) {
    final query = widget.title.trim().toLowerCase();
    if (query.isEmpty) return highlights;
    return highlights
        .where((h) => h.series.title.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BackgroundWithOneLight(
        child: Column(
          children: [
            _TVAppBar(
              title: widget.title,
              onBack: () => AppNavigation.pop(context),
            ),
            Expanded(
              child: BlocBuilder<HighlightBloc, HighlightState>(
                builder: (context, state) {
                  if (state.allHighLightStatus == Status.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.allHighLightStatus == Status.error) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Something went wrong while loading highlights.",
                            style: text16(),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              context.read<HighlightBloc>().add(
                                const HighlightEvent.fetchHighLight(),
                              );
                            },
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    );
                  }

                  final filtered = _filteredHighlights(state.highlights);

                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        "No highlights found for ${widget.title}.",
                        style: text16(),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 1.2,
                          ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final highlight = filtered[index];
                        return _TVMatchCard(
                          highlight: highlight,
                          autofocus: index == 0,
                          onTap: () {
                            AppNavigation.push(
                              context,
                              "/highlightMatch/${highlight.id}",
                            );
                          },
                        );
                      },
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
} // TV Optimized AppBar

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
          _TVFocusableIcon(
            icon: Icons.arrow_back_rounded,
            onSelect: onBack,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: text24(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
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

// TV Focusable Icon Button
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

class _TVMatchCard extends StatefulWidget {
  final HighlightModel highlight;
  final VoidCallback? onTap;
  final bool autofocus;

  const _TVMatchCard({
    required this.highlight,
    this.onTap,
    this.autofocus = false,
  });

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

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final highlight = widget.highlight;
    final team1 = highlight.teamA.shortName.isNotEmpty
        ? highlight.teamA.shortName
        : highlight.teamA.name;
    final team2 = highlight.teamB.shortName.isNotEmpty
        ? highlight.teamB.shortName
        : highlight.teamB.name;
    final category = highlight.category;
    final seriesName = highlight.series.title;

    return TvFocusable(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      borderRadius: BorderRadius.circular(16),
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
                Expanded(
                  flex: 6,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        highlight.thumbnail,
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
                      if (category.isNotEmpty)
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
                              category.toUpperCase(),
                              style: text11(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 8,
                        left: 10,
                        right: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              highlight.title,
                              style: text11(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              _formatDuration(highlight.duration),
                              style: text10(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                              child: Image.network(
                                highlight.series.tournamentLogo,
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
                              seriesName,
                              style: text12(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
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
