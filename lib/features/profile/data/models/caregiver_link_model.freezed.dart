// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'caregiver_link_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CaregiverLinkModel {

/// Primary key (UUID).
 String get id;/// Foreign key to `profiles.id` — the primary (low-vision) user.
@JsonKey(name: 'user_id') String get userId;/// Foreign key to `profiles.id` — the caregiver.
@JsonKey(name: 'caregiver_id') String get caregiverId;/// Lifecycle state of the link; starts as [LinkStatus.pending].
@_LinkStatusConverter() LinkStatus get status;/// Scoped permissions granted to the caregiver
/// (e.g. `['read:health', 'write:sos']`).
 List<String> get permissions;/// Row creation timestamp — set by Postgres default.
@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of CaregiverLinkModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CaregiverLinkModelCopyWith<CaregiverLinkModel> get copyWith => _$CaregiverLinkModelCopyWithImpl<CaregiverLinkModel>(this as CaregiverLinkModel, _$identity);

  /// Serializes this CaregiverLinkModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CaregiverLinkModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.caregiverId, caregiverId) || other.caregiverId == caregiverId)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.permissions, permissions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,caregiverId,status,const DeepCollectionEquality().hash(permissions),createdAt);

@override
String toString() {
  return 'CaregiverLinkModel(id: $id, userId: $userId, caregiverId: $caregiverId, status: $status, permissions: $permissions, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CaregiverLinkModelCopyWith<$Res>  {
  factory $CaregiverLinkModelCopyWith(CaregiverLinkModel value, $Res Function(CaregiverLinkModel) _then) = _$CaregiverLinkModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'caregiver_id') String caregiverId,@_LinkStatusConverter() LinkStatus status, List<String> permissions,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$CaregiverLinkModelCopyWithImpl<$Res>
    implements $CaregiverLinkModelCopyWith<$Res> {
  _$CaregiverLinkModelCopyWithImpl(this._self, this._then);

  final CaregiverLinkModel _self;
  final $Res Function(CaregiverLinkModel) _then;

/// Create a copy of CaregiverLinkModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? caregiverId = null,Object? status = null,Object? permissions = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,caregiverId: null == caregiverId ? _self.caregiverId : caregiverId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LinkStatus,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CaregiverLinkModel].
extension CaregiverLinkModelPatterns on CaregiverLinkModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CaregiverLinkModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CaregiverLinkModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CaregiverLinkModel value)  $default,){
final _that = this;
switch (_that) {
case _CaregiverLinkModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CaregiverLinkModel value)?  $default,){
final _that = this;
switch (_that) {
case _CaregiverLinkModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'caregiver_id')  String caregiverId, @_LinkStatusConverter()  LinkStatus status,  List<String> permissions, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CaregiverLinkModel() when $default != null:
return $default(_that.id,_that.userId,_that.caregiverId,_that.status,_that.permissions,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'caregiver_id')  String caregiverId, @_LinkStatusConverter()  LinkStatus status,  List<String> permissions, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _CaregiverLinkModel():
return $default(_that.id,_that.userId,_that.caregiverId,_that.status,_that.permissions,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'caregiver_id')  String caregiverId, @_LinkStatusConverter()  LinkStatus status,  List<String> permissions, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CaregiverLinkModel() when $default != null:
return $default(_that.id,_that.userId,_that.caregiverId,_that.status,_that.permissions,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CaregiverLinkModel implements CaregiverLinkModel {
  const _CaregiverLinkModel({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'caregiver_id') required this.caregiverId, @_LinkStatusConverter() this.status = LinkStatus.pending, final  List<String> permissions = const <String>[], @JsonKey(name: 'created_at') required this.createdAt}): _permissions = permissions;
  factory _CaregiverLinkModel.fromJson(Map<String, dynamic> json) => _$CaregiverLinkModelFromJson(json);

/// Primary key (UUID).
@override final  String id;
/// Foreign key to `profiles.id` — the primary (low-vision) user.
@override@JsonKey(name: 'user_id') final  String userId;
/// Foreign key to `profiles.id` — the caregiver.
@override@JsonKey(name: 'caregiver_id') final  String caregiverId;
/// Lifecycle state of the link; starts as [LinkStatus.pending].
@override@JsonKey()@_LinkStatusConverter() final  LinkStatus status;
/// Scoped permissions granted to the caregiver
/// (e.g. `['read:health', 'write:sos']`).
 final  List<String> _permissions;
/// Scoped permissions granted to the caregiver
/// (e.g. `['read:health', 'write:sos']`).
@override@JsonKey() List<String> get permissions {
  if (_permissions is EqualUnmodifiableListView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_permissions);
}

/// Row creation timestamp — set by Postgres default.
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of CaregiverLinkModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CaregiverLinkModelCopyWith<_CaregiverLinkModel> get copyWith => __$CaregiverLinkModelCopyWithImpl<_CaregiverLinkModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CaregiverLinkModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CaregiverLinkModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.caregiverId, caregiverId) || other.caregiverId == caregiverId)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._permissions, _permissions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,caregiverId,status,const DeepCollectionEquality().hash(_permissions),createdAt);

@override
String toString() {
  return 'CaregiverLinkModel(id: $id, userId: $userId, caregiverId: $caregiverId, status: $status, permissions: $permissions, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CaregiverLinkModelCopyWith<$Res> implements $CaregiverLinkModelCopyWith<$Res> {
  factory _$CaregiverLinkModelCopyWith(_CaregiverLinkModel value, $Res Function(_CaregiverLinkModel) _then) = __$CaregiverLinkModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'caregiver_id') String caregiverId,@_LinkStatusConverter() LinkStatus status, List<String> permissions,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$CaregiverLinkModelCopyWithImpl<$Res>
    implements _$CaregiverLinkModelCopyWith<$Res> {
  __$CaregiverLinkModelCopyWithImpl(this._self, this._then);

  final _CaregiverLinkModel _self;
  final $Res Function(_CaregiverLinkModel) _then;

/// Create a copy of CaregiverLinkModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? caregiverId = null,Object? status = null,Object? permissions = null,Object? createdAt = null,}) {
  return _then(_CaregiverLinkModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,caregiverId: null == caregiverId ? _self.caregiverId : caregiverId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LinkStatus,permissions: null == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
