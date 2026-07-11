// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channels_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChannelsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChannelsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChannelsEvent()';
}


}

/// @nodoc
class $ChannelsEventCopyWith<$Res>  {
$ChannelsEventCopyWith(ChannelsEvent _, $Res Function(ChannelsEvent) __);
}


/// Adds pattern-matching-related methods to [ChannelsEvent].
extension ChannelsEventPatterns on ChannelsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Search value)?  search,TResult Function( _AllChannels value)?  allChannels,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Search() when search != null:
return search(_that);case _AllChannels() when allChannels != null:
return allChannels(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Search value)  search,required TResult Function( _AllChannels value)  allChannels,}){
final _that = this;
switch (_that) {
case _Search():
return search(_that);case _AllChannels():
return allChannels(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Search value)?  search,TResult? Function( _AllChannels value)?  allChannels,}){
final _that = this;
switch (_that) {
case _Search() when search != null:
return search(_that);case _AllChannels() when allChannels != null:
return allChannels(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String value)?  search,TResult Function( String? search)?  allChannels,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Search() when search != null:
return search(_that.value);case _AllChannels() when allChannels != null:
return allChannels(_that.search);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String value)  search,required TResult Function( String? search)  allChannels,}) {final _that = this;
switch (_that) {
case _Search():
return search(_that.value);case _AllChannels():
return allChannels(_that.search);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String value)?  search,TResult? Function( String? search)?  allChannels,}) {final _that = this;
switch (_that) {
case _Search() when search != null:
return search(_that.value);case _AllChannels() when allChannels != null:
return allChannels(_that.search);case _:
  return null;

}
}

}

/// @nodoc


class _Search implements ChannelsEvent {
  const _Search(this.value);
  

 final  String value;

/// Create a copy of ChannelsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchCopyWith<_Search> get copyWith => __$SearchCopyWithImpl<_Search>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Search&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'ChannelsEvent.search(value: $value)';
}


}

/// @nodoc
abstract mixin class _$SearchCopyWith<$Res> implements $ChannelsEventCopyWith<$Res> {
  factory _$SearchCopyWith(_Search value, $Res Function(_Search) _then) = __$SearchCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class __$SearchCopyWithImpl<$Res>
    implements _$SearchCopyWith<$Res> {
  __$SearchCopyWithImpl(this._self, this._then);

  final _Search _self;
  final $Res Function(_Search) _then;

/// Create a copy of ChannelsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_Search(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _AllChannels implements ChannelsEvent {
  const _AllChannels({this.search});
  

 final  String? search;

/// Create a copy of ChannelsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AllChannelsCopyWith<_AllChannels> get copyWith => __$AllChannelsCopyWithImpl<_AllChannels>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AllChannels&&(identical(other.search, search) || other.search == search));
}


@override
int get hashCode => Object.hash(runtimeType,search);

@override
String toString() {
  return 'ChannelsEvent.allChannels(search: $search)';
}


}

