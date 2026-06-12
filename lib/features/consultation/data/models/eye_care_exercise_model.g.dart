// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eye_care_exercise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EyeCareExerciseModel _$EyeCareExerciseModelFromJson(
  Map<String, dynamic> json,
) => _EyeCareExerciseModel(
  id: json['id'] as String,
  title: json['title'] as String,
  audioGuidePath: json['audio_guide_path'] as String,
  durationSeconds: (json['duration_seconds'] as num).toInt(),
  medicalDisclaimer: json['medical_disclaimer'] as String,
);

Map<String, dynamic> _$EyeCareExerciseModelToJson(
  _EyeCareExerciseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'audio_guide_path': instance.audioGuidePath,
  'duration_seconds': instance.durationSeconds,
  'medical_disclaimer': instance.medicalDisclaimer,
};
