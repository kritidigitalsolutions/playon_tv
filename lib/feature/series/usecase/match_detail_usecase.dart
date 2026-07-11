import 'package:playon/core/models/response/match_detail_model.dart';
import 'package:playon/feature/series/datasource/series_datasource.dart';

class MatchDetailUsecase {
  final SeriesDatasource seriesDatasource;
  MatchDetailUsecase({required this.seriesDatasource});
  Future<MatchDetailResponse?>call({required String id})async{
    return await seriesDatasource.matchDetail(id: id);
  }
}