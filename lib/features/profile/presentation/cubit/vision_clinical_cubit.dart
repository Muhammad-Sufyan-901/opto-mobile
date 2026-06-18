// Cubit for the Vision Clinical Profile screen.
//
// Owns the [VisionClinicalEntity] for the current user and exposes a [load]
// operation that fetches from the owner-only RLS row.
//
// 🔒 MEDICAL SENSITIVITY: Clinical data is owner-only — never pass the entity
// to community, map, or catalog surfaces. See database_schema.md for RLS policy.
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/profile/domain/entities/vision_clinical_entity.dart';
import 'package:opto/features/profile/domain/repositories/profile_repository.dart';

// ── States ────────────────────────────────────────────────────────────────────

sealed class VisionClinicalState {}

class VisionClinicalInitial extends VisionClinicalState {}

class VisionClinicalLoading extends VisionClinicalState {}

class VisionClinicalLoaded extends VisionClinicalState {
  final VisionClinicalEntity clinical;
  VisionClinicalLoaded(this.clinical);
}

/// Emitted when the user has no clinical data row yet (null from DB).
class VisionClinicalEmpty extends VisionClinicalState {}

class VisionClinicalError extends VisionClinicalState {
  final String message;
  VisionClinicalError(this.message);
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

/// Manages [VisionClinicalState] for the vision profile screen.
///
/// Call [load] once (with the current user's id) when the screen mounts.
/// Emits [VisionClinicalEmpty] when the DB row does not exist yet, and
/// [VisionClinicalLoaded] when a row is found.
class VisionClinicalCubit extends Cubit<VisionClinicalState> {
  final ProfileRepository _repo;

  VisionClinicalCubit(this._repo) : super(VisionClinicalInitial());

  /// Fetches the clinical profile for [userId].
  ///
  /// Emits [VisionClinicalLoading] → [VisionClinicalLoaded] on success,
  /// [VisionClinicalEmpty] when no row exists, or [VisionClinicalError]
  /// on failure.
  Future<void> load(String userId) async {
    emit(VisionClinicalLoading());
    try {
      final clinical = await _repo.getVisionClinical(userId);
      if (isClosed) return;
      if (clinical == null) {
        emit(VisionClinicalEmpty());
      } else {
        emit(VisionClinicalLoaded(clinical));
      }
    } on Failure catch (f) {
      if (!isClosed) emit(VisionClinicalError(f.message));
    } catch (e) {
      if (!isClosed) emit(VisionClinicalError('An unexpected error occurred.'));
    }
  }
}
