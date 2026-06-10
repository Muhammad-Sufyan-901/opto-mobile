// Cubit for anthropometric measurements (view / edit).
//
// 🔒 Operates on owner-only data — never expose this cubit outside the
//    prosthetic_hub feature.
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/constants/prosthetic_enums.dart';
import 'package:opto/core/error/failures.dart';
import 'package:opto/features/prosthetic_hub/domain/repositories/anthropometric_repository.dart';
import 'package:opto/features/prosthetic_hub/presentation/bloc/anthropometric/anthropometric_state.dart';

export 'anthropometric_state.dart';

/// Cubit that drives the anthropometric measurements screen.
class AnthropometricCubit extends Cubit<AnthropometricState> {
  AnthropometricCubit(this._repo) : super(const AnthropometricState.initial());

  final AnthropometricRepository _repo;

  // ---------------------------------------------------------------------------
  // OPERATIONS
  // ---------------------------------------------------------------------------

  /// Loads the current user's measurements.
  Future<void> loadMeasurements() async {
    emit(const AnthropometricState.loading());
    try {
      final entity = await _repo.getMyAnthropometric();
      emit(AnthropometricState.loaded(entity));
    } on Failure catch (f) {
      emit(AnthropometricState.error(_toMessage(f)));
    } catch (_) {
      emit(const AnthropometricState.error('Failed to load measurements.'));
    }
  }

  /// Saves (creates or updates) the current user's measurements.
  Future<void> saveMeasurements({
    double? socketSizeMm,
    double? curvature,
    double? irisDiameterMm,
    String? matchedIrisHex,
    required DataSource source,
  }) async {
    emit(const AnthropometricState.loading());
    try {
      await _repo.upsertAnthropometric(
        socketSizeMm: socketSizeMm,
        curvature: curvature,
        irisDiameterMm: irisDiameterMm,
        matchedIrisHex: matchedIrisHex,
        source: source,
      );
      emit(const AnthropometricState.saved());
    } on Failure catch (f) {
      emit(AnthropometricState.error(_toMessage(f)));
    } catch (_) {
      emit(const AnthropometricState.error('Failed to save measurements.'));
    }
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------

  String _toMessage(Failure f) {
    if (f is AuthFailure) return 'Please sign in to access your measurements.';
    if (f is NetworkFailure) {
      return 'No internet connection. Please try again.';
    }
    if (f is ServerFailure) return f.message;
    return f.message;
  }
}
