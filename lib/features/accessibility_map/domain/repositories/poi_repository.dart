// Domain contract for the accessibility POI repository.
//
// The data-layer implementation ([PoiRepositoryImpl]) fulfils this contract.
// Blocs depend on this abstraction, never on the concrete implementation.
import 'package:opto/features/accessibility_map/domain/entities/accessibility_poi_entity.dart';

/// Contract for reading and creating accessibility points of interest.
///
/// All methods return or throw typed [Failure]s from `core/error/failures.dart`.
abstract class PoiRepository {
  const PoiRepository();

  // ── read ──────────────────────────────────────────────────────────────────

  /// Returns POIs within a bounding box around the given [lat]/[lng].
  ///
  /// [radiusDegrees] controls the bounding-box half-width (default 0.05° ≈ 5 km).
  ///
  /// Results are returned unsorted; the repository implementation sorts them
  /// by haversine distance (ascending) before returning, if [sortByDistance]
  /// is true.
  ///
  /// NOTE: The schema uses plain `double precision` columns — there is no
  /// PostGIS `ST_DWithin`. This is a bounding-box range filter + client-side
  /// haversine sort.
  Future<List<AccessibilityPoiEntity>> getNearbyPois({
    required double lat,
    required double lng,
    double radiusDegrees = 0.05,
    bool sortByDistance = true,
  });

  /// Returns all POIs without a distance filter (for use when location is
  /// unavailable; sorted alphabetically by name).
  Future<List<AccessibilityPoiEntity>> getAllPois();

  /// Returns a single POI by [id].
  ///
  /// Throws [ServerFailure('POI not found')] on PGRST116.
  Future<AccessibilityPoiEntity> getPoiById(String id);

  // ── write ─────────────────────────────────────────────────────────────────

  /// Inserts a new POI row.
  ///
  /// [created_by] is stamped from `auth.currentUser.id` in the data source —
  /// never passed from the UI.
  ///
  /// [attributes] should use [PoiAttribute.jsonKey] keys.
  Future<AccessibilityPoiEntity> addPoi({
    required String name,
    required double lat,
    required double lng,
    required Map<String, bool> attributes,
  });
}
