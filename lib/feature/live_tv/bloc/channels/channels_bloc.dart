// ignore_for_file: prefer_initializing_formals

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:playon/core/models/response/channel_model.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/feature/live_tv/usecase/all_channel_usecase.dart';

part 'channels_event.dart';
part 'channels_state.dart';
part 'channels_bloc.freezed.dart';

class ChannelsBloc extends Bloc<ChannelsEvent, ChannelsState> {
  final AllChannelUsecase _allChannelUsecase;
  ChannelsBloc(
    {
      required AllChannelUsecase allChannelUsecase,
    }
  ) :
  _allChannelUsecase=allChannelUsecase,
  super(ChannelsState()) {
    on<_AllChannels>((event, emit) async {
      emit(state.copyWith(channelsStatus: Status.loading));
      final result=await _allChannelUsecase(search: state.search);
      if(result.isNotEmpty){
        emit(state.copyWith(channels: result,channelsStatus: Status.success));
      }else if(result.isEmpty){
        emit(state.copyWith(channelsStatus: Status.success));
      } else{
        emit(state.copyWith(channelsStatus: Status.error));
      }
    });
    on<_Search>((event, emit) {
      emit(state.copyWith(search: event.value));
    });
  }
}
