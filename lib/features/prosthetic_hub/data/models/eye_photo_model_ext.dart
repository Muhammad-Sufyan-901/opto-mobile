// Extension methods on EyePhotoModel to produce domain entities.
import 'package:opto/features/prosthetic_hub/data/models/eye_photo_model.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/eye_photo_entity.dart';

/// Maps [EyePhotoModel] → [EyePhotoEntity].
///
/// [signedUrl] is not set here — it is populated by the repository after
/// calling [StorageClientProvider.createSignedUrl].
extension EyePhotoModelX on EyePhotoModel {
  EyePhotoEntity toEntity({String? signedUrl}) => EyePhotoEntity(
        id: id,
        userId: userId,
        storagePath: storagePath,
        purpose: purpose,
        signedUrl: signedUrl,
        createdAt: createdAt,
      );
}
