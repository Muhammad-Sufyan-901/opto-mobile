// Domain entity for an eye-care clinic / manufacturer.
//
// Pure-Dart representation used in use-cases and BLoC states —
// no Supabase / serialisation dependencies.
//
// Corresponds to the `clinics` table in the Supabase database.

/// Immutable domain representation of a clinic or prosthetic manufacturer.
///
/// [isManufacturer] distinguishes prosthetic manufacturers from standard
/// eye-care clinics; both share the same table.
class ClinicEntity {
  const ClinicEntity({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.address,
    this.isManufacturer = false,
  });

  /// Primary key (UUID).
  final String id;

  /// Display name of the clinic or manufacturer.
  final String name;

  /// Whether this entry is a prosthetic manufacturer rather than a clinic.
  final bool isManufacturer;

  /// Latitude coordinate for map display.
  final double lat;

  /// Longitude coordinate for map display.
  final double lng;

  /// Street / postal address.
  final String address;

  ClinicEntity copyWith({
    String? id,
    String? name,
    bool? isManufacturer,
    double? lat,
    double? lng,
    String? address,
  }) {
    return ClinicEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      isManufacturer: isManufacturer ?? this.isManufacturer,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      address: address ?? this.address,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClinicEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          isManufacturer == other.isManufacturer &&
          lat == other.lat &&
          lng == other.lng &&
          address == other.address;

  @override
  int get hashCode => Object.hash(id, name, isManufacturer, lat, lng, address);
}
