// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_reminder_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CareReminderModel _$CareReminderModelFromJson(Map<String, dynamic> json) =>
    _CareReminderModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      label: json['label'] as String,
      scheduleCron: json['schedule_cron'] as String,
      notifyCaregiver: json['notify_caregiver'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$CareReminderModelToJson(_CareReminderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'label': instance.label,
      'schedule_cron': instance.scheduleCron,
      'notify_caregiver': instance.notifyCaregiver,
      'is_active': instance.isActive,
    };
