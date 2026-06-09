// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'caregiver_link_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CaregiverLinkModel _$CaregiverLinkModelFromJson(Map<String, dynamic> json) =>
    _CaregiverLinkModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      caregiverId: json['caregiver_id'] as String,
      status: json['status'] == null
          ? LinkStatus.pending
          : const _LinkStatusConverter().fromJson(json['status'] as String?),
      permissions:
          (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$CaregiverLinkModelToJson(_CaregiverLinkModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'caregiver_id': instance.caregiverId,
      'status': const _LinkStatusConverter().toJson(instance.status),
      'permissions': instance.permissions,
      'created_at': instance.createdAt.toIso8601String(),
    };
