import 'package:playon/core/models/response/series_model.dart';
import 'package:playon/feature/series/datasource/series_datasource.dart';

class AllSeriesUsecase {
  final SeriesDatasource seriesDatasource;

  AllSeriesUsecase({required this.seriesDatasource});

  Future<List<SeriesModel>> call({
    required int limit,
    required int page,
  }) async {
    return await seriesDatasource.allSeries(
      limit: limit,
      page: page,
    );
  }
}