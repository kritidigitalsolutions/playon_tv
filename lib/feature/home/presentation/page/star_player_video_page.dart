import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:playon/core/service/enum.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/core/widgets/media_payler_widget.dart';
import 'package:playon/feature/home/bloc/star_player/star_payer_cubit.dart';

/// ---------------------------------------------------------------------
/// Design tokens
///
/// A small, deliberate palette instead of flat black-on-black:
/// - kBg          near-black cinema backdrop (not pure #000, keeps depth)
/// - kAccent      "live broadcast" cyan — used for focus glow + CTA
/// - kGold        premium accent, reserved only for the premium badge
/// - kGlass       frosted panel fill sitting over the blurred hero art
/// ---------------------------------------------------------------------
const kBg = Color(0xFF0A0C10);
const kAccent = Color(0xFF2FE6C4);
const kGold = Color(0xFFF3B94D);
const kGlass = Color(0x14FFFFFF);
const kHairline = Color(0x1FFFFFFF);

/// TV variant of the Star Player detail screen.
///
/// Layout concept: instead of a flat black canvas with two boxes side
/// by side, the highlight's own thumbnail becomes a soft, blurred,
/// dimmed backdrop behind the whole screen — the video pane and the
/// glass info panel float on top of it. This is the same "ambient art"
/// language used across premium 10-foot sports apps, and it makes the
/// screen feel like it belongs to *this* highlight rather than a
/// generic template.
///
/// Focus is the primary input on a TV, so it gets a real signature
/// treatment: every interactive element sits inside [_GlowFocusable],
/// which grows slightly and blooms a soft cyan halo when the D-pad
/// lands on it — a deliberate, singular motion cue instead of scattered
/// effects everywhere.
class StarPlayerVideoPageTv extends StatefulWidget {
  const StarPlayerVideoPageTv({super.key, required this.id});

  final String id;

  @override
  State<StarPlayerVideoPageTv> createState() => _StarPlayerVideoPageTvState();
}

