part of 'auth_bloc.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default("") String otp,
    @Default("")String devicename,
    @Default(Status.init)Status loginStatus,
    @Default(null)UserModel? user,
    @Default(Status.init)Status fetchStatus,
  })=_AuthState;
}
