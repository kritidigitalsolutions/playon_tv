// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent()';
}


}

/// @nodoc
class $AuthEventCopyWith<$Res>  {
$AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}


/// Adds pattern-matching-related methods to [AuthEvent].
extension AuthEventPatterns on AuthEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Otp value)?  otp,TResult Function( _DeviceName value)?  deviceName,TResult Function( _LoginTv value)?  loginTv,TResult Function( _FetchUser value)?  fetchUser,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Otp() when otp != null:
return otp(_that);case _DeviceName() when deviceName != null:
return deviceName(_that);case _LoginTv() when loginTv != null:
return loginTv(_that);case _FetchUser() when fetchUser != null:
return fetchUser(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Otp value)  otp,required TResult Function( _DeviceName value)  deviceName,required TResult Function( _LoginTv value)  loginTv,required TResult Function( _FetchUser value)  fetchUser,}){
final _that = this;
switch (_that) {
case _Otp():
return otp(_that);case _DeviceName():
return deviceName(_that);case _LoginTv():
return loginTv(_that);case _FetchUser():
return fetchUser(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Otp value)?  otp,TResult? Function( _DeviceName value)?  deviceName,TResult? Function( _LoginTv value)?  loginTv,TResult? Function( _FetchUser value)?  fetchUser,}){
final _that = this;
switch (_that) {
case _Otp() when otp != null:
return otp(_that);case _DeviceName() when deviceName != null:
return deviceName(_that);case _LoginTv() when loginTv != null:
return loginTv(_that);case _FetchUser() when fetchUser != null:
return fetchUser(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String value)?  otp,TResult Function( String value)?  deviceName,TResult Function()?  loginTv,TResult Function()?  fetchUser,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Otp() when otp != null:
return otp(_that.value);case _DeviceName() when deviceName != null:
return deviceName(_that.value);case _LoginTv() when loginTv != null:
return loginTv();case _FetchUser() when fetchUser != null:
return fetchUser();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String value)  otp,required TResult Function( String value)  deviceName,required TResult Function()  loginTv,required TResult Function()  fetchUser,}) {final _that = this;
switch (_that) {
case _Otp():
return otp(_that.value);case _DeviceName():
return deviceName(_that.value);case _LoginTv():
return loginTv();case _FetchUser():
return fetchUser();case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String value)?  otp,TResult? Function( String value)?  deviceName,TResult? Function()?  loginTv,TResult? Function()?  fetchUser,}) {final _that = this;
switch (_that) {
case _Otp() when otp != null:
return otp(_that.value);case _DeviceName() when deviceName != null:
return deviceName(_that.value);case _LoginTv() when loginTv != null:
return loginTv();case _FetchUser() when fetchUser != null:
return fetchUser();case _:
  return null;

}
}

}

/// @nodoc


class _Otp implements AuthEvent {
  const _Otp(this.value);
  

 final  String value;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtpCopyWith<_Otp> get copyWith => __$OtpCopyWithImpl<_Otp>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Otp&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'AuthEvent.otp(value: $value)';
}


}

/// @nodoc
abstract mixin class _$OtpCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$OtpCopyWith(_Otp value, $Res Function(_Otp) _then) = __$OtpCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class __$OtpCopyWithImpl<$Res>
    implements _$OtpCopyWith<$Res> {
  __$OtpCopyWithImpl(this._self, this._then);

  final _Otp _self;
  final $Res Function(_Otp) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_Otp(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _DeviceName implements AuthEvent {
  const _DeviceName(this.value);
  

 final  String value;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceNameCopyWith<_DeviceName> get copyWith => __$DeviceNameCopyWithImpl<_DeviceName>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceName&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'AuthEvent.deviceName(value: $value)';
}


}

/// @nodoc
abstract mixin class _$DeviceNameCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$DeviceNameCopyWith(_DeviceName value, $Res Function(_DeviceName) _then) = __$DeviceNameCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class __$DeviceNameCopyWithImpl<$Res>
    implements _$DeviceNameCopyWith<$Res> {
  __$DeviceNameCopyWithImpl(this._self, this._then);

  final _DeviceName _self;
  final $Res Function(_DeviceName) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_DeviceName(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _LoginTv implements AuthEvent {
  const _LoginTv();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginTv);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.loginTv()';
}


}




/// @nodoc


class _FetchUser implements AuthEvent {
  const _FetchUser();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FetchUser);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.fetchUser()';
}


}




/// @nodoc
mixin _$AuthState {

 String get otp; String get devicename; Status get loginStatus; UserModel? get user; Status get fetchStatus;
/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStateCopyWith<AuthState> get copyWith => _$AuthStateCopyWithImpl<AuthState>(this as AuthState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState&&(identical(other.otp, otp) || other.otp == otp)&&(identical(other.devicename, devicename) || other.devicename == devicename)&&(identical(other.loginStatus, loginStatus) || other.loginStatus == loginStatus)&&(identical(other.user, user) || other.user == user)&&(identical(other.fetchStatus, fetchStatus) || other.fetchStatus == fetchStatus));
}


