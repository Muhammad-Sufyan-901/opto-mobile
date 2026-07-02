// Domain contract for Connect community post operations.
//
// Implementations live in the data layer
// (`lib/features/connect/data/repositories/connect_repository_impl.dart`).
//
// NOTE: No Supabase or infrastructure imports — domain layer stays pure Dart.
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
  // ── posts ──────────────────────────────────────────────────────────────────

  /// Fetches the paginated community feed ordered by [createdAt] descending.
  ///
  /// [limit] defaults to 20; [offset] defaults to 0.
  /// [topic] narrows the feed to posts with that topic label; null = all topics.
  ///
  /// Throws [ServerFailure] on network/RLS error.
  Future<List<PostEntity>> getFeed({
    int limit = 20,
    int offset = 0,
    String? topic,
  });

  /// Fetches a single fully-hydrated post by [postId].
  ///
  /// Used in the thread detail screen to render the original post header when
  /// navigated via deep-link (no [seedPost] available from route extra).
  ///
  /// Throws [ServerFailure] when the post is not found or on network error.
  Future<PostEntity> getPostById(String postId);

  /// Inserts a new post for the currently signed-in user.
  ///
  /// [body] must be non-empty.
  ///
  /// Throws [AuthFailure] when unauthenticated, [ServerFailure] on RLS/network
  /// error.
  Future<PostEntity> createPost({
    required String body,
    String? title,
    String? topic,
    String? voiceUrl,
  });

  /// Deletes the post with [postId].
  ///
  /// RLS enforces that only the author can delete.
  ///
  /// Throws [ServerFailure] on RLS/network error.
  Future<void> deletePost(String postId);

  // ── media ──────────────────────────────────────────────────────────────────

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

  // ── replies ────────────────────────────────────────────────────────────────

  /// Fetches all replies for [postId] ordered by [createdAt] ascending.
  ///
  /// Throws [ServerFailure] on error.
  Future<List<PostReplyEntity>> getReplies(String postId);

  /// Inserts a reply to [postId].
  ///
  /// [body] must be non-empty.
  /// [parentReplyId] enables one-level nesting; null for top-level replies.
  ///
  /// Throws [AuthFailure] when unauthenticated, [ServerFailure] on error.
  Future<PostReplyEntity> addReply({
    required String postId,
    required String body,
    String? parentReplyId,
    String? voiceUrl,
  });

  /// Deletes a reply. RLS enforces author-only.
  Future<void> deleteReply(String replyId);

  /// Marks [replyId] as the best answer for [postId].
  ///
  /// Only the OP author can invoke this (RLS-enforced).
  /// Clears any previously marked best answer for the same post first.
  ///
  /// Throws [AuthFailure] when unauthenticated, [ServerFailure] on RLS/error.
  Future<void> markBestAnswer({
    required String replyId,
    required String postId,
  });

  // ── likes ──────────────────────────────────────────────────────────────────

  /// Toggles a like on [postId] for the current user.
  ///
  /// Inserts a `post_likes` row if not liked; deletes if already liked.
  /// Returns `true` if the post is now liked, `false` if unliked.
  ///
  /// Throws [AuthFailure] when unauthenticated.
  Future<bool> toggleLike(String postId);

  // ── bookmarks ──────────────────────────────────────────────────────────────

  /// Toggles a bookmark/save on [postId] for the current user.
  ///
  /// Inserts a `post_bookmarks` row if not saved; deletes if already saved.
  /// Returns `true` if the post is now saved, `false` if unsaved.
  ///
  /// Throws [AuthFailure] when unauthenticated.
  Future<bool> toggleBookmark(String postId);

  // ── realtime feed ──────────────────────────────────────────────────────────

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
