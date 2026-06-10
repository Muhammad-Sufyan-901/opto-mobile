// State definitions for the Eye Photos cubit.
//
// States:
//   initial   — not yet loaded
//   loading   — async operation in progress
//   loaded    — list of [EyePhotoEntity] available (may be empty)
//   uploading — upload in progress (keeps existing list visible)
//   uploaded  — upload succeeded; new entity included
//   deleting  — delete in progress
//   deleted   — row removed successfully
//   error     — async operation failed
import 'package:opto/features/prosthetic_hub/domain/entities/eye_photo_entity.dart';

sealed class EyePhotosState {
  const EyePhotosState();
}

/// Not yet loaded.
class EyePhotosInitial extends EyePhotosState {
  const EyePhotosInitial();
}

/// Fetching the list.
class EyePhotosLoading extends EyePhotosState {
  const EyePhotosLoading();
}

/// List loaded (may be empty).
class EyePhotosLoaded extends EyePhotosState {
  const EyePhotosLoaded(this.photos);
  final List<EyePhotoEntity> photos;
}

/// Upload in progress — existing list still available.
class EyePhotosUploading extends EyePhotosState {
  const EyePhotosUploading(this.photos);
  final List<EyePhotoEntity> photos;
}

/// Upload completed — [newPhoto] is the freshly inserted entity.
class EyePhotosUploaded extends EyePhotosState {
  const EyePhotosUploaded({required this.photos, required this.newPhoto});
  final List<EyePhotoEntity> photos;
  final EyePhotoEntity newPhoto;
}

/// Delete in progress for [deletingId].
class EyePhotosDeleting extends EyePhotosState {
  const EyePhotosDeleting({required this.photos, required this.deletingId});
  final List<EyePhotoEntity> photos;
  final String deletingId;
}

/// Delete completed successfully.
class EyePhotosDeleted extends EyePhotosState {
  const EyePhotosDeleted(this.photos);
  final List<EyePhotoEntity> photos;
}

/// An error occurred.
class EyePhotosError extends EyePhotosState {
  const EyePhotosError(this.message);
  final String message;
}