@override
int get hashCode => Object.hash(runtimeType,otp,devicename,loginStatus,user,fetchStatus);

@override
String toString() {
  return 'AuthState(otp: $otp, devicename: $devicename, loginStatus: $loginStatus, user: $user, fetchStatus: $fetchStatus)';
}


}

/// @nodoc
abstract mixin class $AuthStateCopyWith<$Res>  {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) _then) = _$AuthStateCopyWithImpl;
@useResult
$Res call({
 String otp, String devicename, Status loginStatus, UserModel? user, Status fetchStatus
});




}
/// @nodoc
class _$AuthStateCopyWithImpl<$Res>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._self, this._then);

  final AuthState _self;
  final $Res Function(AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? otp = null,Object? devicename = null,Object? loginStatus = null,Object? user = freezed,Object? fetchStatus = null,}) {
  return _then(_self.copyWith(
otp: null == otp ? _self.otp : otp // ignore: cast_nullable_to_non_nullable
as String,devicename: null == devicename ? _self.devicename : devicename // ignore: cast_nullable_to_non_nullable
as String,loginStatus: null == loginStatus ? _self.loginStatus : loginStatus // ignore: cast_nullable_to_non_nullable
as Status,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel?,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as Status,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthState value)  $default,){
final _that = this;
switch (_that) {
case _AuthState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String otp,  String devicename,  Status loginStatus,  UserModel? user,  Status fetchStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that.otp,_that.devicename,_that.loginStatus,_that.user,_that.fetchStatus);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String otp,  String devicename,  Status loginStatus,  UserModel? user,  Status fetchStatus)  $default,) {final _that = this;
switch (_that) {
case _AuthState():
return $default(_that.otp,_that.devicename,_that.loginStatus,_that.user,_that.fetchStatus);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String otp,  String devicename,  Status loginStatus,  UserModel? user,  Status fetchStatus)?  $default,) {final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that.otp,_that.devicename,_that.loginStatus,_that.user,_that.fetchStatus);case _:
  return null;

}
}

}

/// @nodoc


class _AuthState implements AuthState {
  const _AuthState({this.otp = "", this.devicename = "", this.loginStatus = Status.init, this.user = null, this.fetchStatus = Status.init});
  

@override@JsonKey() final  String otp;
@override@JsonKey() final  String devicename;
@override@JsonKey() final  Status loginStatus;
@override@JsonKey() final  UserModel? user;
@override@JsonKey() final  Status fetchStatus;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthStateCopyWith<_AuthState> get copyWith => __$AuthStateCopyWithImpl<_AuthState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthState&&(identical(other.otp, otp) || other.otp == otp)&&(identical(other.devicename, devicename) || other.devicename == devicename)&&(identical(other.loginStatus, loginStatus) || other.loginStatus == loginStatus)&&(identical(other.user, user) || other.user == user)&&(identical(other.fetchStatus, fetchStatus) || other.fetchStatus == fetchStatus));
}


@override
int get hashCode => Object.hash(runtimeType,otp,devicename,loginStatus,user,fetchStatus);

@override
String toString() {
  return 'AuthState(otp: $otp, devicename: $devicename, loginStatus: $loginStatus, user: $user, fetchStatus: $fetchStatus)';
}


}

/// @nodoc
abstract mixin class _$AuthStateCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthStateCopyWith(_AuthState value, $Res Function(_AuthState) _then) = __$AuthStateCopyWithImpl;
@override @useResult
$Res call({
 String otp, String devicename, Status loginStatus, UserModel? user, Status fetchStatus
});




}
/// @nodoc
class __$AuthStateCopyWithImpl<$Res>
    implements _$AuthStateCopyWith<$Res> {
  __$AuthStateCopyWithImpl(this._self, this._then);

  final _AuthState _self;
  final $Res Function(_AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? otp = null,Object? devicename = null,Object? loginStatus = null,Object? user = freezed,Object? fetchStatus = null,}) {
  return _then(_AuthState(
otp: null == otp ? _self.otp : otp // ignore: cast_nullable_to_non_nullable
as String,devicename: null == devicename ? _self.devicename : devicename // ignore: cast_nullable_to_non_nullable
as String,loginStatus: null == loginStatus ? _self.loginStatus : loginStatus // ignore: cast_nullable_to_non_nullable
as Status,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel?,fetchStatus: null == fetchStatus ? _self.fetchStatus : fetchStatus // ignore: cast_nullable_to_non_nullable
as Status,
  ));
}


}

// dart format on
