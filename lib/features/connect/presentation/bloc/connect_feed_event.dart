// Events for [ConnectFeedBloc].
//
// Uses `freezed` for immutable, sealed event classes — mirrors
// the pattern in `profile_event.dart`.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/features/connect/domain/entities/post_entity.dart';

part 'connect_feed_event.freezed.dart';

@freezed
sealed class ConnectFeedEvent with _$ConnectFeedEvent {
  /// Load (or reload) the paginated feed.
  ///
  /// Set [reset] to `true` to clear pagination state and restart from offset 0.
  const factory ConnectFeedEvent.loadFeed({@Default(false) bool reset}) =
      LoadFeed;

  /// Subscribe to the Realtime feed channel.
  ///
  /// Call once when the community screen mounts. Emits [NewPostReceived] events
  /// as new posts arrive from Supabase Realtime.
  const factory ConnectFeedEvent.subscribeFeed() = SubscribeFeed;

  /// A new post arrived via the Realtime channel.
  ///
  /// Handled internally — emitted by the Realtime stream listener.
  const factory ConnectFeedEvent.newPostReceived(PostEntity post) =
      NewPostReceived;

  /// Toggle the like state on [postId] for the current user.
  ///
  /// Applies an optimistic update immediately; reverts on failure.
  const factory ConnectFeedEvent.toggleLike(String postId) = ToggleLike;

  /// Toggle the bookmark/save state on [postId] for the current user.
  ///
  /// Applies an optimistic update immediately; reverts on failure.
  const factory ConnectFeedEvent.toggleBookmark(String postId) =
      ToggleBookmark;

  /// Change the active topic-filter chip to [index].
  ///
  /// [topic] is the string label of the selected topic, or null for "All".
  /// Triggers a server-side reload with the chosen topic filter.
  const factory ConnectFeedEvent.changeTopicFilter({
    required int index,
    String? topic,
  }) = ChangeTopicFilter;
}
