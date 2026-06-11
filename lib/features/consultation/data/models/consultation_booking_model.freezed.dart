// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consultation_booking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConsultationBookingModel {

/// Primary key (UUID).
 String get id;/// FK → `profiles.id` — the patient.
@JsonKey(name: 'user_id') String get userId;/// FK → `doctors.id` — the booked doctor.
@JsonKey(name: 'doctor_id') String get doctorId;/// FK → `doctor_availability.id` — the reserved slot.
@JsonKey(name: 'slot_id') String get slotId;/// Delivery mode — raw Postgres `consult_mode` enum string
/// ('video', 'non_verbal', 'in_person').
 String get mode;/// Lifecycle status — raw Postgres `booking_status` enum string
/// ('booked', 'completed', 'cancelled').
 String get status;/// Whether the booking was completed entirely via Aura Voice.
@JsonKey(name: 'booked_via_voice') bool get bookedViaVoice;/// Row creation timestamp — set by Postgres default.
@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of ConsultationBookingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsultationBookingModelCopyWith<ConsultationBookingModel> get copyWith => _$ConsultationBookingModelCopyWithImpl<ConsultationBookingModel>(this as ConsultationBookingModel, _$identity);

  /// Serializes this ConsultationBookingModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsultationBookingModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.doctorId, doctorId) || other.doctorId == doctorId)&&(identical(other.slotId, slotId) || other.slotId == slotId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.status, status) || other.status == status)&&(identical(other.bookedViaVoice, bookedViaVoice) || other.bookedViaVoice == bookedViaVoice)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,doctorId,slotId,mode,status,bookedViaVoice,createdAt);

