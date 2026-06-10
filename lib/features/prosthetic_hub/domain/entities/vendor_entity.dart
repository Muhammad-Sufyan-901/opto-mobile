// Pure-Dart domain entity for a vendor in the Prosthetic Hub catalog.
//
// No serialisation dependencies — use [VendorModel.toEntity()] in the data
// layer to produce instances from Supabase rows.

/// Immutable domain representation of a row in the `vendors` table.
class VendorEntity {
  const VendorEntity({
    required this.id,
    required this.name,
    required this.isVerified,
    this.clinicId,
  });

  /// Primary key (UUID).
  final String id;

  /// Display name of the vendor / clinic.
  final String name;

  /// Whether the vendor has been verified by Opto.
  final bool isVerified;

  /// Optional FK to a linked clinic record.
  final String? clinicId;

  VendorEntity copyWith({
    String? id,
    String? name,
    bool? isVerified,
    String? clinicId,
  }) {
    return VendorEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      isVerified: isVerified ?? this.isVerified,
      clinicId: clinicId ?? this.clinicId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VendorEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          isVerified == other.isVerified &&
          clinicId == other.clinicId;

  @override
  int get hashCode => Object.hash(id, name, isVerified, clinicId);
}
