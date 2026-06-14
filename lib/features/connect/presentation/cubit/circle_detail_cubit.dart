// Cubit for the circle-detail screen — loads a single circle and its recent
// threads, and handles optimistic join/leave toggling.
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/connect/domain/entities/circle_entity.dart';
import 'package:opto/features/connect/domain/entities/post_entity.dart';
import 'package:opto/features/connect/domain/repositories/circles_repository.dart';
import 'package:opto/features/connect/domain/repositories/connect_repository.dart';

part 'circle_detail_cubit.freezed.dart';

// =============================================================================
// STATE
// =============================================================================

@freezed
sealed class CircleDetailState with _$CircleDetailState {
  /// Screen not yet loaded.
  const factory CircleDetailState.initial() = CircleDetailInitial;

  /// Data is being fetched.
  const factory CircleDetailState.loading() = CircleDetailLoading;

  /// Circle metadata and recent threads are available.
  const factory CircleDetailState.loaded({
    required CircleEntity circle,
    required List<PostEntity> recentThreads,
  }) = CircleDetailLoaded;

  /// Load failed with [message].
  const factory CircleDetailState.error({required String message}) =
      CircleDetailError;
}

// =============================================================================
// CUBIT
// =============================================================================

/// Cubit that drives the circle-detail screen.
///
/// Responsibilities:
/// - Fetch circle metadata and its recent threads in parallel.
/// - Optimistically toggle membership (join / leave) and revert on error.
class CircleDetailCubit extends Cubit<CircleDetailState> {
  CircleDetailCubit({
    required CirclesRepository circlesRepository,
    required ConnectRepository connectRepository,
  })  : _circles = circlesRepository,
        _connect = connectRepository,
        super(const CircleDetailState.initial());

  final CirclesRepository _circles;
  final ConnectRepository _connect;

  // ---------------------------------------------------------------------------
  // PUBLIC API
  // ---------------------------------------------------------------------------

  /// Loads (or reloads) the circle identified by [slug] together with its
  /// most-recent threads (up to 10).
  Future<void> load(String slug) async {
    emit(const CircleDetailState.loading());
    try {
      final results = await Future.wait([
        _circles.getCircle(slug),
        _connect.getFeed(limit: 10, offset: 0, topic: slug),
      ]);
      final circle = results[0] as CircleEntity;
      final threads = results[1] as List<PostEntity>;
      emit(CircleDetailState.loaded(circle: circle, recentThreads: threads));
    } on Failure catch (f) {
      emit(CircleDetailState.error(message: f.message));
    } catch (e) {
      emit(CircleDetailState.error(message: e.toString()));
    }
  }

  /// Optimistically toggles membership (join or leave) and reverts on failure.
  Future<void> toggleJoin() async {
    final current = state;
    if (current is! CircleDetailLoaded) return;
    final circle = current.circle;
    final wasJoined = circle.isMember;

    // Optimistic update — flip membership and adjust the member count.
    emit(CircleDetailState.loaded(
      circle: circle.copyWith(
        isMember: !wasJoined,
        memberCount: wasJoined
            ? circle.memberCount - 1
            : circle.memberCount + 1,
      ),
      recentThreads: current.recentThreads,
    ));

    try {
      if (wasJoined) {
        await _circles.leaveCircle(circle.id);
      } else {
        await _circles.joinCircle(circle.id);
      }
    } catch (_) {
      // Revert to the state before the optimistic update.
      emit(CircleDetailState.loaded(
        circle: circle,
        recentThreads: current.recentThreads,
      ));
    }
  }
}
