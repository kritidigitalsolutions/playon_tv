import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:playon/core/models/response/podcast_model.dart'
    show PodcastResponse, PodcastModel;
import 'package:playon/core/service/storage_service.dart';
import 'package:playon/static/app_url.dart';

class PodcastDatasource {
  Future<PodcastResponse?> allPodcast() async {
    try {
      final url = Uri.parse(AppUrl.allPodcast);

      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return PodcastResponse.fromJson(jsonDecode(response.body));
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

  Future<PodcastModel?> podcastDetail({required String id}) async {
    final token = await StorageService.getToken();
    try {
      final url = Uri.parse(AppUrl.podcastDetail(id: id));

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final podcastJson = decoded['podcast'] as Map<String, dynamic>?;

        if (podcastJson == null) {
          print("API Error: response missing 'podcast' key");
          return null;
        }

        return PodcastModel.fromJson(podcastJson);
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
