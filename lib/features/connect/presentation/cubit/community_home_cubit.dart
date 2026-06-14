// Cubit for the community home screen — loads circles and trending posts
// in parallel, derives a featured post, and exposes a Freezed state.
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/connect/domain/entities/circle_entity.dart';
import 'package:opto/features/connect/domain/entities/post_entity.dart';
import 'package:opto/features/connect/domain/repositories/circles_repository.dart';
import 'package:opto/features/connect/domain/repositories/connect_repository.dart';

part 'community_home_cubit.freezed.dart';

// =============================================================================
// STATE
// =============================================================================

@freezed
sealed class CommunityHomeState with _$CommunityHomeState {
  /// Screen not yet loaded.
  const factory CommunityHomeState.initial() = CommunityHomeInitial;

  /// Data is being fetched.
  const factory CommunityHomeState.loading() = CommunityHomeLoading;

  /// Circles and trending posts have been loaded.
  ///
  /// [featuredPost] is the most-liked post in the batch; null when the feed is
  /// empty. [trendingPosts] contains up to 2 posts that are NOT the featured one.
  const factory CommunityHomeState.loaded({
    required PostEntity? featuredPost,
    required List<CircleEntity> circles,
    required List<PostEntity> trendingPosts,
  }) = CommunityHomeLoaded;

  /// Load failed with [message].
  const factory CommunityHomeState.error({required String message}) =
      CommunityHomeError;
}

// =============================================================================
// CUBIT
// =============================================================================

/// Cubit that drives the community home screen.
///
/// Responsibilities:
/// - Fetch all circles and the first page of the global feed in parallel.
/// - Derive a featured post (most-liked) and up to 2 trending posts.
class CommunityHomeCubit extends Cubit<CommunityHomeState> {
  CommunityHomeCubit({
    required CirclesRepository circlesRepository,
    required ConnectRepository connectRepository,
  })  : _circles = circlesRepository,
        _connect = connectRepository,
        super(const CommunityHomeState.initial());

  final CirclesRepository _circles;
  final ConnectRepository _connect;

  // ---------------------------------------------------------------------------
  // PUBLIC API
  // ---------------------------------------------------------------------------

  /// Loads (or reloads) circles and trending posts.
  Future<void> load() async {
    emit(const CommunityHomeState.loading());
    try {
      // Fetch circles and the first 5 posts in parallel.
      final results = await Future.wait([
        _circles.getCircles(),
        _connect.getFeed(limit: 5, offset: 0),
      ]);

      final circles = results[0] as List<CircleEntity>;
      final posts = results[1] as List<PostEntity>;

      // Featured = most-liked post in the batch (fallback: null when empty).
      final PostEntity? featured = posts.isNotEmpty
          ? posts.reduce((a, b) => a.likeCount >= b.likeCount ? a : b)
          : null;

      // Trending = top 2 posts that are NOT the featured one.
      final trending = posts
          .where((p) => p.id != featured?.id)
          .take(2)
          .toList();

      emit(CommunityHomeState.loaded(
        featuredPost: featured,
        circles: circles,
        trendingPosts: trending,
      ));
    } on Failure catch (f) {
      emit(CommunityHomeState.error(message: f.message));
    } catch (e) {
      emit(CommunityHomeState.error(message: e.toString()));
    }
  }
}
