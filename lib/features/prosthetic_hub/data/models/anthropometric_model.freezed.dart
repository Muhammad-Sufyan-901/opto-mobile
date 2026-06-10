// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anthropometric_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnthropometricModel {

/// Primary key (UUID).
 String get id;/// FK to `profiles.id` — the owner of this measurement record.
@JsonKey(name: 'user_id') String get userId;/// Socket size in millimetres (nullable — may not yet be measured).
@JsonKey(name: 'socket_size_mm') double? get socketSizeMm;/// Socket curvature in mm (nullable).
 double? get curvature;/// Iris diameter in millimetres (nullable).
@JsonKey(name: 'iris_diameter_mm') double? get irisDiameterMm;/// Hex colour code matched on-device via colour CV (nullable).
@JsonKey(name: 'matched_iris_hex') String? get matchedIrisHex;/// How the measurements were recorded.
@JsonKey(fromJson: _dataSourceFromJson, toJson: _dataSourceToJson) DataSource get source;/// Row creation timestamp (ISO 8601 string from Postgres).
@JsonKey(name: 'created_at') String? get createdAt;
/// Create a copy of AnthropometricModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnthropometricModelCopyWith<AnthropometricModel> get copyWith => _$AnthropometricModelCopyWithImpl<AnthropometricModel>(this as AnthropometricModel, _$identity);

  /// Serializes this AnthropometricModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnthropometricModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.socketSizeMm, socketSizeMm) || other.socketSizeMm == socketSizeMm)&&(identical(other.curvature, curvature) || other.curvature == curvature)&&(identical(other.irisDiameterMm, irisDiameterMm) || other.irisDiameterMm == irisDiameterMm)&&(identical(other.matchedIrisHex, matchedIrisHex) || other.matchedIrisHex == matchedIrisHex)&&(identical(other.source, source) || other.source == source)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,socketSizeMm,curvature,irisDiameterMm,matchedIrisHex,source,createdAt);

