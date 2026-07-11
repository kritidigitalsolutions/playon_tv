import 'package:go_router/go_router.dart';
import 'package:playon/feature/auth/presentation/pages/login_tv_page.dart';
import 'package:playon/feature/highlights/presentation/pages/highlight_match_page.dart';
import 'package:playon/feature/highlights/presentation/pages/highlight_tornament_page.dart';
import 'package:playon/feature/highlights/presentation/pages/highlights.dart';
import 'package:playon/feature/home/presentation/page/home_page.dart';
import 'package:playon/feature/home/presentation/page/match_video_page.dart';
import 'package:playon/feature/live_tv/presentation/pages/live_channel_datail_page.dart';
import 'package:playon/feature/live_tv/presentation/pages/live_tv.dart';
import 'package:playon/feature/podcast/presentation/pages/podcast_page.dart';
import 'package:playon/feature/series/presentation/pages/series.dart';
import 'package:playon/feature/series/presentation/pages/series_detail_page.dart';
import 'package:playon/feature/series/presentation/pages/series_match_page.dart';
import 'package:playon/feature/trending/presentation/trending_detail_page.dart';
import 'package:playon/feature/notification/presentation/pages/notification_page.dart';
import 'package:playon/home_shell.dart';
import 'package:playon/splash_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
    GoRoute(path: '/', builder: (context, state) => const HomeShell()),
    GoRoute(path: '/loginTv', builder: (context, state) => const LoginTvPage()),

    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(path: '/livetv', builder: (context, state) => const LiveTv()),
    GoRoute(
      path: '/notification',
      builder: (context, state) => const NotificationPage(),
    ),
    GoRoute(path: '/series', builder: (context, state) => const Series()),
    GoRoute(
      path: '/highlights',
      builder: (context, state) => const Highlights(),
    ),
    GoRoute(
      path: '/trending/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? "";
        return TrendingDetailPage(id: id);
      },
    ),
    GoRoute(
      path: '/liveChannelDetail/:slug',
      builder: (context, state) {
        final slug = state.pathParameters['slug']!;
        return LiveChannelDatailPage(slug: slug);
      },
    ),
    GoRoute(
      path: '/podcast/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
        return PodcastPage(id: id);
      },
    ),
    GoRoute(
      path: '/seriesDetail/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return SeriesDetailPage(id: id);
      },
    ),
    GoRoute(
      path: '/seriesMatch/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return SeriesMatchPage(id: id);
      },
    ),
    GoRoute(
      path: '/allHighlightsTornament/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        final title = state.extra as String? ?? '';
        return HighlightTornamentPage(id: id, title: title);
      },
    ),
    GoRoute(
      path: '/highlightMatch/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return HighlightMatchPage(id: id); // ✅ correct page
      },
    ),
    GoRoute(
      path: '/matchVideo/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
        return MatchVideoPage(id: id);
      },
    ),
  ],
);
