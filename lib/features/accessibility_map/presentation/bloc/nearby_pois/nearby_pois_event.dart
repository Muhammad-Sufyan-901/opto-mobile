// Events for [NearbyPoisBloc].
//
// Uses `freezed` for immutable, sealed event classes.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'nearby_pois_event.freezed.dart';

@freezed
sealed class NearbyPoisEvent with _$NearbyPoisEvent {
  /// Load (or refresh) POIs near the given position.
  ///
  /// When [lat] and [lng] are null the bloc falls back to [getAllPois]
  /// (no location available — sorted alphabetically).
  const factory NearbyPoisEvent.load({
    double? lat,
    double? lng,
    @Default(0.05) double radiusDegrees,
  }) = LoadNearbyPois;

  /// Refresh the current result set (reuses last known position / fallback).
  const factory NearbyPoisEvent.refresh() = RefreshNearbyPois;
}
