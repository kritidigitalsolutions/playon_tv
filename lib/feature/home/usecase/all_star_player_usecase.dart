import 'package:playon/core/models/response/star_player_model.dart';
import 'package:playon/feature/home/datasource/home_datasource.dart';

class AllStarPlayerUseCase {
  final HomeDatasource homeDatasource;

  AllStarPlayerUseCase({required this.homeDatasource});
  Future<List<StarPlayerModel>> call() async {
    return await homeDatasource.allStarPlayers();
  }
}