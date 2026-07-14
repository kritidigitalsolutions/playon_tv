part of 'podcast_bloc.dart';

@freezed
abstract class PodcastState with _$PodcastState {
  const factory PodcastState({
    @Default(null)PodcastResponse? podcastResponse,
    @Default(null)PodcastModel? podcastDetail,
    @Default(Status.init)Status allPodcastStatus,
    @Default(Status.init)Status podcastDetailStatus,
  })=_PodcastState;
}