@override
String toString() {
  return 'ConsultationBookingModel(id: $id, userId: $userId, doctorId: $doctorId, slotId: $slotId, mode: $mode, status: $status, bookedViaVoice: $bookedViaVoice, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ConsultationBookingModelCopyWith<$Res>  {
  factory $ConsultationBookingModelCopyWith(ConsultationBookingModel value, $Res Function(ConsultationBookingModel) _then) = _$ConsultationBookingModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'doctor_id') String doctorId,@JsonKey(name: 'slot_id') String slotId, String mode, String status,@JsonKey(name: 'booked_via_voice') bool bookedViaVoice,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$ConsultationBookingModelCopyWithImpl<$Res>
    implements $ConsultationBookingModelCopyWith<$Res> {
  _$ConsultationBookingModelCopyWithImpl(this._self, this._then);

  final ConsultationBookingModel _self;
  final $Res Function(ConsultationBookingModel) _then;

/// Create a copy of ConsultationBookingModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? doctorId = null,Object? slotId = null,Object? mode = null,Object? status = null,Object? bookedViaVoice = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,doctorId: null == doctorId ? _self.doctorId : doctorId // ignore: cast_nullable_to_non_nullable
as String,slotId: null == slotId ? _self.slotId : slotId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,bookedViaVoice: null == bookedViaVoice ? _self.bookedViaVoice : bookedViaVoice // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsultationBookingModel].
extension ConsultationBookingModelPatterns on ConsultationBookingModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsultationBookingModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsultationBookingModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsultationBookingModel value)  $default,){
final _that = this;
switch (_that) {
case _ConsultationBookingModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsultationBookingModel value)?  $default,){
final _that = this;
switch (_that) {
case _ConsultationBookingModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'doctor_id')  String doctorId, @JsonKey(name: 'slot_id')  String slotId,  String mode,  String status, @JsonKey(name: 'booked_via_voice')  bool bookedViaVoice, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsultationBookingModel() when $default != null:
return $default(_that.id,_that.userId,_that.doctorId,_that.slotId,_that.mode,_that.status,_that.bookedViaVoice,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'doctor_id')  String doctorId, @JsonKey(name: 'slot_id')  String slotId,  String mode,  String status, @JsonKey(name: 'booked_via_voice')  bool bookedViaVoice, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ConsultationBookingModel():
return $default(_that.id,_that.userId,_that.doctorId,_that.slotId,_that.mode,_that.status,_that.bookedViaVoice,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'doctor_id')  String doctorId, @JsonKey(name: 'slot_id')  String slotId,  String mode,  String status, @JsonKey(name: 'booked_via_voice')  bool bookedViaVoice, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ConsultationBookingModel() when $default != null:
return $default(_that.id,_that.userId,_that.doctorId,_that.slotId,_that.mode,_that.status,_that.bookedViaVoice,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConsultationBookingModel implements ConsultationBookingModel {
  const _ConsultationBookingModel({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'doctor_id') required this.doctorId, @JsonKey(name: 'slot_id') required this.slotId, required this.mode, required this.status, @JsonKey(name: 'booked_via_voice') required this.bookedViaVoice, @JsonKey(name: 'created_at') required this.createdAt});
  factory _ConsultationBookingModel.fromJson(Map<String, dynamic> json) => _$ConsultationBookingModelFromJson(json);

/// Primary key (UUID).
@override final  String id;
/// FK → `profiles.id` — the patient.
@override@JsonKey(name: 'user_id') final  String userId;
/// FK → `doctors.id` — the booked doctor.
@override@JsonKey(name: 'doctor_id') final  String doctorId;
/// FK → `doctor_availability.id` — the reserved slot.
@override@JsonKey(name: 'slot_id') final  String slotId;
/// Delivery mode — raw Postgres `consult_mode` enum string
/// ('video', 'non_verbal', 'in_person').
@override final  String mode;
/// Lifecycle status — raw Postgres `booking_status` enum string
/// ('booked', 'completed', 'cancelled').
@override final  String status;
/// Whether the booking was completed entirely via Aura Voice.
@override@JsonKey(name: 'booked_via_voice') final  bool bookedViaVoice;
/// Row creation timestamp — set by Postgres default.
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of ConsultationBookingModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsultationBookingModelCopyWith<_ConsultationBookingModel> get copyWith => __$ConsultationBookingModelCopyWithImpl<_ConsultationBookingModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConsultationBookingModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsultationBookingModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.doctorId, doctorId) || other.doctorId == doctorId)&&(identical(other.slotId, slotId) || other.slotId == slotId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.status, status) || other.status == status)&&(identical(other.bookedViaVoice, bookedViaVoice) || other.bookedViaVoice == bookedViaVoice)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,doctorId,slotId,mode,status,bookedViaVoice,createdAt);

@override
String toString() {
  return 'ConsultationBookingModel(id: $id, userId: $userId, doctorId: $doctorId, slotId: $slotId, mode: $mode, status: $status, bookedViaVoice: $bookedViaVoice, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ConsultationBookingModelCopyWith<$Res> implements $ConsultationBookingModelCopyWith<$Res> {
  factory _$ConsultationBookingModelCopyWith(_ConsultationBookingModel value, $Res Function(_ConsultationBookingModel) _then) = __$ConsultationBookingModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'doctor_id') String doctorId,@JsonKey(name: 'slot_id') String slotId, String mode, String status,@JsonKey(name: 'booked_via_voice') bool bookedViaVoice,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$ConsultationBookingModelCopyWithImpl<$Res>
    implements _$ConsultationBookingModelCopyWith<$Res> {
  __$ConsultationBookingModelCopyWithImpl(this._self, this._then);

  final _ConsultationBookingModel _self;
  final $Res Function(_ConsultationBookingModel) _then;

/// Create a copy of ConsultationBookingModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? doctorId = null,Object? slotId = null,Object? mode = null,Object? status = null,Object? bookedViaVoice = null,Object? createdAt = null,}) {
  return _then(_ConsultationBookingModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,doctorId: null == doctorId ? _self.doctorId : doctorId // ignore: cast_nullable_to_non_nullable
as String,slotId: null == slotId ? _self.slotId : slotId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,bookedViaVoice: null == bookedViaVoice ? _self.bookedViaVoice : bookedViaVoice // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
