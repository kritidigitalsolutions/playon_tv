// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_catagory_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChannelCatagoryEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChannelCatagoryEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChannelCatagoryEvent()';
}


}

/// @nodoc
class $ChannelCatagoryEventCopyWith<$Res>  {
$ChannelCatagoryEventCopyWith(ChannelCatagoryEvent _, $Res Function(ChannelCatagoryEvent) __);
}


/// Adds pattern-matching-related methods to [ChannelCatagoryEvent].
extension ChannelCatagoryEventPatterns on ChannelCatagoryEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AllChannelCategory value)?  allChannelCategory,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AllChannelCategory() when allChannelCategory != null:
return allChannelCategory(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AllChannelCategory value)  allChannelCategory,}){
final _that = this;
switch (_that) {
case _AllChannelCategory():
return allChannelCategory(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AllChannelCategory value)?  allChannelCategory,}){
final _that = this;
switch (_that) {
case _AllChannelCategory() when allChannelCategory != null:
return allChannelCategory(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  allChannelCategory,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AllChannelCategory() when allChannelCategory != null:
return allChannelCategory();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  allChannelCategory,}) {final _that = this;
switch (_that) {
case _AllChannelCategory():
return allChannelCategory();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  allChannelCategory,}) {final _that = this;
switch (_that) {
case _AllChannelCategory() when allChannelCategory != null:
return allChannelCategory();case _:
  return null;

}
}

}

/// @nodoc


class _AllChannelCategory implements ChannelCatagoryEvent {
  const _AllChannelCategory();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AllChannelCategory);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChannelCatagoryEvent.allChannelCategory()';
}


}




/// @nodoc
mixin _$ChannelCatagoryState {

 List<ChannelCatagoryModel> get channelCatagoryList; Status get channelCatagoryStatus;
/// Create a copy of ChannelCatagoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChannelCatagoryStateCopyWith<ChannelCatagoryState> get copyWith => _$ChannelCatagoryStateCopyWithImpl<ChannelCatagoryState>(this as ChannelCatagoryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChannelCatagoryState&&const DeepCollectionEquality().equals(other.channelCatagoryList, channelCatagoryList)&&(identical(other.channelCatagoryStatus, channelCatagoryStatus) || other.channelCatagoryStatus == channelCatagoryStatus));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(channelCatagoryList),channelCatagoryStatus);

@override
String toString() {
  return 'ChannelCatagoryState(channelCatagoryList: $channelCatagoryList, channelCatagoryStatus: $channelCatagoryStatus)';
}


}

/// @nodoc
abstract mixin class $ChannelCatagoryStateCopyWith<$Res>  {
  factory $ChannelCatagoryStateCopyWith(ChannelCatagoryState value, $Res Function(ChannelCatagoryState) _then) = _$ChannelCatagoryStateCopyWithImpl;
@useResult
$Res call({
 List<ChannelCatagoryModel> channelCatagoryList, Status channelCatagoryStatus
});




}
/// @nodoc
class _$ChannelCatagoryStateCopyWithImpl<$Res>
    implements $ChannelCatagoryStateCopyWith<$Res> {
  _$ChannelCatagoryStateCopyWithImpl(this._self, this._then);

  final ChannelCatagoryState _self;
  final $Res Function(ChannelCatagoryState) _then;

/// Create a copy of ChannelCatagoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? channelCatagoryList = null,Object? channelCatagoryStatus = null,}) {
  return _then(_self.copyWith(
channelCatagoryList: null == channelCatagoryList ? _self.channelCatagoryList : channelCatagoryList // ignore: cast_nullable_to_non_nullable
as List<ChannelCatagoryModel>,channelCatagoryStatus: null == channelCatagoryStatus ? _self.channelCatagoryStatus : channelCatagoryStatus // ignore: cast_nullable_to_non_nullable
as Status,
  ));
}

}


