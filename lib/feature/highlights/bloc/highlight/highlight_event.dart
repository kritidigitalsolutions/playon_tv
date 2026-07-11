part of 'highlight_bloc.dart';

@freezed
class HighlightEvent with _$HighlightEvent {
  const factory HighlightEvent.fetchHighLight() = _FetchHighLight;
  const factory HighlightEvent.fetchHighLightMore() = _FetchHighLightMore;
  const factory HighlightEvent.highlightDetail({required String id})=_HightLightDetail;
}