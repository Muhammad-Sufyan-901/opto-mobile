// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anthropometric_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnthropometricModel _$AnthropometricModelFromJson(Map<String, dynamic> json) =>
    _AnthropometricModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      socketSizeMm: (json['socket_size_mm'] as num?)?.toDouble(),
      curvature: (json['curvature'] as num?)?.toDouble(),
      irisDiameterMm: (json['iris_diameter_mm'] as num?)?.toDouble(),
      matchedIrisHex: json['matched_iris_hex'] as String?,
      source: _dataSourceFromJson(json['source'] as String?),
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$AnthropometricModelToJson(
  _AnthropometricModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'socket_size_mm': instance.socketSizeMm,
  'curvature': instance.curvature,
  'iris_diameter_mm': instance.irisDiameterMm,
  'matched_iris_hex': instance.matchedIrisHex,
  'source': _dataSourceToJson(instance.source),
  'created_at': instance.createdAt,
};
