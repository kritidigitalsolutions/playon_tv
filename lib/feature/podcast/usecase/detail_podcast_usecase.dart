import 'package:playon/core/models/response/podcast_model.dart';
import 'package:playon/feature/podcast/datasource/podcast_datasource.dart';

class DetailPodcastUsecase {
  final PodcastDatasource podcastDatasource;

  DetailPodcastUsecase({required this.podcastDatasource});

  Future<PodcastModel?> call({required String id}) async {
    return await podcastDatasource.podcastDetail(id: id);
  }
}