// Events for [ComposePostBloc].
//
// Uses `freezed` for immutable, sealed event classes.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'compose_post_event.freezed.dart';

@freezed
sealed class ComposePostEvent with _$ComposePostEvent {
  /// User edited the post body text to [body].
  const factory ComposePostEvent.bodyChanged(String body) = BodyChanged;

  /// User selected a media attachment at [localPath] with [altText].
  const factory ComposePostEvent.mediaSelected({
    required String localPath,
    required String altText,
  }) = MediaSelected;

  /// User removed the current media attachment.
  const factory ComposePostEvent.mediaRemoved() = MediaRemoved;

  /// User tapped submit — validates and persists the post (and optional media).
  const factory ComposePostEvent.submit() = Submit;
}
