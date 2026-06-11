// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_media_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostMediaModel _$PostMediaModelFromJson(Map<String, dynamic> json) =>
    _PostMediaModel(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      storagePath: json['storage_path'] as String,
      altText: json['alt_text'] as String,
    );

Map<String, dynamic> _$PostMediaModelToJson(_PostMediaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'post_id': instance.postId,
      'storage_path': instance.storagePath,
      'alt_text': instance.altText,
    };
