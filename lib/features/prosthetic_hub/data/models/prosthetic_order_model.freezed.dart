// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prosthetic_order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProstheticOrderModel {

/// Primary key (UUID).
 String get id;/// FK to `profiles.id` — the owner.
@JsonKey(name: 'user_id') String get userId;/// FK to `prosthetic_products.id`.
@JsonKey(name: 'product_id') String get productId;/// FK to `anthropometric_data.id` — set for custom orders.
@JsonKey(name: 'anthropometric_id') String? get anthropometricId;/// Current lifecycle status.
@JsonKey(fromJson: _statusFromJson, toJson: _statusToJson) OrderStatus get status;/// Whether the user has given explicit read-aloud consent.
@JsonKey(name: 'consent_given') bool get consentGiven;/// Order total in IDR.
@JsonKey(name: 'total_idr') int get totalIdr;/// Row creation timestamp (ISO 8601 string).
@JsonKey(name: 'created_at') String? get createdAt;
/// Create a copy of ProstheticOrderModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProstheticOrderModelCopyWith<ProstheticOrderModel> get copyWith => _$ProstheticOrderModelCopyWithImpl<ProstheticOrderModel>(this as ProstheticOrderModel, _$identity);

  /// Serializes this ProstheticOrderModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProstheticOrderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.anthropometricId, anthropometricId) || other.anthropometricId == anthropometricId)&&(identical(other.status, status) || other.status == status)&&(identical(other.consentGiven, consentGiven) || other.consentGiven == consentGiven)&&(identical(other.totalIdr, totalIdr) || other.totalIdr == totalIdr)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,productId,anthropometricId,status,consentGiven,totalIdr,createdAt);

@override
String toString() {
  return 'ProstheticOrderModel(id: $id, userId: $userId, productId: $productId, anthropometricId: $anthropometricId, status: $status, consentGiven: $consentGiven, totalIdr: $totalIdr, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ProstheticOrderModelCopyWith<$Res>  {
  factory $ProstheticOrderModelCopyWith(ProstheticOrderModel value, $Res Function(ProstheticOrderModel) _then) = _$ProstheticOrderModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'anthropometric_id') String? anthropometricId,@JsonKey(fromJson: _statusFromJson, toJson: _statusToJson) OrderStatus status,@JsonKey(name: 'consent_given') bool consentGiven,@JsonKey(name: 'total_idr') int totalIdr,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class _$ProstheticOrderModelCopyWithImpl<$Res>
    implements $ProstheticOrderModelCopyWith<$Res> {
  _$ProstheticOrderModelCopyWithImpl(this._self, this._then);

  final ProstheticOrderModel _self;
  final $Res Function(ProstheticOrderModel) _then;

/// Create a copy of ProstheticOrderModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? productId = null,Object? anthropometricId = freezed,Object? status = null,Object? consentGiven = null,Object? totalIdr = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,anthropometricId: freezed == anthropometricId ? _self.anthropometricId : anthropometricId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,consentGiven: null == consentGiven ? _self.consentGiven : consentGiven // ignore: cast_nullable_to_non_nullable
as bool,totalIdr: null == totalIdr ? _self.totalIdr : totalIdr // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProstheticOrderModel].
extension ProstheticOrderModelPatterns on ProstheticOrderModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProstheticOrderModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProstheticOrderModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProstheticOrderModel value)  $default,){
final _that = this;
switch (_that) {
case _ProstheticOrderModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProstheticOrderModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProstheticOrderModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'anthropometric_id')  String? anthropometricId, @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)  OrderStatus status, @JsonKey(name: 'consent_given')  bool consentGiven, @JsonKey(name: 'total_idr')  int totalIdr, @JsonKey(name: 'created_at')  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProstheticOrderModel() when $default != null:
return $default(_that.id,_that.userId,_that.productId,_that.anthropometricId,_that.status,_that.consentGiven,_that.totalIdr,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'anthropometric_id')  String? anthropometricId, @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)  OrderStatus status, @JsonKey(name: 'consent_given')  bool consentGiven, @JsonKey(name: 'total_idr')  int totalIdr, @JsonKey(name: 'created_at')  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ProstheticOrderModel():
return $default(_that.id,_that.userId,_that.productId,_that.anthropometricId,_that.status,_that.consentGiven,_that.totalIdr,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'anthropometric_id')  String? anthropometricId, @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)  OrderStatus status, @JsonKey(name: 'consent_given')  bool consentGiven, @JsonKey(name: 'total_idr')  int totalIdr, @JsonKey(name: 'created_at')  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ProstheticOrderModel() when $default != null:
return $default(_that.id,_that.userId,_that.productId,_that.anthropometricId,_that.status,_that.consentGiven,_that.totalIdr,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProstheticOrderModel implements ProstheticOrderModel {
  const _ProstheticOrderModel({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'anthropometric_id') this.anthropometricId, @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson) required this.status, @JsonKey(name: 'consent_given') this.consentGiven = false, @JsonKey(name: 'total_idr') required this.totalIdr, @JsonKey(name: 'created_at') this.createdAt});
  factory _ProstheticOrderModel.fromJson(Map<String, dynamic> json) => _$ProstheticOrderModelFromJson(json);

