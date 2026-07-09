import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:playon/core/models/response/high_light_model.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/feature/highlights/usecase/all_highlight_usecase.dart';

part 'highlight_event.dart';
part 'highlight_state.dart';
part 'highlight_bloc.freezed.dart';

class HighlightBloc extends Bloc<HighlightEvent, HighlightState> {
  final AllHighlightUsecase _allHighlightUsecase;

  HighlightBloc({required AllHighlightUsecase highlightUsecase})
    : _allHighlightUsecase = highlightUsecase,
      super(const HighlightState()) {
    on<_FetchHighLight>(_onFetchHighLight);
    on<_FetchHighLightMore>(_onFetchHighLightMore);
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
}
