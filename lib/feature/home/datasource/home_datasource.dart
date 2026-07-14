import 'dart:convert' show jsonDecode;

import 'package:http/http.dart' as http show get;
import 'package:playon/core/models/response/banner_model.dart';
import 'package:playon/core/models/response/player_model.dart';
import 'package:playon/core/models/response/social_media_model.dart';
import 'package:playon/core/models/response/star_player_detail_model.dart';
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

  Future<StarPlayerResponse?> allStarPlayers() async {
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
        return StarPlayerResponse.fromJson(jsonData);
      } else {
        throw Exception(
          "Failed to load star players. Status Code: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error fetching star players: $e");
    }
  }

  Future<StarPlayerDetailResponse?> starPlayerDetail({
    required String id,
  }) async {
    try {
      final url = Uri.parse(AppUrl.starPlayerVideoDetail(id: id));
      final token = await StorageService.getToken();

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return StarPlayerDetailResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized. Please login again.");
      } else if (response.statusCode == 404) {
        throw Exception("Star player details not found.");
      } else {
        throw Exception(
          "Failed to fetch star player details. Status Code: ${response.statusCode}\nResponse: ${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Error fetching star player details: $e");
    }
  }

  Future<PlayerResponse?> playerSearch({required String search}) async {
    try {
      final url = Uri.parse(AppUrl.searchPlayer(search: search));

      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return PlayerResponse.fromJson(jsonDecode(response.body));
      } else {
        print("API Error: ${response.statusCode}");
        return null;
      }
    } catch (e, stackTrace) {
      print("Exception: $e");
      print("StackTrace: $stackTrace");
      return null;
    }
  }
}
