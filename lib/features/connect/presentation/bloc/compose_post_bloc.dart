// BLoC for the compose-post flow — manages body text, optional media
// attachment, validation, and submission to [ConnectRepository].
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/connect/domain/repositories/connect_repository.dart';
import 'package:opto/features/connect/presentation/bloc/compose_post_event.dart';
import 'package:opto/features/connect/presentation/bloc/compose_post_state.dart';

export 'compose_post_event.dart';
export 'compose_post_state.dart';

/// BLoC that drives the compose-post bottom-sheet / screen.
///
/// Responsibilities:
/// - Track edits to body text and media attachment.
/// - Validate before submission (non-empty body; alt text required when media
///   is selected).
/// - Call [ConnectRepository.createPost] and, if media is attached,
///   [ConnectRepository.addMedia].
/// - Emit [ComposeSuccess] on completion so the parent screen can dismiss the
///   sheet and trigger a feed reload.
class ComposePostBloc extends Bloc<ComposePostEvent, ComposePostState> {
  ComposePostBloc(this._connect) : super(const ComposePostState.idle()) {
    on<BodyChanged>(_onBodyChanged);
    on<MediaSelected>(_onMediaSelected);
    on<MediaRemoved>(_onMediaRemoved);
    on<Submit>(_onSubmit);
  }

  final ConnectRepository _connect;

  // ---------------------------------------------------------------------------
  // HANDLERS
  // ---------------------------------------------------------------------------

  void _onBodyChanged(
    BodyChanged event,
    Emitter<ComposePostState> emit,
  ) {
    // Preserve existing media fields when only the body changes.
    final current = state is ComposeIdle
        ? state as ComposeIdle
        : const ComposeIdle();
    emit(current.copyWith(body: event.body));
  }

  void _onMediaSelected(
    MediaSelected event,
    Emitter<ComposePostState> emit,
  ) {
    final current = state is ComposeIdle
        ? state as ComposeIdle
        : const ComposeIdle();
    emit(current.copyWith(
      mediaPath: event.localPath,
      altText: event.altText,
    ));
  }

  void _onMediaRemoved(
    MediaRemoved event,
    Emitter<ComposePostState> emit,
  ) {
    final current = state is ComposeIdle
        ? state as ComposeIdle
        : const ComposeIdle();
    // Clear mediaPath to null and reset altText.
    emit(ComposeIdle(body: current.body));
  }

  Future<void> _onSubmit(
    Submit event,
    Emitter<ComposePostState> emit,
  ) async {
    // Only process submission from the idle state.
    if (state is! ComposeIdle) return;
    final current = state as ComposeIdle;

    // ── Validation ────────────────────────────────────────────────────────────

    if (current.body.trim().isEmpty) {
      emit(const ComposePostState.error(
          message: 'Post body cannot be empty.'));
      // Restore idle so the user can correct without re-typing.
      emit(current);
      return;
    }

    if (current.mediaPath != null && current.altText.trim().isEmpty) {
      emit(const ComposePostState.error(
          message: 'Please add a description for the attached image.'));
      emit(current);
      return;
    }

    // ── Submission ───────────────────────────────────────────────────────────

    emit(const ComposePostState.submitting());

    try {
      final post = await _connect.createPost(body: current.body.trim());

      if (current.mediaPath != null) {
        await _connect.addMedia(
          postId: post.id,
          localPath: current.mediaPath!,
          altText: current.altText.trim(),
        );
      }

      emit(ComposePostState.success(post));
    } on Failure catch (f) {
      emit(ComposePostState.error(message: f.message));
    } catch (_) {
      emit(const ComposePostState.error(
          message: 'An unexpected error occurred.'));
    }
  }
}
