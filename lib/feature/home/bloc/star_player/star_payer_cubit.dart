// ignore_for_file: prefer_initializing_formals

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:playon/core/models/response/star_player_model.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/feature/home/usecase/all_star_player_usecase.dart';

part 'star_payer_state.dart';
part 'star_payer_cubit.freezed.dart';

class StarPayerCubit extends Cubit<StarPayerState> {
  final AllStarPlayerUseCase _allStarPlayerUseCase;
  StarPayerCubit({required AllStarPlayerUseCase allStarPlayerUseCase})
    : _allStarPlayerUseCase = allStarPlayerUseCase,
      super(StarPayerState());

  void allStarPlayer() async {
    emit(state.copyWith(allPlayerStatus: Status.loading));
    final result = await _allStarPlayerUseCase();
    if (result.isNotEmpty) {
      emit(
        state.copyWith(starPlayers: result, allPlayerStatus: Status.success),
      );
    } else if (result.isEmpty) {
      emit(state.copyWith(allPlayerStatus: Status.success));
    } else {
      emit(state.copyWith(allPlayerStatus: Status.error));
    }
  }
}
