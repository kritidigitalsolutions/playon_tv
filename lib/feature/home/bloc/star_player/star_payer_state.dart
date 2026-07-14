part of 'star_payer_cubit.dart';

@freezed
abstract class StarPayerState with _$StarPayerState {
  const factory StarPayerState({
    @Default(null)StarPlayerResponse? starPlayers,
    @Default(Status.init)Status allPlayerStatus,
    @Default(null)StarPlayerDetailResponse? starPlayerDetail,
    @Default(Status.init)Status starPlayerDetailStatus,
    @Default(null)PlayerResponse? searchPlayers,
    @Default(Status.init)Status searchPlayerStatus,
    @Default("")String search,
  }) = _StarPayerState;
}
