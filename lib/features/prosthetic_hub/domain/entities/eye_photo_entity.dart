// Pure-Dart domain entity for an eye photo reference.
//
// 🔒 SENSITIVE: owner-only. [signedUrl] is ephemeral — never persist it.
import 'package:opto/core/constants/prosthetic_enums.dart';

/// Immutable domain representation of a row in the `eye_photos` table.
///
/// [signedUrl] is populated by the repository after generating a signed URL
/// from the Storage bucket. It expires — do not cache beyond the current
/// session or screen lifecycle.
class EyePhotoEntity {
  const EyePhotoEntity({
    required this.id,
    required this.userId,
    required this.storagePath,
    required this.purpose,
    this.signedUrl,
    this.createdAt,
  });

  /// Primary key (UUID).
  final String id;

  /// Owner user ID.
  final String userId;

  /// Private Storage object path in the `eye-photos` bucket.
  final String storagePath;

  /// Intended use for this photo.
  final PhotoPurpose purpose;

  /// Short-lived signed URL for displaying the image.
  ///
  /// Null until resolved by the repository. Expires after [expiresIn] seconds.
  final String? signedUrl;

  /// Row creation timestamp.
  final String? createdAt;

  EyePhotoEntity copyWith({
    String? id,
    String? userId,
    String? storagePath,
    PhotoPurpose? purpose,
    String? signedUrl,
    String? createdAt,
  }) =>
      EyePhotoEntity(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        storagePath: storagePath ?? this.storagePath,
        purpose: purpose ?? this.purpose,
        signedUrl: signedUrl ?? this.signedUrl,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EyePhotoEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
