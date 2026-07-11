part of 'series_bloc.dart';

@freezed
class SeriesEvent with _$SeriesEvent {
  const factory SeriesEvent.getSeriesList() = _GetSeriesList;
  const factory SeriesEvent.getMoreSeriesList() = _GetMoreSeriesList;
  const factory SeriesEvent.getSeriesDetail({required String id}) = _GetSeriesDetail;
}