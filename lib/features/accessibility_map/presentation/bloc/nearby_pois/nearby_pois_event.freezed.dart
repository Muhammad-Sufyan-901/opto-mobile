// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nearby_pois_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NearbyPoisEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NearbyPoisEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NearbyPoisEvent()';
}


}

/// @nodoc
class $NearbyPoisEventCopyWith<$Res>  {
$NearbyPoisEventCopyWith(NearbyPoisEvent _, $Res Function(NearbyPoisEvent) __);
}


/// Adds pattern-matching-related methods to [NearbyPoisEvent].
extension NearbyPoisEventPatterns on NearbyPoisEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadNearbyPois value)?  load,TResult Function( RefreshNearbyPois value)?  refresh,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadNearbyPois() when load != null:
return load(_that);case RefreshNearbyPois() when refresh != null:
return refresh(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadNearbyPois value)  load,required TResult Function( RefreshNearbyPois value)  refresh,}){
final _that = this;
switch (_that) {
case LoadNearbyPois():
return load(_that);case RefreshNearbyPois():
return refresh(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadNearbyPois value)?  load,TResult? Function( RefreshNearbyPois value)?  refresh,}){
final _that = this;
switch (_that) {
case LoadNearbyPois() when load != null:
return load(_that);case RefreshNearbyPois() when refresh != null:
return refresh(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( double? lat,  double? lng,  double radiusDegrees)?  load,TResult Function()?  refresh,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadNearbyPois() when load != null:
return load(_that.lat,_that.lng,_that.radiusDegrees);case RefreshNearbyPois() when refresh != null:
return refresh();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( double? lat,  double? lng,  double radiusDegrees)  load,required TResult Function()  refresh,}) {final _that = this;
switch (_that) {
case LoadNearbyPois():
return load(_that.lat,_that.lng,_that.radiusDegrees);case RefreshNearbyPois():
return refresh();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( double? lat,  double? lng,  double radiusDegrees)?  load,TResult? Function()?  refresh,}) {final _that = this;
switch (_that) {
case LoadNearbyPois() when load != null:
return load(_that.lat,_that.lng,_that.radiusDegrees);case RefreshNearbyPois() when refresh != null:
return refresh();case _:
  return null;

}
}

}

/// @nodoc


class LoadNearbyPois implements NearbyPoisEvent {
  const LoadNearbyPois({this.lat, this.lng, this.radiusDegrees = 0.05});
  

 final  double? lat;
 final  double? lng;
@JsonKey() final  double radiusDegrees;

/// Create a copy of NearbyPoisEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadNearbyPoisCopyWith<LoadNearbyPois> get copyWith => _$LoadNearbyPoisCopyWithImpl<LoadNearbyPois>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadNearbyPois&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.radiusDegrees, radiusDegrees) || other.radiusDegrees == radiusDegrees));
}


@override
int get hashCode => Object.hash(runtimeType,lat,lng,radiusDegrees);

@override
String toString() {
  return 'NearbyPoisEvent.load(lat: $lat, lng: $lng, radiusDegrees: $radiusDegrees)';
}


}

/// @nodoc
abstract mixin class $LoadNearbyPoisCopyWith<$Res> implements $NearbyPoisEventCopyWith<$Res> {
  factory $LoadNearbyPoisCopyWith(LoadNearbyPois value, $Res Function(LoadNearbyPois) _then) = _$LoadNearbyPoisCopyWithImpl;
@useResult
$Res call({
 double? lat, double? lng, double radiusDegrees
});




}
/// @nodoc
class _$LoadNearbyPoisCopyWithImpl<$Res>
    implements $LoadNearbyPoisCopyWith<$Res> {
  _$LoadNearbyPoisCopyWithImpl(this._self, this._then);

  final LoadNearbyPois _self;
  final $Res Function(LoadNearbyPois) _then;

/// Create a copy of NearbyPoisEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? lat = freezed,Object? lng = freezed,Object? radiusDegrees = null,}) {
  return _then(LoadNearbyPois(
lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,radiusDegrees: null == radiusDegrees ? _self.radiusDegrees : radiusDegrees // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class RefreshNearbyPois implements NearbyPoisEvent {
  const RefreshNearbyPois();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshNearbyPois);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NearbyPoisEvent.refresh()';
}


}




// dart format on
