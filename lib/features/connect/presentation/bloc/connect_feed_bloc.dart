// BLoC for the community feed — sits between [ConnectRepository] and the
// community screen. Handles pagination, Realtime subscriptions, topic-filtering,
// and optimistic like toggling.
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/connect/domain/repositories/connect_repository.dart';
import 'package:opto/features/connect/presentation/bloc/connect_feed_event.dart';
import 'package:opto/features/connect/presentation/bloc/connect_feed_state.dart';

export 'connect_feed_event.dart';
export 'connect_feed_state.dart';

/// BLoC that drives the Connect community feed screen.
///
/// Responsibilities:
/// - Paginated [ConnectRepository.getFeed] calls (20 posts per page).
/// - Server-side topic filtering — [ChangeTopicFilter] now passes the topic
///   label string into [getFeed(topic:)] rather than client-side chip selection.
/// - Realtime subscription via [ConnectRepository.watchNewPosts] — new posts
///   are prepended de-duplicated to the list.
/// - Optimistic like toggling with automatic revert on failure.
///
/// Disposal: [close] cancels the [StreamSubscription] and calls
/// [ConnectRepository.dispose] to release the Realtime channel. Because
/// [ConnectRepository] is registered as a [registerFactory], each BLoC instance
/// owns its own repository (and its own [RealtimeChannelManager]), so disposal
/// here only affects this BLoC's channel.
class ConnectFeedBloc extends Bloc<ConnectFeedEvent, ConnectFeedState> {
  ConnectFeedBloc(this._connect) : super(const ConnectFeedState.initial()) {
    on<LoadFeed>(_onLoadFeed);
    on<SubscribeFeed>(_onSubscribeFeed);
    on<NewPostReceived>(_onNewPostReceived);
    on<ToggleLike>(_onToggleLike);
    on<ToggleBookmark>(_onToggleBookmark);
    on<ChangeTopicFilter>(_onChangeTopicFilter);
  }

  final ConnectRepository _connect;

  /// Active Realtime stream subscription; cancelled in [close].
  StreamSubscription? _feedSubscription;

  static const int _pageSize = 20;

  /// Current pagination offset — reset to 0 by [LoadFeed] with `reset: true`.
  int _offset = 0;

  // ---------------------------------------------------------------------------
  // HANDLERS
  // ---------------------------------------------------------------------------

  Future<void> _onLoadFeed(
    LoadFeed event,
    Emitter<ConnectFeedState> emit,
  ) async {
    if (event.reset) {
      _offset = 0;
    }

    // Retrieve the active topic label from current state (if any).
    final currentTopicLabel = state is FeedLoaded
        ? (state as FeedLoaded).activeTopicLabel
        : null;

    // Show a full loading spinner only on the initial load (offset == 0).
    // For pagination the UI uses FeedLoaded.isLoadingMore.
    if (_offset == 0) {
      emit(const ConnectFeedState.loading());
    } else if (state is FeedLoaded) {
      emit((state as FeedLoaded).copyWith(isLoadingMore: true));
    }

    try {
      final results = await _connect.getFeed(
        limit: _pageSize,
        offset: _offset,
        topic: currentTopicLabel,
      );
      final hasReachedEnd = results.length < _pageSize;

      if (_offset == 0) {
        // Fresh load — replace list entirely.
        emit(ConnectFeedState.loaded(
          posts: results,
          hasReachedEnd: hasReachedEnd,
          activeTopicLabel: currentTopicLabel,
        ));
      } else {
        // Pagination — append to existing list, preserving activeTopic.
        final current = state is FeedLoaded
            ? (state as FeedLoaded)
            : const FeedLoaded(posts: []);
        emit(current.copyWith(
          posts: [...current.posts, ...results],
          isLoadingMore: false,
          hasReachedEnd: hasReachedEnd,
        ));
      }

      _offset += results.length;
    } on Failure catch (f) {
      emit(ConnectFeedState.error(message: f.message));
    } catch (_) {
      emit(const ConnectFeedState.error(
          message: 'An unexpected error occurred.'));
    }
  }

