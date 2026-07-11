part of 'channel_catagory_bloc.dart';

@freezed
abstract class ChannelCatagoryState with _$ChannelCatagoryState {
  const factory ChannelCatagoryState({
    @Default([])List<ChannelCatagoryModel> channelCatagoryList,
    @Default(Status.init)Status channelCatagoryStatus,
  })=_ChannelCatagoryState;
}
