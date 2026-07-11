part of 'match_bloc.dart';

@freezed
abstract class MatchEvent with _$MatchEvent {
  const factory MatchEvent.matchDetail({required String id,}) = _MatchDetail;
}