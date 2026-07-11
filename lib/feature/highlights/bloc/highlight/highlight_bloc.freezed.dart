// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'highlight_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HighlightEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HighlightEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HighlightEvent()';
}


}

/// @nodoc
class $HighlightEventCopyWith<$Res>  {
$HighlightEventCopyWith(HighlightEvent _, $Res Function(HighlightEvent) __);
}


/// Adds pattern-matching-related methods to [HighlightEvent].
extension HighlightEventPatterns on HighlightEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _FetchHighLight value)?  fetchHighLight,TResult Function( _FetchHighLightMore value)?  fetchHighLightMore,TResult Function( _HightLightDetail value)?  highlightDetail,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FetchHighLight() when fetchHighLight != null:
return fetchHighLight(_that);case _FetchHighLightMore() when fetchHighLightMore != null:
return fetchHighLightMore(_that);case _HightLightDetail() when highlightDetail != null:
return highlightDetail(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _FetchHighLight value)  fetchHighLight,required TResult Function( _FetchHighLightMore value)  fetchHighLightMore,required TResult Function( _HightLightDetail value)  highlightDetail,}){
final _that = this;
switch (_that) {
case _FetchHighLight():
return fetchHighLight(_that);case _FetchHighLightMore():
return fetchHighLightMore(_that);case _HightLightDetail():
return highlightDetail(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _FetchHighLight value)?  fetchHighLight,TResult? Function( _FetchHighLightMore value)?  fetchHighLightMore,TResult? Function( _HightLightDetail value)?  highlightDetail,}){
final _that = this;
switch (_that) {
case _FetchHighLight() when fetchHighLight != null:
return fetchHighLight(_that);case _FetchHighLightMore() when fetchHighLightMore != null:
return fetchHighLightMore(_that);case _HightLightDetail() when highlightDetail != null:
return highlightDetail(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  fetchHighLight,TResult Function()?  fetchHighLightMore,TResult Function( String id)?  highlightDetail,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FetchHighLight() when fetchHighLight != null:
return fetchHighLight();case _FetchHighLightMore() when fetchHighLightMore != null:
return fetchHighLightMore();case _HightLightDetail() when highlightDetail != null:
return highlightDetail(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  fetchHighLight,required TResult Function()  fetchHighLightMore,required TResult Function( String id)  highlightDetail,}) {final _that = this;
switch (_that) {
case _FetchHighLight():
return fetchHighLight();case _FetchHighLightMore():
return fetchHighLightMore();case _HightLightDetail():
return highlightDetail(_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  fetchHighLight,TResult? Function()?  fetchHighLightMore,TResult? Function( String id)?  highlightDetail,}) {final _that = this;
switch (_that) {
case _FetchHighLight() when fetchHighLight != null:
return fetchHighLight();case _FetchHighLightMore() when fetchHighLightMore != null:
return fetchHighLightMore();case _HightLightDetail() when highlightDetail != null:
return highlightDetail(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _FetchHighLight implements HighlightEvent {
  const _FetchHighLight();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FetchHighLight);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HighlightEvent.fetchHighLight()';
}


}




/// @nodoc


class _FetchHighLightMore implements HighlightEvent {
  const _FetchHighLightMore();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FetchHighLightMore);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HighlightEvent.fetchHighLightMore()';
}


}




/// @nodoc


class _HightLightDetail implements HighlightEvent {
  const _HightLightDetail({required this.id});
  

 final  String id;

/// Create a copy of HighlightEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HightLightDetailCopyWith<_HightLightDetail> get copyWith => __$HightLightDetailCopyWithImpl<_HightLightDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HightLightDetail&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'HighlightEvent.highlightDetail(id: $id)';
}


}

/// @nodoc
abstract mixin class _$HightLightDetailCopyWith<$Res> implements $HighlightEventCopyWith<$Res> {
  factory _$HightLightDetailCopyWith(_HightLightDetail value, $Res Function(_HightLightDetail) _then) = __$HightLightDetailCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class __$HightLightDetailCopyWithImpl<$Res>
    implements _$HightLightDetailCopyWith<$Res> {
  __$HightLightDetailCopyWithImpl(this._self, this._then);

  final _HightLightDetail _self;
  final $Res Function(_HightLightDetail) _then;

/// Create a copy of HighlightEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_HightLightDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$HighlightState {

 List<HighlightModel> get highlights; int get page; int get pageSize; int get total; int get totalPages; Status get allHighLightStatus; Status get moreHighLightStatus; HighlightDetailResponse? get highlightDetail; Status get highlightDetailStatus;
/// Create a copy of HighlightState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HighlightStateCopyWith<HighlightState> get copyWith => _$HighlightStateCopyWithImpl<HighlightState>(this as HighlightState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HighlightState&&const DeepCollectionEquality().equals(other.highlights, highlights)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.total, total) || other.total == total)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.allHighLightStatus, allHighLightStatus) || other.allHighLightStatus == allHighLightStatus)&&(identical(other.moreHighLightStatus, moreHighLightStatus) || other.moreHighLightStatus == moreHighLightStatus)&&(identical(other.highlightDetail, highlightDetail) || other.highlightDetail == highlightDetail)&&(identical(other.highlightDetailStatus, highlightDetailStatus) || other.highlightDetailStatus == highlightDetailStatus));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(highlights),page,pageSize,total,totalPages,allHighLightStatus,moreHighLightStatus,highlightDetail,highlightDetailStatus);

@override
String toString() {
  return 'HighlightState(highlights: $highlights, page: $page, pageSize: $pageSize, total: $total, totalPages: $totalPages, allHighLightStatus: $allHighLightStatus, moreHighLightStatus: $moreHighLightStatus, highlightDetail: $highlightDetail, highlightDetailStatus: $highlightDetailStatus)';
}


}

/// @nodoc
abstract mixin class $HighlightStateCopyWith<$Res>  {
  factory $HighlightStateCopyWith(HighlightState value, $Res Function(HighlightState) _then) = _$HighlightStateCopyWithImpl;
@useResult
$Res call({
 List<HighlightModel> highlights, int page, int pageSize, int total, int totalPages, Status allHighLightStatus, Status moreHighLightStatus, HighlightDetailResponse? highlightDetail, Status highlightDetailStatus
});




}
/// @nodoc
class _$HighlightStateCopyWithImpl<$Res>
    implements $HighlightStateCopyWith<$Res> {
  _$HighlightStateCopyWithImpl(this._self, this._then);

  final HighlightState _self;
  final $Res Function(HighlightState) _then;

/// Create a copy of HighlightState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? highlights = null,Object? page = null,Object? pageSize = null,Object? total = null,Object? totalPages = null,Object? allHighLightStatus = null,Object? moreHighLightStatus = null,Object? highlightDetail = freezed,Object? highlightDetailStatus = null,}) {
  return _then(_self.copyWith(
highlights: null == highlights ? _self.highlights : highlights // ignore: cast_nullable_to_non_nullable
as List<HighlightModel>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,allHighLightStatus: null == allHighLightStatus ? _self.allHighLightStatus : allHighLightStatus // ignore: cast_nullable_to_non_nullable
as Status,moreHighLightStatus: null == moreHighLightStatus ? _self.moreHighLightStatus : moreHighLightStatus // ignore: cast_nullable_to_non_nullable
as Status,highlightDetail: freezed == highlightDetail ? _self.highlightDetail : highlightDetail // ignore: cast_nullable_to_non_nullable
as HighlightDetailResponse?,highlightDetailStatus: null == highlightDetailStatus ? _self.highlightDetailStatus : highlightDetailStatus // ignore: cast_nullable_to_non_nullable
as Status,
  ));
}

}


/// Adds pattern-matching-related methods to [HighlightState].
extension HighlightStatePatterns on HighlightState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HighlightState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HighlightState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HighlightState value)  $default,){
final _that = this;
switch (_that) {
case _HighlightState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HighlightState value)?  $default,){
final _that = this;
switch (_that) {
case _HighlightState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<HighlightModel> highlights,  int page,  int pageSize,  int total,  int totalPages,  Status allHighLightStatus,  Status moreHighLightStatus,  HighlightDetailResponse? highlightDetail,  Status highlightDetailStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HighlightState() when $default != null:
return $default(_that.highlights,_that.page,_that.pageSize,_that.total,_that.totalPages,_that.allHighLightStatus,_that.moreHighLightStatus,_that.highlightDetail,_that.highlightDetailStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<HighlightModel> highlights,  int page,  int pageSize,  int total,  int totalPages,  Status allHighLightStatus,  Status moreHighLightStatus,  HighlightDetailResponse? highlightDetail,  Status highlightDetailStatus)  $default,) {final _that = this;
switch (_that) {
case _HighlightState():
return $default(_that.highlights,_that.page,_that.pageSize,_that.total,_that.totalPages,_that.allHighLightStatus,_that.moreHighLightStatus,_that.highlightDetail,_that.highlightDetailStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<HighlightModel> highlights,  int page,  int pageSize,  int total,  int totalPages,  Status allHighLightStatus,  Status moreHighLightStatus,  HighlightDetailResponse? highlightDetail,  Status highlightDetailStatus)?  $default,) {final _that = this;
switch (_that) {
case _HighlightState() when $default != null:
return $default(_that.highlights,_that.page,_that.pageSize,_that.total,_that.totalPages,_that.allHighLightStatus,_that.moreHighLightStatus,_that.highlightDetail,_that.highlightDetailStatus);case _:
  return null;

}
}

}

/// @nodoc


class _HighlightState implements HighlightState {
  const _HighlightState({final  List<HighlightModel> highlights = const [], this.page = 1, this.pageSize = 10, this.total = 0, this.totalPages = 0, this.allHighLightStatus = Status.init, this.moreHighLightStatus = Status.init, this.highlightDetail = null, this.highlightDetailStatus = Status.init}): _highlights = highlights;
  

 final  List<HighlightModel> _highlights;
@override@JsonKey() List<HighlightModel> get highlights {
  if (_highlights is EqualUnmodifiableListView) return _highlights;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_highlights);
}

@override@JsonKey() final  int page;
@override@JsonKey() final  int pageSize;
@override@JsonKey() final  int total;
@override@JsonKey() final  int totalPages;
@override@JsonKey() final  Status allHighLightStatus;
@override@JsonKey() final  Status moreHighLightStatus;
@override@JsonKey() final  HighlightDetailResponse? highlightDetail;
@override@JsonKey() final  Status highlightDetailStatus;

/// Create a copy of HighlightState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HighlightStateCopyWith<_HighlightState> get copyWith => __$HighlightStateCopyWithImpl<_HighlightState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HighlightState&&const DeepCollectionEquality().equals(other._highlights, _highlights)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.total, total) || other.total == total)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.allHighLightStatus, allHighLightStatus) || other.allHighLightStatus == allHighLightStatus)&&(identical(other.moreHighLightStatus, moreHighLightStatus) || other.moreHighLightStatus == moreHighLightStatus)&&(identical(other.highlightDetail, highlightDetail) || other.highlightDetail == highlightDetail)&&(identical(other.highlightDetailStatus, highlightDetailStatus) || other.highlightDetailStatus == highlightDetailStatus));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_highlights),page,pageSize,total,totalPages,allHighLightStatus,moreHighLightStatus,highlightDetail,highlightDetailStatus);

@override
String toString() {
  return 'HighlightState(highlights: $highlights, page: $page, pageSize: $pageSize, total: $total, totalPages: $totalPages, allHighLightStatus: $allHighLightStatus, moreHighLightStatus: $moreHighLightStatus, highlightDetail: $highlightDetail, highlightDetailStatus: $highlightDetailStatus)';
}


}

