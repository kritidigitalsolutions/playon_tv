// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'series_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SeriesEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeriesEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SeriesEvent()';
}


}

/// @nodoc
class $SeriesEventCopyWith<$Res>  {
$SeriesEventCopyWith(SeriesEvent _, $Res Function(SeriesEvent) __);
}


/// Adds pattern-matching-related methods to [SeriesEvent].
extension SeriesEventPatterns on SeriesEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _GetSeriesList value)?  getSeriesList,TResult Function( _GetMoreSeriesList value)?  getMoreSeriesList,TResult Function( _GetSeriesDetail value)?  getSeriesDetail,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetSeriesList() when getSeriesList != null:
return getSeriesList(_that);case _GetMoreSeriesList() when getMoreSeriesList != null:
return getMoreSeriesList(_that);case _GetSeriesDetail() when getSeriesDetail != null:
return getSeriesDetail(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _GetSeriesList value)  getSeriesList,required TResult Function( _GetMoreSeriesList value)  getMoreSeriesList,required TResult Function( _GetSeriesDetail value)  getSeriesDetail,}){
final _that = this;
switch (_that) {
case _GetSeriesList():
return getSeriesList(_that);case _GetMoreSeriesList():
return getMoreSeriesList(_that);case _GetSeriesDetail():
return getSeriesDetail(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _GetSeriesList value)?  getSeriesList,TResult? Function( _GetMoreSeriesList value)?  getMoreSeriesList,TResult? Function( _GetSeriesDetail value)?  getSeriesDetail,}){
final _that = this;
switch (_that) {
case _GetSeriesList() when getSeriesList != null:
return getSeriesList(_that);case _GetMoreSeriesList() when getMoreSeriesList != null:
return getMoreSeriesList(_that);case _GetSeriesDetail() when getSeriesDetail != null:
return getSeriesDetail(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  getSeriesList,TResult Function()?  getMoreSeriesList,TResult Function( String id)?  getSeriesDetail,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetSeriesList() when getSeriesList != null:
return getSeriesList();case _GetMoreSeriesList() when getMoreSeriesList != null:
return getMoreSeriesList();case _GetSeriesDetail() when getSeriesDetail != null:
return getSeriesDetail(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  getSeriesList,required TResult Function()  getMoreSeriesList,required TResult Function( String id)  getSeriesDetail,}) {final _that = this;
switch (_that) {
case _GetSeriesList():
return getSeriesList();case _GetMoreSeriesList():
return getMoreSeriesList();case _GetSeriesDetail():
return getSeriesDetail(_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  getSeriesList,TResult? Function()?  getMoreSeriesList,TResult? Function( String id)?  getSeriesDetail,}) {final _that = this;
switch (_that) {
case _GetSeriesList() when getSeriesList != null:
return getSeriesList();case _GetMoreSeriesList() when getMoreSeriesList != null:
return getMoreSeriesList();case _GetSeriesDetail() when getSeriesDetail != null:
return getSeriesDetail(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _GetSeriesList implements SeriesEvent {
  const _GetSeriesList();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetSeriesList);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SeriesEvent.getSeriesList()';
}


}




/// @nodoc


class _GetMoreSeriesList implements SeriesEvent {
  const _GetMoreSeriesList();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetMoreSeriesList);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SeriesEvent.getMoreSeriesList()';
}


}




/// @nodoc


class _GetSeriesDetail implements SeriesEvent {
  const _GetSeriesDetail({required this.id});
  

 final  String id;

/// Create a copy of SeriesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetSeriesDetailCopyWith<_GetSeriesDetail> get copyWith => __$GetSeriesDetailCopyWithImpl<_GetSeriesDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetSeriesDetail&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'SeriesEvent.getSeriesDetail(id: $id)';
}


}

/// @nodoc
abstract mixin class _$GetSeriesDetailCopyWith<$Res> implements $SeriesEventCopyWith<$Res> {
  factory _$GetSeriesDetailCopyWith(_GetSeriesDetail value, $Res Function(_GetSeriesDetail) _then) = __$GetSeriesDetailCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class __$GetSeriesDetailCopyWithImpl<$Res>
    implements _$GetSeriesDetailCopyWith<$Res> {
  __$GetSeriesDetailCopyWithImpl(this._self, this._then);

  final _GetSeriesDetail _self;
  final $Res Function(_GetSeriesDetail) _then;

/// Create a copy of SeriesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_GetSeriesDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$SeriesState {

 List<SeriesModel> get series; int get page; int get pageSize; int get total; int get totalPages; Status get allSeriesStatus; Status get moreSeriesStatus; SeriesDetailsResponse? get seriesDetail; Status get seriesDetailStatus;
/// Create a copy of SeriesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeriesStateCopyWith<SeriesState> get copyWith => _$SeriesStateCopyWithImpl<SeriesState>(this as SeriesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeriesState&&const DeepCollectionEquality().equals(other.series, series)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.total, total) || other.total == total)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.allSeriesStatus, allSeriesStatus) || other.allSeriesStatus == allSeriesStatus)&&(identical(other.moreSeriesStatus, moreSeriesStatus) || other.moreSeriesStatus == moreSeriesStatus)&&(identical(other.seriesDetail, seriesDetail) || other.seriesDetail == seriesDetail)&&(identical(other.seriesDetailStatus, seriesDetailStatus) || other.seriesDetailStatus == seriesDetailStatus));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(series),page,pageSize,total,totalPages,allSeriesStatus,moreSeriesStatus,seriesDetail,seriesDetailStatus);

@override
String toString() {
  return 'SeriesState(series: $series, page: $page, pageSize: $pageSize, total: $total, totalPages: $totalPages, allSeriesStatus: $allSeriesStatus, moreSeriesStatus: $moreSeriesStatus, seriesDetail: $seriesDetail, seriesDetailStatus: $seriesDetailStatus)';
}


}

/// @nodoc
abstract mixin class $SeriesStateCopyWith<$Res>  {
  factory $SeriesStateCopyWith(SeriesState value, $Res Function(SeriesState) _then) = _$SeriesStateCopyWithImpl;
@useResult
$Res call({
 List<SeriesModel> series, int page, int pageSize, int total, int totalPages, Status allSeriesStatus, Status moreSeriesStatus, SeriesDetailsResponse? seriesDetail, Status seriesDetailStatus
});




}
/// @nodoc
class _$SeriesStateCopyWithImpl<$Res>
    implements $SeriesStateCopyWith<$Res> {
  _$SeriesStateCopyWithImpl(this._self, this._then);

  final SeriesState _self;
  final $Res Function(SeriesState) _then;

/// Create a copy of SeriesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? series = null,Object? page = null,Object? pageSize = null,Object? total = null,Object? totalPages = null,Object? allSeriesStatus = null,Object? moreSeriesStatus = null,Object? seriesDetail = freezed,Object? seriesDetailStatus = null,}) {
  return _then(_self.copyWith(
series: null == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as List<SeriesModel>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,allSeriesStatus: null == allSeriesStatus ? _self.allSeriesStatus : allSeriesStatus // ignore: cast_nullable_to_non_nullable
as Status,moreSeriesStatus: null == moreSeriesStatus ? _self.moreSeriesStatus : moreSeriesStatus // ignore: cast_nullable_to_non_nullable
as Status,seriesDetail: freezed == seriesDetail ? _self.seriesDetail : seriesDetail // ignore: cast_nullable_to_non_nullable
as SeriesDetailsResponse?,seriesDetailStatus: null == seriesDetailStatus ? _self.seriesDetailStatus : seriesDetailStatus // ignore: cast_nullable_to_non_nullable
as Status,
  ));
}

}


/// Adds pattern-matching-related methods to [SeriesState].
extension SeriesStatePatterns on SeriesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeriesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeriesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeriesState value)  $default,){
final _that = this;
switch (_that) {
case _SeriesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeriesState value)?  $default,){
final _that = this;
switch (_that) {
case _SeriesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SeriesModel> series,  int page,  int pageSize,  int total,  int totalPages,  Status allSeriesStatus,  Status moreSeriesStatus,  SeriesDetailsResponse? seriesDetail,  Status seriesDetailStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeriesState() when $default != null:
return $default(_that.series,_that.page,_that.pageSize,_that.total,_that.totalPages,_that.allSeriesStatus,_that.moreSeriesStatus,_that.seriesDetail,_that.seriesDetailStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SeriesModel> series,  int page,  int pageSize,  int total,  int totalPages,  Status allSeriesStatus,  Status moreSeriesStatus,  SeriesDetailsResponse? seriesDetail,  Status seriesDetailStatus)  $default,) {final _that = this;
switch (_that) {
case _SeriesState():
return $default(_that.series,_that.page,_that.pageSize,_that.total,_that.totalPages,_that.allSeriesStatus,_that.moreSeriesStatus,_that.seriesDetail,_that.seriesDetailStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SeriesModel> series,  int page,  int pageSize,  int total,  int totalPages,  Status allSeriesStatus,  Status moreSeriesStatus,  SeriesDetailsResponse? seriesDetail,  Status seriesDetailStatus)?  $default,) {final _that = this;
switch (_that) {
case _SeriesState() when $default != null:
return $default(_that.series,_that.page,_that.pageSize,_that.total,_that.totalPages,_that.allSeriesStatus,_that.moreSeriesStatus,_that.seriesDetail,_that.seriesDetailStatus);case _:
  return null;

}
}

}

/// @nodoc


class _SeriesState implements SeriesState {
  const _SeriesState({final  List<SeriesModel> series = const [], this.page = 1, this.pageSize = 10, this.total = 0, this.totalPages = 0, this.allSeriesStatus = Status.init, this.moreSeriesStatus = Status.init, this.seriesDetail = null, this.seriesDetailStatus = Status.init}): _series = series;
  

 final  List<SeriesModel> _series;
@override@JsonKey() List<SeriesModel> get series {
  if (_series is EqualUnmodifiableListView) return _series;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_series);
}

@override@JsonKey() final  int page;
@override@JsonKey() final  int pageSize;
@override@JsonKey() final  int total;
@override@JsonKey() final  int totalPages;
@override@JsonKey() final  Status allSeriesStatus;
@override@JsonKey() final  Status moreSeriesStatus;
@override@JsonKey() final  SeriesDetailsResponse? seriesDetail;
@override@JsonKey() final  Status seriesDetailStatus;

/// Create a copy of SeriesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeriesStateCopyWith<_SeriesState> get copyWith => __$SeriesStateCopyWithImpl<_SeriesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeriesState&&const DeepCollectionEquality().equals(other._series, _series)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.total, total) || other.total == total)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.allSeriesStatus, allSeriesStatus) || other.allSeriesStatus == allSeriesStatus)&&(identical(other.moreSeriesStatus, moreSeriesStatus) || other.moreSeriesStatus == moreSeriesStatus)&&(identical(other.seriesDetail, seriesDetail) || other.seriesDetail == seriesDetail)&&(identical(other.seriesDetailStatus, seriesDetailStatus) || other.seriesDetailStatus == seriesDetailStatus));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_series),page,pageSize,total,totalPages,allSeriesStatus,moreSeriesStatus,seriesDetail,seriesDetailStatus);

@override
String toString() {
  return 'SeriesState(series: $series, page: $page, pageSize: $pageSize, total: $total, totalPages: $totalPages, allSeriesStatus: $allSeriesStatus, moreSeriesStatus: $moreSeriesStatus, seriesDetail: $seriesDetail, seriesDetailStatus: $seriesDetailStatus)';
}


}

