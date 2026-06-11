// Domain contract for Connect community post operations.
//
// Implementations live in the data layer
// (`lib/features/connect/data/repositories/connect_repository_impl.dart`).
//
// NOTE: No Supabase or infrastructure imports — domain layer stays pure Dart.
import 'package:opto/core/error/failures.dart';
import 'package:opto/features/connect/domain/entities/post_entity.dart';
import 'package:opto/features/connect/domain/entities/post_media_entity.dart';
import 'package:opto/features/connect/domain/entities/post_reply_entity.dart';

/// Abstract contract for Connect community post operations.
///
/// Covers posts, media attachments, replies, likes, and the live Realtime feed.
///
/// Methods throw [Failure] subclasses on error; the BLoC catches and maps them
/// to error states.
abstract class ConnectRepository {
  /// Fetches the paginated community feed ordered by [createdAt] descending.
  ///
  /// [limit] defaults to 20; [offset] defaults to 0.
  ///
  /// Throws [ServerFailure] on network/RLS error.
  Future<List<PostEntity>> getFeed({int limit = 20, int offset = 0});

  /// Inserts a new post for the currently signed-in user.
  ///
  /// [body] must be non-empty.
  ///
  /// Throws [AuthFailure] when unauthenticated, [ServerFailure] on RLS/network
  /// error.
  Future<PostEntity> createPost({required String body});

  /// Deletes the post with [postId].
  ///
  /// RLS enforces that only the author can delete.
  ///
  /// Throws [ServerFailure] on RLS/network error.
  Future<void> deletePost(String postId);

  /// Uploads a media file (at [localPath]) to the `post-media` Storage bucket
  /// and inserts a `post_media` row linked to [postId].
  ///
  /// [altText] must be non-empty — enforced at this call site before hitting
  /// the DB.
  ///
  /// Throws [StorageFailure] on upload error, [ServerFailure] on DB error.
  Future<PostMediaEntity> addMedia({
    required String postId,
    required String localPath,
    required String altText,
  });

  /// Removes a `post_media` row and deletes the Storage object.
  ///
  /// Throws [StorageFailure] / [ServerFailure] on error.
  Future<void> removeMedia(String mediaId);

  /// Fetches all replies for [postId] ordered by [createdAt] ascending.
  ///
  /// Throws [ServerFailure] on error.
  Future<List<PostReplyEntity>> getReplies(String postId);

  /// Inserts a reply to [postId].
  ///
  /// [body] must be non-empty.
  ///
  /// Throws [AuthFailure] when unauthenticated, [ServerFailure] on error.
  Future<PostReplyEntity> addReply({
    required String postId,
    required String body,
  });

  /// Deletes a reply. RLS enforces author-only.
  Future<void> deleteReply(String replyId);

  /// Toggles a like on [postId] for the current user.
  ///
  /// Inserts a `post_likes` row if not liked; deletes if already liked.
  /// Returns `true` if the post is now liked, `false` if unliked.
  ///
  /// Throws [AuthFailure] when unauthenticated.
  Future<bool> toggleLike(String postId);

  /// Returns a stream of new [PostEntity] inserts from the Supabase Realtime
  /// `connect-feed` channel. Each emitted item is a newly-inserted post.
  ///
  /// The repository implementation must clean up the Realtime channel when
  /// the stream is cancelled — tie disposal to [RealtimeChannelManager.dispose].
  ///
  /// Callers (ConnectFeedBloc) must cancel the [StreamSubscription] in [close()].
  Stream<PostEntity> watchNewPosts();

  /// Releases Realtime channel resources.
  ///
  /// Must be called from the owning BLoC's [close] method.
  Future<void> dispose();
}
