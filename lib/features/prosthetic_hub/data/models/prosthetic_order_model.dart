// Freezed + json_serializable DTO for the `prosthetic_orders` table.
//
// Mirrors the row shape in `database_schema.md` §Prosthetic.prosthetic_orders.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/core/constants/prosthetic_enums.dart';

part 'prosthetic_order_model.freezed.dart';
part 'prosthetic_order_model.g.dart';

// =============================================================================
// ENUM JSON HELPERS
// =============================================================================

OrderStatus _statusFromJson(String? v) => OrderStatus.fromString(v);
String _statusToJson(OrderStatus s) => s.dbValue;

// =============================================================================
// MODEL
// =============================================================================

/// Data-layer representation of a row in the `prosthetic_orders` table.
@freezed
abstract class ProstheticOrderModel with _$ProstheticOrderModel {
  const factory ProstheticOrderModel({
    /// Primary key (UUID).
    required String id,

    /// FK to `profiles.id` — the owner.
    @JsonKey(name: 'user_id') required String userId,

    /// FK to `prosthetic_products.id`.
    @JsonKey(name: 'product_id') required String productId,

    /// FK to `anthropometric_data.id` — set for custom orders.
    @JsonKey(name: 'anthropometric_id') String? anthropometricId,

    /// Current lifecycle status.
    @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
    required OrderStatus status,

    /// Whether the user has given explicit read-aloud consent.
    @JsonKey(name: 'consent_given') @Default(false) bool consentGiven,

    /// Order total in IDR.
    @JsonKey(name: 'total_idr') required int totalIdr,

    /// Row creation timestamp (ISO 8601 string).
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _ProstheticOrderModel;

  factory ProstheticOrderModel.fromJson(Map<String, dynamic> json) =>
      _$ProstheticOrderModelFromJson(json);
}
