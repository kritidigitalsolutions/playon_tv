import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/core/widgets/app_text_field.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/feature/highlights/bloc/highlight/highlight_bloc.dart';
import 'package:playon/feature/home/bloc/star_player/star_payer_cubit.dart';
import 'package:playon/feature/home/presentation/widgets/highlight_card.dart';
import 'package:playon/feature/home/presentation/widgets/reel_highlight_card.dart';
import 'package:playon/core/models/response/star_player_model.dart';
import 'package:playon/feature/series/bloc/series/series_bloc.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_image.dart';
import 'package:playon/static/app_navigation.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  final _searchFieldFocus = FocusNode();
  final _searchBarFocus = FocusNode();
  Timer? _debounce;
  String _query = '';

  @override
  void initState() {
    super.initState();

    // Reuse whatever Home has already loaded. Only dispatch a fetch if a
    // section genuinely hasn't loaded yet, so re-opening Search doesn't
    // refire network calls that SportsView already triggered.
    final seriesState = context.read<SeriesBloc>().state;
    if (seriesState.series.isEmpty &&
        seriesState.allSeriesStatus != Status.loading) {
      context.read<SeriesBloc>().add(const SeriesEvent.getSeriesList());
    }

    final highlightState = context.read<HighlightBloc>().state;
    if (highlightState.highlights.isEmpty &&
        highlightState.allHighLightStatus != Status.loading) {
      context.read<HighlightBloc>().add(const HighlightEvent.fetchHighLight());
    }

    final starState = context.read<StarPayerCubit>().state;
    if ((starState.starPlayers?.highlights ?? []).isEmpty &&
        starState.allPlayerStatus != Status.loading) {
      context.read<StarPayerCubit>().allStarPlayer();
    }

    // Jio Hotstar-style: land straight in the search field so typing
    // works immediately, without an extra D-pad press.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFieldFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFieldFocus.dispose();
    _searchBarFocus.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (!mounted) return;
      setState(() => _query = value.trim());
    });
  }

  void _clear() {
    _searchController.clear();
    _debounce?.cancel();
    setState(() => _query = '');
    _searchFieldFocus.requestFocus();
  }

  bool _matches(String haystack, String query) =>
      haystack.toLowerCase().contains(query.toLowerCase());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BackgroundWithOneLight(
          // One shared traversal group for the whole page, so D-pad
          // moves cleanly: back button -> search field -> clear (if
          // shown) -> Series row -> Matches row -> Star Players row.
          child: FocusTraversalGroup(
            policy: ReadingOrderTraversalPolicy(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                const SizedBox(height: 8),
                Expanded(child: _buildResults()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          TvFocusable(
            autofocus: true,
            borderRadius: BorderRadius.circular(50),
            onSelect: () => AppNavigation.pop(context),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.arrow_back, color: Colors.white, size: 26),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            // Two-stage focus, same pattern as HomePage's search bar:
            // the outer TvFocusable node is what the D-pad actually
            // lands on; selecting it hands typing focus to the field.
            child: TvFocusable(
              focusNode: _searchBarFocus,
              borderRadius: BorderRadius.circular(30),
              onSelect: () => _searchFieldFocus.requestFocus(),
              child: AppTextField(
                controller: _searchController,
                focusNode: _searchFieldFocus,
                hintText: "Search series, matches, players",
                onChanged: _onQueryChanged,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 14, right: 10),
                  child: Icon(
                    Icons.search,
                    size: 22,
                    color: AppColors.textSecondary,
                  ),
                ),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: TvFocusable(
                          borderRadius: BorderRadius.circular(50),
                          onSelect: _clear,
                          child: const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.close,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_query.isEmpty) {
      return const _EmptyState(
        icon: Icons.search,
        message: "Search for series, live matches, and star players",
      );
    }

    final seriesState = context.watch<SeriesBloc>().state;
    final highlightState = context.watch<HighlightBloc>().state;
    final starState = context.watch<StarPayerCubit>().state;

    final isAnyLoading =
        (seriesState.series.isEmpty &&
            seriesState.allSeriesStatus == Status.loading) ||
        (highlightState.highlights.isEmpty &&
            highlightState.allHighLightStatus == Status.loading) ||
        ((starState.starPlayers?.highlights ?? []).isEmpty &&
            starState.allPlayerStatus == Status.loading);

    final matchedSeries = seriesState.series
        .where((s) => _matches(s.title, _query) || _matches(s.sport, _query))
        .toList();

    final matchedHighlights = highlightState.highlights.where((h) {
      return _matches(h.series.title, _query) ||
          _matches(h.teamA.name, _query) ||
          _matches(h.teamB.name, _query) ||
          (h.teamA.shortName.isNotEmpty &&
              _matches(h.teamA.shortName, _query)) ||
          (h.teamB.shortName.isNotEmpty && _matches(h.teamB.shortName, _query));
    }).toList();

    // NOTE: StarPlayerModel's fields beyond `.id` and `.sport` weren't
    // visible to me from the code shown, so this only matches on sport
    // for now (e.g. searching "cricket" surfaces cricket star players).
    // If you want name-based matching too, point me at
    // star_player_model.dart and I'll wire it in properly.
    final allStarHighlights = starState.starPlayers?.highlights ?? [];
    final matchedStarPlayers = allStarHighlights
        .where((h) => _matches(h.sport?.name ?? '', _query))
        .toList();

    final hasAnyResults =
        matchedSeries.isNotEmpty ||
        matchedHighlights.isNotEmpty ||
        matchedStarPlayers.isNotEmpty;

    if (!hasAnyResults) {
      if (isAnyLoading) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      }
      return _EmptyState(
        icon: Icons.search_off,
        message: 'No results found for "$_query"',
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (matchedSeries.isNotEmpty)
            _ResultSection(
              title: "Series",
              height: 220,
              itemCount: matchedSeries.length,
              itemBuilder: (context, index) {
                final series = matchedSeries[index];
                return TvFocusable(
                  onSelect: () {
                    AppNavigation.push(context, "/seriesDetail/${series.id}");
                  },
                  child: _SeriesResultCard(
                    title: series.title,
                    image: series.banner,
                    logo: series.tournamentLogo,
                  ),
                );
              },
            ),
          if (matchedHighlights.isNotEmpty)
            _ResultSection(
              title: "Matches",
              height: 250,
              itemCount: matchedHighlights.length,
              itemBuilder: (context, index) {
                final item = matchedHighlights[index];
                return TvFocusable(
                  onSelect: () {
                    AppNavigation.push(context, "/highlightMatch/${item.id}");
                  },
                  child: HighlightCard(
                    image: item.thumbnail,
                    logo: item.series.tournamentLogo.isNotEmpty
                        ? item.series.tournamentLogo
                        : AppImage.logo,
                    tournamentName: item.series.title,
                    teamA: item.teamA.shortName.isNotEmpty
                        ? item.teamA.shortName
                        : item.teamA.name,
                    teamB: item.teamB.shortName.isNotEmpty
                        ? item.teamB.shortName
                        : item.teamB.name,
                  ),
                );
              },
            ),
          if (matchedStarPlayers.isNotEmpty)
            _ResultSection(
              title: "Star Players",
              height: 260,
              itemCount: matchedStarPlayers.length,
              itemBuilder: (context, index) {
                final highlight = matchedStarPlayers[index];
                return TvFocusable(
                  onSelect: () {
                    AppNavigation.push(
                      context,
                      "starPlayerVideo/${highlight.id}",
                    );
                  },
                  child: ReelHighlightCard(
                    starPlayerResponse: StarPlayerResponse(
                      success: true,
                      count: 1,
                      highlights: [highlight],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

/// One horizontally-scrolling "Series" / "Matches" / "Star Players"
/// results row, each in its own [FocusTraversalGroup] so D-pad Left/
/// Right stays scoped to the row while Up/Down moves between rows.
class _ResultSection extends StatelessWidget {
  final String title;
  final double height;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  const _ResultSection({
    required this.title,
    required this.height,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Text(title, style: text24()),
        ),
        SizedBox(
          height: height,
          child: FocusTraversalGroup(
            policy: WidgetOrderTraversalPolicy(),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: itemCount,
              itemBuilder: itemBuilder,
            ),
          ),
        ),
      ],
    );
  }
}

/// Compact series card for search results — same visual language as
/// the trending-series cards on Home (banner + tournament logo badge
/// + title), just sized for a search results row.
class _SeriesResultCard extends StatelessWidget {
  final String title;
  final String image;
  final String logo;

  const _SeriesResultCard({
    required this.title,
    required this.image,
    required this.logo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            image.isNotEmpty
                ? Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        AppImage.tornamentlogo,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(AppImage.tornamentlogo, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.35),
                    Colors.transparent,
                    Colors.black.withOpacity(0.75),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            if (logo.isNotEmpty)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withOpacity(0.15),
                    border: Border.all(
                      color: AppColors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Image.network(
                    logo,
                    width: 28,
                    height: 28,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(AppImage.logo, width: 28, height: 28);
                    },
                  ),
                ),
              ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Text(
                title,
                style: text17(color: AppColors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.white.withOpacity(0.4)),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: text17(color: AppColors.white.withOpacity(0.6)),
            ),
          ],
        ),
      ),
    );
  }
}
