// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CircleModel _$CircleModelFromJson(Map<String, dynamic> json) => _CircleModel(
  id: json['id'] as String,
  slug: json['slug'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  about: json['about'] as String?,
  iconKey: json['icon_key'] as String?,
  colorKey: json['color_key'] as String?,
  pinnedNote: json['pinned_note'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$CircleModelToJson(_CircleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'description': instance.description,
      'about': instance.about,
      'icon_key': instance.iconKey,
      'color_key': instance.colorKey,
      'pinned_note': instance.pinnedNote,
      'created_at': instance.createdAt.toIso8601String(),
    };
