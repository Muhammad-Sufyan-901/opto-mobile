// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConsultationModel _$ConsultationModelFromJson(Map<String, dynamic> json) =>
    _ConsultationModel(
      id: json['id'] as String,
      bookingId: json['booking_id'] as String,
      summary: json['summary'] as String?,
      prescription: json['prescription'] as String?,
      recordingPath: json['recording_path'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ConsultationModelToJson(_ConsultationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'booking_id': instance.bookingId,
      'summary': instance.summary,
      'prescription': instance.prescription,
      'recording_path': instance.recordingPath,
      'created_at': instance.createdAt.toIso8601String(),
    };
