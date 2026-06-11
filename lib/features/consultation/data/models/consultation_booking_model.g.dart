// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation_booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConsultationBookingModel _$ConsultationBookingModelFromJson(
  Map<String, dynamic> json,
) => _ConsultationBookingModel(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  doctorId: json['doctor_id'] as String,
  slotId: json['slot_id'] as String,
  mode: json['mode'] as String,
  status: json['status'] as String,
  bookedViaVoice: json['booked_via_voice'] as bool? ?? false,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ConsultationBookingModelToJson(
  _ConsultationBookingModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'doctor_id': instance.doctorId,
  'slot_id': instance.slotId,
  'mode': instance.mode,
  'status': instance.status,
  'booked_via_voice': instance.bookedViaVoice,
  'created_at': instance.createdAt.toIso8601String(),
};
