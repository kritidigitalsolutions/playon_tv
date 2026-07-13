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

class Series extends StatefulWidget {
  const Series({super.key});

  @override
  State<Series> createState() => _SeriesState();
}

class _SeriesState extends State<Series> {
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
    // Kick off the initial fetch.
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
    final nearBottom =
        _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200;
    if (nearBottom) {
      context.read<SeriesBloc>().add(const SeriesEvent.getMoreSeriesList());
    }
  }

  // Client-side filter by sport tab, same behaviour as before —
  // the API list endpoint doesn't take a sport filter param here,
  // so we filter over whatever page(s) have been loaded so far.
  List<SeriesModel> _filter(List<SeriesModel> series) {
    if (selectedFilter == 'HOME') return series;
    return series
        .where((item) => (item.sport).toUpperCase() == selectedFilter)
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
              child: Text("All Series", style: text24()),
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
                  // Initial load.
                  if (state.allSeriesStatus == Status.loading &&
                      state.series.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Initial load failed.
                  if (state.allSeriesStatus == Status.error &&
                      state.series.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Something went wrong", style: text16()),
                          const SizedBox(height: 8),
                          TvFocusable(
                            autofocus: true,
                            borderRadius: BorderRadius.circular(8),
                            onSelect: () {
                              context.read<SeriesBloc>().add(
                                const SeriesEvent.getSeriesList(),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Text("Retry", style: text16()),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final filteredSeries = _filter(state.series);

                  if (filteredSeries.isEmpty) {
                    return Center(
                      child: Text("No series found", style: text16()),
                    );
                  }

                  final isLoadingMore =
                      state.moreSeriesStatus == Status.loading;

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<SeriesBloc>().add(
                        const SeriesEvent.getSeriesList(),
                      );
                    },
                    child: FocusTraversalGroup(
                      policy: ReadingOrderTraversalPolicy(),
                      child: GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(4),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4, // Number of cards per row
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1,
                            ),
                        itemCount:
                            filteredSeries.length + (isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= filteredSeries.length) {
                            // Trailing pagination spinner.
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            );
                          }

                          final item = filteredSeries[index];
                          return SeriesCard(
                            series: item,
                            autofocus: index == 0,
                            onTap: () {
                              AppNavigation.push(
                                context,
                                "/seriesDetail/${item.id}",
                              );
                            },
                          );
                        },
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

class SeriesCard extends StatefulWidget {
  final SeriesModel series;
  final VoidCallback? onTap;
  final bool autofocus;

  const SeriesCard({
    super.key,
    required this.series,
    this.onTap,
    this.autofocus = false,
  });

  @override
  State<SeriesCard> createState() => _SeriesCardState();
}

class _SeriesCardState extends State<SeriesCard> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!mounted) return;
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final series = widget.series;

    return TvFocusable(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      onSelect: widget.onTap ?? () {},
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background.withAlpha(60),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _isFocused
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.3),
            width: _isFocused ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isFocused
                  ? AppColors.primary.withOpacity(0.5)
                  : Colors.black.withOpacity(0.3),
              blurRadius: _isFocused ? 22 : 8,
              spreadRadius: _isFocused ? 2 : 0,
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
                          color: Colors.grey[850],
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
                  ],
                ),
              ),
              // Content section — NOT wrapped in Expanded. It only
              // takes the height its text actually needs.
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      series.title,
                      style: text16(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Sport and Country as pill chips
                    Row(
                      children: [
                        if ((series.sport).isNotEmpty)
                          _Chip(text: series.sport.toUpperCase()),
                        if ((series.tourCountry ?? '').isNotEmpty) ...[
                          const SizedBox(width: 8),
                          _Chip(text: series.tourCountry!),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Description
                    Text(
                      series.description,
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

/// Small pill-shaped label used for sport/country tags.
class _Chip extends StatelessWidget {
  final String text;
  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: text12(fontWeight: FontWeight.w600)),
    );
  }
}
