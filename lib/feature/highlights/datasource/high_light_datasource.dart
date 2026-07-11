// ignore_for_file: avoid_print

import 'dart:convert' show jsonDecode;

import 'package:http/http.dart' as http;
import 'package:playon/core/models/response/high_light_detail_model.dart';
import 'package:playon/core/models/response/high_light_model.dart';
import 'package:playon/core/service/storage_service.dart';
import 'package:playon/static/app_url.dart';

class HighLightDatasource {
  Future<List<HighlightModel>> getHighlights(
    {
      required int page,
      required int limit,
    }
  ) async {
    try {
      final url = Uri.parse(AppUrl.allHighlights(page: page, limit: limit));

      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = HighlightResponse.fromJson(jsonDecode(response.body));
        print(data);
        return data.highlights;
      } else {
        throw Exception(
          'Failed to load highlights. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching highlights: $e');
    }
  }
  Future<HighlightDetailResponse?> getHighlightDetail({
    required String id,
  }) async {
    try {
      final url = Uri.parse(AppUrl.highlightDetail(id: id));
      final token=await StorageService.getToken();
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json','Authorization':'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = HighlightDetailResponse.fromJson(
          jsonDecode(response.body),
        );
        print(data);
        return data;
      } else {
        throw Exception(
          'Failed to load highlight detail. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching highlight detail: $e');
    }
  }
}
