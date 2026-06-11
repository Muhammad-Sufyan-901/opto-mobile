// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'doctor_availability_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DoctorAvailabilityModel {

/// Primary key (UUID).
 String get id;/// FK → `doctors.id` — the doctor who owns this slot.
@JsonKey(name: 'doctor_id') String get doctorId;/// Start of the bookable time window (UTC timestamptz).
@JsonKey(name: 'slot_start') DateTime get slotStart;/// End of the bookable time window (UTC timestamptz).
@JsonKey(name: 'slot_end') DateTime get slotEnd;/// Whether this slot has already been claimed by a booking.
@JsonKey(name: 'is_booked') bool get isBooked;
/// Create a copy of DoctorAvailabilityModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoctorAvailabilityModelCopyWith<DoctorAvailabilityModel> get copyWith => _$DoctorAvailabilityModelCopyWithImpl<DoctorAvailabilityModel>(this as DoctorAvailabilityModel, _$identity);

  /// Serializes this DoctorAvailabilityModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoctorAvailabilityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.doctorId, doctorId) || other.doctorId == doctorId)&&(identical(other.slotStart, slotStart) || other.slotStart == slotStart)&&(identical(other.slotEnd, slotEnd) || other.slotEnd == slotEnd)&&(identical(other.isBooked, isBooked) || other.isBooked == isBooked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,doctorId,slotStart,slotEnd,isBooked);

@override
String toString() {
  return 'DoctorAvailabilityModel(id: $id, doctorId: $doctorId, slotStart: $slotStart, slotEnd: $slotEnd, isBooked: $isBooked)';
}


}

