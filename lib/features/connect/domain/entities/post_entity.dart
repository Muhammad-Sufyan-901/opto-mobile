// Domain entity for a community post (aggregate).
//
// This is the pure-Dart representation used in use-cases and BLoC states —
// no Supabase / serialisation dependencies.

import 'package:opto/features/connect/domain/entities/post_media_entity.dart';

/// Immutable domain representation of a community post.
///
/// [authorName] and [authorAvatarUrl] are joined from `profiles` at the
/// repository level and may be null until hydrated.
/// [mediaList], [replyCount], [likeCount], and [likedByMe] are also
/// repository-populated aggregations.
class PostEntity {
  const PostEntity({
    required this.id,
    required this.authorId,
    required this.body,
    required this.createdAt,
    this.authorName,
    this.authorAvatarUrl,
    this.mediaList = const [],
    this.replyCount = 0,
    this.likeCount = 0,
    this.likedByMe = false,
  });

  /// Primary key (UUID).
  final String id;

  /// UUID of the post's author — foreign key to `auth.users`.
  final String authorId;

  /// Text content of the post.
  final String body;

  /// Timestamp when the post row was created.
  final DateTime createdAt;

  /// Display name joined from `profiles`; null until hydrated by the repository.
  final String? authorName;

  /// Avatar public URL joined from `profiles`; null until hydrated.
  final String? authorAvatarUrl;

  /// Media attachments belonging to this post; repository-populated.
  final List<PostMediaEntity> mediaList;

  /// Total number of direct replies; repository-populated aggregation.
  final int replyCount;

  /// Total number of likes; repository-populated aggregation.
  final int likeCount;

  /// Whether the currently-authenticated user has liked this post.
  final bool likedByMe;

  PostEntity copyWith({
    String? id,
    String? authorId,
    String? body,
    DateTime? createdAt,
    String? authorName,
    String? authorAvatarUrl,
    List<PostMediaEntity>? mediaList,
    int? replyCount,
    int? likeCount,
    bool? likedByMe,
  }) {
    return PostEntity(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      authorName: authorName ?? this.authorName,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      mediaList: mediaList ?? this.mediaList,
      replyCount: replyCount ?? this.replyCount,
      likeCount: likeCount ?? this.likeCount,
      likedByMe: likedByMe ?? this.likedByMe,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          authorId == other.authorId &&
          body == other.body &&
          createdAt == other.createdAt &&
          authorName == other.authorName &&
          authorAvatarUrl == other.authorAvatarUrl &&
          mediaList == other.mediaList &&
          replyCount == other.replyCount &&
          likeCount == other.likeCount &&
          likedByMe == other.likedByMe;

  @override
  int get hashCode => Object.hash(
        id,
        authorId,
        body,
        createdAt,
        authorName,
        authorAvatarUrl,
        Object.hashAll(mediaList),
        replyCount,
        likeCount,
        likedByMe,
      );
}
