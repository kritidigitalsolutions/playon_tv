// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'banner_ads_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BannerAdsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BannerAdsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BannerAdsEvent()';
}


}

/// @nodoc
class $BannerAdsEventCopyWith<$Res>  {
$BannerAdsEventCopyWith(BannerAdsEvent _, $Res Function(BannerAdsEvent) __);
}


/// Adds pattern-matching-related methods to [BannerAdsEvent].
extension BannerAdsEventPatterns on BannerAdsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _FetchBanner value)?  fetchBannerAds,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FetchBanner() when fetchBannerAds != null:
return fetchBannerAds(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _FetchBanner value)  fetchBannerAds,}){
final _that = this;
switch (_that) {
case _FetchBanner():
return fetchBannerAds(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _FetchBanner value)?  fetchBannerAds,}){
final _that = this;
switch (_that) {
case _FetchBanner() when fetchBannerAds != null:
return fetchBannerAds(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  fetchBannerAds,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FetchBanner() when fetchBannerAds != null:
return fetchBannerAds();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  fetchBannerAds,}) {final _that = this;
switch (_that) {
case _FetchBanner():
return fetchBannerAds();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  fetchBannerAds,}) {final _that = this;
switch (_that) {
case _FetchBanner() when fetchBannerAds != null:
return fetchBannerAds();case _:
  return null;

}
}

}

/// @nodoc


class _FetchBanner implements BannerAdsEvent {
  const _FetchBanner();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FetchBanner);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BannerAdsEvent.fetchBannerAds()';
}


}




/// @nodoc
mixin _$BannerAdsState {

 Status get bannerStatus; List<BannerModel> get bannerAds;
/// Create a copy of BannerAdsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BannerAdsStateCopyWith<BannerAdsState> get copyWith => _$BannerAdsStateCopyWithImpl<BannerAdsState>(this as BannerAdsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BannerAdsState&&(identical(other.bannerStatus, bannerStatus) || other.bannerStatus == bannerStatus)&&const DeepCollectionEquality().equals(other.bannerAds, bannerAds));
}


@override
int get hashCode => Object.hash(runtimeType,bannerStatus,const DeepCollectionEquality().hash(bannerAds));

@override
String toString() {
  return 'BannerAdsState(bannerStatus: $bannerStatus, bannerAds: $bannerAds)';
}


}

/// @nodoc
abstract mixin class $BannerAdsStateCopyWith<$Res>  {
  factory $BannerAdsStateCopyWith(BannerAdsState value, $Res Function(BannerAdsState) _then) = _$BannerAdsStateCopyWithImpl;
@useResult
$Res call({
 Status bannerStatus, List<BannerModel> bannerAds
});




}
/// @nodoc
class _$BannerAdsStateCopyWithImpl<$Res>
    implements $BannerAdsStateCopyWith<$Res> {
  _$BannerAdsStateCopyWithImpl(this._self, this._then);

  final BannerAdsState _self;
  final $Res Function(BannerAdsState) _then;

/// Create a copy of BannerAdsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bannerStatus = null,Object? bannerAds = null,}) {
  return _then(_self.copyWith(
bannerStatus: null == bannerStatus ? _self.bannerStatus : bannerStatus // ignore: cast_nullable_to_non_nullable
as Status,bannerAds: null == bannerAds ? _self.bannerAds : bannerAds // ignore: cast_nullable_to_non_nullable
as List<BannerModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [BannerAdsState].
extension BannerAdsStatePatterns on BannerAdsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BannerAdsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BannerAdsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BannerAdsState value)  $default,){
final _that = this;
switch (_that) {
case _BannerAdsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BannerAdsState value)?  $default,){
final _that = this;
switch (_that) {
case _BannerAdsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Status bannerStatus,  List<BannerModel> bannerAds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BannerAdsState() when $default != null:
return $default(_that.bannerStatus,_that.bannerAds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Status bannerStatus,  List<BannerModel> bannerAds)  $default,) {final _that = this;
switch (_that) {
case _BannerAdsState():
return $default(_that.bannerStatus,_that.bannerAds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Status bannerStatus,  List<BannerModel> bannerAds)?  $default,) {final _that = this;
switch (_that) {
case _BannerAdsState() when $default != null:
return $default(_that.bannerStatus,_that.bannerAds);case _:
  return null;

}
}

}

/// @nodoc


class _BannerAdsState implements BannerAdsState {
  const _BannerAdsState({this.bannerStatus = Status.init, final  List<BannerModel> bannerAds = const []}): _bannerAds = bannerAds;
  

@override@JsonKey() final  Status bannerStatus;
 final  List<BannerModel> _bannerAds;
@override@JsonKey() List<BannerModel> get bannerAds {
  if (_bannerAds is EqualUnmodifiableListView) return _bannerAds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bannerAds);
}


/// Create a copy of BannerAdsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BannerAdsStateCopyWith<_BannerAdsState> get copyWith => __$BannerAdsStateCopyWithImpl<_BannerAdsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BannerAdsState&&(identical(other.bannerStatus, bannerStatus) || other.bannerStatus == bannerStatus)&&const DeepCollectionEquality().equals(other._bannerAds, _bannerAds));
}


@override
int get hashCode => Object.hash(runtimeType,bannerStatus,const DeepCollectionEquality().hash(_bannerAds));

@override
String toString() {
  return 'BannerAdsState(bannerStatus: $bannerStatus, bannerAds: $bannerAds)';
}


}

/// @nodoc
abstract mixin class _$BannerAdsStateCopyWith<$Res> implements $BannerAdsStateCopyWith<$Res> {
  factory _$BannerAdsStateCopyWith(_BannerAdsState value, $Res Function(_BannerAdsState) _then) = __$BannerAdsStateCopyWithImpl;
@override @useResult
$Res call({
 Status bannerStatus, List<BannerModel> bannerAds
});




}
/// @nodoc
class __$BannerAdsStateCopyWithImpl<$Res>
    implements _$BannerAdsStateCopyWith<$Res> {
  __$BannerAdsStateCopyWithImpl(this._self, this._then);

  final _BannerAdsState _self;
  final $Res Function(_BannerAdsState) _then;

/// Create a copy of BannerAdsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bannerStatus = null,Object? bannerAds = null,}) {
  return _then(_BannerAdsState(
bannerStatus: null == bannerStatus ? _self.bannerStatus : bannerStatus // ignore: cast_nullable_to_non_nullable
as Status,bannerAds: null == bannerAds ? _self._bannerAds : bannerAds // ignore: cast_nullable_to_non_nullable
as List<BannerModel>,
  ));
}


}

// dart format on
