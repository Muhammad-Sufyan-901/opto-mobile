// Repository implementation for the POI domain area.
//
// Delegates all I/O to [MapRemoteDataSource]; maps data-layer models to
// domain entities via the `_ext.dart` extensions.
//
// "Nearby" queries use a bounding-box range filter (Risk R3 from the plan):
//   latitude  ∈ [lat − radiusDegrees, lat + radiusDegrees]
//   longitude ∈ [lng − radiusDegrees, lng + radiusDegrees]
// Results are then haversine-sorted client-side using `latlong2`.
import 'package:latlong2/latlong.dart';

import 'package:opto/features/accessibility_map/data/datasources/map_remote_data_source.dart';
import 'package:opto/features/accessibility_map/data/models/accessibility_poi_model_ext.dart';
import 'package:opto/features/accessibility_map/domain/entities/accessibility_poi_entity.dart';
import 'package:opto/features/accessibility_map/domain/repositories/poi_repository.dart';

/// Production [PoiRepository] backed by [MapRemoteDataSource].
class PoiRepositoryImpl implements PoiRepository {
  const PoiRepositoryImpl({required MapRemoteDataSource remoteDataSource})
      : _remote = remoteDataSource;

  final MapRemoteDataSource _remote;

  static const Distance _haversine = Distance();

  @override
  Future<List<AccessibilityPoiEntity>> getNearbyPois({
    required double lat,
    required double lng,
    double radiusDegrees = 0.05,
    bool sortByDistance = true,
  }) async {
    final models = await _remote.getPoisInBounds(
      minLat: lat - radiusDegrees,
      maxLat: lat + radiusDegrees,
      minLng: lng - radiusDegrees,
      maxLng: lng + radiusDegrees,
    );

    final origin = LatLng(lat, lng);
    var entities = models.map((m) {
      final distanceM = _haversine(origin, LatLng(m.lat, m.lng));
      return m.toEntity(distanceMeters: distanceM);
    }).toList();

    if (sortByDistance) {
      entities.sort(
        (a, b) => (a.distanceMeters ?? double.infinity)
            .compareTo(b.distanceMeters ?? double.infinity),
      );
    }

    return entities;
  }

  @override
  Future<List<AccessibilityPoiEntity>> getAllPois() async {
    final models = await _remote.getAllPois();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<AccessibilityPoiEntity> getPoiById(String id) async {
    final model = await _remote.getPoiById(id);
    return model.toEntity();
  }

  @override
  Future<AccessibilityPoiEntity> addPoi({
    required String name,
    required double lat,
    required double lng,
    required Map<String, bool> attributes,
  }) async {
    // Convert bool map to dynamic map for the JSON payload.
    final model = await _remote.insertPoi(
      name: name,
      lat: lat,
      lng: lng,
      attributes: attributes.map((k, v) => MapEntry(k, v)),
    );
    return model.toEntity();
  }
}
