// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prosthetic_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProstheticOrderModel _$ProstheticOrderModelFromJson(
  Map<String, dynamic> json,
) => _ProstheticOrderModel(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  productId: json['product_id'] as String,
  anthropometricId: json['anthropometric_id'] as String?,
  status: _statusFromJson(json['status'] as String?),
  consentGiven: json['consent_given'] as bool? ?? false,
  totalIdr: (json['total_idr'] as num).toInt(),
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$ProstheticOrderModelToJson(
  _ProstheticOrderModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'product_id': instance.productId,
  'anthropometric_id': instance.anthropometricId,
  'status': _statusToJson(instance.status),
  'consent_given': instance.consentGiven,
  'total_idr': instance.totalIdr,
  'created_at': instance.createdAt,
};
