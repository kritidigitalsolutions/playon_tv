import 'package:playon/core/models/response/channel_model.dart';
import 'package:playon/feature/live_tv/datasource/live_tv_datasource.dart';

class AllChannelUsecase {
  final LiveTvDatasource _liveTvDatasource;

  AllChannelUsecase({required this._liveTvDatasource});

  Future<List<ChannelModel>> call({String? search}) async {
    return await _liveTvDatasource.allChannel(search: search);
  }
}