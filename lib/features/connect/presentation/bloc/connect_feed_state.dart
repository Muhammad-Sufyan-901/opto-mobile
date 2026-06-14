// States for [ConnectFeedBloc].
//
// Uses `freezed` for immutable, sealed state classes — mirrors
// the pattern in `profile_state.dart`.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/features/connect/domain/entities/post_entity.dart';

part 'connect_feed_state.freezed.dart';

@freezed
sealed class ConnectFeedState with _$ConnectFeedState {
  /// Feed not yet loaded.
  const factory ConnectFeedState.initial() = FeedInitial;

  /// Initial feed load in progress.
  const factory ConnectFeedState.loading() = FeedLoading;

  /// Feed loaded successfully.
  ///
  /// [isLoadingMore] indicates a pagination request in flight.
  /// [activeTopic] is the index of the selected topic-filter chip.
  /// [activeTopicLabel] is the string label passed to [getFeed] for server-side
  ///   filtering; null means "All topics".
  /// [hasReachedEnd] is `true` when the last page returned fewer items than
  ///   the page size — no more pages to fetch.
  const factory ConnectFeedState.loaded({
    required List<PostEntity> posts,
    @Default(false) bool isLoadingMore,
    @Default(0) int activeTopic,
    String? activeTopicLabel,
    @Default(false) bool hasReachedEnd,
  }) = FeedLoaded;

  /// Feed load or operation failed with [message].
  const factory ConnectFeedState.error({required String message}) = FeedError;
}
