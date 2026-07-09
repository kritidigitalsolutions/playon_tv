class AppUrl {
  static const String baseUrl = "http://192.168.1.29:8000";
  static const String loginTv = "$baseUrl/api/tv/login";
  static const String fetchUser = "$baseUrl/api/user/profile";
  static const String allBanner = "$baseUrl/api/banner-ads";
static String allHighlights({
  required int page,
  required int limit,
}) {
  return "$baseUrl/api/highlights?page=$page&limit=$limit";
}}
