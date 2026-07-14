// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'podcast_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PodcastEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PodcastEvent()';
}


}

/// @nodoc
class $PodcastEventCopyWith<$Res>  {
$PodcastEventCopyWith(PodcastEvent _, $Res Function(PodcastEvent) __);
}


/// Adds pattern-matching-related methods to [PodcastEvent].
extension PodcastEventPatterns on PodcastEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AllPodcast value)?  allPodcast,TResult Function( _PodcastDetail value)?  podcastDetail,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AllPodcast() when allPodcast != null:
return allPodcast(_that);case _PodcastDetail() when podcastDetail != null:
return podcastDetail(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AllPodcast value)  allPodcast,required TResult Function( _PodcastDetail value)  podcastDetail,}){
final _that = this;
switch (_that) {
case _AllPodcast():
return allPodcast(_that);case _PodcastDetail():
return podcastDetail(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AllPodcast value)?  allPodcast,TResult? Function( _PodcastDetail value)?  podcastDetail,}){
final _that = this;
switch (_that) {
case _AllPodcast() when allPodcast != null:
return allPodcast(_that);case _PodcastDetail() when podcastDetail != null:
return podcastDetail(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  allPodcast,TResult Function( String podcastId)?  podcastDetail,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AllPodcast() when allPodcast != null:
return allPodcast();case _PodcastDetail() when podcastDetail != null:
return podcastDetail(_that.podcastId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  allPodcast,required TResult Function( String podcastId)  podcastDetail,}) {final _that = this;
switch (_that) {
case _AllPodcast():
return allPodcast();case _PodcastDetail():
return podcastDetail(_that.podcastId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  allPodcast,TResult? Function( String podcastId)?  podcastDetail,}) {final _that = this;
switch (_that) {
case _AllPodcast() when allPodcast != null:
return allPodcast();case _PodcastDetail() when podcastDetail != null:
return podcastDetail(_that.podcastId);case _:
  return null;

}
}

}

/// @nodoc


class _AllPodcast implements PodcastEvent {
  const _AllPodcast();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AllPodcast);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PodcastEvent.allPodcast()';
}


}




/// @nodoc


class _PodcastDetail implements PodcastEvent {
  const _PodcastDetail({required this.podcastId});
  

 final  String podcastId;

/// Create a copy of PodcastEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastDetailCopyWith<_PodcastDetail> get copyWith => __$PodcastDetailCopyWithImpl<_PodcastDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastDetail&&(identical(other.podcastId, podcastId) || other.podcastId == podcastId));
}


@override
int get hashCode => Object.hash(runtimeType,podcastId);

@override
String toString() {
  return 'PodcastEvent.podcastDetail(podcastId: $podcastId)';
}


}

