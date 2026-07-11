import 'package:playon/core/models/response/series_detail_model.dart';
import 'package:playon/feature/series/datasource/series_datasource.dart';

class SeriesDetailUsecase {
  final SeriesDatasource seriesDatasource;

  SeriesDetailUsecase({required this.seriesDatasource});
  Future<SeriesDetailsResponse?>call({required String id})async{
    return await seriesDatasource.seriesDetail(id: id);
  }
}