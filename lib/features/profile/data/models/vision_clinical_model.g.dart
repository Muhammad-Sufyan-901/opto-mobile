// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vision_clinical_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VisionClinicalModel _$VisionClinicalModelFromJson(Map<String, dynamic> json) =>
    _VisionClinicalModel(
      userId: json['user_id'] as String,
      diagnosis: json['diagnosis'] as String?,
      diagnosisSeverity: json['diagnosis_severity'] as String?,
      affectedEyes: json['affected_eyes'] as String?,
      diagnosedYear: (json['diagnosed_year'] as num?)?.toInt(),
      lightPerception: json['light_perception'] as String?,
      centralAcuity: json['central_acuity'] as String?,
      visualField: json['visual_field'] as String?,
      prosthesisEye: json['prosthesis_eye'] as String?,
      prosthesisType: json['prosthesis_type'] as String?,
      prosthesisMaterial: json['prosthesis_material'] as String?,
      prosthesisFittedDate: _parseDate(json['prosthesis_fitted_date']),
      prosthesisFittedClinic: json['prosthesis_fitted_clinic'] as String?,
      lastPolishDate: _parseDate(json['last_polish_date']),
      nextPolishDue: _parseDate(json['next_polish_due']),
      assistiveTech: json['assistive_tech'] == null
          ? const []
          : const _AssistiveTechListConverter().fromJson(
              json['assistive_tech'] as List,
            ),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$VisionClinicalModelToJson(
  _VisionClinicalModel instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'diagnosis': instance.diagnosis,
  'diagnosis_severity': instance.diagnosisSeverity,
  'affected_eyes': instance.affectedEyes,
  'diagnosed_year': instance.diagnosedYear,
  'light_perception': instance.lightPerception,
  'central_acuity': instance.centralAcuity,
  'visual_field': instance.visualField,
  'prosthesis_eye': instance.prosthesisEye,
  'prosthesis_type': instance.prosthesisType,
  'prosthesis_material': instance.prosthesisMaterial,
  'prosthesis_fitted_date': _formatDate(instance.prosthesisFittedDate),
  'prosthesis_fitted_clinic': instance.prosthesisFittedClinic,
  'last_polish_date': _formatDate(instance.lastPolishDate),
  'next_polish_due': _formatDate(instance.nextPolishDue),
  'assistive_tech': const _AssistiveTechListConverter().toJson(
    instance.assistiveTech,
  ),
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
