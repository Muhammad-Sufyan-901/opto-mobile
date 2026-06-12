// States for [NearbyPoisBloc].
//
// Uses `freezed` for immutable, sealed state classes.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/features/accessibility_map/domain/entities/accessibility_poi_entity.dart';

part 'nearby_pois_state.freezed.dart';

@freezed
sealed class NearbyPoisState with _$NearbyPoisState {
  /// Initial state — list not yet loaded.
  const factory NearbyPoisState.initial() = NearbyPoisInitial;

  /// Fetch in progress.
  const factory NearbyPoisState.loading() = NearbyPoisLoading;

  /// POI list loaded.
  ///
  /// [locationAvailable] tells the UI whether results are distance-sorted
  /// (true) or alphabetically sorted (false — no position).
  const factory NearbyPoisState.loaded({
    required List<AccessibilityPoiEntity> pois,
    @Default(false) bool locationAvailable,
  }) = NearbyPoisLoaded;

  /// Fetch failed with [message].
  const factory NearbyPoisState.error(String message) = NearbyPoisError;
}
