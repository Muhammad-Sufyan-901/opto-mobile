// Cubit for caregiver links management.
//
// Owns the list of [CaregiverLinkEntity] for the current user and exposes
// load and updateStatus operations. All repository calls throw typed
// [Failure] subclasses on error; the cubit maps them to [CaregiverLinksError].
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/constants/identity_enums.dart';
import 'package:opto/core/error/failures.dart';
import 'package:opto/features/profile/domain/entities/caregiver_link_entity.dart';
import 'package:opto/features/profile/domain/repositories/caregiver_link_repository.dart';

// ── States ────────────────────────────────────────────────────────────────────

sealed class CaregiverLinksState {}

class CaregiverLinksInitial extends CaregiverLinksState {}

class CaregiverLinksLoading extends CaregiverLinksState {}

/// Loaded state — carries both the full link list and the ID of the currently
/// signed-in user so the screen can partition into "supporting me" vs
/// "I'm the caregiver" without an extra async call.
class CaregiverLinksLoaded extends CaregiverLinksState {
  CaregiverLinksLoaded({required this.links, required this.currentUserId});
  final List<CaregiverLinkEntity> links;
  final String currentUserId;
}

class CaregiverLinksError extends CaregiverLinksState {
  CaregiverLinksError(this.message);
  final String message;
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

/// Manages [CaregiverLinksState] for the caregiver links screen.
///
/// Call [load] once (with the current user's id) when the screen mounts.
/// [updateStatus] handles approve/reject/revoke actions; it separates the
/// write error from the reload error so a failed write restores previous state
/// while a failed reload after a successful write just surfaces an error.
class CaregiverLinksCubit extends Cubit<CaregiverLinksState> {
  final CaregiverLinkRepository _repo;

  /// Cached userId from the first [load] call, reused by [_reload].
  String? _userId;

  CaregiverLinksCubit(this._repo) : super(CaregiverLinksInitial());

  // ── LOAD ───────────────────────────────────────────────────────────────────

  /// Fetches all caregiver links where [userId] appears as either party.
  ///
  /// Emits [CaregiverLinksLoading] then [CaregiverLinksLoaded] on success,
  /// or [CaregiverLinksError] on failure.
  Future<void> load(String userId) async {
    _userId = userId;
    emit(CaregiverLinksLoading());
    try {
      final links = await _repo.getLinksForUser(userId);
      emit(CaregiverLinksLoaded(links: links, currentUserId: userId));
    } on Failure catch (f) {
      emit(CaregiverLinksError(f.message));
    } catch (e) {
      debugPrint('CaregiverLinksCubit.load: unexpected error — $e');
      emit(CaregiverLinksError('Failed to load caregiver links.'));
    }
  }

  // ── UPDATE STATUS ──────────────────────────────────────────────────────────

  /// Updates the [status] of the link identified by [linkId].
  ///
  /// Write errors emit [CaregiverLinksError] then restore [previous] state.
  /// If the write succeeds but [_reload] fails, error is emitted WITHOUT
  /// restoring — the change was committed on the server.
  Future<void> updateStatus(String linkId, LinkStatus status) async {
    final previous = state;
    try {
      await _repo.updateLinkStatus(linkId, status);
    } on Failure catch (f) {
      emit(CaregiverLinksError(f.message));
      emit(previous);
      return;
    } catch (e) {
      debugPrint('CaregiverLinksCubit.updateStatus: unexpected error — $e');
      emit(CaregiverLinksError('Failed to update link status.'));
      emit(previous);
      return;
    }
    await _reload();
  }

  // ── INTERNAL ───────────────────────────────────────────────────────────────

  Future<void> _reload() async {
    final uid = _userId;
    if (uid == null) return;
    try {
      final links = await _repo.getLinksForUser(uid);
      emit(CaregiverLinksLoaded(links: links, currentUserId: uid));
    } on Failure catch (f) {
      emit(CaregiverLinksError(f.message));
    } catch (e) {
      debugPrint('CaregiverLinksCubit._reload: $e');
      emit(CaregiverLinksError('Failed to refresh caregiver links.'));
    }
  }
}
