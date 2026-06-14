// Remote data source for all `connect`-feature tables and Storage operations.
//
// This is the ONLY place in the connect feature that calls
// `SupabaseClientProvider.client` directly.
// Callers (repository impls) must never import this file from the domain layer.
//
// SECURITY NOTES:
// - Never join 🔒 tables (anthropometric_data, eye_photos, consultations,
//   sos_events) in any query here.
// - Author display name / avatar / verified come ONLY from the `profiles` table
//   and are joined inside getFeed / getPostById / getReplies using the
//   `profiles!author_id` foreign-key hint so PostgREST resolves the correct FK.
// - Use only `SupabaseClientProvider.client` — never `Supabase.instance.client`
//   directly.
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/core/supabase/realtime_channel_manager.dart';
import 'package:opto/core/supabase/supabase_client_provider.dart';
import 'package:opto/core/supabase/supabase_error_mapper.dart';
import 'package:opto/features/connect/data/models/content_report_model.dart';
import 'package:opto/features/connect/data/models/follow_model.dart';
import 'package:opto/features/connect/data/models/post_media_model.dart';
import 'package:opto/features/connect/data/models/post_model.dart';
import 'package:opto/features/connect/data/models/post_model_ext.dart';
import 'package:opto/features/connect/data/models/post_reply_model.dart';
import 'package:opto/features/connect/data/models/post_reply_model_ext.dart';
import 'package:opto/features/connect/domain/entities/post_entity.dart';
import 'package:opto/features/connect/domain/entities/post_reply_entity.dart';

// ─── Helpers ──────────────────────────────────────────────────────────────────

/// PostgREST select string for posts with author join + aggregate counts.
///
/// Returns: id, author_id, body, created_at, title, topic, voice_url
/// + author(full_name, avatar_url, is_verified)
/// + post_likes(count)  (renamed to like_count by PostgREST)
/// + post_replies(count) (renamed to reply_count)
const _postSelect = '''
  id, author_id, body, created_at, title, topic, voice_url,
  author:profiles!author_id(full_name, avatar_url, is_verified),
  like_count:post_likes(count),
  reply_count:post_replies(count)
''';

/// Same join for replies, without the reply-count aggregate.
const _replySelect = '''
  id, post_id, author_id, body, created_at, parent_reply_id, is_best_answer, voice_url,
  author:profiles!author_id(full_name, avatar_url, is_verified)
''';

// ─── Projection helpers ────────────────────────────────────────────────────────

/// PostgREST aggregate count returns a list of objects: [{count: 3}].
int _extractCount(dynamic raw) {
  if (raw == null) return 0;
  if (raw is int) return raw;
  if (raw is List && raw.isNotEmpty) {
    final first = raw.first;
    if (first is Map && first.containsKey('count')) {
      return (first['count'] as num?)?.toInt() ?? 0;
    }
  }
  return 0;
}

PostEntity _hydratePost(
  Map<String, dynamic> row, {
  required Set<String> likedPostIds,
}) {
  final authorMap = row['author'] as Map<String, dynamic>?;
  final likeCountRaw = row['like_count'];
  final replyCountRaw = row['reply_count'];

  final model = PostModel.fromJson(row);
  return model.toEntity(
    authorName: authorMap?['full_name'] as String?,
    authorAvatarUrl: authorMap?['avatar_url'] as String?,
    authorIsVerified: (authorMap?['is_verified'] as bool?) ?? false,
    likeCount: _extractCount(likeCountRaw),
    replyCount: _extractCount(replyCountRaw),
    likedByMe: likedPostIds.contains(model.id),
  );
}

PostReplyEntity _hydrateReply(Map<String, dynamic> row) {
  final authorMap = row['author'] as Map<String, dynamic>?;
  final model = PostReplyModel.fromJson(row);
  return model.toEntity(
    authorName: authorMap?['full_name'] as String?,
    authorIsVerified: (authorMap?['is_verified'] as bool?) ?? false,
  );
}

/// Contract for the connect remote data source.
abstract class ConnectRemoteDataSource {
  // ── posts ──────────────────────────────────────────────────────────────────
  Future<List<PostEntity>> getFeed({
    int limit = 20,
    int offset = 0,
    String? topic,
  });

  /// Fetches a single post by [postId] with full author + count hydration.
  Future<PostEntity> getPostById(String postId);

  Future<PostEntity> createPost({
    required String body,
    String? title,
    String? topic,
    String? voiceUrl,
  });

  Future<void> deletePost(String postId);

  // ── media ──────────────────────────────────────────────────────────────────
  Future<PostMediaModel> addMedia({
    required String postId,
    required String localPath,
    required String altText,
  });

  Future<void> removeMedia(String mediaId);

  // ── replies ────────────────────────────────────────────────────────────────
  Future<List<PostReplyEntity>> getReplies(String postId);

  Future<PostReplyEntity> addReply({
    required String postId,
    required String body,
    String? parentReplyId,
    String? voiceUrl,
  });

  Future<void> deleteReply(String replyId);

