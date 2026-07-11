// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_media_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SocialMediaState {

 List<SocialModel> get socialMedia; Status get socialMediaStatus;
/// Create a copy of SocialMediaState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SocialMediaStateCopyWith<SocialMediaState> get copyWith => _$SocialMediaStateCopyWithImpl<SocialMediaState>(this as SocialMediaState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SocialMediaState&&const DeepCollectionEquality().equals(other.socialMedia, socialMedia)&&(identical(other.socialMediaStatus, socialMediaStatus) || other.socialMediaStatus == socialMediaStatus));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(socialMedia),socialMediaStatus);

@override
String toString() {
  return 'SocialMediaState(socialMedia: $socialMedia, socialMediaStatus: $socialMediaStatus)';
}


}

/// @nodoc
abstract mixin class $SocialMediaStateCopyWith<$Res>  {
  factory $SocialMediaStateCopyWith(SocialMediaState value, $Res Function(SocialMediaState) _then) = _$SocialMediaStateCopyWithImpl;
@useResult
$Res call({
 List<SocialModel> socialMedia, Status socialMediaStatus
});




}
/// @nodoc
class _$SocialMediaStateCopyWithImpl<$Res>
    implements $SocialMediaStateCopyWith<$Res> {
  _$SocialMediaStateCopyWithImpl(this._self, this._then);

  final SocialMediaState _self;
  final $Res Function(SocialMediaState) _then;

/// Create a copy of SocialMediaState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? socialMedia = null,Object? socialMediaStatus = null,}) {
  return _then(_self.copyWith(
socialMedia: null == socialMedia ? _self.socialMedia : socialMedia // ignore: cast_nullable_to_non_nullable
as List<SocialModel>,socialMediaStatus: null == socialMediaStatus ? _self.socialMediaStatus : socialMediaStatus // ignore: cast_nullable_to_non_nullable
as Status,
  ));
}

}


/// Adds pattern-matching-related methods to [SocialMediaState].
extension SocialMediaStatePatterns on SocialMediaState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SocialMediaState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SocialMediaState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SocialMediaState value)  $default,){
final _that = this;
switch (_that) {
case _SocialMediaState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SocialMediaState value)?  $default,){
final _that = this;
switch (_that) {
case _SocialMediaState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SocialModel> socialMedia,  Status socialMediaStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SocialMediaState() when $default != null:
return $default(_that.socialMedia,_that.socialMediaStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SocialModel> socialMedia,  Status socialMediaStatus)  $default,) {final _that = this;
switch (_that) {
case _SocialMediaState():
return $default(_that.socialMedia,_that.socialMediaStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SocialModel> socialMedia,  Status socialMediaStatus)?  $default,) {final _that = this;
switch (_that) {
case _SocialMediaState() when $default != null:
return $default(_that.socialMedia,_that.socialMediaStatus);case _:
  return null;

}
}

}

/// @nodoc


class _SocialMediaState implements SocialMediaState {
  const _SocialMediaState({final  List<SocialModel> socialMedia = const [], this.socialMediaStatus = Status.init}): _socialMedia = socialMedia;
  

 final  List<SocialModel> _socialMedia;
@override@JsonKey() List<SocialModel> get socialMedia {
  if (_socialMedia is EqualUnmodifiableListView) return _socialMedia;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_socialMedia);
}

@override@JsonKey() final  Status socialMediaStatus;

/// Create a copy of SocialMediaState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SocialMediaStateCopyWith<_SocialMediaState> get copyWith => __$SocialMediaStateCopyWithImpl<_SocialMediaState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SocialMediaState&&const DeepCollectionEquality().equals(other._socialMedia, _socialMedia)&&(identical(other.socialMediaStatus, socialMediaStatus) || other.socialMediaStatus == socialMediaStatus));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_socialMedia),socialMediaStatus);

@override
String toString() {
  return 'SocialMediaState(socialMedia: $socialMedia, socialMediaStatus: $socialMediaStatus)';
}


}

/// @nodoc
abstract mixin class _$SocialMediaStateCopyWith<$Res> implements $SocialMediaStateCopyWith<$Res> {
  factory _$SocialMediaStateCopyWith(_SocialMediaState value, $Res Function(_SocialMediaState) _then) = __$SocialMediaStateCopyWithImpl;
@override @useResult
$Res call({
 List<SocialModel> socialMedia, Status socialMediaStatus
});




}
/// @nodoc
class __$SocialMediaStateCopyWithImpl<$Res>
    implements _$SocialMediaStateCopyWith<$Res> {
  __$SocialMediaStateCopyWithImpl(this._self, this._then);

  final _SocialMediaState _self;
  final $Res Function(_SocialMediaState) _then;

/// Create a copy of SocialMediaState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? socialMedia = null,Object? socialMediaStatus = null,}) {
  return _then(_SocialMediaState(
socialMedia: null == socialMedia ? _self._socialMedia : socialMedia // ignore: cast_nullable_to_non_nullable
as List<SocialModel>,socialMediaStatus: null == socialMediaStatus ? _self.socialMediaStatus : socialMediaStatus // ignore: cast_nullable_to_non_nullable
as Status,
  ));
}


}

// dart format on