@override
String toString() {
  return 'AnthropometricModel(id: $id, userId: $userId, socketSizeMm: $socketSizeMm, curvature: $curvature, irisDiameterMm: $irisDiameterMm, matchedIrisHex: $matchedIrisHex, source: $source, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AnthropometricModelCopyWith<$Res>  {
  factory $AnthropometricModelCopyWith(AnthropometricModel value, $Res Function(AnthropometricModel) _then) = _$AnthropometricModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'socket_size_mm') double? socketSizeMm, double? curvature,@JsonKey(name: 'iris_diameter_mm') double? irisDiameterMm,@JsonKey(name: 'matched_iris_hex') String? matchedIrisHex,@JsonKey(fromJson: _dataSourceFromJson, toJson: _dataSourceToJson) DataSource source,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class _$AnthropometricModelCopyWithImpl<$Res>
    implements $AnthropometricModelCopyWith<$Res> {
  _$AnthropometricModelCopyWithImpl(this._self, this._then);

  final AnthropometricModel _self;
  final $Res Function(AnthropometricModel) _then;

/// Create a copy of AnthropometricModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? socketSizeMm = freezed,Object? curvature = freezed,Object? irisDiameterMm = freezed,Object? matchedIrisHex = freezed,Object? source = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,socketSizeMm: freezed == socketSizeMm ? _self.socketSizeMm : socketSizeMm // ignore: cast_nullable_to_non_nullable
as double?,curvature: freezed == curvature ? _self.curvature : curvature // ignore: cast_nullable_to_non_nullable
as double?,irisDiameterMm: freezed == irisDiameterMm ? _self.irisDiameterMm : irisDiameterMm // ignore: cast_nullable_to_non_nullable
as double?,matchedIrisHex: freezed == matchedIrisHex ? _self.matchedIrisHex : matchedIrisHex // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as DataSource,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AnthropometricModel].
extension AnthropometricModelPatterns on AnthropometricModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnthropometricModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnthropometricModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnthropometricModel value)  $default,){
final _that = this;
switch (_that) {
case _AnthropometricModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnthropometricModel value)?  $default,){
final _that = this;
switch (_that) {
case _AnthropometricModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'socket_size_mm')  double? socketSizeMm,  double? curvature, @JsonKey(name: 'iris_diameter_mm')  double? irisDiameterMm, @JsonKey(name: 'matched_iris_hex')  String? matchedIrisHex, @JsonKey(fromJson: _dataSourceFromJson, toJson: _dataSourceToJson)  DataSource source, @JsonKey(name: 'created_at')  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnthropometricModel() when $default != null:
return $default(_that.id,_that.userId,_that.socketSizeMm,_that.curvature,_that.irisDiameterMm,_that.matchedIrisHex,_that.source,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'socket_size_mm')  double? socketSizeMm,  double? curvature, @JsonKey(name: 'iris_diameter_mm')  double? irisDiameterMm, @JsonKey(name: 'matched_iris_hex')  String? matchedIrisHex, @JsonKey(fromJson: _dataSourceFromJson, toJson: _dataSourceToJson)  DataSource source, @JsonKey(name: 'created_at')  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _AnthropometricModel():
return $default(_that.id,_that.userId,_that.socketSizeMm,_that.curvature,_that.irisDiameterMm,_that.matchedIrisHex,_that.source,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'socket_size_mm')  double? socketSizeMm,  double? curvature, @JsonKey(name: 'iris_diameter_mm')  double? irisDiameterMm, @JsonKey(name: 'matched_iris_hex')  String? matchedIrisHex, @JsonKey(fromJson: _dataSourceFromJson, toJson: _dataSourceToJson)  DataSource source, @JsonKey(name: 'created_at')  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AnthropometricModel() when $default != null:
return $default(_that.id,_that.userId,_that.socketSizeMm,_that.curvature,_that.irisDiameterMm,_that.matchedIrisHex,_that.source,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnthropometricModel implements AnthropometricModel {
  const _AnthropometricModel({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'socket_size_mm') this.socketSizeMm, this.curvature, @JsonKey(name: 'iris_diameter_mm') this.irisDiameterMm, @JsonKey(name: 'matched_iris_hex') this.matchedIrisHex, @JsonKey(fromJson: _dataSourceFromJson, toJson: _dataSourceToJson) required this.source, @JsonKey(name: 'created_at') this.createdAt});
  factory _AnthropometricModel.fromJson(Map<String, dynamic> json) => _$AnthropometricModelFromJson(json);

/// Primary key (UUID).
@override final  String id;
/// FK to `profiles.id` — the owner of this measurement record.
@override@JsonKey(name: 'user_id') final  String userId;
/// Socket size in millimetres (nullable — may not yet be measured).
@override@JsonKey(name: 'socket_size_mm') final  double? socketSizeMm;
/// Socket curvature in mm (nullable).
@override final  double? curvature;
/// Iris diameter in millimetres (nullable).
@override@JsonKey(name: 'iris_diameter_mm') final  double? irisDiameterMm;
/// Hex colour code matched on-device via colour CV (nullable).
@override@JsonKey(name: 'matched_iris_hex') final  String? matchedIrisHex;
/// How the measurements were recorded.
@override@JsonKey(fromJson: _dataSourceFromJson, toJson: _dataSourceToJson) final  DataSource source;
/// Row creation timestamp (ISO 8601 string from Postgres).
@override@JsonKey(name: 'created_at') final  String? createdAt;

/// Create a copy of AnthropometricModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnthropometricModelCopyWith<_AnthropometricModel> get copyWith => __$AnthropometricModelCopyWithImpl<_AnthropometricModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnthropometricModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnthropometricModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.socketSizeMm, socketSizeMm) || other.socketSizeMm == socketSizeMm)&&(identical(other.curvature, curvature) || other.curvature == curvature)&&(identical(other.irisDiameterMm, irisDiameterMm) || other.irisDiameterMm == irisDiameterMm)&&(identical(other.matchedIrisHex, matchedIrisHex) || other.matchedIrisHex == matchedIrisHex)&&(identical(other.source, source) || other.source == source)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,socketSizeMm,curvature,irisDiameterMm,matchedIrisHex,source,createdAt);

@override
String toString() {
  return 'AnthropometricModel(id: $id, userId: $userId, socketSizeMm: $socketSizeMm, curvature: $curvature, irisDiameterMm: $irisDiameterMm, matchedIrisHex: $matchedIrisHex, source: $source, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AnthropometricModelCopyWith<$Res> implements $AnthropometricModelCopyWith<$Res> {
  factory _$AnthropometricModelCopyWith(_AnthropometricModel value, $Res Function(_AnthropometricModel) _then) = __$AnthropometricModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'socket_size_mm') double? socketSizeMm, double? curvature,@JsonKey(name: 'iris_diameter_mm') double? irisDiameterMm,@JsonKey(name: 'matched_iris_hex') String? matchedIrisHex,@JsonKey(fromJson: _dataSourceFromJson, toJson: _dataSourceToJson) DataSource source,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class __$AnthropometricModelCopyWithImpl<$Res>
    implements _$AnthropometricModelCopyWith<$Res> {
  __$AnthropometricModelCopyWithImpl(this._self, this._then);

  final _AnthropometricModel _self;
  final $Res Function(_AnthropometricModel) _then;

/// Create a copy of AnthropometricModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? socketSizeMm = freezed,Object? curvature = freezed,Object? irisDiameterMm = freezed,Object? matchedIrisHex = freezed,Object? source = null,Object? createdAt = freezed,}) {
  return _then(_AnthropometricModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,socketSizeMm: freezed == socketSizeMm ? _self.socketSizeMm : socketSizeMm // ignore: cast_nullable_to_non_nullable
as double?,curvature: freezed == curvature ? _self.curvature : curvature // ignore: cast_nullable_to_non_nullable
as double?,irisDiameterMm: freezed == irisDiameterMm ? _self.irisDiameterMm : irisDiameterMm // ignore: cast_nullable_to_non_nullable
as double?,matchedIrisHex: freezed == matchedIrisHex ? _self.matchedIrisHex : matchedIrisHex // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as DataSource,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
