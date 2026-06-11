// Domain entity for a reply to a community post.
//
// This is the pure-Dart representation used in use-cases and BLoC states —
// no Supabase / serialisation dependencies.

/// Immutable domain representation of a reply to a community post.
///
/// [authorName] is joined from `profiles` at the repository level and may be
/// null until hydrated.
class PostReplyEntity {
  const PostReplyEntity({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.body,
    required this.createdAt,
    this.authorName,
  });

  /// Primary key (UUID).
  final String id;

  /// Foreign key referencing the parent post.
  final String postId;

  /// UUID of the reply's author — foreign key to `auth.users`.
  final String authorId;

  /// Text content of the reply.
  final String body;

  /// Timestamp when the reply row was created.
  final DateTime createdAt;

  /// Display name joined from `profiles`; null until hydrated by the repository.
  final String? authorName;

  PostReplyEntity copyWith({
    String? id,
    String? postId,
    String? authorId,
    String? body,
    DateTime? createdAt,
    String? authorName,
  }) {
    return PostReplyEntity(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      authorId: authorId ?? this.authorId,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      authorName: authorName ?? this.authorName,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostReplyEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          postId == other.postId &&
          authorId == other.authorId &&
          body == other.body &&
          createdAt == other.createdAt &&
          authorName == other.authorName;

  @override
  int get hashCode =>
      Object.hash(id, postId, authorId, body, createdAt, authorName);
}
