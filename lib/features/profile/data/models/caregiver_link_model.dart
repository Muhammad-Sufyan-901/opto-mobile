// Freezed + json_serializable DTO for the `caregiver_links` table.
//
// Mirrors the row shape defined in `database_schema.md`
// §Identity.caregiver_links.
//
// SECURITY NOTE: This table is owner-only (RLS). Never expose caregiver IDs
// in community or map surfaces.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/core/constants/identity_enums.dart';

part 'caregiver_link_model.freezed.dart';
part 'caregiver_link_model.g.dart';

// =============================================================================
// JSON CONVERTER
// =============================================================================

/// Converts between [LinkStatus] and the lowercase string stored in Postgres.
class _LinkStatusConverter implements JsonConverter<LinkStatus, String?> {
  const _LinkStatusConverter();

  @override
  LinkStatus fromJson(String? json) => LinkStatus.fromString(json);

  @override
  String toJson(LinkStatus status) => status.dbValue;
}

// =============================================================================
// MODEL
// =============================================================================

/// Data-layer representation of a row in the `caregiver_links` table.
///
/// Use [CaregiverLinkModel.fromJson] to deserialise a Supabase response map.
@freezed
abstract class CaregiverLinkModel with _$CaregiverLinkModel {
  const factory CaregiverLinkModel({
    /// Primary key (UUID).
    required String id,

    /// Foreign key to `profiles.id` — the primary (low-vision) user.
    @JsonKey(name: 'user_id') required String userId,

    /// Foreign key to `profiles.id` — the caregiver.
    @JsonKey(name: 'caregiver_id') required String caregiverId,

    /// Lifecycle state of the link; starts as [LinkStatus.pending].
    @_LinkStatusConverter() @Default(LinkStatus.pending) LinkStatus status,

    /// Scoped permissions granted to the caregiver
    /// (e.g. `['read:health', 'write:sos']`).
    @Default(<String>[]) List<String> permissions,

    /// Row creation timestamp — set by Postgres default.
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _CaregiverLinkModel;

  /// Deserialises a Supabase / JSON map to a [CaregiverLinkModel].
  factory CaregiverLinkModel.fromJson(Map<String, dynamic> json) =>
      _$CaregiverLinkModelFromJson(json);
}
