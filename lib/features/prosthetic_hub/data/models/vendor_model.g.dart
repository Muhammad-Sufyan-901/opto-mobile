// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VendorModel _$VendorModelFromJson(Map<String, dynamic> json) => _VendorModel(
  id: json['id'] as String,
  name: json['name'] as String,
  isVerified: json['is_verified'] as bool,
  clinicId: json['clinic_id'] as String?,
);

Map<String, dynamic> _$VendorModelToJson(_VendorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'is_verified': instance.isVerified,
      'clinic_id': instance.clinicId,
    };
