// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_availability_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DoctorAvailabilityModel _$DoctorAvailabilityModelFromJson(
  Map<String, dynamic> json,
) => _DoctorAvailabilityModel(
  id: json['id'] as String,
  doctorId: json['doctor_id'] as String,
  slotStart: DateTime.parse(json['slot_start'] as String),
  slotEnd: DateTime.parse(json['slot_end'] as String),
  isBooked: json['is_booked'] as bool,
);

Map<String, dynamic> _$DoctorAvailabilityModelToJson(
  _DoctorAvailabilityModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'doctor_id': instance.doctorId,
  'slot_start': instance.slotStart.toIso8601String(),
  'slot_end': instance.slotEnd.toIso8601String(),
  'is_booked': instance.isBooked,
};
