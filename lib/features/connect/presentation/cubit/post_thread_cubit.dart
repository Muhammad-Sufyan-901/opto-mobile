// Cubit for a single post's reply thread — loads the OP + replies and
// handles new reply submission, nesting, and best-answer marking.
//
// State is defined inline using `freezed` to match the project convention.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/connect/domain/entities/post_entity.dart';
import 'package:opto/features/connect/domain/entities/post_reply_entity.dart';
import 'package:opto/features/connect/domain/repositories/connect_repository.dart';

part 'post_thread_cubit.freezed.dart';

// =============================================================================
// STATE
// =============================================================================

@freezed
sealed class PostThreadState with _$PostThreadState {
  /// Thread not yet loaded.
  const factory PostThreadState.initial() = PostThreadInitial;

  /// Replies being fetched (but may show a seed post immediately).
  const factory PostThreadState.loading({PostEntity? seedPost}) =
      PostThreadLoading;

  /// Both the OP and replies are loaded successfully.
  ///
  /// [topLevel] contains only root replies (parentReplyId == null).
  /// [nested] maps each top-level reply id → its child replies.
  const factory PostThreadState.loaded({
    required PostEntity post,
    required List<PostReplyEntity> topLevel,
    required Map<String, List<PostReplyEntity>> nested,
  }) = PostThreadLoaded;

  /// Load or reply submission failed with [message].
  const factory PostThreadState.error({required String message}) =
      PostThreadError;
}

// =============================================================================
// CUBIT
// =============================================================================

/// Cubit that drives the post-thread screen.
///
/// Responsibilities:
/// - Fetch the OP ([ConnectRepository.getPostById]) and its replies.
/// - Optionally render a [seedPost] from the route extra immediately while
///   the network request is in flight.
/// - Build a one-level reply tree (top-level + their direct children).
/// - Submit new replies ([addReply]) with optional [parentReplyId].
/// - Mark a reply as best answer ([markBestAnswer]).
class PostThreadCubit extends Cubit<PostThreadState> {
  PostThreadCubit(this._connect) : super(const PostThreadState.initial());

  final ConnectRepository _connect;

  // ---------------------------------------------------------------------------
  // PUBLIC API
  // ---------------------------------------------------------------------------

  /// Loads (or reloads) the OP + replies for [postId].
  ///
  /// If [seedPost] is provided (from route extra), it is surfaced immediately
  /// via a [PostThreadLoading] state so the screen can render the OP header
  /// before the network round-trip completes.
  Future<void> load(String postId, {PostEntity? seedPost}) async {
    emit(PostThreadState.loading(seedPost: seedPost));
    try {
      final results = await Future.wait([
        _connect.getPostById(postId),
        _connect.getReplies(postId),
      ]);

      final post = results[0] as PostEntity;
      final replies = results[1] as List<PostReplyEntity>;

      emit(PostThreadState.loaded(
        post: post,
        topLevel: _topLevel(replies),
        nested: _buildNestedMap(replies),
      ));
    } on Failure catch (f) {
      emit(PostThreadState.error(message: f.message));
    } catch (_) {
      emit(const PostThreadState.error(
          message: 'An unexpected error occurred.'));
    }
  }

  /// Adds a [body] reply to [postId], optionally nested under [parentReplyId].
  ///
  /// On failure the error state is emitted briefly then the previous loaded
  /// state is restored so the thread is still visible after the error.
  Future<void> addReply({
    required String postId,
    required String body,
    String? parentReplyId,
  }) async {
    final current = state;
    try {
      await _connect.addReply(
        postId: postId,
        body: body,
        parentReplyId: parentReplyId,
      );
      // Reload to pick up the new reply with server-confirmed data.
      final post = current is PostThreadLoaded ? current.post : null;
      await load(postId, seedPost: post);
    } on Failure catch (f) {
      emit(PostThreadState.error(message: f.message));
      if (current is PostThreadLoaded) emit(current);
    } catch (_) {
      emit(const PostThreadState.error(
          message: 'An unexpected error occurred.'));
      if (current is PostThreadLoaded) emit(current);
    }
  }

  /// Marks [replyId] as the best answer for [postId].
  ///
  /// Only the OP author can call this (RLS-enforced by the server).
  Future<void> markBestAnswer({
    required String replyId,
    required String postId,
  }) async {
    final current = state;
    try {
      await _connect.markBestAnswer(replyId: replyId, postId: postId);
      // Reload to reflect the updated is_best_answer flag.
      final post = current is PostThreadLoaded ? current.post : null;
      await load(postId, seedPost: post);
    } on Failure catch (f) {
      emit(PostThreadState.error(message: f.message));
      if (current is PostThreadLoaded) emit(current);
    } catch (_) {
      emit(const PostThreadState.error(
          message: 'An unexpected error occurred.'));
      if (current is PostThreadLoaded) emit(current);
    }
  }

  /// Toggles the like state on [postId] for the current user.
  ///
  /// Applies an optimistic update immediately; reverts on failure.
  Future<void> toggleLike(String postId) async {
    final current = state;
    if (current is! PostThreadLoaded) return;

    final preToggle = current.post;
    final nowLiked = !preToggle.likedByMe;
    emit(current.copyWith(
      post: preToggle.copyWith(
        likedByMe: nowLiked,
        likeCount: nowLiked ? preToggle.likeCount + 1 : preToggle.likeCount - 1,
      ),
    ));

    try {
      await _connect.toggleLike(postId);
    } on Failure catch (_) {
      emit(current.copyWith(post: preToggle));
    } catch (_) {
      emit(current.copyWith(post: preToggle));
    }
  }

  /// Toggles the bookmark/save state on [postId] for the current user.
  ///
  /// Applies an optimistic update immediately; reverts on failure.
  Future<void> toggleBookmark(String postId) async {
    final current = state;
    if (current is! PostThreadLoaded) return;

    final preToggle = current.post;
    emit(current.copyWith(
      post: preToggle.copyWith(bookmarkedByMe: !preToggle.bookmarkedByMe),
    ));

    try {
      await _connect.toggleBookmark(postId);
    } on Failure catch (_) {
      emit(current.copyWith(post: preToggle));
    } catch (_) {
      emit(current.copyWith(post: preToggle));
    }
  }

  // ---------------------------------------------------------------------------
  // PRIVATE HELPERS
  // ---------------------------------------------------------------------------

  /// Returns only root-level replies (no parent).
  static List<PostReplyEntity> _topLevel(List<PostReplyEntity> all) =>
      all.where((r) => r.parentReplyId == null).toList();

  /// Builds a map from top-level reply id → its direct children.
  static Map<String, List<PostReplyEntity>> _buildNestedMap(
    List<PostReplyEntity> all,
  ) {
    final Map<String, List<PostReplyEntity>> map = {};
    for (final r in all) {
      if (r.parentReplyId != null) {
        map.putIfAbsent(r.parentReplyId!, () => []).add(r);
      }
    }
    return map;
  }
}
