import 'package:playon/core/models/response/star_player_detail_model.dart';
import 'package:playon/feature/home/datasource/home_datasource.dart';

class StarPlayerDetailUseCase {
  final HomeDatasource homeDatasource;

  StarPlayerDetailUseCase({required this.homeDatasource});
  Future<StarPlayerDetailResponse?> call({required String id})async{
    return await homeDatasource.starPlayerDetail(id: id);
  }
}