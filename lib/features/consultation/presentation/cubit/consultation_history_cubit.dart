// 🔒 MEDICALLY SENSITIVE — Cubit for consultation history.
//
// Reads the patient's own past consultations from
// [ConsultationHistoryRepository]. Access is enforced exclusively by Supabase
// RLS; this cubit must not attempt any client-side access filtering.
//
// State is defined in `consultation_history_state.dart` using `freezed` to
// match the project convention (see `post_thread_cubit.dart`).
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/consultation/domain/repositories/consultation_history_repository.dart';
import 'package:opto/features/consultation/presentation/cubit/consultation_history_state.dart';

export 'consultation_history_state.dart';

/// 🔒 Cubit that drives the consultation-history screen.
///
/// Responsibilities:
/// - Fetch all past consultations for the signed-in patient via
///   [ConsultationHistoryRepository.getMyConsultations].
/// - Surface load errors without leaking sensitive data in error messages.
///
/// SECURITY REQUIREMENTS:
///   • Results are never written to persistent local storage (Hive / shared
///     preferences). The state lives only in memory for the current session.
///   • This cubit's state must not be shared with community, map, or catalog
///     surfaces.
class ConsultationHistoryCubit extends Cubit<ConsultationHistoryState> {
  ConsultationHistoryCubit(this._historyRepo)
      : super(const ConsultationHistoryState.initial());

  final ConsultationHistoryRepository _historyRepo;

  // ---------------------------------------------------------------------------
  // PUBLIC API
  // ---------------------------------------------------------------------------

  /// Loads (or reloads) the patient's consultation history.
  ///
  /// Emits [ConsultationHistoryLoading] while the request is in flight, then
  /// either [ConsultationHistoryLoaded] or [ConsultationHistoryError].
  Future<void> loadHistory() async {
    emit(const ConsultationHistoryState.loading());
    try {
      final consultations = await _historyRepo.getMyConsultations();
      emit(ConsultationHistoryState.loaded(consultations: consultations));
    } on Failure catch (e) {
      emit(ConsultationHistoryState.error(e.message));
    } catch (e) {
      emit(ConsultationHistoryState.error(e.toString()));
    }
  }
}
