import 'package:http/http.dart' as http;
import 'package:playon/core/models/response/channel_catagory_model.dart';
import 'package:playon/core/models/response/channel_model.dart';
import 'package:playon/core/models/response/channel_stream_response_model.dart';
import 'package:playon/core/service/storage_service.dart';
import 'package:playon/static/app_url.dart';

import 'dart:convert';

class LiveTvDatasource {
  Future<List<ChannelCatagoryModel>> allChannelCategory() async {
    try {
      final url = Uri.parse(AppUrl.channelCatagory);

      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        final categoryResponse = CategoryResponse.fromJson(jsonData);

        return categoryResponse.categories;
      } else {
        throw Exception(
          'Failed to load channel categories. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching channel categories: $e');
    }
  }

  Future<List<ChannelModel>> allChannel({String? search}) async {
    try {
      final url = Uri.parse(AppUrl.channel(search: search));

      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        final channelResponse = ChannelResponse.fromJson(jsonData);

        return channelResponse.channels;
      } else {
        throw Exception(
          "Failed to load channels. Status Code: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error fetching channels: $e");
    }
  }

  Future<ChannelStreamResponse> watchLive({required String slug}) async {
    final token = await StorageService.getToken();

    try {
      final url = Uri.parse(AppUrl.watchLive(slug: slug));

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        return ChannelStreamResponse.fromJson(jsonDecode(response.body));
      }

      throw Exception("Failed to load channel stream (${response.statusCode})");
    } catch (e) {
      throw Exception("Error fetching channel stream: $e");
    }
  }
}