  /// Marks [replyId] as best answer for [postId].
  ///
  /// RLS enforces that only the OP author can update is_best_answer.
  Future<void> markBestAnswer({
    required String replyId,
    required String postId,
  });

  // ── likes ──────────────────────────────────────────────────────────────────
  /// Returns `true` if the user just liked (insert), `false` if unliked (delete).
  Future<bool> toggleLike(String postId);

  // ── realtime feed ──────────────────────────────────────────────────────────
  /// Subscribes to INSERT events on the `posts` table.
  /// Returns a [Stream] that emits raw JSON maps for each new post.
  /// The caller ([ConnectRepositoryImpl]) is responsible for calling
  /// [dispose()] on the manager when done.
  Stream<Map<String, dynamic>> watchNewPostsRaw(RealtimeChannelManager manager);

  // ── follows ────────────────────────────────────────────────────────────────
  Future<List<FollowModel>> getFollows(String userId);

  Future<FollowModel> follow({
    required String targetId,
    required String type,
  });

  Future<void> unfollow({required String targetId});

  // ── reports ────────────────────────────────────────────────────────────────
  Future<ContentReportModel> reportPost({
    required String postId,
    required String reason,
  });
}

// =============================================================================
// IMPLEMENTATION
// =============================================================================

/// Production implementation backed by Supabase PostgREST and Storage.
///
/// All [PostgrestException]s are mapped to [ServerFailure] via
/// [SupabaseErrorMapper.fromPostgrest] before being rethrown.
/// All [StorageException]s are mapped via [SupabaseErrorMapper.fromStorage].
class ConnectRemoteDataSourceImpl implements ConnectRemoteDataSource {
  SupabaseClient get _client => SupabaseClientProvider.client;

  // ── posts ──────────────────────────────────────────────────────────────────

