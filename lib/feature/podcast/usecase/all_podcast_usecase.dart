import 'package:playon/core/models/response/podcast_model.dart';
import 'package:playon/feature/podcast/datasource/podcast_datasource.dart';

class AllPodcastUsecase {
  final PodcastDatasource podcastDatasource;

  AllPodcastUsecase({required this.podcastDatasource});

  Future<PodcastResponse?> call() async {
    return await podcastDatasource.allPodcast();
  }
}