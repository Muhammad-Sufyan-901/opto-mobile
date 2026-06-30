// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConsultationMessageModel _$ConsultationMessageModelFromJson(
  Map<String, dynamic> json,
) => _ConsultationMessageModel(
  id: json['id'] as String,
  bookingId: json['booking_id'] as String,
  senderId: json['sender_id'] as String,
  body: json['body'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ConsultationMessageModelToJson(
  _ConsultationMessageModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'booking_id': instance.bookingId,
  'sender_id': instance.senderId,
  'body': instance.body,
  'created_at': instance.createdAt.toIso8601String(),
};
