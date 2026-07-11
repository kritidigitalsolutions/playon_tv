import 'dart:convert' show jsonDecode;

import 'package:http/http.dart' as http;
import 'package:playon/core/models/response/series_detail_model.dart';
import 'package:playon/core/models/response/series_model.dart';
import 'package:playon/core/service/storage_service.dart';
import 'package:playon/static/app_url.dart';

class SeriesDatasource {
  Future<List<SeriesModel>> allSeries({
    required int limit,
    required int page,
  }) async {
    try {
      final url = Uri.parse(AppUrl.allSeries(page: page, limit: limit));

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == true) {
          final List<dynamic> seriesJson = data['series'] ?? [];

          return seriesJson.map((e) => SeriesModel.fromJson(e)).toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to load series');
        }
      } else {
        throw Exception(
          'Failed to load series. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching series: $e');
    }
  }

  Future<SeriesDetailsResponse?> seriesDetail({required String id}) async {
    try {
      final token = await StorageService.getToken();

      final url = Uri.parse(AppUrl.seriesDetail(id: id));

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        return SeriesDetailsResponse.fromJson(json);
      } else {
        print('Series Detail API Error: ${response.statusCode}');
        print(response.body);
        return null;
      }
    } catch (e, stackTrace) {
      print('Series Detail Exception: $e');
      print(stackTrace);
      return null;
    }
  }
}
