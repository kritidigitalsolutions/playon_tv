part of 'podcast_bloc.dart';

@freezed
class PodcastEvent with _$PodcastEvent {
  const factory PodcastEvent.allPodcast() = _AllPodcast;
  const factory PodcastEvent.podcastDetail({required String podcastId}) = _PodcastDetail;
}