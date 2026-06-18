// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) =>
    _ProfileModel(
      id: json['id'] as String,
      role: const _UserRoleConverter().fromJson(json['role'] as String?),
      fullName: json['full_name'] as String?,
      phone: json['phone'] as String?,
      visionProfile: const _VisionProfileConverter().fromJson(
        json['vision_profile'] as String?,
      ),
      avatarUrl: json['avatar_url'] as String?,
      username: json['handle'] as String?,
      pronouns: json['pronouns'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ProfileModelToJson(_ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': const _UserRoleConverter().toJson(instance.role),
      'full_name': instance.fullName,
      'phone': instance.phone,
      'vision_profile': const _VisionProfileConverter().toJson(
        instance.visionProfile,
      ),
      'avatar_url': instance.avatarUrl,
      'handle': instance.username,
      'pronouns': instance.pronouns,
      'bio': instance.bio,
      'location': instance.location,
      'created_at': instance.createdAt.toIso8601String(),
    };
