// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostModel _$PostModelFromJson(Map<String, dynamic> json) => _PostModel(
  id: json['id'] as String,
  authorId: json['author_id'] as String,
  body: json['body'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  title: json['title'] as String?,
  topic: json['topic'] as String?,
  voiceUrl: json['voice_url'] as String?,
);

Map<String, dynamic> _$PostModelToJson(_PostModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author_id': instance.authorId,
      'body': instance.body,
      'created_at': instance.createdAt.toIso8601String(),
      'title': instance.title,
      'topic': instance.topic,
      'voice_url': instance.voiceUrl,
    };
