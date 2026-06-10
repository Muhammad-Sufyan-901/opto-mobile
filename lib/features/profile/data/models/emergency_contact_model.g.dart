// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_contact_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EmergencyContactModel _$EmergencyContactModelFromJson(
  Map<String, dynamic> json,
) => _EmergencyContactModel(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String,
  relationship: json['relationship'] as String?,
  priority: (json['priority'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$EmergencyContactModelToJson(
  _EmergencyContactModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'name': instance.name,
  'phone': instance.phone,
  'relationship': instance.relationship,
  'priority': instance.priority,
};
