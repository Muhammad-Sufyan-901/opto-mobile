// Domain contract for eye photo operations.
//
// 🔒 SENSITIVE: all operations are owner-scoped (RLS enforced by Postgres +
// Storage bucket policies).
import 'dart:typed_data';

import 'package:opto/core/constants/prosthetic_enums.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/eye_photo_entity.dart';

/// Repository contract for the `eye_photos` table and `eye-photos` bucket.
///
/// Implementations must:
///   - Scope all queries to auth.currentUser.id.
///   - Return images via SIGNED URLs only (never public URLs).
///   - Not cache signed URLs beyond the session lifecycle.
abstract class EyePhotosRepository {
  /// Returns all of the current user's eye photo records with signed URLs.
  Future<List<EyePhotoEntity>> getMyEyePhotos();

  /// Uploads [bytes] to the `eye-photos` bucket and inserts an `eye_photos` row.
  ///
  /// Returns the newly created [EyePhotoEntity] with a signed URL.
  Future<EyePhotoEntity> uploadEyePhoto({
    required Uint8List bytes,
    required PhotoPurpose purpose,
    String? contentType,
  });

  /// Deletes the Storage object and the `eye_photos` row for [photoId].
  Future<void> deleteEyePhoto(String photoId);
}
