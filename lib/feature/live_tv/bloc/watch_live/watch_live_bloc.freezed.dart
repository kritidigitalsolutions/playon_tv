// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watch_live_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WatchLiveEvent {

 String get slug;
/// Create a copy of WatchLiveEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchLiveEventCopyWith<WatchLiveEvent> get copyWith => _$WatchLiveEventCopyWithImpl<WatchLiveEvent>(this as WatchLiveEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchLiveEvent&&(identical(other.slug, slug) || other.slug == slug));
}


@override
int get hashCode => Object.hash(runtimeType,slug);

@override
String toString() {
  return 'WatchLiveEvent(slug: $slug)';
}


}

/// @nodoc
abstract mixin class $WatchLiveEventCopyWith<$Res>  {
  factory $WatchLiveEventCopyWith(WatchLiveEvent value, $Res Function(WatchLiveEvent) _then) = _$WatchLiveEventCopyWithImpl;
@useResult
$Res call({
 String slug
});




}
/// @nodoc
class _$WatchLiveEventCopyWithImpl<$Res>
    implements $WatchLiveEventCopyWith<$Res> {
  _$WatchLiveEventCopyWithImpl(this._self, this._then);

  final WatchLiveEvent _self;
  final $Res Function(WatchLiveEvent) _then;

/// Create a copy of WatchLiveEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slug = null,}) {
  return _then(_self.copyWith(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WatchLiveEvent].
extension WatchLiveEventPatterns on WatchLiveEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _WatchLiveChannel value)?  watchLiveChannel,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchLiveChannel() when watchLiveChannel != null:
return watchLiveChannel(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _WatchLiveChannel value)  watchLiveChannel,}){
final _that = this;
switch (_that) {
case _WatchLiveChannel():
return watchLiveChannel(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _WatchLiveChannel value)?  watchLiveChannel,}){
final _that = this;
switch (_that) {
case _WatchLiveChannel() when watchLiveChannel != null:
return watchLiveChannel(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String slug)?  watchLiveChannel,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchLiveChannel() when watchLiveChannel != null:
return watchLiveChannel(_that.slug);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String slug)  watchLiveChannel,}) {final _that = this;
switch (_that) {
case _WatchLiveChannel():
return watchLiveChannel(_that.slug);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String slug)?  watchLiveChannel,}) {final _that = this;
switch (_that) {
case _WatchLiveChannel() when watchLiveChannel != null:
return watchLiveChannel(_that.slug);case _:
  return null;

}
}

}

/// @nodoc


class _WatchLiveChannel implements WatchLiveEvent {
  const _WatchLiveChannel({required this.slug});
  

@override final  String slug;

/// Create a copy of WatchLiveEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchLiveChannelCopyWith<_WatchLiveChannel> get copyWith => __$WatchLiveChannelCopyWithImpl<_WatchLiveChannel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchLiveChannel&&(identical(other.slug, slug) || other.slug == slug));
}


@override
int get hashCode => Object.hash(runtimeType,slug);

@override
String toString() {
  return 'WatchLiveEvent.watchLiveChannel(slug: $slug)';
}


}

