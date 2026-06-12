// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accessibility_poi_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccessibilityPoiModel {

/// Primary key (UUID).
 String get id;/// Human-readable name of the place.
 String get name;/// Latitude (WGS-84) — stored as `double precision` in Postgres.
 double get lat;/// Longitude (WGS-84) — stored as `double precision` in Postgres.
 double get lng;/// Accessibility feature flags as a jsonb map.
///
/// Keys follow [PoiAttribute.jsonKey] conventions; values are booleans.
/// Use `Map<String, dynamic>` to handle free-form / unknown keys.
 Map<String, dynamic> get attributes;/// Number of community verifications.
@JsonKey(name: 'verified_count') int get verifiedCount;/// Optional FK to the profiles table (the creator).
@JsonKey(name: 'created_by') String? get createdBy;
/// Create a copy of AccessibilityPoiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccessibilityPoiModelCopyWith<AccessibilityPoiModel> get copyWith => _$AccessibilityPoiModelCopyWithImpl<AccessibilityPoiModel>(this as AccessibilityPoiModel, _$identity);

  /// Serializes this AccessibilityPoiModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccessibilityPoiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&const DeepCollectionEquality().equals(other.attributes, attributes)&&(identical(other.verifiedCount, verifiedCount) || other.verifiedCount == verifiedCount)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,lat,lng,const DeepCollectionEquality().hash(attributes),verifiedCount,createdBy);

