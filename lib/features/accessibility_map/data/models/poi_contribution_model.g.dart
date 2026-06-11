// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poi_contribution_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PoiContributionModel _$PoiContributionModelFromJson(
  Map<String, dynamic> json,
) => _PoiContributionModel(
  id: json['id'] as String,
  poiId: json['poi_id'] as String,
  userId: json['user_id'] as String,
  change: json['change'] as Map<String, dynamic>,
  status: json['status'] as String,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$PoiContributionModelToJson(
  _PoiContributionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'poi_id': instance.poiId,
  'user_id': instance.userId,
  'change': instance.change,
  'status': instance.status,
  'created_at': instance.createdAt,
};