/// @nodoc
abstract mixin class _$SeriesStateCopyWith<$Res> implements $SeriesStateCopyWith<$Res> {
  factory _$SeriesStateCopyWith(_SeriesState value, $Res Function(_SeriesState) _then) = __$SeriesStateCopyWithImpl;
@override @useResult
$Res call({
 List<SeriesModel> series, int page, int pageSize, int total, int totalPages, Status allSeriesStatus, Status moreSeriesStatus, SeriesDetailsResponse? seriesDetail, Status seriesDetailStatus
});




}
/// @nodoc
class __$SeriesStateCopyWithImpl<$Res>
    implements _$SeriesStateCopyWith<$Res> {
  __$SeriesStateCopyWithImpl(this._self, this._then);

  final _SeriesState _self;
  final $Res Function(_SeriesState) _then;

/// Create a copy of SeriesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? series = null,Object? page = null,Object? pageSize = null,Object? total = null,Object? totalPages = null,Object? allSeriesStatus = null,Object? moreSeriesStatus = null,Object? seriesDetail = freezed,Object? seriesDetailStatus = null,}) {
  return _then(_SeriesState(
series: null == series ? _self._series : series // ignore: cast_nullable_to_non_nullable
as List<SeriesModel>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,allSeriesStatus: null == allSeriesStatus ? _self.allSeriesStatus : allSeriesStatus // ignore: cast_nullable_to_non_nullable
as Status,moreSeriesStatus: null == moreSeriesStatus ? _self.moreSeriesStatus : moreSeriesStatus // ignore: cast_nullable_to_non_nullable
as Status,seriesDetail: freezed == seriesDetail ? _self.seriesDetail : seriesDetail // ignore: cast_nullable_to_non_nullable
as SeriesDetailsResponse?,seriesDetailStatus: null == seriesDetailStatus ? _self.seriesDetailStatus : seriesDetailStatus // ignore: cast_nullable_to_non_nullable
as Status,
  ));
}


}

// dart format on
