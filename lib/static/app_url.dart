class AppUrl {
  static const String baseUrl = "https://api.playonsports.online";
  static const String loginTv = "$baseUrl/api/tv/login";
  static const String fetchUser = "$baseUrl/api/user/profile";
  static const String allBanner = "$baseUrl/api/banner-ads";
  static String allHighlights({required int page, required int limit}) {
    return "$baseUrl/api/highlights?page=$page&limit=$limit";
  }

  static String allSeries({required int page, required int limit}) {
    return "$baseUrl/api/series?page=$page&limit=$limit";
  }

  static String channelCatagory = "$baseUrl/api/channel-categories";
  static String socialMedia = "$baseUrl/api/social-media";
  static String channel({String? search}) {
    return "$baseUrl/api/channels/live?search=$search";
  }

  static String seriesDetail({required String id}) {
    return "$baseUrl/api/series/$id";
  }

  static String highlightDetail({required String id}) {
    return "$baseUrl/api/highlights/$id";
  }

  static String watchLive({required String slug}) {
    return "$baseUrl/api/channels/$slug/watch";
  }

  static String matchDetail({required String id}) {
    return "$baseUrl/api/matches/$id";
  }

  static String starPlayer = "$baseUrl/api/star-players";
  static String starPlayerVideoDetail({required String id}) {
    return "$baseUrl/api/star-players/$id";
  }

  static String allPodcast = "$baseUrl/api/podcasts";
}
