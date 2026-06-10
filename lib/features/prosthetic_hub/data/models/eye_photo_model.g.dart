// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eye_photo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EyePhotoModel _$EyePhotoModelFromJson(Map<String, dynamic> json) =>
    _EyePhotoModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      storagePath: json['storage_path'] as String,
      purpose: _purposeFromJson(json['purpose'] as String?),
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$EyePhotoModelToJson(_EyePhotoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'storage_path': instance.storagePath,
      'purpose': _purposeToJson(instance.purpose),
      'created_at': instance.createdAt,
    };
