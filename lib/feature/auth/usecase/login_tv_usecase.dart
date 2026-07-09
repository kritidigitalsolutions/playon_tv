import 'package:playon/feature/auth/datasource/auth_datasource.dart';

class LoginTvUsecase {
  final AuthDatasource authDatasource;

  LoginTvUsecase({required this.authDatasource});

  Future<bool> call({required String code,String? deviceName}) async {
    return await authDatasource.loginTv(code: code, deviceName: deviceName??"Unknown Device");
  }
}