part of 'watch_live_bloc.dart';

@freezed
abstract class WatchLiveState with _$WatchLiveState {
  const factory WatchLiveState({
    @Default(Status.init)Status isLiveWatch,
    @Default(null)ChannelStreamResponse? channelStreamResponse,
  })=_WatchLiveState;
}
