import 'package:playon/core/models/response/high_light_model.dart';
import 'package:playon/feature/highlights/datasource/high_light_datasource.dart';

class AllHighlightUsecase {
  final HighLightDatasource highLightDatasource;
  AllHighlightUsecase({required this.highLightDatasource});
  Future<List<HighlightModel>> call({
    required int page,
    required int limit,
  }) async {
    return await highLightDatasource.getHighlights(page: page, limit: limit);
  }
}
