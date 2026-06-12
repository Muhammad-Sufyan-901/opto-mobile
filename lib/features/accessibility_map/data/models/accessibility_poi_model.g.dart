// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accessibility_poi_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccessibilityPoiModel _$AccessibilityPoiModelFromJson(
  Map<String, dynamic> json,
) => _AccessibilityPoiModel(
  id: json['id'] as String,
  name: json['name'] as String,
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
  attributes: json['attributes'] as Map<String, dynamic>,
  verifiedCount: (json['verified_count'] as num?)?.toInt() ?? 0,
  createdBy: json['created_by'] as String?,
);

Map<String, dynamic> _$AccessibilityPoiModelToJson(
  _AccessibilityPoiModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'lat': instance.lat,
  'lng': instance.lng,
  'attributes': instance.attributes,
  'verified_count': instance.verifiedCount,
  'created_by': instance.createdBy,
};
