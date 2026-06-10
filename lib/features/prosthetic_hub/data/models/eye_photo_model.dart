// Freezed + json_serializable DTO for the `eye_photos` table.
//
// 🔒 SENSITIVE: owner-only RLS. Reads are via signed URLs only (never public).
// Mirrors the row shape defined in `database_schema.md`
// §Prosthetic.eye_photos.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/core/constants/prosthetic_enums.dart';

part 'eye_photo_model.freezed.dart';
part 'eye_photo_model.g.dart';

// =============================================================================
// ENUM JSON HELPERS
// =============================================================================

PhotoPurpose _purposeFromJson(String? v) => PhotoPurpose.fromString(v);
String _purposeToJson(PhotoPurpose p) => p.dbValue;

// =============================================================================
// MODEL
// =============================================================================

/// Data-layer representation of a row in the `eye_photos` table.
///
/// [storagePath] is the private Storage object path in the `eye-photos` bucket.
/// Never call `.getPublicUrl()` — always use signed URLs.
///
/// 🔒 SECURITY: This model must never appear in a join/select accessible to
/// other users. All queries must be scoped to [auth.uid()].
@freezed
abstract class EyePhotoModel with _$EyePhotoModel {
  const factory EyePhotoModel({
    /// Primary key (UUID).
    required String id,

    /// FK to `profiles.id` — the owner.
    @JsonKey(name: 'user_id') required String userId,

    /// Path to the private object in the `eye-photos` Storage bucket.
    @JsonKey(name: 'storage_path') required String storagePath,

    /// Intended use for this photo.
    @JsonKey(
      fromJson: _purposeFromJson,
      toJson: _purposeToJson,
    )
    required PhotoPurpose purpose,

    /// Row creation timestamp (ISO 8601 string).
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _EyePhotoModel;

  factory EyePhotoModel.fromJson(Map<String, dynamic> json) =>
      _$EyePhotoModelFromJson(json);
}
