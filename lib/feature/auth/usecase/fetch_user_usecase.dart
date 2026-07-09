import 'package:playon/core/models/response/user_model.dart';
import 'package:playon/feature/auth/datasource/auth_datasource.dart';

class FetchUserUsecase {
  final AuthDatasource authDatasource;

  FetchUserUsecase({required this.authDatasource});

  Future<UserModel?>call()async{
    return await authDatasource.fetchUser();
  }
}