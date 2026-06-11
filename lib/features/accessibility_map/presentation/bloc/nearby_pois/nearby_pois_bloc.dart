// BLoC for the nearby POIs listing screen.
//
// Drives [NearbyPoisScreen]; delegates to [PoiRepository].
// The location result is passed in via the [LoadNearbyPois] event — location
// permission and position acquisition happen at the screen layer using
// [LocationService] before the event is dispatched.
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/accessibility_map/domain/repositories/poi_repository.dart';
import 'package:opto/features/accessibility_map/presentation/bloc/nearby_pois/nearby_pois_event.dart';
import 'package:opto/features/accessibility_map/presentation/bloc/nearby_pois/nearby_pois_state.dart';

export 'nearby_pois_event.dart';
export 'nearby_pois_state.dart';

/// BLoC that drives the nearby POIs list screen.
///
/// Inject via the abstract [PoiRepository] contract.
class NearbyPoisBloc extends Bloc<NearbyPoisEvent, NearbyPoisState> {
  NearbyPoisBloc(this._repo) : super(const NearbyPoisState.initial()) {
    on<LoadNearbyPois>(_onLoad);
    on<RefreshNearbyPois>(_onRefresh);
  }

  final PoiRepository _repo;

  // Last successful load params — used by refresh.
  double? _lastLat;
  double? _lastLng;
  double _lastRadius = 0.05;

  // ── handlers ──────────────────────────────────────────────────────────────

  Future<void> _onLoad(
    LoadNearbyPois event,
    Emitter<NearbyPoisState> emit,
  ) async {
    emit(const NearbyPoisState.loading());
    _lastLat = event.lat;
    _lastLng = event.lng;
    _lastRadius = event.radiusDegrees;
    await _fetchAndEmit(emit, event.lat, event.lng, event.radiusDegrees);
  }

  Future<void> _onRefresh(
    RefreshNearbyPois event,
    Emitter<NearbyPoisState> emit,
  ) async {
    emit(const NearbyPoisState.loading());
    await _fetchAndEmit(emit, _lastLat, _lastLng, _lastRadius);
  }

  Future<void> _fetchAndEmit(
    Emitter<NearbyPoisState> emit,
    double? lat,
    double? lng,
    double radius,
  ) async {
    try {
      if (lat != null && lng != null) {
        final pois = await _repo.getNearbyPois(
          lat: lat,
          lng: lng,
          radiusDegrees: radius,
        );
        emit(NearbyPoisState.loaded(pois: pois, locationAvailable: true));
      } else {
        // No location — fall back to alphabetical full list.
        final pois = await _repo.getAllPois();
        emit(NearbyPoisState.loaded(pois: pois));
      }
    } on Failure catch (f) {
      emit(NearbyPoisState.error(_toMessage(f)));
    } catch (e) {
      emit(const NearbyPoisState.error('An unexpected error occurred.'));
    }
  }

  // ── helpers ───────────────────────────────────────────────────────────────

  String _toMessage(Failure f) {
    return switch (f) {
      NetworkFailure() =>
        'No internet connection. Please check your network and try again.',
      AuthFailure() => 'Please sign in to view accessible places.',
      LocationFailure() =>
        'Location unavailable. Showing all accessible places instead.',
      _ => f.message,
    };
  }
}