/// @nodoc
abstract mixin class _$WatchLiveChannelCopyWith<$Res> implements $WatchLiveEventCopyWith<$Res> {
  factory _$WatchLiveChannelCopyWith(_WatchLiveChannel value, $Res Function(_WatchLiveChannel) _then) = __$WatchLiveChannelCopyWithImpl;
@override @useResult
$Res call({
 String slug
});




}
/// @nodoc
class __$WatchLiveChannelCopyWithImpl<$Res>
    implements _$WatchLiveChannelCopyWith<$Res> {
  __$WatchLiveChannelCopyWithImpl(this._self, this._then);

  final _WatchLiveChannel _self;
  final $Res Function(_WatchLiveChannel) _then;

/// Create a copy of WatchLiveEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slug = null,}) {
  return _then(_WatchLiveChannel(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$WatchLiveState {

 Status get isLiveWatch; ChannelStreamResponse? get channelStreamResponse;
/// Create a copy of WatchLiveState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchLiveStateCopyWith<WatchLiveState> get copyWith => _$WatchLiveStateCopyWithImpl<WatchLiveState>(this as WatchLiveState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchLiveState&&(identical(other.isLiveWatch, isLiveWatch) || other.isLiveWatch == isLiveWatch)&&(identical(other.channelStreamResponse, channelStreamResponse) || other.channelStreamResponse == channelStreamResponse));
}


@override
int get hashCode => Object.hash(runtimeType,isLiveWatch,channelStreamResponse);

@override
String toString() {
  return 'WatchLiveState(isLiveWatch: $isLiveWatch, channelStreamResponse: $channelStreamResponse)';
}


}

/// @nodoc
abstract mixin class $WatchLiveStateCopyWith<$Res>  {
  factory $WatchLiveStateCopyWith(WatchLiveState value, $Res Function(WatchLiveState) _then) = _$WatchLiveStateCopyWithImpl;
@useResult
$Res call({
 Status isLiveWatch, ChannelStreamResponse? channelStreamResponse
});




}
/// @nodoc
class _$WatchLiveStateCopyWithImpl<$Res>
    implements $WatchLiveStateCopyWith<$Res> {
  _$WatchLiveStateCopyWithImpl(this._self, this._then);

  final WatchLiveState _self;
  final $Res Function(WatchLiveState) _then;

/// Create a copy of WatchLiveState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLiveWatch = null,Object? channelStreamResponse = freezed,}) {
  return _then(_self.copyWith(
isLiveWatch: null == isLiveWatch ? _self.isLiveWatch : isLiveWatch // ignore: cast_nullable_to_non_nullable
as Status,channelStreamResponse: freezed == channelStreamResponse ? _self.channelStreamResponse : channelStreamResponse // ignore: cast_nullable_to_non_nullable
as ChannelStreamResponse?,
  ));
}

}


/// Adds pattern-matching-related methods to [WatchLiveState].
extension WatchLiveStatePatterns on WatchLiveState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchLiveState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchLiveState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchLiveState value)  $default,){
final _that = this;
switch (_that) {
case _WatchLiveState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchLiveState value)?  $default,){
final _that = this;
switch (_that) {
case _WatchLiveState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Status isLiveWatch,  ChannelStreamResponse? channelStreamResponse)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchLiveState() when $default != null:
return $default(_that.isLiveWatch,_that.channelStreamResponse);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Status isLiveWatch,  ChannelStreamResponse? channelStreamResponse)  $default,) {final _that = this;
switch (_that) {
case _WatchLiveState():
return $default(_that.isLiveWatch,_that.channelStreamResponse);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Status isLiveWatch,  ChannelStreamResponse? channelStreamResponse)?  $default,) {final _that = this;
switch (_that) {
case _WatchLiveState() when $default != null:
return $default(_that.isLiveWatch,_that.channelStreamResponse);case _:
  return null;

}
}

}

/// @nodoc


class _WatchLiveState implements WatchLiveState {
  const _WatchLiveState({this.isLiveWatch = Status.init, this.channelStreamResponse = null});
  

@override@JsonKey() final  Status isLiveWatch;
@override@JsonKey() final  ChannelStreamResponse? channelStreamResponse;

/// Create a copy of WatchLiveState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchLiveStateCopyWith<_WatchLiveState> get copyWith => __$WatchLiveStateCopyWithImpl<_WatchLiveState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchLiveState&&(identical(other.isLiveWatch, isLiveWatch) || other.isLiveWatch == isLiveWatch)&&(identical(other.channelStreamResponse, channelStreamResponse) || other.channelStreamResponse == channelStreamResponse));
}


@override
int get hashCode => Object.hash(runtimeType,isLiveWatch,channelStreamResponse);

@override
String toString() {
  return 'WatchLiveState(isLiveWatch: $isLiveWatch, channelStreamResponse: $channelStreamResponse)';
}


}

/// @nodoc
abstract mixin class _$WatchLiveStateCopyWith<$Res> implements $WatchLiveStateCopyWith<$Res> {
  factory _$WatchLiveStateCopyWith(_WatchLiveState value, $Res Function(_WatchLiveState) _then) = __$WatchLiveStateCopyWithImpl;
@override @useResult
$Res call({
 Status isLiveWatch, ChannelStreamResponse? channelStreamResponse
});




}
/// @nodoc
class __$WatchLiveStateCopyWithImpl<$Res>
    implements _$WatchLiveStateCopyWith<$Res> {
  __$WatchLiveStateCopyWithImpl(this._self, this._then);

  final _WatchLiveState _self;
  final $Res Function(_WatchLiveState) _then;

/// Create a copy of WatchLiveState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLiveWatch = null,Object? channelStreamResponse = freezed,}) {
  return _then(_WatchLiveState(
isLiveWatch: null == isLiveWatch ? _self.isLiveWatch : isLiveWatch // ignore: cast_nullable_to_non_nullable
as Status,channelStreamResponse: freezed == channelStreamResponse ? _self.channelStreamResponse : channelStreamResponse // ignore: cast_nullable_to_non_nullable
as ChannelStreamResponse?,
  ));
}


}

// dart format on