  Future<void> _onSubscribeFeed(
    SubscribeFeed event,
    Emitter<ConnectFeedState> emit,
  ) async {
    // Cancel any pre-existing subscription before creating a new one.
    await _feedSubscription?.cancel();

    _feedSubscription = _connect.watchNewPosts().listen(
          (post) => add(ConnectFeedEvent.newPostReceived(post)),
          onError: (_) {}, // silently ignore Realtime errors — feed still usable
        );
  }

  void _onNewPostReceived(
    NewPostReceived event,
    Emitter<ConnectFeedState> emit,
  ) {
    if (state is! FeedLoaded) return;
    final current = state as FeedLoaded;

    // De-duplicate: if the post arrived via our own createPost, it may already
    // be in the list because ConnectFeedBloc resets after compose success.
    if (current.posts.any((p) => p.id == event.post.id)) return;

    emit(current.copyWith(posts: [event.post, ...current.posts]));
  }

  Future<void> _onToggleLike(
    ToggleLike event,
    Emitter<ConnectFeedState> emit,
  ) async {
    if (state is! FeedLoaded) return;
    final current = state as FeedLoaded;

    // Optimistic update.
    final preLikePosts = current.posts;
    final optimisticPosts = preLikePosts.map((post) {
      if (post.id != event.postId) return post;
      final nowLiked = !post.likedByMe;
      return post.copyWith(
        likedByMe: nowLiked,
        likeCount: nowLiked ? post.likeCount + 1 : post.likeCount - 1,
      );
    }).toList();

    emit(current.copyWith(posts: optimisticPosts));

    try {
      await _connect.toggleLike(event.postId);
      // Server confirms; state is already correct from optimistic update.
    } on Failure catch (_) {
      // Revert to the pre-toggle list on failure.
      emit(current.copyWith(posts: preLikePosts));
    } catch (_) {
      emit(current.copyWith(posts: preLikePosts));
    }
  }

  Future<void> _onToggleBookmark(
    ToggleBookmark event,
    Emitter<ConnectFeedState> emit,
  ) async {
    if (state is! FeedLoaded) return;
    final current = state as FeedLoaded;

    // Optimistic update.
    final preSavePosts = current.posts;
    final optimisticPosts = preSavePosts.map((post) {
      if (post.id != event.postId) return post;
      return post.copyWith(bookmarkedByMe: !post.bookmarkedByMe);
    }).toList();

    emit(current.copyWith(posts: optimisticPosts));

    try {
      await _connect.toggleBookmark(event.postId);
      // Server confirms; state is already correct from optimistic update.
    } on Failure catch (_) {
      // Revert to the pre-toggle list on failure.
      emit(current.copyWith(posts: preSavePosts));
    } catch (_) {
      emit(current.copyWith(posts: preSavePosts));
    }
  }

  Future<void> _onChangeTopicFilter(
    ChangeTopicFilter event,
    Emitter<ConnectFeedState> emit,
  ) async {
    // Emit interim loading with updated chip index.
    if (state is FeedLoaded) {
      emit((state as FeedLoaded)
          .copyWith(activeTopic: event.index, activeTopicLabel: event.topic));
    }

    // Reload from offset 0 with the new topic filter.
    _offset = 0;
    try {
      final results = await _connect.getFeed(
        limit: _pageSize,
        offset: 0,
        topic: event.topic,
      );
      final hasReachedEnd = results.length < _pageSize;
      _offset = results.length;
      emit(ConnectFeedState.loaded(
        posts: results,
        hasReachedEnd: hasReachedEnd,
        activeTopic: event.index,
        activeTopicLabel: event.topic,
      ));
    } on Failure catch (f) {
      emit(ConnectFeedState.error(message: f.message));
    } catch (_) {
      emit(const ConnectFeedState.error(
          message: 'An unexpected error occurred.'));
    }
  }

  // ---------------------------------------------------------------------------
  // LIFECYCLE
  // ---------------------------------------------------------------------------

  @override
  Future<void> close() async {
    await _feedSubscription?.cancel();
    await _connect.dispose();
    return super.close();
  }
}
