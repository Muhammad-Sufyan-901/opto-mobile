// Cubit for tutorials listing and detail operations.
//
// Read-only — tutorials are public data (no user-owned rows).
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/constants/prosthetic_enums.dart';
import 'package:opto/core/error/failures.dart';
import 'package:opto/features/prosthetic_hub/domain/repositories/tutorials_repository.dart';
import 'package:opto/features/prosthetic_hub/presentation/bloc/tutorials/tutorials_state.dart';

export 'tutorials_state.dart';

/// Cubit that drives the care tutorials list and player screens.
///
/// Inject by the abstract [TutorialsRepository] contract — never by the impl.
class TutorialsCubit extends Cubit<TutorialsState> {
  final TutorialsRepository _repo;

  TutorialsCubit(this._repo) : super(const TutorialsState.initial());

  // ---------------------------------------------------------------------------
  // OPERATIONS
  // ---------------------------------------------------------------------------

  /// Loads all tutorials with an optional [categoryFilter].
  ///
  /// Emits [TutorialsLoading] → [TutorialsLoaded] or [TutorialsError].
  Future<void> loadTutorials({TutorialCategory? categoryFilter}) async {
    emit(const TutorialsState.loading());
    try {
      final tutorials = await _repo.getTutorials(
        categoryFilter: categoryFilter,
      );
      emit(TutorialsState.loaded(tutorials));
    } on Failure catch (f) {
      emit(TutorialsState.error(_toMessage(f)));
    } catch (_) {
      emit(const TutorialsState.error('An unexpected error occurred.'));
    }
  }

  /// Loads a single tutorial by [id].
  ///
  /// Emits [TutorialsLoading] → [TutorialsLoaded] (single-item list) or
  /// [TutorialsError].
  Future<void> loadTutorialById(String id) async {
    emit(const TutorialsState.loading());
    try {
      final tutorial = await _repo.getTutorialById(id);
      emit(TutorialsState.loaded([tutorial]));
    } on Failure catch (f) {
      emit(TutorialsState.error(_toMessage(f)));
    } catch (_) {
      emit(const TutorialsState.error('An unexpected error occurred.'));
    }
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------

  String _toMessage(Failure f) {
    if (f is ServerFailure) {
      if (f.message.contains('not found')) {
        return 'Tutorial not found.';
      }
      if (f.message.contains('permission')) {
        return 'You do not have permission to view this tutorial.';
      }
      return f.message;
    }
    if (f is NetworkFailure) {
      return 'No internet connection. Please check your network and try again.';
    }
    if (f is AuthFailure) {
      return 'Please sign in to view tutorials.';
    }
    return f.message;
  }
}