/// Primary key (UUID).
@override final  String id;
/// FK to `profiles.id` — the owner.
@override@JsonKey(name: 'user_id') final  String userId;
/// FK to `prosthetic_products.id`.
@override@JsonKey(name: 'product_id') final  String productId;
/// FK to `anthropometric_data.id` — set for custom orders.
@override@JsonKey(name: 'anthropometric_id') final  String? anthropometricId;
/// Current lifecycle status.
@override@JsonKey(fromJson: _statusFromJson, toJson: _statusToJson) final  OrderStatus status;
/// Whether the user has given explicit read-aloud consent.
@override@JsonKey(name: 'consent_given') final  bool consentGiven;
/// Order total in IDR.
@override@JsonKey(name: 'total_idr') final  int totalIdr;
/// Row creation timestamp (ISO 8601 string).
@override@JsonKey(name: 'created_at') final  String? createdAt;

/// Create a copy of ProstheticOrderModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProstheticOrderModelCopyWith<_ProstheticOrderModel> get copyWith => __$ProstheticOrderModelCopyWithImpl<_ProstheticOrderModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProstheticOrderModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProstheticOrderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.anthropometricId, anthropometricId) || other.anthropometricId == anthropometricId)&&(identical(other.status, status) || other.status == status)&&(identical(other.consentGiven, consentGiven) || other.consentGiven == consentGiven)&&(identical(other.totalIdr, totalIdr) || other.totalIdr == totalIdr)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,productId,anthropometricId,status,consentGiven,totalIdr,createdAt);

@override
String toString() {
  return 'ProstheticOrderModel(id: $id, userId: $userId, productId: $productId, anthropometricId: $anthropometricId, status: $status, consentGiven: $consentGiven, totalIdr: $totalIdr, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ProstheticOrderModelCopyWith<$Res> implements $ProstheticOrderModelCopyWith<$Res> {
  factory _$ProstheticOrderModelCopyWith(_ProstheticOrderModel value, $Res Function(_ProstheticOrderModel) _then) = __$ProstheticOrderModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'anthropometric_id') String? anthropometricId,@JsonKey(fromJson: _statusFromJson, toJson: _statusToJson) OrderStatus status,@JsonKey(name: 'consent_given') bool consentGiven,@JsonKey(name: 'total_idr') int totalIdr,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class __$ProstheticOrderModelCopyWithImpl<$Res>
    implements _$ProstheticOrderModelCopyWith<$Res> {
  __$ProstheticOrderModelCopyWithImpl(this._self, this._then);

  final _ProstheticOrderModel _self;
  final $Res Function(_ProstheticOrderModel) _then;

/// Create a copy of ProstheticOrderModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? productId = null,Object? anthropometricId = freezed,Object? status = null,Object? consentGiven = null,Object? totalIdr = null,Object? createdAt = freezed,}) {
  return _then(_ProstheticOrderModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,anthropometricId: freezed == anthropometricId ? _self.anthropometricId : anthropometricId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,consentGiven: null == consentGiven ? _self.consentGiven : consentGiven // ignore: cast_nullable_to_non_nullable
as bool,totalIdr: null == totalIdr ? _self.totalIdr : totalIdr // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
