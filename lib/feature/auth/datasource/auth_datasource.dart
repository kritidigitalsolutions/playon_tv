import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:playon/core/models/response/user_model.dart';
import 'package:playon/core/service/storage_service.dart';
import 'package:playon/static/app_url.dart';

class AuthDatasource {
  Future<bool> loginTv({required String code,required String deviceName}) async {
    try {
      final url = Uri.parse(AppUrl.loginTv);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'code': code,'deviceName':deviceName}),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          final String token = data['token'] ?? '';

          if (token.isNotEmpty) {
            await StorageService.saveToken(token);
          }
          print(response.body);
          return true;
        }

        return false;
      } else {
        print('Login failed: ${response.statusCode}');
        print(response.body);
        return false;
      }
    } catch (e) {
      print('TV Login Error: $e');
      return false;
    }
  }
  Future<UserModel?>fetchUser()async{
    final token=await StorageService.getToken();
    if(token==null){
      return null;
    }
      final url=Uri.parse(AppUrl.fetchUser);
      final response=await http.get(url,headers: {
        'Authorization':'Bearer $token',
      });
      if(response.statusCode==200){
        final data=jsonDecode(response.body);
        if(data['success']==true){
          return UserModel.fromJson(data);
        }
      }
      return null;
  }
}
