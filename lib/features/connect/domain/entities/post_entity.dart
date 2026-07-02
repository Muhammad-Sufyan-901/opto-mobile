// Domain entity for a community post (aggregate).
//
// This is the pure-Dart representation used in BLoC states —
// no Supabase / serialisation dependencies.

import 'package:opto/features/connect/domain/entities/post_media_entity.dart';

/// Immutable domain representation of a community post.
///
/// [authorName], [authorAvatarUrl], [authorIsVerified], [mediaList],
/// [replyCount], [likeCount], and [likedByMe] are all joined / computed
/// at the repository level and may reflect defaults until hydrated.
class PostEntity {
  const PostEntity({
    required this.id,
    required this.authorId,
    required this.body,
    required this.createdAt,
    this.title,
    this.topic,
    this.voiceUrl,
    this.authorName,
    this.authorAvatarUrl,
    this.authorIsVerified = false,
    this.mediaList = const [],
    this.replyCount = 0,
    this.likeCount = 0,
    this.likedByMe = false,
    this.bookmarkedByMe = false,
  });

  /// Primary key (UUID).
  final String id;

  /// UUID of the post's author — foreign key to `auth.users`.
  final String authorId;

  /// Text content of the post.
  final String body;

  /// Timestamp when the post row was created.
  final DateTime createdAt;

  /// Optional short heading for the post; null for body-only posts.
  final String? title;

  /// Topic/circle label (e.g. "Prosthetic care", "Low vision"); used by filter
  /// chips and displayed as a pill in thread cards.
  final String? topic;

  /// URL of a voice-note recording attached to this post; null when absent.
  final String? voiceUrl;

  /// Display name joined from `profiles`; null until hydrated by the repository.
  final String? authorName;

  /// Avatar public URL joined from `profiles`; null until hydrated.
  final String? authorAvatarUrl;

  /// Whether the author has the community-verified badge
  /// (from `profiles.is_verified`).
  final bool authorIsVerified;

  /// Media attachments belonging to this post; repository-populated.
  final List<PostMediaEntity> mediaList;

  /// Total number of direct replies; repository-populated aggregation.
  final int replyCount;

  /// Total number of likes; repository-populated aggregation.
  final int likeCount;

  /// Whether the currently-authenticated user has liked this post.
  final bool likedByMe;

  /// Whether the currently-authenticated user has bookmarked/saved this post.
  final bool bookmarkedByMe;

  PostEntity copyWith({
    String? id,
    String? authorId,
    String? body,
    DateTime? createdAt,
    Object? title = _sentinel,
    Object? topic = _sentinel,
    Object? voiceUrl = _sentinel,
    String? authorName,
    String? authorAvatarUrl,
    bool? authorIsVerified,
    List<PostMediaEntity>? mediaList,
    int? replyCount,
    int? likeCount,
    bool? likedByMe,
    bool? bookmarkedByMe,
  }) {
    return PostEntity(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      title: title == _sentinel ? this.title : title as String?,
      topic: topic == _sentinel ? this.topic : topic as String?,
      voiceUrl: voiceUrl == _sentinel ? this.voiceUrl : voiceUrl as String?,
      authorName: authorName ?? this.authorName,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      authorIsVerified: authorIsVerified ?? this.authorIsVerified,
      mediaList: mediaList ?? this.mediaList,
      replyCount: replyCount ?? this.replyCount,
      likeCount: likeCount ?? this.likeCount,
      likedByMe: likedByMe ?? this.likedByMe,
      bookmarkedByMe: bookmarkedByMe ?? this.bookmarkedByMe,
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
          title == other.title &&
          topic == other.topic &&
          voiceUrl == other.voiceUrl &&
          authorName == other.authorName &&
          authorAvatarUrl == other.authorAvatarUrl &&
          authorIsVerified == other.authorIsVerified &&
          mediaList == other.mediaList &&
          replyCount == other.replyCount &&
          likeCount == other.likeCount &&
          likedByMe == other.likedByMe &&
          bookmarkedByMe == other.bookmarkedByMe;

  @override
  int get hashCode => Object.hash(
        id,
        authorId,
        body,
        createdAt,
        title,
        topic,
        voiceUrl,
        authorName,
        authorAvatarUrl,
        authorIsVerified,
        Object.hashAll(mediaList),
        replyCount,
        likeCount,
        likedByMe,
        bookmarkedByMe,
      );
}

// Sentinel used in copyWith to distinguish "not provided" from explicit null.
const Object _sentinel = Object();
