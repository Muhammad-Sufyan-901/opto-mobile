// Repository implementation for eye photos.
//
// 🔒 SENSITIVE: orchestrates Storage upload + PostgREST insert; all operations
// are owner-scoped (enforced by RLS + Storage bucket policies).
//
// Upload flow:
//   1. Upload bytes to `eye-photos` bucket via [StorageClientProvider].
//   2. Insert `eye_photos` row with `storage_path`.
//   3. Generate a short-lived signed URL via [StorageClientProvider.createSignedUrl].
//   4. Return [EyePhotoEntity] with signed URL.
//
// Read flow:
//   1. Fetch rows from `eye_photos` (scoped by RLS to auth.uid()).
//   2. Generate signed URLs for each photo.
//   3. Return entities.
//
// Delete flow:
//   1. Fetch the `storage_path` from the row.
//   2. Delete the Storage object.
//   3. Delete the `eye_photos` row.
import 'dart:typed_data';

import 'package:opto/core/constants/prosthetic_enums.dart';
import 'package:opto/core/error/failures.dart';
import 'package:opto/core/supabase/storage_client_provider.dart';
import 'package:opto/core/supabase/supabase_client_provider.dart';
import 'package:opto/features/prosthetic_hub/data/datasources/prosthetic_remote_data_source.dart';
import 'package:opto/features/prosthetic_hub/data/models/eye_photo_model_ext.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/eye_photo_entity.dart';
import 'package:opto/features/prosthetic_hub/domain/repositories/eye_photos_repository.dart';

/// Signed-URL TTL in seconds (1 hour).
const int _signedUrlExpiresIn = 3600;

class EyePhotosRepositoryImpl implements EyePhotosRepository {
  EyePhotosRepositoryImpl(this._dataSource);

  final ProstheticRemoteDataSource _dataSource;

  /// Returns the current user's ID or throws [AuthFailure].
  String get _userId {
    final id = SupabaseClientProvider.client.auth.currentUser?.id;
    if (id == null) throw const AuthFailure('Not authenticated');
    return id;
  }

  @override
  Future<List<EyePhotoEntity>> getMyEyePhotos() async {
    final models = await _dataSource.getMyEyePhotos();
    final entities = <EyePhotoEntity>[];
    for (final model in models) {
      String? signedUrl;
      try {
        signedUrl = await StorageClientProvider.createSignedUrl(
          'eye-photos',
          model.storagePath,
          expiresIn: _signedUrlExpiresIn,
        );
      } catch (_) {
        // A failed sign is non-fatal — entity still included with null URL.
        // The UI will show a placeholder instead of crashing.
      }
      entities.add(model.toEntity(signedUrl: signedUrl));
    }
    return entities;
  }

  @override
  Future<EyePhotoEntity> uploadEyePhoto({
    required Uint8List bytes,
    required PhotoPurpose purpose,
    String? contentType,
  }) async {
    final userId = _userId;

    // 1 — Upload bytes to Storage.
    final filename = '${DateTime.now().microsecondsSinceEpoch}.jpg';
    final storagePath = await _dataSource.uploadToEyePhotosBucket(
      userId: userId,
      bytes: bytes,
      filename: filename,
      contentType: contentType ?? 'image/jpeg',
    );

    // 2 — Insert `eye_photos` row.
    final model = await _dataSource.insertEyePhotoRow(
      storagePath: storagePath,
      purpose: purpose,
    );

    // 3 — Generate signed URL for immediate display.
    final signedUrl = await StorageClientProvider.createSignedUrl(
      'eye-photos',
      storagePath,
      expiresIn: _signedUrlExpiresIn,
    );

    return model.toEntity(signedUrl: signedUrl);
  }

  @override
  Future<void> deleteEyePhoto(String photoId) async {
    // 1 — Fetch storage path before deleting the row.
    final storagePath = await _dataSource.getEyePhotoStoragePath(photoId);

    // 2 — Delete the row first (keeps DB consistent even if Storage call fails).
    await _dataSource.deleteEyePhotoRow(photoId);

    // 3 — Delete the Storage object (best-effort; don't re-throw if path missing).
    if (storagePath != null) {
      try {
        await StorageClientProvider.storage
            .from('eye-photos')
            .remove([storagePath]);
      } on StorageFailure {
        // Log but don't surface as error — the DB row is already gone.
        // An orphaned Storage object is a cleanup concern, not a user error.
      } catch (_) {
        // Same rationale — silent best-effort.
      }
    }
  }
}
