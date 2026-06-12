// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_reply_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostReplyModel _$PostReplyModelFromJson(Map<String, dynamic> json) =>
    _PostReplyModel(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      authorId: json['author_id'] as String,
      body: json['body'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$PostReplyModelToJson(_PostReplyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'post_id': instance.postId,
      'author_id': instance.authorId,
      'body': instance.body,
      'created_at': instance.createdAt.toIso8601String(),
    };
