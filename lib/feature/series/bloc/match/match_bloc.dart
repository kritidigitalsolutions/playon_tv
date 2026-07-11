import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:playon/core/models/response/match_detail_model.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/feature/series/usecase/match_detail_usecase.dart';

part 'match_event.dart';
part 'match_state.dart';
part 'match_bloc.freezed.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final MatchDetailUsecase _matchDetailUsecase;
  MatchBloc({required MatchDetailUsecase matchDetailUsecase})
    : _matchDetailUsecase = matchDetailUsecase,
      super(MatchState()) {
    on<_MatchDetail>((event, emit) async {
      emit(state.copyWith(status: Status.loading));
      final result = await _matchDetailUsecase(id: event.id);
      if (result != null) {
        emit(state.copyWith(matchDetail: result, status: Status.success));
      } else {
        emit(state.copyWith(status: Status.error));
      }
    });
  }
}
