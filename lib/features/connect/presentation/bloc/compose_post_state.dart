// States for [ComposePostBloc].
//
// Uses `freezed` for immutable, sealed state classes.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/features/connect/domain/entities/post_entity.dart';

part 'compose_post_state.freezed.dart';

@freezed
sealed class ComposePostState with _$ComposePostState {
  /// Compose form is idle and editable.
  ///
  /// [body] is the current text. [mediaPath] is the local file path of the
  /// selected attachment (null if none). [altText] is the accessibility
  /// description for the attachment.
  const factory ComposePostState.idle({
    @Default('') String body,
    String? mediaPath,
    @Default('') String altText,
  }) = ComposeIdle;

  /// Post submission in progress — disable the form.
  const factory ComposePostState.submitting() = ComposeSubmitting;

  /// Post created successfully; [post] is the newly-created entity.
  const factory ComposePostState.success(PostEntity post) = ComposeSuccess;

  /// Submission failed with [message].
  const factory ComposePostState.error({required String message}) = ComposeError;
}
