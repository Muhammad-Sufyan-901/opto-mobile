// 🔒 MEDICALLY SENSITIVE — States for [ConsultationHistoryCubit].
//
// Uses `freezed` for immutable, sealed state classes — mirrors
// the pattern in `post_thread_cubit.dart`.
//
// SECURITY NOTE: [ConsultationHistoryLoaded.consultations] contains medically
// sensitive records. The state must NOT be persisted to disk or exposed in
// community/map/catalog surfaces. See `consultation_history_repository.dart`.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/features/consultation/domain/entities/consultation_entity.dart';

part 'consultation_history_state.freezed.dart';

@freezed
sealed class ConsultationHistoryState with _$ConsultationHistoryState {
  /// History not yet loaded.
  const factory ConsultationHistoryState.initial() =
      ConsultationHistoryInitial;

  /// History fetch in progress.
  const factory ConsultationHistoryState.loading() =
      ConsultationHistoryLoading;

  /// 🔒 History loaded successfully.
  ///
  /// [consultations] are ordered by [ConsultationEntity.createdAt] descending
  /// (most recent first). Do NOT write this list to persistent storage.
  const factory ConsultationHistoryState.loaded({
    required List<ConsultationEntity> consultations,
  }) = ConsultationHistoryLoaded;

  /// History load failed with [message].
  const factory ConsultationHistoryState.error(String message) =
      ConsultationHistoryError;
}
