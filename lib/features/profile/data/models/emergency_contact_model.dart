// Freezed + json_serializable DTO for the `emergency_contacts` table.
//
// Mirrors the row shape defined in `database_schema.md`
// §Identity.emergency_contacts.
//
// SECURITY NOTE: This table falls under the owner-only RLS policy.
// Never surface these records in community/map/catalog joins.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'emergency_contact_model.freezed.dart';
part 'emergency_contact_model.g.dart';

// =============================================================================
// MODEL
// =============================================================================

/// Data-layer representation of a row in the `emergency_contacts` table.
///
/// Use [EmergencyContactModel.fromJson] to deserialise a Supabase response map.
@freezed
abstract class EmergencyContactModel with _$EmergencyContactModel {
  const factory EmergencyContactModel({
    /// Primary key (UUID).
    required String id,

    /// Foreign key to `profiles.id` (UUID) — the owner of this contact.
    @JsonKey(name: 'user_id') required String userId,

    /// Full name of the emergency contact.
    required String name,

    /// Phone number of the emergency contact.
    required String phone,

    /// Optional relationship label (e.g. "Mother", "Spouse").
    String? relationship,

    /// Sort order; lower numbers are contacted first (default 0).
    @Default(0) int priority,
  }) = _EmergencyContactModel;

  /// Deserialises a Supabase / JSON map to an [EmergencyContactModel].
  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) =>
      _$EmergencyContactModelFromJson(json);
}
