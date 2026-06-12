// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DoctorModel _$DoctorModelFromJson(Map<String, dynamic> json) => _DoctorModel(
  id: json['id'] as String,
  profileId: json['profile_id'] as String,
  specialty: json['specialty'] as String,
  clinicId: json['clinic_id'] as String?,
  isVerified: json['is_verified'] as bool,
);

Map<String, dynamic> _$DoctorModelToJson(_DoctorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profile_id': instance.profileId,
      'specialty': instance.specialty,
      'clinic_id': instance.clinicId,
      'is_verified': instance.isVerified,
    };
