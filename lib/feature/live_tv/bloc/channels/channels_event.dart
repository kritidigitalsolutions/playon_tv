part of 'channels_bloc.dart';

@freezed
class ChannelsEvent with _$ChannelsEvent {
  const factory ChannelsEvent.search(String value) = _Search;
  const factory ChannelsEvent.allChannels({String? search}) = _AllChannels;
}
