// Freezed + json_serializable DTO for the `prosthetic_products` table.
//
// Mirrors the row shape defined in `database_schema.md`
// §Prosthetic.prosthetic_products.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/core/constants/prosthetic_enums.dart';

part 'prosthetic_product_model.freezed.dart';
part 'prosthetic_product_model.g.dart';

// =============================================================================
// ENUM JSON HELPERS
// =============================================================================

ProductType _productTypeFromJson(String? v) => ProductType.fromString(v);
String _productTypeToJson(ProductType t) => t.dbValue;

// =============================================================================
// MODEL
// =============================================================================

/// Data-layer representation of a row in the `prosthetic_products` table.
///
/// Use [ProstheticProductModel.fromJson] to deserialise a Supabase map.
/// Use `ProstheticProductModelX.toEntity()` (in
/// `prosthetic_product_model_ext.dart`) to convert to the domain entity.
@freezed
abstract class ProstheticProductModel with _$ProstheticProductModel {
  const factory ProstheticProductModel({
    /// Primary key (UUID).
    required String id,

    /// Product category — mirrors the `product_type` Postgres enum.
    @JsonKey(
      name: 'type',
      fromJson: _productTypeFromJson,
      toJson: _productTypeToJson,
    )
    required ProductType type,

    /// Human-readable product name.
    required String name,

    /// Audio description announced to screen reader users on focus.
    @JsonKey(name: 'audio_description') required String audioDescription,

    /// Material description (e.g. 'PMMA', 'silicone').
    String? material,

    /// Iris colour name (applies to prosthesis type only).
    @JsonKey(name: 'iris_color') String? irisColor,

    /// Size code / label.
    String? size,

    /// Whether this is a custom/bespoke order.
    @JsonKey(name: 'is_custom') required bool isCustom,

    /// Price in Indonesian Rupiah (IDR).
    @JsonKey(name: 'price_idr') required int priceIdr,

    /// FK to the `vendors` table (nullable).
    @JsonKey(name: 'vendor_id') String? vendorId,

    /// Whether this product is actively listed in the catalog.
    @JsonKey(name: 'is_active') required bool isActive,
  }) = _ProstheticProductModel;

  /// Deserialises a Supabase / JSON map to a [ProstheticProductModel].
  factory ProstheticProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProstheticProductModelFromJson(json);
}
