part of 'highlight_bloc.dart';

@freezed
abstract class HighlightState with _$HighlightState {
  const factory HighlightState({
    @Default([]) List<HighlightModel> highlights,
    @Default(1) int page,
    @Default(10) int pageSize,
    @Default(0) int total,
    @Default(0) int totalPages,
    @Default(Status.init) Status allHighLightStatus,
    @Default(Status.init) Status moreHighLightStatus,
  }) = _HighlightState;
}