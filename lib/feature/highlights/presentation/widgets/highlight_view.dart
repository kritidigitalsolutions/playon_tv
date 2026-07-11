import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playon/core/models/response/series_model.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/core/widgets/app_tab_bar.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/feature/series/bloc/series/series_bloc.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_navigation.dart';

class HighlightsView extends StatefulWidget {
  const HighlightsView();

  @override
  State<HighlightsView> createState() => HighlightsViewState();
}

class HighlightsViewState extends State<HighlightsView> {
  int selectedIndex = 0;
  String selectedFilter = 'HOME';

  final ScrollController _scrollController = ScrollController();

  final List<String> tabs = const [
    "HOME",
    "CRICKET",
    "FOOTBALL",
    "HOCKEY",
    "KHOKHO",
    "KABADDI",
  ];

  @override
  void initState() {
    super.initState();
    context.read<SeriesBloc>().add(const SeriesEvent.getSeriesList());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.position.pixels >= threshold) {
      context.read<SeriesBloc>().add(const SeriesEvent.getMoreSeriesList());
    }
  }

  // Filters by the series' sport field (e.g. "cricket", "hockey"),
  List<SeriesModel> _filteredSeries(List<SeriesModel> series) {
    if (selectedFilter == 'HOME') return series;
    return series
        .where(
          (item) => item.sport.toUpperCase() == selectedFilter.toUpperCase(),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BackgroundWithOneLight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("All Highlights", style: text24()),
            ),
            Center(
              child: AppTabBar(
                tabs: tabs,
                selectedIndex: selectedIndex,
                onChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                    selectedFilter = tabs[index];
                  });
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<SeriesBloc, SeriesState>(
                builder: (context, state) {
                  if (state.allSeriesStatus == Status.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.allSeriesStatus == Status.error) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Something went wrong while loading series.",
                            style: text16(),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              context.read<SeriesBloc>().add(
                                const SeriesEvent.getSeriesList(),
                              );
                            },
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    );
                  }

                  final filtered = _filteredSeries(state.series);

                  if (filtered.isEmpty) {
                    return Center(
                      child: Text("No series found.", style: text16()),
                    );
                  }

                  return GridView.builder(
                    // Re-key the grid whenever the filter changes so old
                    // FocusNodes (which no longer correspond to visible
                    // cards) get torn down instead of stealing focus.
                    key: ValueKey(selectedFilter),
                    controller: _scrollController,
                    padding: const EdgeInsets.all(4),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                    itemCount:
                        filtered.length +
                        (state.moreSeriesStatus == Status.loading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= filtered.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final series = filtered[index];
                      return SeriesCards(
                        // Only the very first card in the grid grabs
                        // initial remote focus.
                        autofocus: index == 0,
                        series: series,
                        onTap: () {
                          // when navigating:
                          AppNavigation.push(
                            context,
                            "/allHighlightsTornament/${series.id}?title=${series.title}",
                          );
                        },
                      );
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

class SeriesCards extends StatefulWidget {
  final SeriesModel series;
  final VoidCallback? onTap;
  final bool autofocus;

  const SeriesCards({
    super.key,
    required this.series,
    this.onTap,
    this.autofocus = false,
  });

  @override
  State<SeriesCards> createState() => _SeriesCardsState();
}

class _SeriesCardsState extends State<SeriesCards> {
  // Kept locally (rather than inside TvFocusable) purely so this card
  // can drive its own border/glow highlight, which TvFocusable's
  // default background-tint highlight doesn't cover. TvFocusable still
  // owns all key handling (Select + D-pad traversal) via this node.
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
      borderRadius: BorderRadius.circular(14),
      // Let this widget's own border/glow be the highlight; skip
      // TvFocusable's flat background tint so it doesn't double up.
      focusBackgroundColor: Colors.transparent,
      onSelect: widget.onTap,
      child: _SeriesCardVisual(series: widget.series, isFocused: _isFocused),
    );
  }
}

/// Pure visual presentation for a series card. Split out from
/// [SeriesCards] so [TvFocusable] owns all key handling while this
/// stays a simple build driven by the [isFocused] flag passed in.
class _SeriesCardVisual extends StatelessWidget {
  const _SeriesCardVisual({required this.series, required this.isFocused});

  final SeriesModel series;
  final bool isFocused;

  @override
  Widget build(BuildContext context) {
    // Sport badge now reads from series.sport (e.g. "cricket",
    // "hockey") — this is the actual sport.
    final hasSport = series.sport.isNotEmpty;
    final hasTitle = series.title.isNotEmpty;

    return AnimatedScale(
      scale: isFocused ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: AppColors.background.withAlpha(60),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isFocused
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.3),
            width: isFocused ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isFocused
                  ? AppColors.primary.withOpacity(0.5)
                  : Colors.black.withOpacity(0.3),
              blurRadius: isFocused ? 22 : 8,
              spreadRadius: isFocused ? 2 : 0,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image - flexes to fill whatever space is left over
              // after the content section below takes what it needs.
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      series.banner,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: Colors.grey[900],
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[850],
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 36,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                    // subtle bottom scrim so the image edge blends
                    // into the content section below
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 40,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.35),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Sport/series badge overlaid on the image's
                    // top-left corner instead of below.
                    if (hasSport || hasTitle)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Row(
                          children: [
                            if (hasSport)
                              _Chip(text: series.sport.toUpperCase()),
                            if (hasSport && hasTitle) const SizedBox(width: 6),
                            if (hasTitle) _Chip(text: series.title),
                          ],
                        ),
                      ),
                    // Status badge, top-right, when applicable.
                    if (series.status.isNotEmpty)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: _Chip(text: series.status.toUpperCase()),
                      ),
                  ],
                ),
              ),
              // Content section — only title + description now.
              // Sized to its own content, so it can never overflow;
              // the image above absorbs any extra or missing space.
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      series.title,
                      style: text16(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      series.sport,
                      style: text12(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small pill-shaped label used for sport/state/live tags. Slightly
/// darker background here since it now sits directly on top of the
/// image rather than on a dark content background.
class _Chip extends StatelessWidget {
  final String text;
  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: text12(fontWeight: FontWeight.w600)),
    );
  }
}
