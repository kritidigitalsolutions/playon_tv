part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.otp(String value) = _Otp;
  const factory AuthEvent.deviceName(String value) = _DeviceName;
  const factory AuthEvent.loginTv() = _LoginTv;
  const factory AuthEvent.fetchUser() = _FetchUser;
}