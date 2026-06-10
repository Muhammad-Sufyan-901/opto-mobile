// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prosthetic_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProstheticProductModel _$ProstheticProductModelFromJson(
  Map<String, dynamic> json,
) => _ProstheticProductModel(
  id: json['id'] as String,
  type: _productTypeFromJson(json['type'] as String?),
  name: json['name'] as String,
  audioDescription: json['audio_description'] as String,
  material: json['material'] as String?,
  irisColor: json['iris_color'] as String?,
  size: json['size'] as String?,
  isCustom: json['is_custom'] as bool,
  priceIdr: (json['price_idr'] as num).toInt(),
  vendorId: json['vendor_id'] as String?,
  isActive: json['is_active'] as bool,
);

Map<String, dynamic> _$ProstheticProductModelToJson(
  _ProstheticProductModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': _productTypeToJson(instance.type),
  'name': instance.name,
  'audio_description': instance.audioDescription,
  'material': instance.material,
  'iris_color': instance.irisColor,
  'size': instance.size,
  'is_custom': instance.isCustom,
  'price_idr': instance.priceIdr,
  'vendor_id': instance.vendorId,
  'is_active': instance.isActive,
};
