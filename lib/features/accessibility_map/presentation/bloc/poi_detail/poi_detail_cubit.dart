// Cubit for the POI detail screen.
//
// Loads a single POI and hosts the verify / suggest-edit contribution action.
//
// RISK R4 note: the verify action inserts a [poi_contributions] row; it does
// NOT directly update `accessibility_pois.verified_count` (no client update
// policy). The count is bumped server-side via trigger/RPC.
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/accessibility_map/domain/repositories/contributions_repository.dart';
import 'package:opto/features/accessibility_map/domain/repositories/poi_repository.dart';
import 'poi_detail_state.dart';

export 'poi_detail_state.dart';

/// Cubit that drives the POI detail screen.
///
/// Inject via abstract [PoiRepository] and [ContributionsRepository] contracts.
class PoiDetailCubit extends Cubit<PoiDetailState> {
  PoiDetailCubit({
    required PoiRepository poiRepository,
    required ContributionsRepository contributionsRepository,
  })  : _poiRepo = poiRepository,
        _contribRepo = contributionsRepository,
        super(const PoiDetailInitial());

  final PoiRepository _poiRepo;
  final ContributionsRepository _contribRepo;

  // ── load ──────────────────────────────────────────────────────────────────

  Future<void> loadPoi(String poiId) async {
    emit(const PoiDetailLoading());
    try {
      final poi = await _poiRepo.getPoiById(poiId);
      emit(PoiDetailLoaded(poi));
    } on Failure catch (f) {
      emit(PoiDetailError(f.message));
    } catch (e) {
      emit(PoiDetailError(e.toString()));
    }
  }

  // ── verify ────────────────────────────────────────────────────────────────

  /// Submit a verification for the currently loaded POI.
  ///
  /// Sets status to [PoiDetailContributing] during the call; on success emits
  /// [PoiDetailContributionSuccess] so the screen can announce to the user.
  Future<void> verifyPoi() async {
    final current = state;
    if (current is! PoiDetailLoaded) return;

    emit(PoiDetailContributing(current.poi));
    try {
      await _contribRepo.submitContribution(
        poiId: current.poi.id,
        change: const {},
      );
      emit(PoiDetailContributionSuccess(
        poi: current.poi,
        message: 'Thank you! Your verification has been submitted.',
      ));
    } on Failure catch (f) {
      emit(PoiDetailLoaded(current.poi));
      emit(PoiDetailError(f.message));
    } catch (e) {
      emit(PoiDetailLoaded(current.poi));
      emit(PoiDetailError(e.toString()));
    }
  }

  // ── suggest edit ──────────────────────────────────────────────────────────

  /// Submit a suggest-edit contribution with [change] payload.
  Future<void> suggestEdit({required Map<String, dynamic> change}) async {
    final current = state;
    if (current is! PoiDetailLoaded) return;
    if (change.isEmpty) return;

    emit(PoiDetailContributing(current.poi));
    try {
      await _contribRepo.submitContribution(
        poiId: current.poi.id,
        change: change,
      );
      emit(PoiDetailContributionSuccess(
        poi: current.poi,
        message: 'Suggestion submitted. Thank you for helping improve this place.',
      ));
    } on Failure catch (f) {
      emit(PoiDetailLoaded(current.poi));
      emit(PoiDetailError(f.message));
    } catch (e) {
      emit(PoiDetailLoaded(current.poi));
      emit(PoiDetailError(e.toString()));
    }
  }
}
