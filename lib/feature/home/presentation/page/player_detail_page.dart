import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:playon/core/models/response/player_model.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/feature/home/bloc/star_player/star_payer_cubit.dart';

/// ---------------------------------------------------------------------
/// Design tokens — same broadcast-dark language as the Star Player
/// video TV screen, kept local (private) to this file so importing
/// both screens together never collides on `kBg`/`kAccent`/etc.
/// ---------------------------------------------------------------------
const _kBg = Color(0xFF0A0C10);
const _kAccent = Color(0xFF2FE6C4);
const _kGold = Color(0xFFF3B94D);
const _kGlass = Color(0x14FFFFFF);
const _kHairline = Color(0x1FFFFFFF);

/// TV player-profile screen. Reached from "View Full Profile" on the
/// Star Player video page, which passes the player's *name* (not id)
/// as the [search] path segment — this page runs that name through
/// [StarPayerCubit.search] + [StarPayerCubit.playerSearch] and renders
/// whichever player comes back first.
class PlayerDetailPage extends StatefulWidget {
  const PlayerDetailPage({super.key, required this.search});

  final String search;

  @override
  State<PlayerDetailPage> createState() => _PlayerDetailPageState();
}

class _PlayerDetailPageState extends State<PlayerDetailPage> {
  final FocusNode _backFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<StarPayerCubit>();
    cubit.search(widget.search);
    cubit.playerSearch();
  }

  @override
  void dispose() {
    _backFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: BlocBuilder<StarPayerCubit, StarPayerState>(
        builder: (context, state) {
          if (state.searchPlayerStatus == Status.loading ||
              state.searchPlayerStatus == Status.init) {
            return const Center(
              child: CircularProgressIndicator(color: _kAccent),
            );
          }

          final players = state.searchPlayers?.players ?? const <PlayerModel>[];

          if (state.searchPlayerStatus == Status.error || players.isEmpty) {
            return _ErrorOrEmptyState(
              notFound: state.searchPlayerStatus != Status.error,
              onRetry: () {
                final cubit = context.read<StarPayerCubit>();
                cubit.search(widget.search);
                cubit.playerSearch();
              },
            );
          }

          final player = players.first;

          return Stack(
            fit: StackFit.expand,
            children: [
              _AmbientBackdrop(image: player.image),
              SafeArea(
                child: FocusTraversalGroup(
                  policy: ReadingOrderTraversalPolicy(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TopBar(
                        title: player.name.toUpperCase(),
                        focusNode: _backFocusNode,
                        onBack: () => context.pop(),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(48, 8, 48, 40),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: _PlayerPortrait(image: player.image),
                              ),
                              const SizedBox(width: 40),
                              Expanded(
                                flex: 6,
                                child: _PlayerInfoPanel(player: player),
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

/// Full-bleed blurred + dimmed player photo behind the whole screen,
/// matching the ambient-art treatment on the video TV page.
class _AmbientBackdrop extends StatelessWidget {
  const _AmbientBackdrop({required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (image.isNotEmpty)
          Image.network(
            image,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: _kBg),
          )
        else
          Container(color: _kBg),
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 42, sigmaY: 42),
          child: Container(color: Colors.black.withOpacity(0.1)),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.1, -0.2),
              radius: 1.3,
              colors: [
                _kBg.withOpacity(0.55),
                _kBg.withOpacity(0.86),
                _kBg.withOpacity(0.97),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}

/// Shared focus-glow ring wrapper — same visual language as the video
/// page's focus treatment, kept local since that one is private to
/// its own file.
class _FocusGlow extends StatefulWidget {
  const _FocusGlow({
    required this.focusNode,
    required this.child,
    this.borderRadius = 12,
  });

  final FocusNode focusNode;
  final Widget child;
  final double borderRadius;

  @override
  State<_FocusGlow> createState() => _FocusGlowState();
}

class _FocusGlowState extends State<_FocusGlow> {
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: _focused
            ? [
                BoxShadow(
                  color: _kAccent.withOpacity(0.55),
                  blurRadius: 26,
                  spreadRadius: 1,
                ),
              ]
            : const [],
        border: Border.all(
          color: _focused ? _kAccent : Colors.transparent,
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
          _FocusGlow(
            focusNode: focusNode,
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
                  color: _kGlass,
                  shape: BoxShape.circle,
                  border: Border.all(color: _kHairline),
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

/// Large portrait photo panel — the visual anchor on the left side of
/// the screen, framed with a soft accent-gradient ring like the avatar
/// treatment on the video page's info panel.
class _PlayerPortrait extends StatelessWidget {
  const _PlayerPortrait({required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [_kAccent, _kAccent.withOpacity(0.15)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: image.isNotEmpty
              ? Image.network(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: _kBg,
                    child: const Icon(
                      Icons.person,
                      color: Colors.white24,
                      size: 64,
                    ),
                  ),
                )
              : Container(
                  color: _kBg,
                  child: const Icon(
                    Icons.person,
                    color: Colors.white24,
                    size: 64,
                  ),
                ),
        ),
      ),
    );
  }
}

class _PlayerInfoPanel extends StatelessWidget {
  const _PlayerInfoPanel({required this.player});

  final PlayerModel player;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: _kGlass,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _kHairline),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 6),
                if (player.team.isNotEmpty)
                  Row(
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        color: Colors.white38,
                        size: 15,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        player.team,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 22),
                Container(height: 1, color: _kHairline),
                const SizedBox(height: 22),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    if (player.sport.isNotEmpty)
                      _Tag(
                        label: player.sport.toUpperCase(),
                        icon: Icons.sports_cricket,
                        color: Colors.white,
                        fill: Colors.white.withOpacity(0.08),
                      ),
                    if (player.position.isNotEmpty)
                      _Tag(
                        label: player.position.toUpperCase(),
                        icon: Icons.badge_outlined,
                        color: Colors.white,
                        fill: Colors.white.withOpacity(0.08),
                      ),
                    if (player.country.isNotEmpty)
                      _Tag(
                        label: player.country.toUpperCase(),
                        icon: Icons.place_outlined,
                        color: Colors.white,
                        fill: Colors.white.withOpacity(0.08),
                      ),
                    _Tag(
                      label: player.featured
                          ? 'FEATURED'
                          : player.status.isNotEmpty
                          ? player.status.toUpperCase()
                          : 'PLAYER',
                      icon: player.featured
                          ? Icons.workspace_premium
                          : Icons.check_circle_outline,
                      color: player.featured ? _kGold : _kAccent,
                      fill: (player.featured ? _kGold : _kAccent).withOpacity(
                        0.14,
                      ),
                      borderColor: (player.featured ? _kGold : _kAccent)
                          .withOpacity(0.4),
                    ),
                  ],
                ),
                if (player.bio.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'ABOUT',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    player.bio,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
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
        border: Border.all(color: borderColor ?? _kHairline),
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

class _ErrorOrEmptyState extends StatelessWidget {
  const _ErrorOrEmptyState({required this.notFound, required this.onRetry});

  /// true => the search simply returned no matching player;
  /// false => the request itself failed.
  final bool notFound;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final retryFocusNode = FocusNode();
    return Container(
      color: _kBg,
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
              child: Icon(
                notFound ? Icons.person_search : Icons.error_outline,
                color: Colors.white54,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              notFound
                  ? 'No player found for this name.'
                  : 'Something went wrong. Please try again.',
              style: const TextStyle(color: Colors.white70, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _FocusGlow(
              focusNode: retryFocusNode,
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
                    color: _kGlass,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: _kHairline),
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
