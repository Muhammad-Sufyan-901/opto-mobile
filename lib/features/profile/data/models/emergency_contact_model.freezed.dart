// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'emergency_contact_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EmergencyContactModel {

/// Primary key (UUID).
 String get id;/// Foreign key to `profiles.id` (UUID) — the owner of this contact.
@JsonKey(name: 'user_id') String get userId;/// Full name of the emergency contact.
 String get name;/// Phone number of the emergency contact.
 String get phone;/// Optional relationship label (e.g. "Mother", "Spouse").
 String? get relationship;/// Sort order; lower numbers are contacted first (default 0).
 int get priority;
/// Create a copy of EmergencyContactModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmergencyContactModelCopyWith<EmergencyContactModel> get copyWith => _$EmergencyContactModelCopyWithImpl<EmergencyContactModel>(this as EmergencyContactModel, _$identity);

  /// Serializes this EmergencyContactModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmergencyContactModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.priority, priority) || other.priority == priority));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,phone,relationship,priority);

@override
String toString() {
  return 'EmergencyContactModel(id: $id, userId: $userId, name: $name, phone: $phone, relationship: $relationship, priority: $priority)';
}


}

/// @nodoc
abstract mixin class $EmergencyContactModelCopyWith<$Res>  {
  factory $EmergencyContactModelCopyWith(EmergencyContactModel value, $Res Function(EmergencyContactModel) _then) = _$EmergencyContactModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String name, String phone, String? relationship, int priority
});




}
/// @nodoc
class _$EmergencyContactModelCopyWithImpl<$Res>
    implements $EmergencyContactModelCopyWith<$Res> {
  _$EmergencyContactModelCopyWithImpl(this._self, this._then);

  final EmergencyContactModel _self;
  final $Res Function(EmergencyContactModel) _then;

/// Create a copy of EmergencyContactModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? phone = null,Object? relationship = freezed,Object? priority = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,relationship: freezed == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EmergencyContactModel].
extension EmergencyContactModelPatterns on EmergencyContactModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmergencyContactModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmergencyContactModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmergencyContactModel value)  $default,){
final _that = this;
switch (_that) {
case _EmergencyContactModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmergencyContactModel value)?  $default,){
final _that = this;
switch (_that) {
case _EmergencyContactModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String name,  String phone,  String? relationship,  int priority)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmergencyContactModel() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.phone,_that.relationship,_that.priority);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String name,  String phone,  String? relationship,  int priority)  $default,) {final _that = this;
switch (_that) {
case _EmergencyContactModel():
return $default(_that.id,_that.userId,_that.name,_that.phone,_that.relationship,_that.priority);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId,  String name,  String phone,  String? relationship,  int priority)?  $default,) {final _that = this;
switch (_that) {
case _EmergencyContactModel() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.phone,_that.relationship,_that.priority);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmergencyContactModel implements EmergencyContactModel {
  const _EmergencyContactModel({required this.id, @JsonKey(name: 'user_id') required this.userId, required this.name, required this.phone, this.relationship, this.priority = 0});
  factory _EmergencyContactModel.fromJson(Map<String, dynamic> json) => _$EmergencyContactModelFromJson(json);

/// Primary key (UUID).
@override final  String id;
/// Foreign key to `profiles.id` (UUID) — the owner of this contact.
@override@JsonKey(name: 'user_id') final  String userId;
/// Full name of the emergency contact.
@override final  String name;
/// Phone number of the emergency contact.
@override final  String phone;
/// Optional relationship label (e.g. "Mother", "Spouse").
@override final  String? relationship;
/// Sort order; lower numbers are contacted first (default 0).
@override@JsonKey() final  int priority;

/// Create a copy of EmergencyContactModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmergencyContactModelCopyWith<_EmergencyContactModel> get copyWith => __$EmergencyContactModelCopyWithImpl<_EmergencyContactModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmergencyContactModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmergencyContactModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.priority, priority) || other.priority == priority));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,phone,relationship,priority);

@override
String toString() {
  return 'EmergencyContactModel(id: $id, userId: $userId, name: $name, phone: $phone, relationship: $relationship, priority: $priority)';
}


}

/// @nodoc
abstract mixin class _$EmergencyContactModelCopyWith<$Res> implements $EmergencyContactModelCopyWith<$Res> {
  factory _$EmergencyContactModelCopyWith(_EmergencyContactModel value, $Res Function(_EmergencyContactModel) _then) = __$EmergencyContactModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String name, String phone, String? relationship, int priority
});




}
/// @nodoc
class __$EmergencyContactModelCopyWithImpl<$Res>
    implements _$EmergencyContactModelCopyWith<$Res> {
  __$EmergencyContactModelCopyWithImpl(this._self, this._then);

  final _EmergencyContactModel _self;
  final $Res Function(_EmergencyContactModel) _then;

/// Create a copy of EmergencyContactModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? phone = null,Object? relationship = freezed,Object? priority = null,}) {
  return _then(_EmergencyContactModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,relationship: freezed == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