@override
String toString() {
  return 'AccessibilityPoiModel(id: $id, name: $name, lat: $lat, lng: $lng, attributes: $attributes, verifiedCount: $verifiedCount, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class $AccessibilityPoiModelCopyWith<$Res>  {
  factory $AccessibilityPoiModelCopyWith(AccessibilityPoiModel value, $Res Function(AccessibilityPoiModel) _then) = _$AccessibilityPoiModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, double lat, double lng, Map<String, dynamic> attributes,@JsonKey(name: 'verified_count') int verifiedCount,@JsonKey(name: 'created_by') String? createdBy
});




}
/// @nodoc
class _$AccessibilityPoiModelCopyWithImpl<$Res>
    implements $AccessibilityPoiModelCopyWith<$Res> {
  _$AccessibilityPoiModelCopyWithImpl(this._self, this._then);

  final AccessibilityPoiModel _self;
  final $Res Function(AccessibilityPoiModel) _then;

/// Create a copy of AccessibilityPoiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? lat = null,Object? lng = null,Object? attributes = null,Object? verifiedCount = null,Object? createdBy = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,attributes: null == attributes ? _self.attributes : attributes // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,verifiedCount: null == verifiedCount ? _self.verifiedCount : verifiedCount // ignore: cast_nullable_to_non_nullable
as int,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccessibilityPoiModel].
extension AccessibilityPoiModelPatterns on AccessibilityPoiModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccessibilityPoiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccessibilityPoiModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccessibilityPoiModel value)  $default,){
final _that = this;
switch (_that) {
case _AccessibilityPoiModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccessibilityPoiModel value)?  $default,){
final _that = this;
switch (_that) {
case _AccessibilityPoiModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double lat,  double lng,  Map<String, dynamic> attributes, @JsonKey(name: 'verified_count')  int verifiedCount, @JsonKey(name: 'created_by')  String? createdBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccessibilityPoiModel() when $default != null:
return $default(_that.id,_that.name,_that.lat,_that.lng,_that.attributes,_that.verifiedCount,_that.createdBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double lat,  double lng,  Map<String, dynamic> attributes, @JsonKey(name: 'verified_count')  int verifiedCount, @JsonKey(name: 'created_by')  String? createdBy)  $default,) {final _that = this;
switch (_that) {
case _AccessibilityPoiModel():
return $default(_that.id,_that.name,_that.lat,_that.lng,_that.attributes,_that.verifiedCount,_that.createdBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double lat,  double lng,  Map<String, dynamic> attributes, @JsonKey(name: 'verified_count')  int verifiedCount, @JsonKey(name: 'created_by')  String? createdBy)?  $default,) {final _that = this;
switch (_that) {
case _AccessibilityPoiModel() when $default != null:
return $default(_that.id,_that.name,_that.lat,_that.lng,_that.attributes,_that.verifiedCount,_that.createdBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccessibilityPoiModel implements AccessibilityPoiModel {
  const _AccessibilityPoiModel({required this.id, required this.name, required this.lat, required this.lng, required final  Map<String, dynamic> attributes, @JsonKey(name: 'verified_count') this.verifiedCount = 0, @JsonKey(name: 'created_by') this.createdBy}): _attributes = attributes;
  factory _AccessibilityPoiModel.fromJson(Map<String, dynamic> json) => _$AccessibilityPoiModelFromJson(json);

/// Primary key (UUID).
@override final  String id;
/// Human-readable name of the place.
@override final  String name;
/// Latitude (WGS-84) — stored as `double precision` in Postgres.
@override final  double lat;
/// Longitude (WGS-84) — stored as `double precision` in Postgres.
@override final  double lng;
/// Accessibility feature flags as a jsonb map.
///
/// Keys follow [PoiAttribute.jsonKey] conventions; values are booleans.
/// Use `Map<String, dynamic>` to handle free-form / unknown keys.
 final  Map<String, dynamic> _attributes;
/// Accessibility feature flags as a jsonb map.
///
/// Keys follow [PoiAttribute.jsonKey] conventions; values are booleans.
/// Use `Map<String, dynamic>` to handle free-form / unknown keys.
@override Map<String, dynamic> get attributes {
  if (_attributes is EqualUnmodifiableMapView) return _attributes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_attributes);
}

/// Number of community verifications.
@override@JsonKey(name: 'verified_count') final  int verifiedCount;
/// Optional FK to the profiles table (the creator).
@override@JsonKey(name: 'created_by') final  String? createdBy;

/// Create a copy of AccessibilityPoiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccessibilityPoiModelCopyWith<_AccessibilityPoiModel> get copyWith => __$AccessibilityPoiModelCopyWithImpl<_AccessibilityPoiModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccessibilityPoiModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccessibilityPoiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&const DeepCollectionEquality().equals(other._attributes, _attributes)&&(identical(other.verifiedCount, verifiedCount) || other.verifiedCount == verifiedCount)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,lat,lng,const DeepCollectionEquality().hash(_attributes),verifiedCount,createdBy);

@override
String toString() {
  return 'AccessibilityPoiModel(id: $id, name: $name, lat: $lat, lng: $lng, attributes: $attributes, verifiedCount: $verifiedCount, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class _$AccessibilityPoiModelCopyWith<$Res> implements $AccessibilityPoiModelCopyWith<$Res> {
  factory _$AccessibilityPoiModelCopyWith(_AccessibilityPoiModel value, $Res Function(_AccessibilityPoiModel) _then) = __$AccessibilityPoiModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double lat, double lng, Map<String, dynamic> attributes,@JsonKey(name: 'verified_count') int verifiedCount,@JsonKey(name: 'created_by') String? createdBy
});




}
/// @nodoc
class __$AccessibilityPoiModelCopyWithImpl<$Res>
    implements _$AccessibilityPoiModelCopyWith<$Res> {
  __$AccessibilityPoiModelCopyWithImpl(this._self, this._then);

  final _AccessibilityPoiModel _self;
  final $Res Function(_AccessibilityPoiModel) _then;

/// Create a copy of AccessibilityPoiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? lat = null,Object? lng = null,Object? attributes = null,Object? verifiedCount = null,Object? createdBy = freezed,}) {
  return _then(_AccessibilityPoiModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,attributes: null == attributes ? _self._attributes : attributes // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,verifiedCount: null == verifiedCount ? _self.verifiedCount : verifiedCount // ignore: cast_nullable_to_non_nullable
as int,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
