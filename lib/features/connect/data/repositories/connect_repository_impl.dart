// Concrete implementation of [ConnectRepository].
//
// Delegates to [ConnectRemoteDataSource] for all PostgREST / Storage calls.
// Maps data-layer models to domain entities via the `toEntity()` extensions.
// Owns the [RealtimeChannelManager] for the live feed subscription.
import 'package:opto/core/error/failures.dart';
import 'package:opto/core/supabase/realtime_channel_manager.dart';
import 'package:opto/features/connect/data/datasources/connect_remote_data_source.dart';
import 'package:opto/features/connect/data/models/post_media_model_ext.dart';
import 'package:opto/features/connect/data/models/post_model.dart';
import 'package:opto/features/connect/data/models/post_model_ext.dart';
import 'package:opto/features/connect/data/models/post_reply_model_ext.dart';
import 'package:opto/features/connect/domain/entities/post_entity.dart';
import 'package:opto/features/connect/domain/entities/post_media_entity.dart';
import 'package:opto/features/connect/domain/entities/post_reply_entity.dart';
import 'package:opto/features/connect/domain/repositories/connect_repository.dart';

/// Production implementation of [ConnectRepository].
///
/// Failures that escape the data source are already typed [Failure]
/// subclasses — they propagate up to the BLoC, which catches and maps
/// them to error states.
///
/// This class owns a [RealtimeChannelManager] for the live-feed channel.
/// Call [dispose] during BLoC teardown (e.g. [Bloc.close]) to unsubscribe.
class ConnectRepositoryImpl implements ConnectRepository {
  ConnectRepositoryImpl({required ConnectRemoteDataSource remoteDataSource})
      : _remote = remoteDataSource;

  final ConnectRemoteDataSource _remote;

  /// Owns the Realtime subscription for the community feed.
  ///
  /// Passed to the data source's [watchNewPostsRaw] so the channel is managed
  /// here, not inside the data source. Call [dispose] to clean up.
  final RealtimeChannelManager _realtimeManager =
      RealtimeChannelManager(channelName: 'connect-feed');

  // ── posts ──────────────────────────────────────────────────────────────────

  @override
  Future<List<PostEntity>> getFeed({int limit = 20, int offset = 0}) async {
    final models = await _remote.getFeed(limit: limit, offset: offset);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<PostEntity> createPost({required String body}) async {
    if (body.trim().isEmpty) {
      throw const ServerFailure('Body cannot be empty');
    }
    final model = await _remote.createPost(body: body);
    return model.toEntity();
  }

  @override
  Future<void> deletePost(String postId) => _remote.deletePost(postId);

  // ── media ──────────────────────────────────────────────────────────────────

  @override
  Future<PostMediaEntity> addMedia({
    required String postId,
    required String localPath,
    required String altText,
  }) async {
    if (altText.trim().isEmpty) {
      throw const ServerFailure('Alt text cannot be empty');
    }
    final model = await _remote.addMedia(
      postId: postId,
      localPath: localPath,
      altText: altText,
    );
    return model.toEntity();
  }

  @override
  Future<void> removeMedia(String mediaId) => _remote.removeMedia(mediaId);

  // ── replies ────────────────────────────────────────────────────────────────

  @override
  Future<List<PostReplyEntity>> getReplies(String postId) async {
    final models = await _remote.getReplies(postId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<PostReplyEntity> addReply({
    required String postId,
    required String body,
  }) async {
    if (body.trim().isEmpty) {
      throw const ServerFailure('Body cannot be empty');
    }
    final model = await _remote.addReply(postId: postId, body: body);
    return model.toEntity();
  }

  @override
  Future<void> deleteReply(String replyId) => _remote.deleteReply(replyId);

  // ── likes ──────────────────────────────────────────────────────────────────

  @override
  Future<bool> toggleLike(String postId) => _remote.toggleLike(postId);

  // ── realtime feed ──────────────────────────────────────────────────────────

  @override
  Stream<PostEntity> watchNewPosts() {
    return _remote.watchNewPostsRaw(_realtimeManager).map(
          (map) => PostModel.fromJson(map).toEntity(),
        );
  }

  // ── lifecycle ──────────────────────────────────────────────────────────────

  /// Unsubscribes from the Realtime feed channel and releases resources.
  ///
  /// Must be called from the owning BLoC's [close] method (via DI teardown).
  @override
  Future<void> dispose() => _realtimeManager.dispose();
}
