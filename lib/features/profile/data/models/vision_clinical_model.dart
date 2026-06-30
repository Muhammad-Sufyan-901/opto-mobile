// Freezed + json_serializable DTO for the `vision_clinical_profile` table.
//
// Mirrors the row shape defined in `database_schema.md`
// §VisionClinicalProfile.
// This is medically sensitive data (🔒 owner-only via RLS) — never expose
// in community/map/catalog joins.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/features/profile/domain/entities/vision_clinical_entity.dart';

part 'vision_clinical_model.freezed.dart';
part 'vision_clinical_model.g.dart';

// =============================================================================
// JSON CONVERTERS
// =============================================================================

/// Converts between a JSONB list of `{name, enabled}` objects and
/// [List<AssistiveTech>].
class _AssistiveTechListConverter
    implements JsonConverter<List<AssistiveTech>, List<dynamic>> {
  const _AssistiveTechListConverter();

  @override
  List<AssistiveTech> fromJson(List<dynamic> json) => json
      .whereType<Map<String, dynamic>>()
      .map((m) => AssistiveTech(
            name: (m['name'] as String?) ?? '',
            enabled: (m['enabled'] as bool?) ?? false,
          ))
      .toList();

  @override
  List<dynamic> toJson(List<AssistiveTech> list) =>
      list.map((e) => {'name': e.name, 'enabled': e.enabled}).toList();
}

// ---------------------------------------------------------------------------
// Date helpers for Supabase `date` columns (returned as ISO-8601 strings).
// ---------------------------------------------------------------------------

DateTime? _parseDate(dynamic v) {
  if (v == null) return null;
  // Supabase returns date columns as ISO-8601 strings; guard against
  // unexpected types (e.g. Map in PostgREST edge cases).
  return DateTime.parse(v.toString());
}

String? _formatDate(DateTime? d) => d?.toIso8601String().substring(0, 10);

// =============================================================================
// MODEL
// =============================================================================

/// Data-layer representation of a row in the `vision_clinical_profile` table.
///
/// Use [VisionClinicalModel.fromJson] to deserialise a Supabase response map.
/// The matching domain entity lives in
/// `lib/features/profile/domain/entities/vision_clinical_entity.dart`.
@freezed
abstract class VisionClinicalModel with _$VisionClinicalModel {
  const factory VisionClinicalModel({
    /// Primary key — matches `profiles.id` / `auth.users.id` (UUID).
    @JsonKey(name: 'user_id') required String userId,

    /// Primary eye diagnosis.
    String? diagnosis,

    /// Severity classification.
    @JsonKey(name: 'diagnosis_severity') String? diagnosisSeverity,

    /// Which eye(s) are affected.
    @JsonKey(name: 'affected_eyes') String? affectedEyes,

    /// Year of diagnosis confirmation.
    @JsonKey(name: 'diagnosed_year') int? diagnosedYear,

    /// Light perception capability.
    @JsonKey(name: 'light_perception') String? lightPerception,

    /// Best corrected visual acuity string.
    @JsonKey(name: 'central_acuity') String? centralAcuity,

    /// Visual field description or degrees.
    @JsonKey(name: 'visual_field') String? visualField,

    /// Which eye has the prosthesis.
    @JsonKey(name: 'prosthesis_eye') String? prosthesisEye,

    /// Type of ocular prosthesis.
    @JsonKey(name: 'prosthesis_type') String? prosthesisType,

    /// Material of the prosthesis.
    @JsonKey(name: 'prosthesis_material') String? prosthesisMaterial,

    /// Date the prosthesis was fitted (Supabase `date` column → ISO string).
    @JsonKey(
      name: 'prosthesis_fitted_date',
      fromJson: _parseDate,
      toJson: _formatDate,
    )
    DateTime? prosthesisFittedDate,

    /// Name or location of the fitting clinic.
    @JsonKey(name: 'prosthesis_fitted_clinic') String? prosthesisFittedClinic,

    /// Date of the last prosthesis polish (Supabase `date` column → ISO string).
    @JsonKey(
      name: 'last_polish_date',
      fromJson: _parseDate,
      toJson: _formatDate,
    )
    DateTime? lastPolishDate,

    /// Scheduled date for the next prosthesis polish (Supabase `date` column).
    @JsonKey(
      name: 'next_polish_due',
      fromJson: _parseDate,
      toJson: _formatDate,
    )
    DateTime? nextPolishDue,

    /// JSONB list of assistive technology devices.
    @JsonKey(name: 'assistive_tech')
    @_AssistiveTechListConverter()
    @Default([])
    List<AssistiveTech> assistiveTech,

    /// Row creation timestamp (nullable — set by Postgres default).
    @JsonKey(name: 'created_at') DateTime? createdAt,

    /// Row last-updated timestamp (nullable — managed by DB trigger).
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _VisionClinicalModel;

  /// Deserialises a Supabase / JSON map to a [VisionClinicalModel].
  factory VisionClinicalModel.fromJson(Map<String, dynamic> json) =>
      _$VisionClinicalModelFromJson(json);
}
