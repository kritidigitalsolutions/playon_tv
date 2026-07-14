import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/core/widgets/media_payler_widget.dart';
import 'package:playon/feature/podcast/bloc/podcast/podcast_bloc.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_navigation.dart';

class PodcastPage extends StatefulWidget {
  const PodcastPage({super.key, required this.id});
  final String id;

  @override
  State<PodcastPage> createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage> {
  bool isFullscreen = false;

  @override
  void initState() {
    super.initState();
    context.read<PodcastBloc>().add(
      PodcastEvent.podcastDetail(podcastId: widget.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final overscanPadding = size.width * 0.03;

    return BlocBuilder<PodcastBloc, PodcastState>(
      builder: (context, state) {
        // Loading
        if (state.podcastDetailStatus == Status.loading) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Error
        if (state.podcastDetailStatus == Status.error) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Failed to load podcast',
                    style: text17(color: AppColors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  TvFocusable(
                    autofocus: true,
                    borderRadius: BorderRadius.circular(20),
                    onSelect: () {
                      context.read<PodcastBloc>().add(
                        PodcastEvent.podcastDetail(podcastId: widget.id),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text(
                        "Retry",
                        style: text17(color: AppColors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final podcast = state.podcastDetail;

        // Success but nothing found
        if (podcast == null || podcast.url.isEmpty) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Text(
                'No Stream Found',
                style: text17(color: AppColors.white),
              ),
            ),
          );
        }

        final player = MediaPlayerWidget(
          url: podcast.url,
          title: podcast.title,
          autoPlay: true,
          isFullscreen: isFullscreen,
          isBack: !isFullscreen,
          onFullscreenChanged: (value) {
            setState(() => isFullscreen = value);
          },
        );

        if (isFullscreen) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) setState(() => isFullscreen = false);
            },
            child: Scaffold(backgroundColor: Colors.black, body: player),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: BackgroundWithOneLight(
            child: SafeArea(
              child: FocusTraversalGroup(
                policy: ReadingOrderTraversalPolicy(),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button — floats over the player, same
                      // focus-glow treatment used across the app rather
                      // than a bare IconButton with no focus indicator.
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          overscanPadding,
                          16,
                          overscanPadding,
                          12,
                        ),
                        child: TvFocusable(
                          autofocus: true,
                          borderRadius: BorderRadius.circular(50),
                          onSelect: () => AppNavigation.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.background.withAlpha(60),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.background),
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: AppColors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),

                      // Big immersive player — 55% of screen height,
                      // matching the hero-video proportions used on
                      // HighlightMatchPage/TrendingDetailPage instead
                      // of the old cramped 45%-height box.
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: overscanPadding,
                        ),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: player,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: overscanPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              podcast.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Badge row — sport + duration as pills,
                            // Hotstar-style, instead of a lone AppButton
                            // sitting next to plain duration text.
                            Row(
                              children: [
                                if (podcast.sportId != null)
                                  _Chip(text: podcast.sportId!.name.toUpperCase()),
                                if (podcast.sportId != null &&
                                    podcast.duration.isNotEmpty)
                                  const SizedBox(width: 10),
                                if (podcast.duration.isNotEmpty)
                                  _Chip(text: podcast.duration),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Description card — bordered surface like
                            // the description block on
                            // HighlightMatchPage, instead of bare
                            // unstyled text sitting on the background.
                            if (podcast.description.isNotEmpty)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.06),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.25),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Description",
                                      style: text18(color: AppColors.white),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      podcast.description,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.85),
                                        fontSize: 16,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Small pill-shaped label used for the sport/duration badges —
/// matches the _Chip pattern used across HighlightMatchPage,
/// TrendingDetailPage, and sports_view.dart cards.
class _Chip extends StatelessWidget {
  final String text;
  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}