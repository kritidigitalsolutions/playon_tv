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

 StarPlayerResponse? get starPlayers; Status get allPlayerStatus; StarPlayerDetailResponse? get starPlayerDetail; Status get starPlayerDetailStatus; PlayerResponse? get searchPlayers; Status get searchPlayerStatus; String get search;
/// Create a copy of StarPayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StarPayerStateCopyWith<StarPayerState> get copyWith => _$StarPayerStateCopyWithImpl<StarPayerState>(this as StarPayerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StarPayerState&&(identical(other.starPlayers, starPlayers) || other.starPlayers == starPlayers)&&(identical(other.allPlayerStatus, allPlayerStatus) || other.allPlayerStatus == allPlayerStatus)&&(identical(other.starPlayerDetail, starPlayerDetail) || other.starPlayerDetail == starPlayerDetail)&&(identical(other.starPlayerDetailStatus, starPlayerDetailStatus) || other.starPlayerDetailStatus == starPlayerDetailStatus)&&(identical(other.searchPlayers, searchPlayers) || other.searchPlayers == searchPlayers)&&(identical(other.searchPlayerStatus, searchPlayerStatus) || other.searchPlayerStatus == searchPlayerStatus)&&(identical(other.search, search) || other.search == search));
}


@override
int get hashCode => Object.hash(runtimeType,starPlayers,allPlayerStatus,starPlayerDetail,starPlayerDetailStatus,searchPlayers,searchPlayerStatus,search);

@override
String toString() {
  return 'StarPayerState(starPlayers: $starPlayers, allPlayerStatus: $allPlayerStatus, starPlayerDetail: $starPlayerDetail, starPlayerDetailStatus: $starPlayerDetailStatus, searchPlayers: $searchPlayers, searchPlayerStatus: $searchPlayerStatus, search: $search)';
}


}

