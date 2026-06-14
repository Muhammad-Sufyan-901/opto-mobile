// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemberProfileModel _$MemberProfileModelFromJson(Map<String, dynamic> json) =>
    _MemberProfileModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      isMentor: json['is_mentor'] as bool? ?? false,
      bio: json['bio'] as String?,
      handle: json['handle'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$MemberProfileModelToJson(_MemberProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'avatar_url': instance.avatarUrl,
      'is_verified': instance.isVerified,
      'is_mentor': instance.isMentor,
      'bio': instance.bio,
      'handle': instance.handle,
      'created_at': instance.createdAt.toIso8601String(),
    };
