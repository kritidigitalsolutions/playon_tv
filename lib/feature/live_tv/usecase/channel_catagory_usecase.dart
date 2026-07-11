import 'package:playon/core/models/response/channel_catagory_model.dart';
import 'package:playon/feature/live_tv/datasource/live_tv_datasource.dart';

class ChannelCatagoryUsecase {
  final LiveTvDatasource liveTvDatasource;

  ChannelCatagoryUsecase({required this.liveTvDatasource});

  Future<List<ChannelCatagoryModel>> call() async {
    return await liveTvDatasource.allChannelCategory();
  }
}