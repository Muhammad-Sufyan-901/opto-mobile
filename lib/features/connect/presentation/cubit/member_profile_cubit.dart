// Cubit for the member-profile screen — loads a member's public profile and
// their recent contributions, and handles optimistic follow/unfollow toggling.
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/connect/domain/entities/member_profile_entity.dart';
import 'package:opto/features/connect/domain/entities/post_entity.dart';
import 'package:opto/features/connect/domain/repositories/member_repository.dart';

part 'member_profile_cubit.freezed.dart';

// =============================================================================
// STATE
// =============================================================================

@freezed
sealed class MemberProfileState with _$MemberProfileState {
  /// Screen not yet loaded.
  const factory MemberProfileState.initial() = MemberProfileInitial;

  /// Data is being fetched.
  const factory MemberProfileState.loading() = MemberProfileLoading;

  /// Profile and contributions have been loaded.
  const factory MemberProfileState.loaded({
    required MemberProfileEntity profile,
    required List<PostEntity> contributions,
  }) = MemberProfileLoaded;

  /// Load failed with [message].
  const factory MemberProfileState.error({required String message}) =
      MemberProfileError;
}

// =============================================================================
// CUBIT
// =============================================================================

/// Cubit that drives the member-profile screen.
///
/// Responsibilities:
/// - Fetch the member's public profile and recent contributions in parallel.
/// - Optimistically toggle follow state and revert on failure.
class MemberProfileCubit extends Cubit<MemberProfileState> {
  MemberProfileCubit({required MemberRepository memberRepository})
      : _member = memberRepository,
        super(const MemberProfileState.initial());

  final MemberRepository _member;

  // ---------------------------------------------------------------------------
  // PUBLIC API
  // ---------------------------------------------------------------------------

  /// Loads (or reloads) the public profile and contributions for [memberId].
  Future<void> load(String memberId) async {
    emit(const MemberProfileState.loading());
    try {
      final results = await Future.wait([
        _member.getMemberProfile(memberId),
        _member.getContributions(memberId),
      ]);
      final profile = results[0] as MemberProfileEntity;
      final contributions = results[1] as List<PostEntity>;
      emit(MemberProfileState.loaded(
        profile: profile,
        contributions: contributions,
      ));
    } on Failure catch (f) {
      emit(MemberProfileState.error(message: f.message));
    } catch (e) {
      emit(MemberProfileState.error(message: e.toString()));
    }
  }

  /// Optimistically toggles follow state for the current member and reverts
  /// on failure.
  Future<void> toggleFollow() async {
    final current = state;
    if (current is! MemberProfileLoaded) return;
    final profile = current.profile;

    // Optimistic update — flip the follow flag immediately.
    emit(MemberProfileState.loaded(
      profile: profile.copyWith(isFollowedByMe: !profile.isFollowedByMe),
      contributions: current.contributions,
    ));

    try {
      final serverIsFollowing = await _member.toggleFollow(profile.id);
      // Reconcile with server's authoritative result.
      emit(MemberProfileState.loaded(
        profile: profile.copyWith(isFollowedByMe: serverIsFollowing),
        contributions: current.contributions,
      ));
    } catch (e) {
      // Briefly surface the error then revert to pre-optimistic state.
      emit(MemberProfileState.error(message: 'Could not update follow status. Please try again.'));
      emit(MemberProfileState.loaded(
        profile: profile,
        contributions: current.contributions,
      ));
    }
  }
}
