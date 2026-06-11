// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FollowModel _$FollowModelFromJson(Map<String, dynamic> json) => _FollowModel(
  followerId: json['follower_id'] as String,
  targetId: json['target_id'] as String,
  type: const _FollowTypeConverter().fromJson(json['type'] as String?),
);

Map<String, dynamic> _$FollowModelToJson(_FollowModel instance) =>
    <String, dynamic>{
      'follower_id': instance.followerId,
      'target_id': instance.targetId,
      'type': const _FollowTypeConverter().toJson(instance.type),
    };