/// @nodoc
abstract mixin class _$AllChannelsCopyWith<$Res> implements $ChannelsEventCopyWith<$Res> {
  factory _$AllChannelsCopyWith(_AllChannels value, $Res Function(_AllChannels) _then) = __$AllChannelsCopyWithImpl;
@useResult
$Res call({
 String? search
});




}
/// @nodoc
class __$AllChannelsCopyWithImpl<$Res>
    implements _$AllChannelsCopyWith<$Res> {
  __$AllChannelsCopyWithImpl(this._self, this._then);

  final _AllChannels _self;
  final $Res Function(_AllChannels) _then;

/// Create a copy of ChannelsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? search = freezed,}) {
  return _then(_AllChannels(
search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ChannelsState {

 List<ChannelModel> get channels; Status get channelsStatus; String get search;
/// Create a copy of ChannelsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChannelsStateCopyWith<ChannelsState> get copyWith => _$ChannelsStateCopyWithImpl<ChannelsState>(this as ChannelsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChannelsState&&const DeepCollectionEquality().equals(other.channels, channels)&&(identical(other.channelsStatus, channelsStatus) || other.channelsStatus == channelsStatus)&&(identical(other.search, search) || other.search == search));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(channels),channelsStatus,search);

@override
String toString() {
  return 'ChannelsState(channels: $channels, channelsStatus: $channelsStatus, search: $search)';
}


}

/// @nodoc
abstract mixin class $ChannelsStateCopyWith<$Res>  {
  factory $ChannelsStateCopyWith(ChannelsState value, $Res Function(ChannelsState) _then) = _$ChannelsStateCopyWithImpl;
@useResult
$Res call({
 List<ChannelModel> channels, Status channelsStatus, String search
});




}
/// @nodoc
class _$ChannelsStateCopyWithImpl<$Res>
    implements $ChannelsStateCopyWith<$Res> {
  _$ChannelsStateCopyWithImpl(this._self, this._then);

  final ChannelsState _self;
  final $Res Function(ChannelsState) _then;

/// Create a copy of ChannelsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? channels = null,Object? channelsStatus = null,Object? search = null,}) {
  return _then(_self.copyWith(
channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as List<ChannelModel>,channelsStatus: null == channelsStatus ? _self.channelsStatus : channelsStatus // ignore: cast_nullable_to_non_nullable
as Status,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChannelsState].
extension ChannelsStatePatterns on ChannelsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChannelsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChannelsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChannelsState value)  $default,){
final _that = this;
switch (_that) {
case _ChannelsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChannelsState value)?  $default,){
final _that = this;
switch (_that) {
case _ChannelsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ChannelModel> channels,  Status channelsStatus,  String search)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChannelsState() when $default != null:
return $default(_that.channels,_that.channelsStatus,_that.search);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ChannelModel> channels,  Status channelsStatus,  String search)  $default,) {final _that = this;
switch (_that) {
case _ChannelsState():
return $default(_that.channels,_that.channelsStatus,_that.search);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ChannelModel> channels,  Status channelsStatus,  String search)?  $default,) {final _that = this;
switch (_that) {
case _ChannelsState() when $default != null:
return $default(_that.channels,_that.channelsStatus,_that.search);case _:
  return null;

}
}

}

/// @nodoc


class _ChannelsState implements ChannelsState {
  const _ChannelsState({final  List<ChannelModel> channels = const [], this.channelsStatus = Status.init, this.search = ""}): _channels = channels;
  

 final  List<ChannelModel> _channels;
@override@JsonKey() List<ChannelModel> get channels {
  if (_channels is EqualUnmodifiableListView) return _channels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_channels);
}

@override@JsonKey() final  Status channelsStatus;
@override@JsonKey() final  String search;

/// Create a copy of ChannelsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChannelsStateCopyWith<_ChannelsState> get copyWith => __$ChannelsStateCopyWithImpl<_ChannelsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChannelsState&&const DeepCollectionEquality().equals(other._channels, _channels)&&(identical(other.channelsStatus, channelsStatus) || other.channelsStatus == channelsStatus)&&(identical(other.search, search) || other.search == search));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_channels),channelsStatus,search);

@override
String toString() {
  return 'ChannelsState(channels: $channels, channelsStatus: $channelsStatus, search: $search)';
}


}

/// @nodoc
abstract mixin class _$ChannelsStateCopyWith<$Res> implements $ChannelsStateCopyWith<$Res> {
  factory _$ChannelsStateCopyWith(_ChannelsState value, $Res Function(_ChannelsState) _then) = __$ChannelsStateCopyWithImpl;
@override @useResult
$Res call({
 List<ChannelModel> channels, Status channelsStatus, String search
});




}
/// @nodoc
class __$ChannelsStateCopyWithImpl<$Res>
    implements _$ChannelsStateCopyWith<$Res> {
  __$ChannelsStateCopyWithImpl(this._self, this._then);

  final _ChannelsState _self;
  final $Res Function(_ChannelsState) _then;

/// Create a copy of ChannelsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? channels = null,Object? channelsStatus = null,Object? search = null,}) {
  return _then(_ChannelsState(
channels: null == channels ? _self._channels : channels // ignore: cast_nullable_to_non_nullable
as List<ChannelModel>,channelsStatus: null == channelsStatus ? _self.channelsStatus : channelsStatus // ignore: cast_nullable_to_non_nullable
as Status,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
