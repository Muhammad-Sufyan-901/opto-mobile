// Pure-Dart domain entity for a product in the Prosthetic Hub catalog.
//
// No serialisation dependencies — use [ProstheticProductModel.toEntity()] in
// the data layer to produce instances from Supabase rows.
import 'package:opto/core/constants/prosthetic_enums.dart';

/// Immutable domain representation of a row in the `prosthetic_products` table.
class ProstheticProductEntity {
  const ProstheticProductEntity({
    required this.id,
    required this.type,
    required this.name,
    required this.audioDescription,
    required this.isCustom,
    required this.priceIdr,
    required this.isActive,
    this.material,
    this.irisColor,
    this.size,
    this.vendorId,
  });

  /// Primary key (UUID).
  final String id;

  /// Product category — mirrors the `product_type` Postgres enum.
  final ProductType type;

  /// Human-readable product name.
  final String name;

  /// Audio description announced to screen reader users on focus.
  final String audioDescription;

  /// Material description (e.g. 'PMMA', 'silicone').
  final String? material;

  /// Iris colour name (applies to prosthesis type only).
  final String? irisColor;

  /// Size code / label.
  final String? size;

  /// Whether this is a custom/bespoke order.
  final bool isCustom;

  /// Price in Indonesian Rupiah (IDR).
  final int priceIdr;

  /// FK to the `vendors` table (nullable).
  final String? vendorId;

  /// Whether this product is actively listed in the catalog.
  final bool isActive;

  ProstheticProductEntity copyWith({
    String? id,
    ProductType? type,
    String? name,
    String? audioDescription,
    String? material,
    String? irisColor,
    String? size,
    bool? isCustom,
    int? priceIdr,
    String? vendorId,
    bool? isActive,
  }) {
    return ProstheticProductEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      audioDescription: audioDescription ?? this.audioDescription,
      material: material ?? this.material,
      irisColor: irisColor ?? this.irisColor,
      size: size ?? this.size,
      isCustom: isCustom ?? this.isCustom,
      priceIdr: priceIdr ?? this.priceIdr,
      vendorId: vendorId ?? this.vendorId,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProstheticProductEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          name == other.name &&
          audioDescription == other.audioDescription &&
          material == other.material &&
          irisColor == other.irisColor &&
          size == other.size &&
          isCustom == other.isCustom &&
          priceIdr == other.priceIdr &&
          vendorId == other.vendorId &&
          isActive == other.isActive;

  @override
  int get hashCode => Object.hash(
        id,
        type,
        name,
        audioDescription,
        material,
        irisColor,
        size,
        isCustom,
        priceIdr,
        vendorId,
        isActive,
      );
}
