// ignore_for_file: prefer_initializing_formals

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:playon/core/models/response/star_player_detail_model.dart';
import 'package:playon/core/models/response/star_player_model.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/feature/home/usecase/all_star_player_usecase.dart';
import 'package:playon/feature/home/usecase/star_player_detail_usecase.dart';

part 'star_payer_state.dart';
part 'star_payer_cubit.freezed.dart';

class StarPayerCubit extends Cubit<StarPayerState> {
  final AllStarPlayerUseCase _allStarPlayerUseCase;
  final StarPlayerDetailUseCase _starPlayerDetailUseCase;
  StarPayerCubit({
    required AllStarPlayerUseCase allStarPlayerUseCase,
    required StarPlayerDetailUseCase starPlayerDetailUseCase,
  }) : _allStarPlayerUseCase = allStarPlayerUseCase,
       _starPlayerDetailUseCase = starPlayerDetailUseCase,
       super(StarPayerState());

  void allStarPlayer() async {
    emit(state.copyWith(allPlayerStatus: Status.loading));
    final result = await _allStarPlayerUseCase();
    if (result !=null) {
      emit(
        state.copyWith(starPlayers: result, allPlayerStatus: Status.success),
      );
    } 
    else {
      emit(state.copyWith(allPlayerStatus: Status.error));
    }
  }

  void starPlayerDetail({required String id}) async {
    emit(state.copyWith(starPlayerDetailStatus: Status.loading));
    final result = await _starPlayerDetailUseCase(id: id);
    if (result != null) {
      emit(
        state.copyWith(
          starPlayerDetail: result,
          starPlayerDetailStatus: Status.success,
        ),
      );
    } else {
      emit(state.copyWith(starPlayerDetailStatus: Status.error));
    }
  }
}
