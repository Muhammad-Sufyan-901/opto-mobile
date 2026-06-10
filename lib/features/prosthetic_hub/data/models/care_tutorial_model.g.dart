// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_tutorial_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CareTutorialModel _$CareTutorialModelFromJson(Map<String, dynamic> json) =>
    _CareTutorialModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: _categoryFromJson(json['category'] as String?),
      videoPath: json['video_path'] as String?,
      audioNarrationPath: json['audio_narration_path'] as String?,
      transcript: json['transcript'] as String,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CareTutorialModelToJson(_CareTutorialModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': _categoryToJson(instance.category),
      'video_path': instance.videoPath,
      'audio_narration_path': instance.audioNarrationPath,
      'transcript': instance.transcript,
      'sort_order': instance.sortOrder,
    };
