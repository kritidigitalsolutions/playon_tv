import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playon/core/models/response/series_detail_model.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/feature/series/bloc/series/series_bloc.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_navigation.dart';

class SeriesDetailPage extends StatefulWidget {
  const SeriesDetailPage({super.key, required this.id});
  final String id;

  @override
  State<SeriesDetailPage> createState() => _SeriesDetailPageState();
}

class _SeriesDetailPageState extends State<SeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<SeriesBloc>().add(SeriesEvent.getSeriesDetail(id: widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SeriesBloc, SeriesState>(
      builder: (context, state) {
        final seriesDetail = state.seriesDetail;
        final matches = seriesDetail?.matches ?? const <MatchModel>[];
        final seriesTitle = seriesDetail?.series.title ?? 'Series Details';

        return Scaffold(
          backgroundColor: AppColors.black,
          body: SafeArea(
            child: BackgroundWithOneLight(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            AppNavigation.pop(context);
                          },
                          icon: Icon(Icons.arrow_back, color: AppColors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            seriesTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Body content
                  Expanded(
                    child: _buildBody(context, state, matches, seriesTitle),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    SeriesState state,
    List<MatchModel> matches,
    String seriesTitle,
  ) {
    if (state.seriesDetailStatus == Status.loading && matches.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.seriesDetailStatus == Status.error && matches.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Something went wrong", style: text17(color: AppColors.white)),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                context.read<SeriesBloc>().add(
                  SeriesEvent.getSeriesDetail(id: widget.id),
                );
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (matches.isEmpty) {
      return Center(
        child: Text(
          "No matches found for this series",
          style: text17(color: AppColors.white.withAlpha(150)),
        ),
      );
    }

    return FocusTraversalGroup(
      policy: ReadingOrderTraversalPolicy(),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 360,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.05,
        ),
        itemCount: matches.length,
        itemBuilder: (context, index) {
          final match = matches[index];
          return SeriesMatchCard(
            match: match,
            seriesTitle: seriesTitle,
            autofocus: index == 0,
            onTap: () {
              AppNavigation.push(context, "seriesMatch/${match.id}");
            },
          );
        },
      ),
    );
  }
}

class SeriesMatchCard extends StatefulWidget {
  final MatchModel match;
  final String seriesTitle;
  final VoidCallback? onTap;
  final bool autofocus;

  const SeriesMatchCard({
    super.key,
    required this.match,
    required this.seriesTitle,
    this.onTap,
    this.autofocus = false,
  });

  @override
  State<SeriesMatchCard> createState() => _SeriesMatchCardState();
}

class _SeriesMatchCardState extends State<SeriesMatchCard> {
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
    final match = widget.match;

    final team1 = match.teamA;
    final team2 = match.teamB;
    final hasTeams = team1.isNotEmpty && team2.isNotEmpty;
    final status = match.status;
    // Prefer a purpose-built thumbnail; fall back to the match banner.
    final image = match.thumbnail.isNotEmpty ? match.thumbnail : match.banner;

    return TvFocusable(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      borderRadius: BorderRadius.circular(14),
      onSelect: widget.onTap ?? () {},
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with the match status badge overlaid on it.
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    image.isNotEmpty
                        ? Image.network(
                            image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[850],
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 32,
                                  color: Colors.grey,
                                ),
                              );
                            },
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: Colors.grey[850],
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey[850],
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 32,
                              color: Colors.grey,
                            ),
                          ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.6, 1.0],
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.35),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (status.isNotEmpty)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.55),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Content footer — sized to its own content, so it
              // can never overflow. The image above takes whatever
              // space is left.
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                          child: ClipOval(
                            child: match.teamALogo.isNotEmpty
                                ? Image.network(
                                    match.teamALogo,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.sports_cricket,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(
                                    Icons.sports_cricket,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.seriesTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (hasTeams) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              team1,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'VS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              team2,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
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