/// @nodoc
abstract mixin class _$HighlightStateCopyWith<$Res> implements $HighlightStateCopyWith<$Res> {
  factory _$HighlightStateCopyWith(_HighlightState value, $Res Function(_HighlightState) _then) = __$HighlightStateCopyWithImpl;
@override @useResult
$Res call({
 List<HighlightModel> highlights, int page, int pageSize, int total, int totalPages, Status allHighLightStatus, Status moreHighLightStatus, HighlightDetailResponse? highlightDetail, Status highlightDetailStatus
});




}
/// @nodoc
class __$HighlightStateCopyWithImpl<$Res>
    implements _$HighlightStateCopyWith<$Res> {
  __$HighlightStateCopyWithImpl(this._self, this._then);

  final _HighlightState _self;
  final $Res Function(_HighlightState) _then;

/// Create a copy of HighlightState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? highlights = null,Object? page = null,Object? pageSize = null,Object? total = null,Object? totalPages = null,Object? allHighLightStatus = null,Object? moreHighLightStatus = null,Object? highlightDetail = freezed,Object? highlightDetailStatus = null,}) {
  return _then(_HighlightState(
highlights: null == highlights ? _self._highlights : highlights // ignore: cast_nullable_to_non_nullable
as List<HighlightModel>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,allHighLightStatus: null == allHighLightStatus ? _self.allHighLightStatus : allHighLightStatus // ignore: cast_nullable_to_non_nullable
as Status,moreHighLightStatus: null == moreHighLightStatus ? _self.moreHighLightStatus : moreHighLightStatus // ignore: cast_nullable_to_non_nullable
as Status,highlightDetail: freezed == highlightDetail ? _self.highlightDetail : highlightDetail // ignore: cast_nullable_to_non_nullable
as HighlightDetailResponse?,highlightDetailStatus: null == highlightDetailStatus ? _self.highlightDetailStatus : highlightDetailStatus // ignore: cast_nullable_to_non_nullable
as Status,
  ));
}


}

// dart format on