/// @nodoc
abstract mixin class _$PodcastDetailCopyWith<$Res> implements $PodcastEventCopyWith<$Res> {
  factory _$PodcastDetailCopyWith(_PodcastDetail value, $Res Function(_PodcastDetail) _then) = __$PodcastDetailCopyWithImpl;
@useResult
$Res call({
 String podcastId
});




}
/// @nodoc
class __$PodcastDetailCopyWithImpl<$Res>
    implements _$PodcastDetailCopyWith<$Res> {
  __$PodcastDetailCopyWithImpl(this._self, this._then);

  final _PodcastDetail _self;
  final $Res Function(_PodcastDetail) _then;

/// Create a copy of PodcastEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? podcastId = null,}) {
  return _then(_PodcastDetail(
podcastId: null == podcastId ? _self.podcastId : podcastId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$PodcastState {

 PodcastResponse? get podcastResponse; PodcastModel? get podcastDetail; Status get allPodcastStatus; Status get podcastDetailStatus;
/// Create a copy of PodcastState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastStateCopyWith<PodcastState> get copyWith => _$PodcastStateCopyWithImpl<PodcastState>(this as PodcastState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastState&&(identical(other.podcastResponse, podcastResponse) || other.podcastResponse == podcastResponse)&&(identical(other.podcastDetail, podcastDetail) || other.podcastDetail == podcastDetail)&&(identical(other.allPodcastStatus, allPodcastStatus) || other.allPodcastStatus == allPodcastStatus)&&(identical(other.podcastDetailStatus, podcastDetailStatus) || other.podcastDetailStatus == podcastDetailStatus));
}


@override
int get hashCode => Object.hash(runtimeType,podcastResponse,podcastDetail,allPodcastStatus,podcastDetailStatus);

@override
String toString() {
  return 'PodcastState(podcastResponse: $podcastResponse, podcastDetail: $podcastDetail, allPodcastStatus: $allPodcastStatus, podcastDetailStatus: $podcastDetailStatus)';
}


}

/// @nodoc
abstract mixin class $PodcastStateCopyWith<$Res>  {
  factory $PodcastStateCopyWith(PodcastState value, $Res Function(PodcastState) _then) = _$PodcastStateCopyWithImpl;
@useResult
$Res call({
 PodcastResponse? podcastResponse, PodcastModel? podcastDetail, Status allPodcastStatus, Status podcastDetailStatus
});




}
/// @nodoc
class _$PodcastStateCopyWithImpl<$Res>
    implements $PodcastStateCopyWith<$Res> {
  _$PodcastStateCopyWithImpl(this._self, this._then);

  final PodcastState _self;
  final $Res Function(PodcastState) _then;

/// Create a copy of PodcastState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? podcastResponse = freezed,Object? podcastDetail = freezed,Object? allPodcastStatus = null,Object? podcastDetailStatus = null,}) {
  return _then(_self.copyWith(
podcastResponse: freezed == podcastResponse ? _self.podcastResponse : podcastResponse // ignore: cast_nullable_to_non_nullable
as PodcastResponse?,podcastDetail: freezed == podcastDetail ? _self.podcastDetail : podcastDetail // ignore: cast_nullable_to_non_nullable
as PodcastModel?,allPodcastStatus: null == allPodcastStatus ? _self.allPodcastStatus : allPodcastStatus // ignore: cast_nullable_to_non_nullable
as Status,podcastDetailStatus: null == podcastDetailStatus ? _self.podcastDetailStatus : podcastDetailStatus // ignore: cast_nullable_to_non_nullable
as Status,
  ));
}

}


/// Adds pattern-matching-related methods to [PodcastState].
extension PodcastStatePatterns on PodcastState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PodcastState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PodcastState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PodcastState value)  $default,){
final _that = this;
switch (_that) {
case _PodcastState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PodcastState value)?  $default,){
final _that = this;
switch (_that) {
case _PodcastState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PodcastResponse? podcastResponse,  PodcastModel? podcastDetail,  Status allPodcastStatus,  Status podcastDetailStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PodcastState() when $default != null:
return $default(_that.podcastResponse,_that.podcastDetail,_that.allPodcastStatus,_that.podcastDetailStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PodcastResponse? podcastResponse,  PodcastModel? podcastDetail,  Status allPodcastStatus,  Status podcastDetailStatus)  $default,) {final _that = this;
switch (_that) {
case _PodcastState():
return $default(_that.podcastResponse,_that.podcastDetail,_that.allPodcastStatus,_that.podcastDetailStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PodcastResponse? podcastResponse,  PodcastModel? podcastDetail,  Status allPodcastStatus,  Status podcastDetailStatus)?  $default,) {final _that = this;
switch (_that) {
case _PodcastState() when $default != null:
return $default(_that.podcastResponse,_that.podcastDetail,_that.allPodcastStatus,_that.podcastDetailStatus);case _:
  return null;

}
}

}

/// @nodoc


class _PodcastState implements PodcastState {
  const _PodcastState({this.podcastResponse = null, this.podcastDetail = null, this.allPodcastStatus = Status.init, this.podcastDetailStatus = Status.init});
  

@override@JsonKey() final  PodcastResponse? podcastResponse;
@override@JsonKey() final  PodcastModel? podcastDetail;
@override@JsonKey() final  Status allPodcastStatus;
@override@JsonKey() final  Status podcastDetailStatus;

/// Create a copy of PodcastState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastStateCopyWith<_PodcastState> get copyWith => __$PodcastStateCopyWithImpl<_PodcastState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastState&&(identical(other.podcastResponse, podcastResponse) || other.podcastResponse == podcastResponse)&&(identical(other.podcastDetail, podcastDetail) || other.podcastDetail == podcastDetail)&&(identical(other.allPodcastStatus, allPodcastStatus) || other.allPodcastStatus == allPodcastStatus)&&(identical(other.podcastDetailStatus, podcastDetailStatus) || other.podcastDetailStatus == podcastDetailStatus));
}


@override
int get hashCode => Object.hash(runtimeType,podcastResponse,podcastDetail,allPodcastStatus,podcastDetailStatus);

@override
String toString() {
  return 'PodcastState(podcastResponse: $podcastResponse, podcastDetail: $podcastDetail, allPodcastStatus: $allPodcastStatus, podcastDetailStatus: $podcastDetailStatus)';
}


}

/// @nodoc
abstract mixin class _$PodcastStateCopyWith<$Res> implements $PodcastStateCopyWith<$Res> {
  factory _$PodcastStateCopyWith(_PodcastState value, $Res Function(_PodcastState) _then) = __$PodcastStateCopyWithImpl;
@override @useResult
$Res call({
 PodcastResponse? podcastResponse, PodcastModel? podcastDetail, Status allPodcastStatus, Status podcastDetailStatus
});




}
/// @nodoc
class __$PodcastStateCopyWithImpl<$Res>
    implements _$PodcastStateCopyWith<$Res> {
  __$PodcastStateCopyWithImpl(this._self, this._then);

  final _PodcastState _self;
  final $Res Function(_PodcastState) _then;

/// Create a copy of PodcastState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? podcastResponse = freezed,Object? podcastDetail = freezed,Object? allPodcastStatus = null,Object? podcastDetailStatus = null,}) {
  return _then(_PodcastState(
podcastResponse: freezed == podcastResponse ? _self.podcastResponse : podcastResponse // ignore: cast_nullable_to_non_nullable
as PodcastResponse?,podcastDetail: freezed == podcastDetail ? _self.podcastDetail : podcastDetail // ignore: cast_nullable_to_non_nullable
as PodcastModel?,allPodcastStatus: null == allPodcastStatus ? _self.allPodcastStatus : allPodcastStatus // ignore: cast_nullable_to_non_nullable
as Status,podcastDetailStatus: null == podcastDetailStatus ? _self.podcastDetailStatus : podcastDetailStatus // ignore: cast_nullable_to_non_nullable
as Status,
  ));
}


}

// dart format on
