// Cubit for the Eye Photos screen.
//
// Exposes:
//   loadPhotos()    — fetch all owner photos from the repository
//   uploadPhoto()   — upload bytes, insert row, return entity with signed URL
//   deletePhoto()   — delete Storage object + DB row
//
// 🔒 SENSITIVE: all operations are owner-scoped (enforced by RLS + Storage
// bucket policies). Signed URLs expire — never cache them beyond screen scope.
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/core/constants/prosthetic_enums.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/eye_photo_entity.dart';
import 'package:opto/features/prosthetic_hub/domain/repositories/eye_photos_repository.dart';
import 'eye_photos_state.dart';

class EyePhotosCubit extends Cubit<EyePhotosState> {
  EyePhotosCubit(this._repository) : super(const EyePhotosInitial());

  final EyePhotosRepository _repository;

  /// Current photo list (fallback for transition states).
  List<EyePhotoEntity> _currentPhotos = [];

  // ── public API ─────────────────────────────────────────────────────────────

  Future<void> loadPhotos() async {
    emit(const EyePhotosLoading());
    try {
      final photos = await _repository.getMyEyePhotos();
      _currentPhotos = photos;
      emit(EyePhotosLoaded(photos));
    } on Failure catch (f) {
      emit(EyePhotosError(f.message));
    } catch (e) {
      emit(EyePhotosError(e.toString()));
    }
  }

  Future<void> uploadPhoto({
    required Uint8List bytes,
    required PhotoPurpose purpose,
    String? contentType,
  }) async {
    emit(EyePhotosUploading(_currentPhotos));
    try {
      final newPhoto = await _repository.uploadEyePhoto(
        bytes: bytes,
        purpose: purpose,
        contentType: contentType,
      );
      _currentPhotos = [newPhoto, ..._currentPhotos];
      emit(EyePhotosUploaded(photos: _currentPhotos, newPhoto: newPhoto));
    } on Failure catch (f) {
      // Restore prior loaded state so the list remains visible.
      emit(EyePhotosLoaded(_currentPhotos));
      emit(EyePhotosError(f.message));
    } catch (e) {
      emit(EyePhotosLoaded(_currentPhotos));
      emit(EyePhotosError(e.toString()));
    }
  }

  Future<void> deletePhoto(String photoId) async {
    emit(EyePhotosDeleting(photos: _currentPhotos, deletingId: photoId));
    try {
      await _repository.deleteEyePhoto(photoId);
      _currentPhotos =
          _currentPhotos.where((p) => p.id != photoId).toList();
      emit(EyePhotosDeleted(_currentPhotos));
    } on Failure catch (f) {
      emit(EyePhotosLoaded(_currentPhotos));
      emit(EyePhotosError(f.message));
    } catch (e) {
      emit(EyePhotosLoaded(_currentPhotos));
      emit(EyePhotosError(e.toString()));
    }
  }
}
