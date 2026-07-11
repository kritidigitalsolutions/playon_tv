// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'star_payer_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StarPayerState {

 List<StarPlayerModel> get starPlayers; Status get allPlayerStatus;
/// Create a copy of StarPayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StarPayerStateCopyWith<StarPayerState> get copyWith => _$StarPayerStateCopyWithImpl<StarPayerState>(this as StarPayerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StarPayerState&&const DeepCollectionEquality().equals(other.starPlayers, starPlayers)&&(identical(other.allPlayerStatus, allPlayerStatus) || other.allPlayerStatus == allPlayerStatus));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(starPlayers),allPlayerStatus);

@override
String toString() {
  return 'StarPayerState(starPlayers: $starPlayers, allPlayerStatus: $allPlayerStatus)';
}


}

/// @nodoc
abstract mixin class $StarPayerStateCopyWith<$Res>  {
  factory $StarPayerStateCopyWith(StarPayerState value, $Res Function(StarPayerState) _then) = _$StarPayerStateCopyWithImpl;
@useResult
$Res call({
 List<StarPlayerModel> starPlayers, Status allPlayerStatus
});




}
/// @nodoc
class _$StarPayerStateCopyWithImpl<$Res>
    implements $StarPayerStateCopyWith<$Res> {
  _$StarPayerStateCopyWithImpl(this._self, this._then);

  final StarPayerState _self;
  final $Res Function(StarPayerState) _then;

/// Create a copy of StarPayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? starPlayers = null,Object? allPlayerStatus = null,}) {
  return _then(_self.copyWith(
starPlayers: null == starPlayers ? _self.starPlayers : starPlayers // ignore: cast_nullable_to_non_nullable
as List<StarPlayerModel>,allPlayerStatus: null == allPlayerStatus ? _self.allPlayerStatus : allPlayerStatus // ignore: cast_nullable_to_non_nullable
as Status,
  ));
}

}


/// Adds pattern-matching-related methods to [StarPayerState].
extension StarPayerStatePatterns on StarPayerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StarPayerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StarPayerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StarPayerState value)  $default,){
final _that = this;
switch (_that) {
case _StarPayerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StarPayerState value)?  $default,){
final _that = this;
switch (_that) {
case _StarPayerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<StarPlayerModel> starPlayers,  Status allPlayerStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StarPayerState() when $default != null:
return $default(_that.starPlayers,_that.allPlayerStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<StarPlayerModel> starPlayers,  Status allPlayerStatus)  $default,) {final _that = this;
switch (_that) {
case _StarPayerState():
return $default(_that.starPlayers,_that.allPlayerStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<StarPlayerModel> starPlayers,  Status allPlayerStatus)?  $default,) {final _that = this;
switch (_that) {
case _StarPayerState() when $default != null:
return $default(_that.starPlayers,_that.allPlayerStatus);case _:
  return null;

}
}

}

/// @nodoc


class _StarPayerState implements StarPayerState {
  const _StarPayerState({final  List<StarPlayerModel> starPlayers = const [], this.allPlayerStatus = Status.init}): _starPlayers = starPlayers;
  

 final  List<StarPlayerModel> _starPlayers;
@override@JsonKey() List<StarPlayerModel> get starPlayers {
  if (_starPlayers is EqualUnmodifiableListView) return _starPlayers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_starPlayers);
}

@override@JsonKey() final  Status allPlayerStatus;

/// Create a copy of StarPayerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StarPayerStateCopyWith<_StarPayerState> get copyWith => __$StarPayerStateCopyWithImpl<_StarPayerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StarPayerState&&const DeepCollectionEquality().equals(other._starPlayers, _starPlayers)&&(identical(other.allPlayerStatus, allPlayerStatus) || other.allPlayerStatus == allPlayerStatus));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_starPlayers),allPlayerStatus);

@override
String toString() {
  return 'StarPayerState(starPlayers: $starPlayers, allPlayerStatus: $allPlayerStatus)';
}


}

/// @nodoc
abstract mixin class _$StarPayerStateCopyWith<$Res> implements $StarPayerStateCopyWith<$Res> {
  factory _$StarPayerStateCopyWith(_StarPayerState value, $Res Function(_StarPayerState) _then) = __$StarPayerStateCopyWithImpl;
@override @useResult
$Res call({
 List<StarPlayerModel> starPlayers, Status allPlayerStatus
});




}
/// @nodoc
class __$StarPayerStateCopyWithImpl<$Res>
    implements _$StarPayerStateCopyWith<$Res> {
  __$StarPayerStateCopyWithImpl(this._self, this._then);

  final _StarPayerState _self;
  final $Res Function(_StarPayerState) _then;

/// Create a copy of StarPayerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? starPlayers = null,Object? allPlayerStatus = null,}) {
  return _then(_StarPayerState(
starPlayers: null == starPlayers ? _self._starPlayers : starPlayers // ignore: cast_nullable_to_non_nullable
as List<StarPlayerModel>,allPlayerStatus: null == allPlayerStatus ? _self.allPlayerStatus : allPlayerStatus // ignore: cast_nullable_to_non_nullable
as Status,
  ));
}


}

// dart format on
