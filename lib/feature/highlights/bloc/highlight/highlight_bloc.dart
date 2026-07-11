// ignore_for_file: prefer_initializing_formals

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:playon/core/models/response/high_light_detail_model.dart';
import 'package:playon/core/models/response/high_light_model.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/feature/highlights/usecase/all_highlight_usecase.dart';
import 'package:playon/feature/highlights/usecase/high_light_deatil_usecase.dart';

part 'highlight_event.dart';
part 'highlight_state.dart';
part 'highlight_bloc.freezed.dart';

class HighlightBloc extends Bloc<HighlightEvent, HighlightState> {
  final AllHighlightUsecase _allHighlightUsecase;
  final HighLightDeatilUsecase _highLightDeatilUsecase;
  HighlightBloc({
    required AllHighlightUsecase allHighlightUsecase,
    required HighLightDeatilUsecase highlightDeatilUsecase, 
  }) : _highLightDeatilUsecase = highlightDeatilUsecase,
       _allHighlightUsecase = allHighlightUsecase,
       super(const HighlightState()) {
    on<_FetchHighLight>(_onFetchHighLight);
    on<_FetchHighLightMore>(_onFetchHighLightMore);
    on<_HightLightDetail>(_onHighlightDetail);
  }

  Future<void> _onFetchHighLight(
    _FetchHighLight event,
    Emitter<HighlightState> emit,
  ) async {
    emit(state.copyWith(allHighLightStatus: Status.loading, page: 1));

    try {
      final result = await _allHighlightUsecase(page: 1, limit: state.pageSize);

      emit(
        state.copyWith(
          highlights: result,
          allHighLightStatus: Status.success,
          page: 1,
        ),
      );
    } catch (_) {
      emit(state.copyWith(allHighLightStatus: Status.error));
    }
  }

  Future<void> _onFetchHighLightMore(
    _FetchHighLightMore event,
    Emitter<HighlightState> emit,
  ) async {
    // guard: don't fetch more if already loading more,
    // or if the initial load hasn't succeeded yet
    if (state.moreHighLightStatus == Status.loading ||
        state.allHighLightStatus != Status.success) {
      return;
    }

    final nextPage = state.page + 1;

    emit(state.copyWith(moreHighLightStatus: Status.loading));

    try {
      final result = await _allHighlightUsecase(
        page: nextPage,
        limit: state.pageSize,
      );

      if (result.isEmpty) {
        // no more data to load
        emit(state.copyWith(moreHighLightStatus: Status.success));
        return;
      }

      emit(
        state.copyWith(
          highlights: [...state.highlights, ...result],
          page: nextPage,
          moreHighLightStatus: Status.success,
        ),
      );
    } catch (_) {
      emit(state.copyWith(moreHighLightStatus: Status.error));
    }
  }

  Future<void> _onHighlightDetail(
    _HightLightDetail event,
    Emitter<HighlightState> emit,
  ) async {
    emit(state.copyWith(highlightDetailStatus: Status.loading));

    try {
      final result = await _highLightDeatilUsecase(id:event.id);

      emit(
        state.copyWith(
          highlightDetail: result,
          highlightDetailStatus: Status.success,
        ),
      );
    } catch (_) {
      emit(state.copyWith(highlightDetailStatus: Status.error));
    }
  }
}
