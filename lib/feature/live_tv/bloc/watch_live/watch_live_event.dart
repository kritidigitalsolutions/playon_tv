part of 'watch_live_bloc.dart';

@freezed
abstract class WatchLiveEvent with _$WatchLiveEvent {
  const factory WatchLiveEvent.watchLiveChannel({required String slug}) = _WatchLiveChannel;
}