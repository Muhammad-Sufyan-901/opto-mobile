// States for [HomeSummaryCubit].
//
// Uses `freezed` for immutable, sealed state classes — mirrors the pattern
// in `consultation_history_state.dart`.
//
// SECURITY NOTE: [HomeSummaryLoaded.recentActivity] may contain medically
// sensitive [HomeItemKind.consultation] rows. This state must not be
// persisted to disk or exposed in community/map/catalog surfaces.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/features/home/domain/entities/home_summary_item.dart';

part 'home_summary_state.freezed.dart';

@freezed
sealed class HomeSummaryState with _$HomeSummaryState {
  /// Summary not yet loaded.
  const factory HomeSummaryState.initial() = HomeSummaryInitial;

  /// Fetch in progress.
  const factory HomeSummaryState.loading() = HomeSummaryLoading;

  /// Both sections loaded successfully.
  ///
  /// [upNext] is ordered soonest-first (undated items last).
  /// [recentActivity] is ordered most-recent-first. Do NOT write either list
  /// to persistent storage.
  const factory HomeSummaryState.loaded({
    required List<HomeSummaryItem> upNext,
    required List<HomeSummaryItem> recentActivity,
  }) = HomeSummaryLoaded;

  /// Load failed with [message].
  const factory HomeSummaryState.error(String message) = HomeSummaryError;
}
