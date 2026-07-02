// Cubit for the My Activity screen (P6).
//
// Loads the current user's posts (via [MemberRepository.getContributions]),
// saved posts (via [MemberRepository.getSavedPosts]), and community stats
// (via [MemberRepository.getMemberProfile]) in a parallel fetch, then
// exposes them as [MyActivityLoaded].
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/connect/domain/entities/post_entity.dart';
import 'package:opto/features/connect/domain/repositories/member_repository.dart';

// ── States ────────────────────────────────────────────────────────────────────

sealed class MyActivityState {}

class MyActivityInitial extends MyActivityState {}

class MyActivityLoading extends MyActivityState {}

/// Emitted when both the post list and stats are available.
class MyActivityLoaded extends MyActivityState {
  MyActivityLoaded({
    required this.posts,
    required this.postsCount,
    required this.helpfulCount,
    required this.circlesCount,
    required this.savedPosts,
  });

  /// Posts authored by the current user, ordered newest-first.
  final List<PostEntity> posts;

  /// Total post count from [community_member_stats] RPC.
  final int postsCount;

  /// Total helpful (like) count from [community_member_stats] RPC.
  final int helpfulCount;

  /// Number of circles the user is in from [community_member_stats] RPC.
  final int circlesCount;

  /// Posts bookmarked/saved by the current user, newest-bookmarked-first.
  final List<PostEntity> savedPosts;
}

class MyActivityError extends MyActivityState {
  MyActivityError(this.message);
  final String message;
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

/// Manages [MyActivityState] for the My Activity screen.
///
/// Call [load] once (with the current user's id) when the screen mounts.
/// Both [MemberRepository.getMemberProfile] and
/// [MemberRepository.getContributions] are fired in parallel; the cubit emits
/// [MyActivityLoaded] only when both have resolved successfully.
class MyActivityCubit extends Cubit<MyActivityState> {
  final MemberRepository _memberRepo;

  MyActivityCubit(this._memberRepo) : super(MyActivityInitial());

  /// Fetches stats, posts, and saved posts for [userId] in parallel.
  ///
  /// Emits [MyActivityLoading] → [MyActivityLoaded] on success,
  /// or [MyActivityError] on failure.
  Future<void> load(String userId) async {
    emit(MyActivityLoading());
    try {
      // Fire all requests concurrently — each is independent.
      final profileFuture = _memberRepo.getMemberProfile(userId);
      final postsFuture = _memberRepo.getContributions(userId);
      final savedFuture = _memberRepo.getSavedPosts(userId);

      final member = await profileFuture;
      if (isClosed) return;
      final posts = await postsFuture;
      if (isClosed) return;
      final saved = await savedFuture;
      if (isClosed) return;

      emit(MyActivityLoaded(
        posts: posts,
        postsCount: member.postsCount,
        helpfulCount: member.helpfulCount,
        circlesCount: member.circlesCount,
        savedPosts: saved,
      ));
    } on Failure catch (f) {
      if (!isClosed) emit(MyActivityError(f.message));
    } catch (e) {
      if (!isClosed) emit(MyActivityError('An unexpected error occurred.'));
    }
  }
}
