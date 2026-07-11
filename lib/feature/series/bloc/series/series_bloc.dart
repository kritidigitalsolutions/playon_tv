// ignore_for_file: prefer_initializing_formals

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:playon/core/models/response/series_detail_model.dart';
import 'package:playon/core/models/response/series_model.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/feature/series/usecase/all_series_usecase.dart';
import 'package:playon/feature/series/usecase/series_detail_usecase.dart';

part 'series_event.dart';
part 'series_state.dart';
part 'series_bloc.freezed.dart';

class SeriesBloc extends Bloc<SeriesEvent, SeriesState> {
  final AllSeriesUsecase _allSeriesUsecase;
  final SeriesDetailUsecase _seriesDetailUsecase;
  SeriesBloc(
    {
      required AllSeriesUsecase allSeriesUsecase,
      required SeriesDetailUsecase seriesDetailUsecase,
    }
  ) : _allSeriesUsecase = allSeriesUsecase,
   _seriesDetailUsecase = seriesDetailUsecase,
      super(SeriesState()) {
     on<_GetSeriesList>(_onFetchSeries);
     on<_GetSeriesDetail>(_onFetchSeriesDetail);
    on<_GetMoreSeriesList>(_onFetchSeriesMore);
   
  }Future<void> _onFetchSeries(
    _GetSeriesList event,
    Emitter<SeriesState> emit,
  ) async {
    emit(state.copyWith(allSeriesStatus: Status.loading, page: 1));

    try {
      final result = await _allSeriesUsecase(page: 1, limit: state.pageSize);

      emit(
        state.copyWith(
          series: result,
          allSeriesStatus: Status.success,
          page: 1,
        ),
      );
    } catch (_) {
      emit(state.copyWith(allSeriesStatus: Status.error));
    }
  }
  Future<void> _onFetchSeriesDetail(
    _GetSeriesDetail event,
    Emitter<SeriesState> emit,
  ) async {
    emit(state.copyWith(seriesDetailStatus: Status.loading));

    try {
      final result = await _seriesDetailUsecase(id: event.id);

      emit(
        state.copyWith(
          seriesDetail: result,
          seriesDetailStatus: Status.success,
        ),
      );
    } catch (_) {
      emit(state.copyWith(seriesDetailStatus: Status.error));
    }
  }
  Future<void> _onFetchSeriesMore(
    _GetMoreSeriesList event,
    Emitter<SeriesState> emit,
  ) async {
    // guard: don't fetch more if already loading more,
    // or if the initial load hasn't succeeded yet
    if (state.moreSeriesStatus == Status.loading ||
        state.allSeriesStatus != Status.success) {
      return;
    }

    final nextPage = state.page + 1;

    emit(state.copyWith(moreSeriesStatus: Status.loading));

    try {
      final result = await _allSeriesUsecase(
        page: nextPage,
        limit: state.pageSize,
      );

      if (result.isEmpty) {
        // no more data to load
        emit(state.copyWith(moreSeriesStatus: Status.success));
        return;
      }

      emit(
        state.copyWith(
          series: [...state.series, ...result],
          page: nextPage,
          moreSeriesStatus: Status.success,
        ),
      );
    } catch (_) {
      emit(state.copyWith(moreSeriesStatus: Status.error));
    }
  }
}


