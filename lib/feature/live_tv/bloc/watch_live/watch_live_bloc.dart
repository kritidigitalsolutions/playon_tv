// ignore_for_file: prefer_initializing_formals

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:playon/core/models/response/channel_stream_response_model.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/feature/live_tv/usecase/watch_live_usecase.dart';

part 'watch_live_event.dart';
part 'watch_live_state.dart';
part 'watch_live_bloc.freezed.dart';

class WatchLiveBloc extends Bloc<WatchLiveEvent, WatchLiveState> {
  final WatchLiveUsecase _watchLiveUsecase;
  WatchLiveBloc({required WatchLiveUsecase watchLiveUsecase})
    : _watchLiveUsecase = watchLiveUsecase,
      super(WatchLiveState()) {
    on<_WatchLiveChannel>((event, emit) async {
      emit(state.copyWith(isLiveWatch: Status.loading));
      final result=await _watchLiveUsecase(slug: event.slug);
      if(result!=null){
        emit(state.copyWith(isLiveWatch: Status.success,channelStreamResponse: result));
      }else{
        emit(state.copyWith(isLiveWatch: Status.error));
      }
    });
  }
}