/// @nodoc
abstract mixin class $StarPayerStateCopyWith<$Res>  {
  factory $StarPayerStateCopyWith(StarPayerState value, $Res Function(StarPayerState) _then) = _$StarPayerStateCopyWithImpl;
@useResult
$Res call({
 StarPlayerResponse? starPlayers, Status allPlayerStatus, StarPlayerDetailResponse? starPlayerDetail, Status starPlayerDetailStatus, PlayerResponse? searchPlayers, Status searchPlayerStatus, String search
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
@pragma('vm:prefer-inline') @override $Res call({Object? starPlayers = freezed,Object? allPlayerStatus = null,Object? starPlayerDetail = freezed,Object? starPlayerDetailStatus = null,Object? searchPlayers = freezed,Object? searchPlayerStatus = null,Object? search = null,}) {
  return _then(_self.copyWith(
starPlayers: freezed == starPlayers ? _self.starPlayers : starPlayers // ignore: cast_nullable_to_non_nullable
as StarPlayerResponse?,allPlayerStatus: null == allPlayerStatus ? _self.allPlayerStatus : allPlayerStatus // ignore: cast_nullable_to_non_nullable
as Status,starPlayerDetail: freezed == starPlayerDetail ? _self.starPlayerDetail : starPlayerDetail // ignore: cast_nullable_to_non_nullable
as StarPlayerDetailResponse?,starPlayerDetailStatus: null == starPlayerDetailStatus ? _self.starPlayerDetailStatus : starPlayerDetailStatus // ignore: cast_nullable_to_non_nullable
as Status,searchPlayers: freezed == searchPlayers ? _self.searchPlayers : searchPlayers // ignore: cast_nullable_to_non_nullable
as PlayerResponse?,searchPlayerStatus: null == searchPlayerStatus ? _self.searchPlayerStatus : searchPlayerStatus // ignore: cast_nullable_to_non_nullable
as Status,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StarPlayerResponse? starPlayers,  Status allPlayerStatus,  StarPlayerDetailResponse? starPlayerDetail,  Status starPlayerDetailStatus,  PlayerResponse? searchPlayers,  Status searchPlayerStatus,  String search)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StarPayerState() when $default != null:
return $default(_that.starPlayers,_that.allPlayerStatus,_that.starPlayerDetail,_that.starPlayerDetailStatus,_that.searchPlayers,_that.searchPlayerStatus,_that.search);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StarPlayerResponse? starPlayers,  Status allPlayerStatus,  StarPlayerDetailResponse? starPlayerDetail,  Status starPlayerDetailStatus,  PlayerResponse? searchPlayers,  Status searchPlayerStatus,  String search)  $default,) {final _that = this;
switch (_that) {
case _StarPayerState():
return $default(_that.starPlayers,_that.allPlayerStatus,_that.starPlayerDetail,_that.starPlayerDetailStatus,_that.searchPlayers,_that.searchPlayerStatus,_that.search);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StarPlayerResponse? starPlayers,  Status allPlayerStatus,  StarPlayerDetailResponse? starPlayerDetail,  Status starPlayerDetailStatus,  PlayerResponse? searchPlayers,  Status searchPlayerStatus,  String search)?  $default,) {final _that = this;
switch (_that) {
case _StarPayerState() when $default != null:
return $default(_that.starPlayers,_that.allPlayerStatus,_that.starPlayerDetail,_that.starPlayerDetailStatus,_that.searchPlayers,_that.searchPlayerStatus,_that.search);case _:
  return null;

}
}

}

/// @nodoc


class _StarPayerState implements StarPayerState {
  const _StarPayerState({this.starPlayers = null, this.allPlayerStatus = Status.init, this.starPlayerDetail = null, this.starPlayerDetailStatus = Status.init, this.searchPlayers = null, this.searchPlayerStatus = Status.init, this.search = ""});
  

@override@JsonKey() final  StarPlayerResponse? starPlayers;
@override@JsonKey() final  Status allPlayerStatus;
@override@JsonKey() final  StarPlayerDetailResponse? starPlayerDetail;
@override@JsonKey() final  Status starPlayerDetailStatus;
@override@JsonKey() final  PlayerResponse? searchPlayers;
@override@JsonKey() final  Status searchPlayerStatus;
@override@JsonKey() final  String search;

/// Create a copy of StarPayerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StarPayerStateCopyWith<_StarPayerState> get copyWith => __$StarPayerStateCopyWithImpl<_StarPayerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StarPayerState&&(identical(other.starPlayers, starPlayers) || other.starPlayers == starPlayers)&&(identical(other.allPlayerStatus, allPlayerStatus) || other.allPlayerStatus == allPlayerStatus)&&(identical(other.starPlayerDetail, starPlayerDetail) || other.starPlayerDetail == starPlayerDetail)&&(identical(other.starPlayerDetailStatus, starPlayerDetailStatus) || other.starPlayerDetailStatus == starPlayerDetailStatus)&&(identical(other.searchPlayers, searchPlayers) || other.searchPlayers == searchPlayers)&&(identical(other.searchPlayerStatus, searchPlayerStatus) || other.searchPlayerStatus == searchPlayerStatus)&&(identical(other.search, search) || other.search == search));
}


@override
int get hashCode => Object.hash(runtimeType,starPlayers,allPlayerStatus,starPlayerDetail,starPlayerDetailStatus,searchPlayers,searchPlayerStatus,search);

@override
String toString() {
  return 'StarPayerState(starPlayers: $starPlayers, allPlayerStatus: $allPlayerStatus, starPlayerDetail: $starPlayerDetail, starPlayerDetailStatus: $starPlayerDetailStatus, searchPlayers: $searchPlayers, searchPlayerStatus: $searchPlayerStatus, search: $search)';
}


}

/// @nodoc
abstract mixin class _$StarPayerStateCopyWith<$Res> implements $StarPayerStateCopyWith<$Res> {
  factory _$StarPayerStateCopyWith(_StarPayerState value, $Res Function(_StarPayerState) _then) = __$StarPayerStateCopyWithImpl;
@override @useResult
$Res call({
 StarPlayerResponse? starPlayers, Status allPlayerStatus, StarPlayerDetailResponse? starPlayerDetail, Status starPlayerDetailStatus, PlayerResponse? searchPlayers, Status searchPlayerStatus, String search
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
@override @pragma('vm:prefer-inline') $Res call({Object? starPlayers = freezed,Object? allPlayerStatus = null,Object? starPlayerDetail = freezed,Object? starPlayerDetailStatus = null,Object? searchPlayers = freezed,Object? searchPlayerStatus = null,Object? search = null,}) {
  return _then(_StarPayerState(
starPlayers: freezed == starPlayers ? _self.starPlayers : starPlayers // ignore: cast_nullable_to_non_nullable
as StarPlayerResponse?,allPlayerStatus: null == allPlayerStatus ? _self.allPlayerStatus : allPlayerStatus // ignore: cast_nullable_to_non_nullable
as Status,starPlayerDetail: freezed == starPlayerDetail ? _self.starPlayerDetail : starPlayerDetail // ignore: cast_nullable_to_non_nullable
as StarPlayerDetailResponse?,starPlayerDetailStatus: null == starPlayerDetailStatus ? _self.starPlayerDetailStatus : starPlayerDetailStatus // ignore: cast_nullable_to_non_nullable
as Status,searchPlayers: freezed == searchPlayers ? _self.searchPlayers : searchPlayers // ignore: cast_nullable_to_non_nullable
as PlayerResponse?,searchPlayerStatus: null == searchPlayerStatus ? _self.searchPlayerStatus : searchPlayerStatus // ignore: cast_nullable_to_non_nullable
as Status,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
