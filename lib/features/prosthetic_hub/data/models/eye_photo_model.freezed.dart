// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'eye_photo_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EyePhotoModel {

/// Primary key (UUID).
 String get id;/// FK to `profiles.id` — the owner.
@JsonKey(name: 'user_id') String get userId;/// Path to the private object in the `eye-photos` Storage bucket.
@JsonKey(name: 'storage_path') String get storagePath;/// Intended use for this photo.
@JsonKey(fromJson: _purposeFromJson, toJson: _purposeToJson) PhotoPurpose get purpose;/// Row creation timestamp (ISO 8601 string).
@JsonKey(name: 'created_at') String? get createdAt;
/// Create a copy of EyePhotoModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EyePhotoModelCopyWith<EyePhotoModel> get copyWith => _$EyePhotoModelCopyWithImpl<EyePhotoModel>(this as EyePhotoModel, _$identity);

  /// Serializes this EyePhotoModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EyePhotoModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,storagePath,purpose,createdAt);

@override
String toString() {
  return 'EyePhotoModel(id: $id, userId: $userId, storagePath: $storagePath, purpose: $purpose, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $EyePhotoModelCopyWith<$Res>  {
  factory $EyePhotoModelCopyWith(EyePhotoModel value, $Res Function(EyePhotoModel) _then) = _$EyePhotoModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'storage_path') String storagePath,@JsonKey(fromJson: _purposeFromJson, toJson: _purposeToJson) PhotoPurpose purpose,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class _$EyePhotoModelCopyWithImpl<$Res>
    implements $EyePhotoModelCopyWith<$Res> {
  _$EyePhotoModelCopyWithImpl(this._self, this._then);

  final EyePhotoModel _self;
  final $Res Function(EyePhotoModel) _then;

/// Create a copy of EyePhotoModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? storagePath = null,Object? purpose = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as PhotoPurpose,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EyePhotoModel].
extension EyePhotoModelPatterns on EyePhotoModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EyePhotoModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EyePhotoModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EyePhotoModel value)  $default,){
final _that = this;
switch (_that) {
case _EyePhotoModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EyePhotoModel value)?  $default,){
final _that = this;
switch (_that) {
case _EyePhotoModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'storage_path')  String storagePath, @JsonKey(fromJson: _purposeFromJson, toJson: _purposeToJson)  PhotoPurpose purpose, @JsonKey(name: 'created_at')  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EyePhotoModel() when $default != null:
return $default(_that.id,_that.userId,_that.storagePath,_that.purpose,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'storage_path')  String storagePath, @JsonKey(fromJson: _purposeFromJson, toJson: _purposeToJson)  PhotoPurpose purpose, @JsonKey(name: 'created_at')  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _EyePhotoModel():
return $default(_that.id,_that.userId,_that.storagePath,_that.purpose,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'storage_path')  String storagePath, @JsonKey(fromJson: _purposeFromJson, toJson: _purposeToJson)  PhotoPurpose purpose, @JsonKey(name: 'created_at')  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _EyePhotoModel() when $default != null:
return $default(_that.id,_that.userId,_that.storagePath,_that.purpose,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EyePhotoModel implements EyePhotoModel {
  const _EyePhotoModel({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'storage_path') required this.storagePath, @JsonKey(fromJson: _purposeFromJson, toJson: _purposeToJson) required this.purpose, @JsonKey(name: 'created_at') this.createdAt});
  factory _EyePhotoModel.fromJson(Map<String, dynamic> json) => _$EyePhotoModelFromJson(json);

/// Primary key (UUID).
@override final  String id;
/// FK to `profiles.id` — the owner.
@override@JsonKey(name: 'user_id') final  String userId;
/// Path to the private object in the `eye-photos` Storage bucket.
@override@JsonKey(name: 'storage_path') final  String storagePath;
/// Intended use for this photo.
@override@JsonKey(fromJson: _purposeFromJson, toJson: _purposeToJson) final  PhotoPurpose purpose;
/// Row creation timestamp (ISO 8601 string).
@override@JsonKey(name: 'created_at') final  String? createdAt;

/// Create a copy of EyePhotoModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EyePhotoModelCopyWith<_EyePhotoModel> get copyWith => __$EyePhotoModelCopyWithImpl<_EyePhotoModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EyePhotoModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EyePhotoModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,storagePath,purpose,createdAt);

@override
String toString() {
  return 'EyePhotoModel(id: $id, userId: $userId, storagePath: $storagePath, purpose: $purpose, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$EyePhotoModelCopyWith<$Res> implements $EyePhotoModelCopyWith<$Res> {
  factory _$EyePhotoModelCopyWith(_EyePhotoModel value, $Res Function(_EyePhotoModel) _then) = __$EyePhotoModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'storage_path') String storagePath,@JsonKey(fromJson: _purposeFromJson, toJson: _purposeToJson) PhotoPurpose purpose,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class __$EyePhotoModelCopyWithImpl<$Res>
    implements _$EyePhotoModelCopyWith<$Res> {
  __$EyePhotoModelCopyWithImpl(this._self, this._then);

  final _EyePhotoModel _self;
  final $Res Function(_EyePhotoModel) _then;

/// Create a copy of EyePhotoModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? storagePath = null,Object? purpose = null,Object? createdAt = freezed,}) {
  return _then(_EyePhotoModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as PhotoPurpose,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
