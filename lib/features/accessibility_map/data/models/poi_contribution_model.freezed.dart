// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poi_contribution_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PoiContributionModel {

/// Primary key (UUID).
 String get id;/// FK → `accessibility_pois.id`.
@JsonKey(name: 'poi_id') String get poiId;/// FK → `profiles.id`.
@JsonKey(name: 'user_id') String get userId;/// Proposed change payload. Empty map `{}` for a plain verification.
 Map<String, dynamic> get change;/// Moderation status string — use [ContributionStatus.fromString].
 String get status;/// Row creation timestamp (ISO-8601 string from Postgres; nullable).
@JsonKey(name: 'created_at') String? get createdAt;
/// Create a copy of PoiContributionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PoiContributionModelCopyWith<PoiContributionModel> get copyWith => _$PoiContributionModelCopyWithImpl<PoiContributionModel>(this as PoiContributionModel, _$identity);

  /// Serializes this PoiContributionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PoiContributionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.poiId, poiId) || other.poiId == poiId)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.change, change)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,poiId,userId,const DeepCollectionEquality().hash(change),status,createdAt);

@override
String toString() {
  return 'PoiContributionModel(id: $id, poiId: $poiId, userId: $userId, change: $change, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PoiContributionModelCopyWith<$Res>  {
  factory $PoiContributionModelCopyWith(PoiContributionModel value, $Res Function(PoiContributionModel) _then) = _$PoiContributionModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'poi_id') String poiId,@JsonKey(name: 'user_id') String userId, Map<String, dynamic> change, String status,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class _$PoiContributionModelCopyWithImpl<$Res>
    implements $PoiContributionModelCopyWith<$Res> {
  _$PoiContributionModelCopyWithImpl(this._self, this._then);

  final PoiContributionModel _self;
  final $Res Function(PoiContributionModel) _then;

/// Create a copy of PoiContributionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? poiId = null,Object? userId = null,Object? change = null,Object? status = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,poiId: null == poiId ? _self.poiId : poiId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,change: null == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PoiContributionModel].
extension PoiContributionModelPatterns on PoiContributionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PoiContributionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PoiContributionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PoiContributionModel value)  $default,){
final _that = this;
switch (_that) {
case _PoiContributionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PoiContributionModel value)?  $default,){
final _that = this;
switch (_that) {
case _PoiContributionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'poi_id')  String poiId, @JsonKey(name: 'user_id')  String userId,  Map<String, dynamic> change,  String status, @JsonKey(name: 'created_at')  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PoiContributionModel() when $default != null:
return $default(_that.id,_that.poiId,_that.userId,_that.change,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'poi_id')  String poiId, @JsonKey(name: 'user_id')  String userId,  Map<String, dynamic> change,  String status, @JsonKey(name: 'created_at')  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _PoiContributionModel():
return $default(_that.id,_that.poiId,_that.userId,_that.change,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'poi_id')  String poiId, @JsonKey(name: 'user_id')  String userId,  Map<String, dynamic> change,  String status, @JsonKey(name: 'created_at')  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PoiContributionModel() when $default != null:
return $default(_that.id,_that.poiId,_that.userId,_that.change,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PoiContributionModel implements PoiContributionModel {
  const _PoiContributionModel({required this.id, @JsonKey(name: 'poi_id') required this.poiId, @JsonKey(name: 'user_id') required this.userId, required final  Map<String, dynamic> change, required this.status, @JsonKey(name: 'created_at') this.createdAt}): _change = change;
  factory _PoiContributionModel.fromJson(Map<String, dynamic> json) => _$PoiContributionModelFromJson(json);

/// Primary key (UUID).
@override final  String id;
/// FK → `accessibility_pois.id`.
@override@JsonKey(name: 'poi_id') final  String poiId;
/// FK → `profiles.id`.
@override@JsonKey(name: 'user_id') final  String userId;
/// Proposed change payload. Empty map `{}` for a plain verification.
 final  Map<String, dynamic> _change;
/// Proposed change payload. Empty map `{}` for a plain verification.
@override Map<String, dynamic> get change {
  if (_change is EqualUnmodifiableMapView) return _change;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_change);
}

/// Moderation status string — use [ContributionStatus.fromString].
@override final  String status;
/// Row creation timestamp (ISO-8601 string from Postgres; nullable).
@override@JsonKey(name: 'created_at') final  String? createdAt;

/// Create a copy of PoiContributionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PoiContributionModelCopyWith<_PoiContributionModel> get copyWith => __$PoiContributionModelCopyWithImpl<_PoiContributionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PoiContributionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PoiContributionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.poiId, poiId) || other.poiId == poiId)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other._change, _change)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,poiId,userId,const DeepCollectionEquality().hash(_change),status,createdAt);

@override
String toString() {
  return 'PoiContributionModel(id: $id, poiId: $poiId, userId: $userId, change: $change, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PoiContributionModelCopyWith<$Res> implements $PoiContributionModelCopyWith<$Res> {
  factory _$PoiContributionModelCopyWith(_PoiContributionModel value, $Res Function(_PoiContributionModel) _then) = __$PoiContributionModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'poi_id') String poiId,@JsonKey(name: 'user_id') String userId, Map<String, dynamic> change, String status,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class __$PoiContributionModelCopyWithImpl<$Res>
    implements _$PoiContributionModelCopyWith<$Res> {
  __$PoiContributionModelCopyWithImpl(this._self, this._then);

  final _PoiContributionModel _self;
  final $Res Function(_PoiContributionModel) _then;

/// Create a copy of PoiContributionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? poiId = null,Object? userId = null,Object? change = null,Object? status = null,Object? createdAt = freezed,}) {
  return _then(_PoiContributionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,poiId: null == poiId ? _self.poiId : poiId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,change: null == change ? _self._change : change // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
