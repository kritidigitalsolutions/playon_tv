import 'package:playon/core/models/response/player_model.dart';
import 'package:playon/feature/home/datasource/home_datasource.dart';

class SearchPlayerUseCase {
  final HomeDatasource homeDatasource;

  SearchPlayerUseCase({required this.homeDatasource});
  Future<PlayerResponse?> call({required String search}) async {
    return await homeDatasource.playerSearch(search: search);
  }
}