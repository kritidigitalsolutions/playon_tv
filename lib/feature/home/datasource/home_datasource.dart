import 'dart:convert' show jsonDecode;

import 'package:http/http.dart' as http show get;
import 'package:playon/core/models/response/banner_model.dart';
import 'package:playon/core/models/response/social_media_model.dart';
import 'package:playon/core/models/response/star_player_model.dart';
import 'package:playon/core/service/storage_service.dart';
import 'package:playon/static/app_url.dart';

class HomeDatasource {
  Future<List<BannerModel>> allBanner() async {
    final url = Uri.parse(AppUrl.allBanner);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = BannerResponse.fromJson(jsonDecode(response.body));
      return data.banners;
    } else {
      throw Exception("Failed to load banners");
    }
  }

  Future<List<SocialModel>> allSocialMedia() async {
    final url = Uri.parse(AppUrl.socialMedia);

    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = SocialResponse.fromJson(jsonDecode(response.body));

      return data.social;
    } else {
      throw Exception(
        "Failed to load social media. Status Code: ${response.statusCode}",
      );
    }
  }

  Future<List<StarPlayerModel>> allStarPlayers() async {
    try {
      final url = Uri.parse(AppUrl.starPlayer);
      final token = await StorageService.getToken();

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        final List<dynamic> players = jsonData['players'] ?? [];

        return players.map((e) => StarPlayerModel.fromJson(e)).toList();
      } else {
        throw Exception(
          "Failed to load star players. Status Code: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error fetching star players: $e");
    }
  }
}
