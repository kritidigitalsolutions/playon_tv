import 'package:playon/core/models/response/high_light_detail_model.dart';
import 'package:playon/feature/highlights/datasource/high_light_datasource.dart';

class HighLightDeatilUsecase {
  final HighLightDatasource highLightDatasource;
  HighLightDeatilUsecase({required this.highLightDatasource});
  Future<HighlightDetailResponse?> call({
    required String id,
  }) async {
    return await highLightDatasource.getHighlightDetail(id: id);
  }
}