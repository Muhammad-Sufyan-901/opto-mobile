// Domain entity for a reply to a community post.
//
// This is the pure-Dart representation used in BLoC states —
// no Supabase / serialisation dependencies.

/// Immutable domain representation of a reply to a community post.
///
/// [authorName] and [authorIsVerified] are joined from `profiles` at the
/// repository level and may reflect defaults until hydrated.
class PostReplyEntity {
  const PostReplyEntity({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.body,
    required this.createdAt,
    this.authorName,
    this.authorIsVerified = false,
    this.parentReplyId,
    this.isBestAnswer = false,
    this.voiceUrl,
    this.likeCount = 0,
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

  /// Whether the author carries the community-verified badge
  /// (from `profiles.is_verified`).
  final bool authorIsVerified;

  /// UUID of the parent reply for one-level nesting; null for top-level replies.
  final String? parentReplyId;

  /// Whether the OP author has marked this as the best answer.
  final bool isBestAnswer;

  /// URL of a voice-note attached to this reply; null when absent.
  final String? voiceUrl;

  /// Like count for this reply (0 until a reply-likes table exists).
  final int likeCount;

  PostReplyEntity copyWith({
    String? id,
    String? postId,
    String? authorId,
    String? body,
    DateTime? createdAt,
    String? authorName,
    bool? authorIsVerified,
    Object? parentReplyId = _sentinel,
    bool? isBestAnswer,
    Object? voiceUrl = _sentinel,
    int? likeCount,
  }) {
    return PostReplyEntity(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      authorId: authorId ?? this.authorId,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      authorName: authorName ?? this.authorName,
      authorIsVerified: authorIsVerified ?? this.authorIsVerified,
      parentReplyId: parentReplyId == _sentinel
          ? this.parentReplyId
          : parentReplyId as String?,
      isBestAnswer: isBestAnswer ?? this.isBestAnswer,
      voiceUrl: voiceUrl == _sentinel ? this.voiceUrl : voiceUrl as String?,
      likeCount: likeCount ?? this.likeCount,
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
          authorName == other.authorName &&
          authorIsVerified == other.authorIsVerified &&
          parentReplyId == other.parentReplyId &&
          isBestAnswer == other.isBestAnswer &&
          voiceUrl == other.voiceUrl &&
          likeCount == other.likeCount;

  @override
  int get hashCode => Object.hash(
        id,
        postId,
        authorId,
        body,
        createdAt,
        authorName,
        authorIsVerified,
        parentReplyId,
        isBestAnswer,
        voiceUrl,
        likeCount,
      );
}

// Sentinel used in copyWith to distinguish "not provided" from explicit null.
const Object _sentinel = Object();
