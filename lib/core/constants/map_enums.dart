// Accessibility Map enums that mirror Postgres enum types in the Opto schema.
//
// These cover the `accessibility_pois` and `poi_contributions` tables used by
// the Accessibility Map module.
//
// NOTE: Identity-related enums live in `lib/core/constants/identity_enums.dart`.
//       Prosthetic Hub enums live in `lib/core/constants/prosthetic_enums.dart`.

// =============================================================================
// CONTRIBUTION STATUS
// =============================================================================

/// The moderation status of a [PoiContributionEntity].
///
/// Mirrors the `contribution_status` Postgres enum in `poi_contributions`.
enum ContributionStatus {
  /// Submitted by a user, awaiting moderator review.
  pending,

  /// Accepted by a moderator; the POI's [verified_count] has been incremented.
  approved,

  /// Rejected by a moderator.
  rejected;

  /// Parses a raw Postgres / JSON string to a [ContributionStatus].
  /// Falls back to [pending] for any unknown value.
  static ContributionStatus fromString(String? value) {
    switch (value) {
      case 'pending':
        return ContributionStatus.pending;
      case 'approved':
        return ContributionStatus.approved;
      case 'rejected':
        return ContributionStatus.rejected;
      default:
        assert(false, 'Unknown ContributionStatus db value: "$value"');
        return ContributionStatus.pending;
    }
  }

  /// Canonical snake_case string written to Postgres.
  String get dbValue => switch (this) {
        ContributionStatus.pending => 'pending',
        ContributionStatus.approved => 'approved',
        ContributionStatus.rejected => 'rejected',
      };
}

// =============================================================================
// POI ATTRIBUTE KEYS
// =============================================================================

/// Canonical keys for the `attributes` jsonb column in `accessibility_pois`.
///
/// The `attributes` column is free-form jsonb; this enum defines the known
/// keys so that:
///  - The add-POI form toggles map to the correct key strings.
///  - The POI detail screen reads attributes aloud using consistent labels.
///  - Unknown keys degrade gracefully (read the raw key, no crash).
///
/// Read-aloud label → [displayLabel]; db/json key → [jsonKey].
enum PoiAttribute {
  /// Ramped access (no step at entry).
  ramp,

  /// Elevator / lift available.
  elevator,

  /// Tactile paving / guiding path for blind users.
  tactilePath,

  /// Wheelchair-accessible entrance and interior.
  wheelchair,

  /// Accessible restroom available.
  accessibleRestroom,

  /// Audio signal / talking sign present.
  audioSignal,

  /// Braille signage available.
  brailleSignage,

  /// Reserved/accessible parking nearby.
  accessibleParking;

  /// The key stored in the `attributes` jsonb map.
  String get jsonKey => switch (this) {
        PoiAttribute.ramp => 'ramp',
        PoiAttribute.elevator => 'elevator',
        PoiAttribute.tactilePath => 'tactile_path',
        PoiAttribute.wheelchair => 'wheelchair',
        PoiAttribute.accessibleRestroom => 'accessible_restroom',
        PoiAttribute.audioSignal => 'audio_signal',
        PoiAttribute.brailleSignage => 'braille_signage',
        PoiAttribute.accessibleParking => 'accessible_parking',
      };

  /// Human-readable label read aloud by the screen reader.
  String get displayLabel => switch (this) {
        PoiAttribute.ramp => 'Ramp access',
        PoiAttribute.elevator => 'Elevator',
        PoiAttribute.tactilePath => 'Tactile path',
        PoiAttribute.wheelchair => 'Wheelchair accessible',
        PoiAttribute.accessibleRestroom => 'Accessible restroom',
        PoiAttribute.audioSignal => 'Audio signal',
        PoiAttribute.brailleSignage => 'Braille signage',
        PoiAttribute.accessibleParking => 'Accessible parking',
      };

  /// Parses a raw JSON key string to the corresponding [PoiAttribute], or
  /// returns `null` if the key is unknown (graceful degradation).
  static PoiAttribute? fromJsonKey(String key) {
    return PoiAttribute.values.where((a) => a.jsonKey == key).firstOrNull;
  }
}
