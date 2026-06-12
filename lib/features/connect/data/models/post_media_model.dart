// Freezed + json_serializable DTO for the `post_media` Supabase table.
//
// Mirrors the row shape defined in `database_schema.md` §4 CONNECT.post_media.
// All DB columns are snake_case; Dart fields are camelCase via [@JsonKey].
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_media_model.freezed.dart';
part 'post_media_model.g.dart';

/// Data model for a `post_media` row.
/// [altText] is non-nullable — enforced at DB level (NOT NULL CHECK) and at the
/// app layer (compose screen must require a non-empty alt-text string).
///
/// Use [PostMediaModel.fromJson] to deserialise a Supabase response map.
/// The matching domain entity lives in
/// `lib/features/connect/domain/entities/post_media_entity.dart`.
@freezed
abstract class PostMediaModel with _$PostMediaModel {
  const factory PostMediaModel({
    /// Primary key (UUID).
    required String id,

    /// FK → `posts.id`.
    @JsonKey(name: 'post_id') required String postId,

    /// Supabase Storage path for the media asset.
    @JsonKey(name: 'storage_path') required String storagePath,

    /// Non-empty alt-text for accessibility — required by both DB and app.
    @JsonKey(name: 'alt_text') required String altText,
  }) = _PostMediaModel;

  /// Deserialises a Supabase / JSON map to a [PostMediaModel].
  factory PostMediaModel.fromJson(Map<String, dynamic> json) =>
      _$PostMediaModelFromJson(json);
}
