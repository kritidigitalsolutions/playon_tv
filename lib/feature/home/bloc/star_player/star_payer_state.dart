part of 'star_payer_cubit.dart';

@freezed
abstract class StarPayerState with _$StarPayerState {
  const factory StarPayerState({
    @Default([])List<StarPlayerModel> starPlayers,
    @Default(Status.init)Status allPlayerStatus,
  }) = _StarPayerState;
}