  @override
  Future<List<PostEntity>> getFeed({
    int limit = 20,
    int offset = 0,
    String? topic,
  }) async {
    try {
      // 1. Build the query; optionally filter by topic.
      // Filters (.eq) must be applied before transform steps (.order/.range).
      final baseQuery =
          _client.from('posts').select(_postSelect);

      final filteredQuery = (topic != null && topic.isNotEmpty)
          ? baseQuery.eq('topic', topic)
          : baseQuery;

      final rows = await filteredQuery
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      // 2. Collect liked post-ids for the current user in one round-trip.
      final likedPostIds = await _fetchLikedPostIds(
        rows.map((r) => r['id'] as String).toList(),
      );

      return rows
          .map((r) => _hydratePost(r, likedPostIds: likedPostIds))
          .toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<PostEntity> getPostById(String postId) async {
    try {
      final row = await _client
          .from('posts')
          .select(_postSelect)
          .eq('id', postId)
          .single();

      final likedPostIds = await _fetchLikedPostIds([postId]);
      return _hydratePost(row, likedPostIds: likedPostIds);
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<PostEntity> createPost({
    required String body,
    String? title,
    String? topic,
    String? voiceUrl,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw const AuthFailure('Not authenticated');
    try {
      final row = await _client
          .from('posts')
          .insert({
            'author_id': userId,
            'body': body,
            'title': ?title,
            'topic': ?topic,
            'voice_url': ?voiceUrl,
          })
          .select(_postSelect)
          .single();

      // Newly created — not liked by anyone yet.
      return _hydratePost(row, likedPostIds: const {});
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await _client.from('posts').delete().eq('id', postId);
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // ── media ──────────────────────────────────────────────────────────────────

  @override
  Future<PostMediaModel> addMedia({
    required String postId,
    required String localPath,
    required String altText,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw const AuthFailure('Not authenticated');

    // 1. Generate a unique storage path.
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${localPath.split('/').last}';
    final storagePath = 'posts/$postId/$fileName';

    // 2. Upload to the `post-media` Storage bucket.
    try {
      await _client.storage
          .from('post-media')
          .upload(storagePath, File(localPath));
    } on StorageException catch (e) {
      throw SupabaseErrorMapper.fromStorage(e);
    } catch (e) {
      throw StorageFailure(e.toString());
    }

    // 3. Insert the post_media row.
    try {
      final row = await _client
          .from('post_media')
          .insert({
            'post_id': postId,
            'storage_path': storagePath,
            'alt_text': altText,
          })
          .select()
          .single();
      return PostMediaModel.fromJson(row);
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> removeMedia(String mediaId) async {
    // 1. Fetch the storage_path for this mediaId.
    try {
      final row = await _client
          .from('post_media')
          .select('storage_path')
          .eq('id', mediaId)
          .single();
      final storagePath = row['storage_path'] as String;

      // 2. Delete the Storage object.
      try {
        await _client.storage.from('post-media').remove([storagePath]);
      } on StorageException catch (e) {
        throw SupabaseErrorMapper.fromStorage(e);
      } catch (e) {
        throw StorageFailure(e.toString());
      }

      // 3. Delete the DB row.
      await _client.from('post_media').delete().eq('id', mediaId);
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } on StorageFailure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // ── replies ────────────────────────────────────────────────────────────────

  @override
  Future<List<PostReplyEntity>> getReplies(String postId) async {
    try {
      final rows = await _client
          .from('post_replies')
          .select(_replySelect)
          .eq('post_id', postId)
          .order('created_at', ascending: true);
      return rows.map(_hydrateReply).toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<PostReplyEntity> addReply({
    required String postId,
    required String body,
    String? parentReplyId,
    String? voiceUrl,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw const AuthFailure('Not authenticated');
    try {
      final row = await _client
          .from('post_replies')
          .insert({
            'post_id': postId,
            'author_id': userId,
            'body': body,
            'parent_reply_id': ?parentReplyId,
            'voice_url': ?voiceUrl,
          })
          .select(_replySelect)
          .single();
      return _hydrateReply(row);
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteReply(String replyId) async {
    try {
      await _client.from('post_replies').delete().eq('id', replyId);
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> markBestAnswer({
    required String replyId,
    required String postId,
  }) async {
    try {
      // The partial unique index on post_replies(post_id) WHERE is_best_answer
      // enforces at most one best-answer per post at the DB level.
      // First, clear any existing best-answer for the same post.
      await _client
          .from('post_replies')
          .update({'is_best_answer': false})
          .eq('post_id', postId)
          .eq('is_best_answer', true);

      // Then mark the selected reply.
      await _client
          .from('post_replies')
          .update({'is_best_answer': true})
          .eq('id', replyId);
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // ── likes ──────────────────────────────────────────────────────────────────

  @override
  Future<bool> toggleLike(String postId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw const AuthFailure('Not authenticated');

    // 1. Check if a like row already exists.
    final existing = await _client
        .from('post_likes')
        .select('id')
        .eq('post_id', postId)
        .eq('user_id', userId)
        .maybeSingle();

    if (existing == null) {
      // 2. Not liked yet — insert and return true.
      // Guard against TOCTOU: a concurrent tap may have already inserted a row
      // between step 1 and now. Catch the unique-violation (23505) and treat
      // it as "already liked" rather than propagating an error.
      try {
        await _client.from('post_likes').insert({
          'post_id': postId,
          'user_id': userId,
        });
        return true;
      } on PostgrestException catch (e) {
        if (e.code == '23505') {
          // Concurrent insert — already liked; treat as liked.
          return false;
        }
        throw SupabaseErrorMapper.fromPostgrest(e);
      } catch (e) {
        throw ServerFailure(e.toString());
      }
    } else {
      // 3. Already liked — delete it and return false.
      try {
        await _client
            .from('post_likes')
            .delete()
            .eq('post_id', postId)
            .eq('user_id', userId);
        return false;
      } on PostgrestException catch (e) {
        throw SupabaseErrorMapper.fromPostgrest(e);
      } catch (e) {
        throw ServerFailure(e.toString());
      }
    }
  }

  // ── realtime feed ──────────────────────────────────────────────────────────

  @override
  Stream<Map<String, dynamic>> watchNewPostsRaw(
    RealtimeChannelManager manager,
  ) {
    return manager.subscribe(
      table: 'posts',
      event: PostgresChangeEvent.insert,
    );
  }

  // ── follows ────────────────────────────────────────────────────────────────

  @override
  Future<List<FollowModel>> getFollows(String userId) async {
    try {
      final rows = await _client
          .from('follows')
          .select()
          .eq('follower_id', userId);
      return rows.map(FollowModel.fromJson).toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<FollowModel> follow({
    required String targetId,
    required String type,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw const AuthFailure('Not authenticated');
    try {
      final row = await _client
          .from('follows')
          .insert({
            'follower_id': userId,
            'target_id': targetId,
            'type': type,
          })
          .select()
          .single();
      return FollowModel.fromJson(row);
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> unfollow({required String targetId}) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw const AuthFailure('Not authenticated');
    try {
      await _client
          .from('follows')
          .delete()
          .eq('follower_id', userId)
          .eq('target_id', targetId);
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // ── reports ────────────────────────────────────────────────────────────────

  @override
  Future<ContentReportModel> reportPost({
    required String postId,
    required String reason,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw const AuthFailure('Not authenticated');
    try {
      final row = await _client
          .from('content_reports')
          .insert({
            'reporter_id': userId,
            'post_id': postId,
            'reason': reason,
          })
          .select()
          .single();
      return ContentReportModel.fromJson(row);
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // ── private helpers ────────────────────────────────────────────────────────

  /// Returns the set of post-ids from [candidateIds] that the current user has
  /// liked. Returns an empty set if unauthenticated or if [candidateIds] is empty.
  Future<Set<String>> _fetchLikedPostIds(List<String> candidateIds) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null || candidateIds.isEmpty) return const {};
    try {
      final rows = await _client
          .from('post_likes')
          .select('post_id')
          .eq('user_id', userId)
          .inFilter('post_id', candidateIds);
      return {for (final r in rows) r['post_id'] as String};
    } catch (_) {
      // Non-fatal — like indicators gracefully fall back to unliked.
      return const {};
    }
  }
}
