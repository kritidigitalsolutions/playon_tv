part of 'series_bloc.dart';

@freezed
abstract class SeriesState with _$SeriesState {
  const factory SeriesState({
    @Default([]) List<SeriesModel> series,
    @Default(1) int page,
    @Default(10) int pageSize,
    @Default(0) int total,
    @Default(0) int totalPages,
    @Default(Status.init) Status allSeriesStatus,
    @Default(Status.init) Status moreSeriesStatus,
    @Default(null) SeriesDetailsResponse? seriesDetail,
    @Default(Status.init) Status seriesDetailStatus,
  }) = _SeriesState;
}
