part of 'channels_bloc.dart';

@freezed
abstract class ChannelsState with _$ChannelsState {
  const factory ChannelsState({
    @Default([])List<ChannelModel> channels,
    @Default(Status.init)Status channelsStatus,
    @Default("")String search,
  })=_ChannelsState;
}
