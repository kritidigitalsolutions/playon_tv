// ignore_for_file: prefer_initializing_formals

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:playon/core/models/response/channel_catagory_model.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/feature/live_tv/usecase/channel_catagory_usecase.dart';

part 'channel_catagory_event.dart';
part 'channel_catagory_state.dart';
part 'channel_catagory_bloc.freezed.dart';

class ChannelCatagoryBloc
    extends Bloc<ChannelCatagoryEvent, ChannelCatagoryState> {
  final ChannelCatagoryUsecase _channelCatagoryUsecase;
  ChannelCatagoryBloc({required ChannelCatagoryUsecase channelCatagoryUsecase})
    : _channelCatagoryUsecase = channelCatagoryUsecase,
      super(ChannelCatagoryState()) {
    on<_AllChannelCategory>((event, emit) async {
      emit(state.copyWith(channelCatagoryStatus: Status.loading));
      final result = await _channelCatagoryUsecase();
      if (result.isNotEmpty) {
        emit(
          state.copyWith(
            channelCatagoryList: result,
            channelCatagoryStatus: Status.success,
          ),
        );
      } else if (result.isEmpty) {
        emit(state.copyWith(channelCatagoryStatus: Status.success));
      } else {
        emit(state.copyWith(channelCatagoryStatus: Status.error));
      }
    });
  }
}
