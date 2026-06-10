// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'care_reminder_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CareReminderModel {

 String get id;@JsonKey(name: 'user_id') String get userId;/// Human-readable label, e.g. "Daily lens cleaning".
 String get label;/// Cron expression, e.g. "0 8 * * *" (daily at 8 AM).
@JsonKey(name: 'schedule_cron') String get scheduleCron;/// Whether the linked caregiver should also be notified.
@JsonKey(name: 'notify_caregiver') bool get notifyCaregiver;/// Whether this reminder is currently active.
@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of CareReminderModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareReminderModelCopyWith<CareReminderModel> get copyWith => _$CareReminderModelCopyWithImpl<CareReminderModel>(this as CareReminderModel, _$identity);

  /// Serializes this CareReminderModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareReminderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.label, label) || other.label == label)&&(identical(other.scheduleCron, scheduleCron) || other.scheduleCron == scheduleCron)&&(identical(other.notifyCaregiver, notifyCaregiver) || other.notifyCaregiver == notifyCaregiver)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,label,scheduleCron,notifyCaregiver,isActive);

@override
String toString() {
  return 'CareReminderModel(id: $id, userId: $userId, label: $label, scheduleCron: $scheduleCron, notifyCaregiver: $notifyCaregiver, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $CareReminderModelCopyWith<$Res>  {
  factory $CareReminderModelCopyWith(CareReminderModel value, $Res Function(CareReminderModel) _then) = _$CareReminderModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String label,@JsonKey(name: 'schedule_cron') String scheduleCron,@JsonKey(name: 'notify_caregiver') bool notifyCaregiver,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$CareReminderModelCopyWithImpl<$Res>
    implements $CareReminderModelCopyWith<$Res> {
  _$CareReminderModelCopyWithImpl(this._self, this._then);

  final CareReminderModel _self;
  final $Res Function(CareReminderModel) _then;

/// Create a copy of CareReminderModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? label = null,Object? scheduleCron = null,Object? notifyCaregiver = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,scheduleCron: null == scheduleCron ? _self.scheduleCron : scheduleCron // ignore: cast_nullable_to_non_nullable
as String,notifyCaregiver: null == notifyCaregiver ? _self.notifyCaregiver : notifyCaregiver // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CareReminderModel].
extension CareReminderModelPatterns on CareReminderModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CareReminderModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CareReminderModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CareReminderModel value)  $default,){
final _that = this;
switch (_that) {
case _CareReminderModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CareReminderModel value)?  $default,){
final _that = this;
switch (_that) {
case _CareReminderModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String label, @JsonKey(name: 'schedule_cron')  String scheduleCron, @JsonKey(name: 'notify_caregiver')  bool notifyCaregiver, @JsonKey(name: 'is_active')  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CareReminderModel() when $default != null:
return $default(_that.id,_that.userId,_that.label,_that.scheduleCron,_that.notifyCaregiver,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String label, @JsonKey(name: 'schedule_cron')  String scheduleCron, @JsonKey(name: 'notify_caregiver')  bool notifyCaregiver, @JsonKey(name: 'is_active')  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _CareReminderModel():
return $default(_that.id,_that.userId,_that.label,_that.scheduleCron,_that.notifyCaregiver,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId,  String label, @JsonKey(name: 'schedule_cron')  String scheduleCron, @JsonKey(name: 'notify_caregiver')  bool notifyCaregiver, @JsonKey(name: 'is_active')  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _CareReminderModel() when $default != null:
return $default(_that.id,_that.userId,_that.label,_that.scheduleCron,_that.notifyCaregiver,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CareReminderModel implements CareReminderModel {
  const _CareReminderModel({required this.id, @JsonKey(name: 'user_id') required this.userId, required this.label, @JsonKey(name: 'schedule_cron') required this.scheduleCron, @JsonKey(name: 'notify_caregiver') this.notifyCaregiver = false, @JsonKey(name: 'is_active') this.isActive = true});
  factory _CareReminderModel.fromJson(Map<String, dynamic> json) => _$CareReminderModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
/// Human-readable label, e.g. "Daily lens cleaning".
@override final  String label;
/// Cron expression, e.g. "0 8 * * *" (daily at 8 AM).
@override@JsonKey(name: 'schedule_cron') final  String scheduleCron;
/// Whether the linked caregiver should also be notified.
@override@JsonKey(name: 'notify_caregiver') final  bool notifyCaregiver;
/// Whether this reminder is currently active.
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of CareReminderModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareReminderModelCopyWith<_CareReminderModel> get copyWith => __$CareReminderModelCopyWithImpl<_CareReminderModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CareReminderModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CareReminderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.label, label) || other.label == label)&&(identical(other.scheduleCron, scheduleCron) || other.scheduleCron == scheduleCron)&&(identical(other.notifyCaregiver, notifyCaregiver) || other.notifyCaregiver == notifyCaregiver)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,label,scheduleCron,notifyCaregiver,isActive);

@override
String toString() {
  return 'CareReminderModel(id: $id, userId: $userId, label: $label, scheduleCron: $scheduleCron, notifyCaregiver: $notifyCaregiver, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$CareReminderModelCopyWith<$Res> implements $CareReminderModelCopyWith<$Res> {
  factory _$CareReminderModelCopyWith(_CareReminderModel value, $Res Function(_CareReminderModel) _then) = __$CareReminderModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String label,@JsonKey(name: 'schedule_cron') String scheduleCron,@JsonKey(name: 'notify_caregiver') bool notifyCaregiver,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$CareReminderModelCopyWithImpl<$Res>
    implements _$CareReminderModelCopyWith<$Res> {
  __$CareReminderModelCopyWithImpl(this._self, this._then);

  final _CareReminderModel _self;
  final $Res Function(_CareReminderModel) _then;

/// Create a copy of CareReminderModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? label = null,Object? scheduleCron = null,Object? notifyCaregiver = null,Object? isActive = null,}) {
  return _then(_CareReminderModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,scheduleCron: null == scheduleCron ? _self.scheduleCron : scheduleCron // ignore: cast_nullable_to_non_nullable
as String,notifyCaregiver: null == notifyCaregiver ? _self.notifyCaregiver : notifyCaregiver // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
