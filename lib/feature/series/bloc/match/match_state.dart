part of 'match_bloc.dart';

@freezed
abstract class MatchState with _$MatchState {
  const factory MatchState({
    @Default(null) MatchDetailResponse? matchDetail,
    @Default(Status.init) Status status,
  })=_MatchState;
}
