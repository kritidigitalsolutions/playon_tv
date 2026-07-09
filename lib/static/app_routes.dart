class AppRoutes {
  AppRoutes._(); // no instances — this is a pure constants holder

  static const splash = '/splash';
  static const root = '/';
  static const loginTv = '/loginTv';
  static const home = '/home';
  static const liveTv = '/livetv';
  static const notification = '/notification';
  static const series = '/series';
  static const highlights = '/highlights';

  static const trending = '/trending/:id';
  static const liveChannelDetail = '/liveChannelDetail/:id';
  static const podcast = '/podcast/:id';
  static const seriesDetail = '/seriesDetail/:id';
  static const seriesMatch = '/seriesMatch/:id';
  static const allHighlightsTornament = '/allHighlightsTornament/:id';
  static const highlightMatch = '/highlightMatch/:id';
  static const matchVideo = '/matchVideo/:id';

  static String _withId(String pattern, int id) =>
      pattern.replaceFirst(':id', '$id');

  static String trendingPath(int id) => _withId(trending, id);
  static String liveChannelDetailPath(int id) => _withId(liveChannelDetail, id);
  static String podcastPath(int id) => _withId(podcast, id);
  static String seriesDetailPath(int id) => _withId(seriesDetail, id);
  static String seriesMatchPath(int id) => _withId(seriesMatch, id);
  static String allHighlightsTornamentPath(int id) =>
      _withId(allHighlightsTornament, id);
  static String highlightMatchPath(int id) => _withId(highlightMatch, id);
  static String matchVideoPath(int id) => _withId(matchVideo, id);
}
