// Pure-Dart domain entity for an accessibility point of interest.
//
// No serialisation dependencies — use [AccessibilityPoiModel.toEntity()] in
// the data layer to produce instances from Supabase rows.
//
// NOTE: This table is public-read (RLS). NEVER join `anthropometric_data`,
//       `eye_photos`, `consultations`, or `sos_events` into any POI query.

/// Immutable domain representation of a row in `accessibility_pois`.
///
/// [attributes] is a map of [String] keys (see [PoiAttribute.jsonKey]) to
/// boolean values indicating which accessibility features are present.
/// Unknown keys are preserved so the screen can degrade gracefully.
class AccessibilityPoiEntity {
  const AccessibilityPoiEntity({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.attributes,
    required this.verifiedCount,
    this.createdBy,
    this.distanceMeters,
  });

  /// Primary key (UUID).
  final String id;

  /// Human-readable name of the place.
  final String name;

  /// Latitude (WGS-84).
  final double lat;

  /// Longitude (WGS-84).
  final double lng;

  /// Accessibility attributes keyed by [PoiAttribute.jsonKey].
  ///
  /// Example: `{'ramp': true, 'elevator': false, 'tactile_path': true}`.
  /// Values are booleans; absent keys are treated as unknown (not false).
  final Map<String, dynamic> attributes;

  /// Number of community verifications.
  final int verifiedCount;

  /// User ID of the creator, nullable per schema.
  final String? createdBy;

  /// Haversine distance from the user's current position, computed client-side.
  /// Null when position is unavailable.
  final double? distanceMeters;

  AccessibilityPoiEntity copyWith({
    String? id,
    String? name,
    double? lat,
    double? lng,
    Map<String, dynamic>? attributes,
    int? verifiedCount,
    String? createdBy,
    double? distanceMeters,
  }) {
    return AccessibilityPoiEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      attributes: attributes ?? this.attributes,
      verifiedCount: verifiedCount ?? this.verifiedCount,
      createdBy: createdBy ?? this.createdBy,
      distanceMeters: distanceMeters ?? this.distanceMeters,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccessibilityPoiEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
