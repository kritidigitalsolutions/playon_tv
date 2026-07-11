import 'package:playon/core/models/response/channel_stream_response_model.dart';
import 'package:playon/feature/live_tv/datasource/live_tv_datasource.dart';

class WatchLiveUsecase {
  final LiveTvDatasource liveTvDatasource;
  WatchLiveUsecase({required this.liveTvDatasource});
  Future<ChannelStreamResponse?> call({required String slug}) async {
    return await liveTvDatasource.watchLive(slug: slug);
  }
}