/// Adds pattern-matching-related methods to [ChannelCatagoryState].
extension ChannelCatagoryStatePatterns on ChannelCatagoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChannelCatagoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChannelCatagoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChannelCatagoryState value)  $default,){
final _that = this;
switch (_that) {
case _ChannelCatagoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChannelCatagoryState value)?  $default,){
final _that = this;
switch (_that) {
case _ChannelCatagoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ChannelCatagoryModel> channelCatagoryList,  Status channelCatagoryStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChannelCatagoryState() when $default != null:
return $default(_that.channelCatagoryList,_that.channelCatagoryStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ChannelCatagoryModel> channelCatagoryList,  Status channelCatagoryStatus)  $default,) {final _that = this;
switch (_that) {
case _ChannelCatagoryState():
return $default(_that.channelCatagoryList,_that.channelCatagoryStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ChannelCatagoryModel> channelCatagoryList,  Status channelCatagoryStatus)?  $default,) {final _that = this;
switch (_that) {
case _ChannelCatagoryState() when $default != null:
return $default(_that.channelCatagoryList,_that.channelCatagoryStatus);case _:
  return null;

}
}

}

/// @nodoc


class _ChannelCatagoryState implements ChannelCatagoryState {
  const _ChannelCatagoryState({final  List<ChannelCatagoryModel> channelCatagoryList = const [], this.channelCatagoryStatus = Status.init}): _channelCatagoryList = channelCatagoryList;
  

 final  List<ChannelCatagoryModel> _channelCatagoryList;
@override@JsonKey() List<ChannelCatagoryModel> get channelCatagoryList {
  if (_channelCatagoryList is EqualUnmodifiableListView) return _channelCatagoryList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_channelCatagoryList);
}

@override@JsonKey() final  Status channelCatagoryStatus;

/// Create a copy of ChannelCatagoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChannelCatagoryStateCopyWith<_ChannelCatagoryState> get copyWith => __$ChannelCatagoryStateCopyWithImpl<_ChannelCatagoryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChannelCatagoryState&&const DeepCollectionEquality().equals(other._channelCatagoryList, _channelCatagoryList)&&(identical(other.channelCatagoryStatus, channelCatagoryStatus) || other.channelCatagoryStatus == channelCatagoryStatus));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_channelCatagoryList),channelCatagoryStatus);

@override
String toString() {
  return 'ChannelCatagoryState(channelCatagoryList: $channelCatagoryList, channelCatagoryStatus: $channelCatagoryStatus)';
}


}

/// @nodoc
abstract mixin class _$ChannelCatagoryStateCopyWith<$Res> implements $ChannelCatagoryStateCopyWith<$Res> {
  factory _$ChannelCatagoryStateCopyWith(_ChannelCatagoryState value, $Res Function(_ChannelCatagoryState) _then) = __$ChannelCatagoryStateCopyWithImpl;
@override @useResult
$Res call({
 List<ChannelCatagoryModel> channelCatagoryList, Status channelCatagoryStatus
});




}
/// @nodoc
class __$ChannelCatagoryStateCopyWithImpl<$Res>
    implements _$ChannelCatagoryStateCopyWith<$Res> {
  __$ChannelCatagoryStateCopyWithImpl(this._self, this._then);

  final _ChannelCatagoryState _self;
  final $Res Function(_ChannelCatagoryState) _then;

/// Create a copy of ChannelCatagoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? channelCatagoryList = null,Object? channelCatagoryStatus = null,}) {
  return _then(_ChannelCatagoryState(
channelCatagoryList: null == channelCatagoryList ? _self._channelCatagoryList : channelCatagoryList // ignore: cast_nullable_to_non_nullable
as List<ChannelCatagoryModel>,channelCatagoryStatus: null == channelCatagoryStatus ? _self.channelCatagoryStatus : channelCatagoryStatus // ignore: cast_nullable_to_non_nullable
as Status,
  ));
}


}

// dart format on
