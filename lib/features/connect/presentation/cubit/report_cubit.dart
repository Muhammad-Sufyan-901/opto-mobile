// Cubit for submitting a content report on a community post.
//
// State is defined inline using `freezed` to match the project convention.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/constants/connect_enums.dart';
import 'package:opto/core/error/failures.dart';
import 'package:opto/features/connect/domain/repositories/report_repository.dart';

part 'report_cubit.freezed.dart';

// =============================================================================
// STATE
// =============================================================================

@freezed
sealed class ReportState with _$ReportState {
  /// Report form ready to submit.
  const factory ReportState.idle() = ReportIdle;

  /// Report submission in progress.
  const factory ReportState.submitting() = ReportSubmitting;

  /// Report submitted successfully.
  const factory ReportState.success() = ReportSuccess;

  /// Submission failed with [message].
  const factory ReportState.error({required String message}) = ReportError;
}

// =============================================================================
// CUBIT
// =============================================================================

/// Cubit that drives the report-content bottom sheet.
///
/// A single [submit] call validates the inputs, delegates to
/// [ReportRepository.reportPost], and emits the appropriate terminal state.
/// The UI should dismiss the sheet and thank the user on [ReportSuccess].
class ReportCubit extends Cubit<ReportState> {
  ReportCubit(this._report) : super(const ReportState.idle());

  final ReportRepository _report;

  // ---------------------------------------------------------------------------
  // PUBLIC API
  // ---------------------------------------------------------------------------

  /// Submits a content report for [postId] with the selected [reason].
  Future<void> submit({
    required String postId,
    required ReportReason reason,
  }) async {
    emit(const ReportState.submitting());
    try {
      await _report.reportPost(postId: postId, reason: reason);
      emit(const ReportState.success());
    } on Failure catch (f) {
      emit(ReportState.error(message: f.message));
    } catch (_) {
      emit(const ReportState.error(
          message: 'An unexpected error occurred.'));
    }
  }
}
