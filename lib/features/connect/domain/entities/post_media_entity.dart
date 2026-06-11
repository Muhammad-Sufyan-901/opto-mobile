// Domain entity for a post media attachment.
//
// This is the pure-Dart representation used in use-cases and BLoC states —
// no Supabase / serialisation dependencies.

/// Immutable domain representation of a single media item attached to a post.
///
/// [storagePath] holds the public URL via the `post-media` Supabase Storage
/// bucket. [altText] is non-nullable because both the DB constraint and the
/// compose screen enforce a non-empty value — this makes the accessibility
/// requirement load-bearing at the domain level.
class PostMediaEntity {
  const PostMediaEntity({
    required this.id,
    required this.postId,
    required this.storagePath,
    required this.altText,
  });

  /// Primary key (UUID).
  final String id;

  /// Foreign key referencing the parent post.
  final String postId;

  /// Public URL for this media item via the `post-media` storage bucket.
  final String storagePath;

  /// Accessibility alt-text description of the media.
  ///
  /// Required by both the DB NOT NULL constraint and the compose screen
  /// (which blocks submission on an empty alt-text field).
  final String altText;

  PostMediaEntity copyWith({
    String? id,
    String? postId,
    String? storagePath,
    String? altText,
  }) {
    return PostMediaEntity(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      storagePath: storagePath ?? this.storagePath,
      altText: altText ?? this.altText,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostMediaEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          postId == other.postId &&
          storagePath == other.storagePath &&
          altText == other.altText;

  @override
  int get hashCode => Object.hash(id, postId, storagePath, altText);
}