class _StarPlayerVideoPageTvState extends State<StarPlayerVideoPageTv> {
  final FocusNode _backButtonFocusNode = FocusNode();
  final FocusNode _playerFocusNode = FocusNode();
  final FocusNode _ctaFocusNode = FocusNode();

  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    context.read<StarPayerCubit>().starPlayerDetail(id: widget.id);
  }

  @override
  void dispose() {
    _backButtonFocusNode.dispose();
    _playerFocusNode.dispose();
    _ctaFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: BlocBuilder<StarPayerCubit, StarPayerState>(
        builder: (context, state) {
          if (state.starPlayerDetailStatus == Status.loading ||
              state.starPlayerDetailStatus == Status.init) {
            return const Center(
              child: CircularProgressIndicator(color: kAccent),
            );
          }

          final highlight = state.starPlayerDetail;

          if (state.starPlayerDetailStatus == Status.error ||
              highlight == null) {
            return _ErrorState(
              onRetry: () => context.read<StarPayerCubit>().starPlayerDetail(
                id: widget.id,
              ),
            );
          }

          final thumbnail = highlight.highlight.thumbnail;

          // Fullscreen bypasses the 16:9-caged video pane entirely and
          // fills the whole screen edge-to-edge. Toggling `isFullscreen`
          // on the pane that lives inside AspectRatio+ClipRRect can never
          // grow past that box, which is why "fullscreen" used to do
          // nothing — this renders a completely different tree instead.
          if (_isFullscreen) {
            return PopScope(
              canPop: false,
              onPopInvoked: (didPop) {
                if (didPop) return;
                setState(() => _isFullscreen = false);
              },
              child: _FullscreenVideo(
                videoUrl: highlight.highlight.videoUrl,
                title: highlight.highlight.title,
                onExitFullscreen: () => setState(() => _isFullscreen = false),
              ),
            );
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              _AmbientBackdrop(thumbnail: thumbnail),
              SafeArea(
                child: FocusTraversalGroup(
                  policy: ReadingOrderTraversalPolicy(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TopBar(
                        title: highlight.highlight.playerName.isNotEmpty
                            ? highlight.highlight.playerName.toUpperCase()
                            : highlight.highlight.title.toUpperCase(),
                        focusNode: _backButtonFocusNode,
                        onBack: () => context.pop(),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(48, 8, 48, 40),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 6,
                                child: _VideoPane(
                                  focusNode: _playerFocusNode,
                                  videoUrl: highlight.highlight.videoUrl,
                                  thumbnail: thumbnail,
                                  title: highlight.highlight.title,
                                  isFullscreen: _isFullscreen,
                                  onFullscreenChanged: (value) {
                                    setState(() => _isFullscreen = value);
                                  },
                                ),
                              ),
                              const SizedBox(width: 40),
                              Expanded(
                                flex: 4,
                                child: _InfoPanel(
                                  ctaFocusNode: _ctaFocusNode,
                                  playerName: highlight.highlight.playerName,
                                  country: highlight.highlight.player.country,
                                  playerImage: highlight.highlight.player.image,
                                  title: highlight.highlight.title,
                                  sportName: highlight.highlight.sport.name,
                                  isPremium: highlight.highlight.isPremium,
                                  onViewProfile: () {
                                    context.push(
                                      '/player/${highlight.highlight.id}',
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Full-bleed, heavily blurred + dimmed thumbnail sitting behind the
/// whole screen. This is the signature layout move: the screen's
/// mood always matches the content instead of a flat black canvas.
class _AmbientBackdrop extends StatelessWidget {
  const _AmbientBackdrop({required this.thumbnail});

  final String thumbnail;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (thumbnail.isNotEmpty)
          Image.network(
            thumbnail,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: kBg),
          )
        else
          Container(color: kBg),
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 42, sigmaY: 42),
          child: Container(color: Colors.black.withOpacity(0.1)),
        ),
        // Vignette: darker at the edges & bottom so overlaid text and
        // focus rings always stay legible regardless of source art.
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.1, -0.2),
              radius: 1.3,
              colors: [
                kBg.withOpacity(0.55),
                kBg.withOpacity(0.86),
                kBg.withOpacity(0.97),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}

/// Wraps any focusable control with a shared, singular focus language:
/// a soft cyan halo blooms outward and the control lifts slightly.
/// Listens to the same [FocusNode] used by [TvFocusable]/D-pad
/// navigation, so it stays perfectly in sync with real TV focus state
/// without needing to know [TvFocusable]'s internals.
class _GlowFocusable extends StatefulWidget {
  const _GlowFocusable({
    required this.focusNode,
    required this.child,
    this.autofocus = false,
    this.borderRadius = 12,
  });

  final FocusNode focusNode;
  final Widget child;
  final bool autofocus;
  final double borderRadius;

  @override
  State<_GlowFocusable> createState() => _GlowFocusableState();
}

class _GlowFocusableState extends State<_GlowFocusable> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scale is already handled by TvFocusable's own AnimatedScale — this
    // only layers the cyan glow ring on top of it, so the two never fight.
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: _focused
            ? [
                BoxShadow(
                  color: kAccent.withOpacity(0.55),
                  blurRadius: 26,
                  spreadRadius: 1,
                ),
              ]
            : const [],
        border: Border.all(
          color: _focused ? kAccent : Colors.transparent,
          width: 2,
        ),
      ),
      child: widget.child,
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.focusNode,
    required this.onBack,
  });

  final String title;
  final FocusNode focusNode;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(48, 20, 48, 12),
      child: Row(
        children: [
          _GlowFocusable(
            focusNode: focusNode,
            autofocus: true,
            borderRadius: 22,
            child: TvFocusable(
              focusNode: focusNode,
              autofocus: true,
              onSelect: onBack,
              borderRadius: BorderRadius.circular(22),
              focusBackgroundColor: Colors.transparent,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: kGlass,
                  shape: BoxShape.circle,
                  border: Border.all(color: kHairline),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// True edge-to-edge fullscreen playback. Deliberately skips
/// [SafeArea]/[AspectRatio] so the player can claim the entire frame,
/// not just the 60% column it lives in normally. The remote's back
/// button (wired via [PopScope] one level up) drops out of fullscreen
/// rather than exiting the page, matching how live TV apps behave.
class _FullscreenVideo extends StatelessWidget {
  const _FullscreenVideo({
    required this.videoUrl,
    required this.title,
    required this.onExitFullscreen,
  });

  final String videoUrl;
  final String title;
  final VoidCallback onExitFullscreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          MediaPlayerWidget(
            url: videoUrl,
            title: title,
            isFullscreen: true,
            onFullscreenChanged: (value) {
              if (!value) onExitFullscreen();
            },
          ),
        ],
      ),
    );
  }
}

class _VideoPane extends StatelessWidget {
  const _VideoPane({
    required this.focusNode,
    required this.videoUrl,
    required this.thumbnail,
    required this.title,
    required this.isFullscreen,
    required this.onFullscreenChanged,
  });

  final FocusNode focusNode;
  final String videoUrl;
  final String thumbnail;
  final String title;
  final bool isFullscreen;
  final ValueChanged<bool> onFullscreenChanged;

  bool get _hasVideo => videoUrl.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: _GlowFocusable(
        focusNode: focusNode,
        borderRadius: 16,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: TvFocusable(
            focusNode: focusNode,
            borderRadius: BorderRadius.circular(16),
            focusBackgroundColor: Colors.transparent,
            // Pressing select on the video pane is the natural TV
            // gesture for "play this fullscreen".
            onSelect: _hasVideo ? () => onFullscreenChanged(true) : null,
            child: _hasVideo
                ? MediaPlayerWidget(
                    url: videoUrl,
                    title: title,
                    isFullscreen: isFullscreen,
                    onFullscreenChanged: onFullscreenChanged,
                  )
                : _ComingSoonOverlay(thumbnail: thumbnail),
          ),
        ),
      ),
    );
  }
}

/// Same "COMING SOON" moment as mobile, restyled to match the new
/// broadcast-dark language instead of a flat dim overlay.
class _ComingSoonOverlay extends StatelessWidget {
  const _ComingSoonOverlay({required this.thumbnail});

  final String thumbnail;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (thumbnail.isNotEmpty)
          Image.network(
            thumbnail,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.black),
          )
        else
          Container(color: Colors.black),
        Container(color: Colors.black.withOpacity(0.55)),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kAccent.withOpacity(0.15),
                  border: Border.all(color: kAccent.withOpacity(0.4)),
                ),
                child: const Icon(Icons.schedule, color: kAccent, size: 28),
              ),
              const SizedBox(height: 16),
              const Text(
                'COMING SOON',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.ctaFocusNode,
    required this.playerName,
    required this.country,
    required this.playerImage,
    required this.title,
    required this.sportName,
    required this.isPremium,
    required this.onViewProfile,
  });

  final FocusNode ctaFocusNode;
  final String playerName;
  final String country;
  final String playerImage;
  final String title;
  final String sportName;
  final bool isPremium;
  final VoidCallback onViewProfile;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: kGlass,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kHairline),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [kAccent, kAccent.withOpacity(0.15)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 26,
                        backgroundColor: kBg,
                        backgroundImage: playerImage.isNotEmpty
                            ? NetworkImage(playerImage)
                            : null,
                        child: playerImage.isEmpty
                            ? const Icon(
                                Icons.person,
                                color: Colors.white70,
                                size: 22,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            playerName.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(
                                Icons.place_outlined,
                                color: Colors.white38,
                                size: 13,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                country,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Container(height: 1, color: kHairline),
                const SizedBox(height: 22),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    if (sportName.isNotEmpty)
                      _Tag(
                        label: sportName.toUpperCase(),
                        icon: Icons.sports_cricket,
                        color: Colors.white,
                        fill: Colors.white.withOpacity(0.08),
                      ),
                    _Tag(
                      label: isPremium ? 'PREMIUM' : 'FREE CONTENT',
                      icon: isPremium
                          ? Icons.workspace_premium
                          : Icons.lock_open_rounded,
                      color: isPremium ? kGold : kAccent,
                      fill: (isPremium ? kGold : kAccent).withOpacity(0.14),
                      borderColor: (isPremium ? kGold : kAccent).withOpacity(
                        0.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                _GlowFocusable(
                  focusNode: ctaFocusNode,
                  borderRadius: 28,
                  child: TvFocusable(
                    focusNode: ctaFocusNode,
                    onSelect: onViewProfile,
                    borderRadius: BorderRadius.circular(28),
                    focusBackgroundColor: Colors.transparent,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [kAccent, kAccent.withOpacity(0.75)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person_outline, color: kBg, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'View Full Profile',
                            style: TextStyle(
                              color: kBg,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
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

class _Tag extends StatelessWidget {
  const _Tag({
    required this.label,
    required this.icon,
    required this.color,
    required this.fill,
    this.borderColor,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color fill;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor ?? kHairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final retryFocusNode = FocusNode();
    return Container(
      color: kBg,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
              child: const Icon(
                Icons.error_outline,
                color: Colors.white54,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong. Please try again.',
              style: TextStyle(color: Colors.white70, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _GlowFocusable(
              focusNode: retryFocusNode,
              autofocus: true,
              borderRadius: 24,
              child: TvFocusable(
                focusNode: retryFocusNode,
                autofocus: true,
                onSelect: onRetry,
                borderRadius: BorderRadius.circular(24),
                focusBackgroundColor: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: kGlass,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: kHairline),
                  ),
                  child: const Text(
                    'Retry',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