/// @nodoc
abstract mixin class $DoctorAvailabilityModelCopyWith<$Res>  {
  factory $DoctorAvailabilityModelCopyWith(DoctorAvailabilityModel value, $Res Function(DoctorAvailabilityModel) _then) = _$DoctorAvailabilityModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'doctor_id') String doctorId,@JsonKey(name: 'slot_start') DateTime slotStart,@JsonKey(name: 'slot_end') DateTime slotEnd,@JsonKey(name: 'is_booked') bool isBooked
});




}
/// @nodoc
class _$DoctorAvailabilityModelCopyWithImpl<$Res>
    implements $DoctorAvailabilityModelCopyWith<$Res> {
  _$DoctorAvailabilityModelCopyWithImpl(this._self, this._then);

  final DoctorAvailabilityModel _self;
  final $Res Function(DoctorAvailabilityModel) _then;

/// Create a copy of DoctorAvailabilityModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? doctorId = null,Object? slotStart = null,Object? slotEnd = null,Object? isBooked = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,doctorId: null == doctorId ? _self.doctorId : doctorId // ignore: cast_nullable_to_non_nullable
as String,slotStart: null == slotStart ? _self.slotStart : slotStart // ignore: cast_nullable_to_non_nullable
as DateTime,slotEnd: null == slotEnd ? _self.slotEnd : slotEnd // ignore: cast_nullable_to_non_nullable
as DateTime,isBooked: null == isBooked ? _self.isBooked : isBooked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DoctorAvailabilityModel].
extension DoctorAvailabilityModelPatterns on DoctorAvailabilityModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DoctorAvailabilityModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DoctorAvailabilityModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DoctorAvailabilityModel value)  $default,){
final _that = this;
switch (_that) {
case _DoctorAvailabilityModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DoctorAvailabilityModel value)?  $default,){
final _that = this;
switch (_that) {
case _DoctorAvailabilityModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'doctor_id')  String doctorId, @JsonKey(name: 'slot_start')  DateTime slotStart, @JsonKey(name: 'slot_end')  DateTime slotEnd, @JsonKey(name: 'is_booked')  bool isBooked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DoctorAvailabilityModel() when $default != null:
return $default(_that.id,_that.doctorId,_that.slotStart,_that.slotEnd,_that.isBooked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'doctor_id')  String doctorId, @JsonKey(name: 'slot_start')  DateTime slotStart, @JsonKey(name: 'slot_end')  DateTime slotEnd, @JsonKey(name: 'is_booked')  bool isBooked)  $default,) {final _that = this;
switch (_that) {
case _DoctorAvailabilityModel():
return $default(_that.id,_that.doctorId,_that.slotStart,_that.slotEnd,_that.isBooked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'doctor_id')  String doctorId, @JsonKey(name: 'slot_start')  DateTime slotStart, @JsonKey(name: 'slot_end')  DateTime slotEnd, @JsonKey(name: 'is_booked')  bool isBooked)?  $default,) {final _that = this;
switch (_that) {
case _DoctorAvailabilityModel() when $default != null:
return $default(_that.id,_that.doctorId,_that.slotStart,_that.slotEnd,_that.isBooked);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DoctorAvailabilityModel implements DoctorAvailabilityModel {
  const _DoctorAvailabilityModel({required this.id, @JsonKey(name: 'doctor_id') required this.doctorId, @JsonKey(name: 'slot_start') required this.slotStart, @JsonKey(name: 'slot_end') required this.slotEnd, @JsonKey(name: 'is_booked') required this.isBooked});
  factory _DoctorAvailabilityModel.fromJson(Map<String, dynamic> json) => _$DoctorAvailabilityModelFromJson(json);

/// Primary key (UUID).
@override final  String id;
/// FK → `doctors.id` — the doctor who owns this slot.
@override@JsonKey(name: 'doctor_id') final  String doctorId;
/// Start of the bookable time window (UTC timestamptz).
@override@JsonKey(name: 'slot_start') final  DateTime slotStart;
/// End of the bookable time window (UTC timestamptz).
@override@JsonKey(name: 'slot_end') final  DateTime slotEnd;
/// Whether this slot has already been claimed by a booking.
@override@JsonKey(name: 'is_booked') final  bool isBooked;

/// Create a copy of DoctorAvailabilityModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoctorAvailabilityModelCopyWith<_DoctorAvailabilityModel> get copyWith => __$DoctorAvailabilityModelCopyWithImpl<_DoctorAvailabilityModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DoctorAvailabilityModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DoctorAvailabilityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.doctorId, doctorId) || other.doctorId == doctorId)&&(identical(other.slotStart, slotStart) || other.slotStart == slotStart)&&(identical(other.slotEnd, slotEnd) || other.slotEnd == slotEnd)&&(identical(other.isBooked, isBooked) || other.isBooked == isBooked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,doctorId,slotStart,slotEnd,isBooked);

@override
String toString() {
  return 'DoctorAvailabilityModel(id: $id, doctorId: $doctorId, slotStart: $slotStart, slotEnd: $slotEnd, isBooked: $isBooked)';
}


}

/// @nodoc
abstract mixin class _$DoctorAvailabilityModelCopyWith<$Res> implements $DoctorAvailabilityModelCopyWith<$Res> {
  factory _$DoctorAvailabilityModelCopyWith(_DoctorAvailabilityModel value, $Res Function(_DoctorAvailabilityModel) _then) = __$DoctorAvailabilityModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'doctor_id') String doctorId,@JsonKey(name: 'slot_start') DateTime slotStart,@JsonKey(name: 'slot_end') DateTime slotEnd,@JsonKey(name: 'is_booked') bool isBooked
});




}
/// @nodoc
class __$DoctorAvailabilityModelCopyWithImpl<$Res>
    implements _$DoctorAvailabilityModelCopyWith<$Res> {
  __$DoctorAvailabilityModelCopyWithImpl(this._self, this._then);

  final _DoctorAvailabilityModel _self;
  final $Res Function(_DoctorAvailabilityModel) _then;

/// Create a copy of DoctorAvailabilityModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? doctorId = null,Object? slotStart = null,Object? slotEnd = null,Object? isBooked = null,}) {
  return _then(_DoctorAvailabilityModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,doctorId: null == doctorId ? _self.doctorId : doctorId // ignore: cast_nullable_to_non_nullable
as String,slotStart: null == slotStart ? _self.slotStart : slotStart // ignore: cast_nullable_to_non_nullable
as DateTime,slotEnd: null == slotEnd ? _self.slotEnd : slotEnd // ignore: cast_nullable_to_non_nullable
as DateTime,isBooked: null == isBooked ? _self.isBooked : isBooked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
