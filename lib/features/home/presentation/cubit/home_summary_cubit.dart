// Cubit for the Home dashboard's "Up next" and "Recent activity" sections.
//
// Reads from [HomeSummaryRepository]. State is defined in
// `home_summary_state.dart` using `freezed` — mirrors
// `consultation_history_cubit.dart`.
//
// SECURITY REQUIREMENTS:
//   • Results are never written to persistent local storage (Hive / shared
//     preferences) — the state lives only in memory for the current session,
//     since `recentActivity` may include 🔒 consultation rows.
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/home/domain/repositories/home_summary_repository.dart';
import 'package:opto/features/home/presentation/cubit/home_summary_state.dart';

export 'home_summary_state.dart';

class HomeSummaryCubit extends Cubit<HomeSummaryState> {
  HomeSummaryCubit(this._summaryRepo) : super(const HomeSummaryState.initial());

  final HomeSummaryRepository _summaryRepo;

  /// Loads (or reloads) both dashboard sections in parallel.
  Future<void> load() async {
    emit(const HomeSummaryState.loading());
    try {
      final results = await Future.wait([
        _summaryRepo.getUpNext(),
        _summaryRepo.getRecentActivity(),
      ]);
      emit(HomeSummaryState.loaded(upNext: results[0], recentActivity: results[1]));
    } on Failure catch (f) {
      emit(HomeSummaryState.error(f.message));
    } catch (e) {
      emit(const HomeSummaryState.error('Could not load your dashboard.'));
    }
  }
}
