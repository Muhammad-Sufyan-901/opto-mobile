// Cubit for a single post's reply thread — loads replies and submits new ones.
//
// State is defined inline using `freezed` to match the project convention
// (see `profile_state.dart`).
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/error/failures.dart';
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

  /// Replies being fetched.
  const factory PostThreadState.loading() = PostThreadLoading;

  /// Replies loaded successfully.
  const factory PostThreadState.loaded({
    required List<PostReplyEntity> replies,
  }) = PostThreadLoaded;

  /// Load or reply submission failed with [message].
  const factory PostThreadState.error({required String message}) =
      PostThreadError;
}

// =============================================================================
// CUBIT
// =============================================================================

/// Cubit that drives the post-thread bottom sheet / screen.
///
/// Responsibilities:
/// - Fetch all replies for a given post via [ConnectRepository.getReplies].
/// - Submit new replies via [ConnectRepository.addReply] and reload on success.
/// - On reply failure, surface the error and restore the previous loaded state
///   so the user doesn't lose the existing thread view.
class PostThreadCubit extends Cubit<PostThreadState> {
  PostThreadCubit(this._connect) : super(const PostThreadState.initial());

  final ConnectRepository _connect;

  // ---------------------------------------------------------------------------
  // PUBLIC API
  // ---------------------------------------------------------------------------

  /// Loads (or reloads) replies for [postId].
  Future<void> load(String postId) async {
    emit(const PostThreadState.loading());
    try {
      final replies = await _connect.getReplies(postId);
      emit(PostThreadState.loaded(replies: replies));
    } on Failure catch (f) {
      emit(PostThreadState.error(message: f.message));
    } catch (_) {
      emit(const PostThreadState.error(
          message: 'An unexpected error occurred.'));
    }
  }

  /// Adds a reply with [body] to [postId] then reloads the thread.
  ///
  /// On failure the error state is emitted briefly before the previous [PostThreadLoaded]
  /// state is restored so the user can retry without losing the thread context.
  Future<void> addReply({
    required String postId,
    required String body,
  }) async {
    final current = state;
    try {
      await _connect.addReply(postId: postId, body: body);
      // Reload to pick up the new reply with server-confirmed data.
      await load(postId);
    } on Failure catch (f) {
      emit(PostThreadState.error(message: f.message));
      // Restore loaded state so the thread is still visible after the error.
      if (current is PostThreadLoaded) emit(current);
    } catch (_) {
      emit(const PostThreadState.error(
          message: 'An unexpected error occurred.'));
      if (current is PostThreadLoaded) emit(current);
    }
  }
}
