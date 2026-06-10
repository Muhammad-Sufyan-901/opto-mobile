// Identity-related enums that mirror Postgres enum types in the Opto schema.
//
// These are kept separate from [UserRole] (which maps the `profiles.role`
// column) to avoid one mega-file and to allow independent evolution.
//
// NOTE: [UserRole] lives in `lib/core/constants/user_role.dart`.
//       [AppThemeMode] lives in `lib/core/constants/app_theme_mode.dart`.
//       Neither is duplicated here.
// =============================================================================
// VISION PROFILE
// =============================================================================

/// Describes how the user perceives vision — used to personalise the UI
/// defaults (contrast, text scale, haptics) on first run.
///
/// Mirrors the `vision_profile` column in the `profiles` table.
enum VisionProfile {
  /// No functional light perception.
  blindTotal,

  /// Some functional vision; benefits from high contrast + large text.
  lowVision,

  /// Wears an ocular prosthesis; may have monocular vision on one side.
  ocularProsthesis,

  /// A sighted caregiver supporting a primary user.
  caregiver,

  /// User has not yet specified their vision profile.
  unspecified;

  /// Parses a raw Postgres / JSON string to a [VisionProfile].
  /// Falls back to [unspecified] for any unknown value.
  static VisionProfile fromString(String? value) {
    switch (value) {
      case 'blind_total':
        return VisionProfile.blindTotal;
      case 'low_vision':
        return VisionProfile.lowVision;
      case 'ocular_prosthesis':
        return VisionProfile.ocularProsthesis;
      case 'caregiver':
        return VisionProfile.caregiver;
      default:
        return VisionProfile.unspecified;
    }
  }

  /// Canonical snake_case string written to Postgres.
  String get dbValue {
    switch (this) {
      case VisionProfile.blindTotal:
        return 'blind_total';
      case VisionProfile.lowVision:
        return 'low_vision';
      case VisionProfile.ocularProsthesis:
        return 'ocular_prosthesis';
      case VisionProfile.caregiver:
        return 'caregiver';
      case VisionProfile.unspecified:
        return 'unspecified';
    }
  }
}

// =============================================================================
// LINK STATUS
// =============================================================================

/// Lifecycle state of a [CaregiverLink] between a user and their caregiver.
///
/// Mirrors the `link_status` Postgres enum in the `caregiver_links` table.
enum LinkStatus {
  /// Invitation sent but not yet accepted by the caregiver.
  pending,

  /// Link accepted and active; caregiver can exercise their [permissions].
  active,

  /// Link has been explicitly revoked by either party.
  revoked;

  /// Parses a raw string to [LinkStatus]. Falls back to [pending].
  static LinkStatus fromString(String? value) {
    return LinkStatus.values.firstWhere(
      (s) => s.dbValue == value,
      orElse: () {
        assert(false, 'Unknown LinkStatus: "$value" — falling back to pending');
        return LinkStatus.pending;
      },
    );
  }

  /// Canonical lowercase string written to Postgres.
  String get dbValue => name; // 'pending' | 'active' | 'revoked'
}

// =============================================================================
// HAPTIC LEVEL
// =============================================================================

/// Controls the intensity of device haptic feedback throughout the app.
///
/// Mirrors the `haptic_intensity` column in `accessibility_settings`.
enum HapticLevel {
  /// Haptics disabled (accessibility need or device limitation).
  off,

  /// Gentle / short taps only — good for users with sensitivity.
  light,

  /// Full haptic patterns including the SOS danger pulse.
  full;

  /// Parses a raw string to [HapticLevel]. Falls back to [full].
  static HapticLevel fromString(String? value) {
    switch (value) {
      case 'off':
        return HapticLevel.off;
      case 'light':
        return HapticLevel.light;
      default:
        return HapticLevel.full;
    }
  }

  /// Canonical lowercase string written to Postgres.
  String get dbValue => name; // 'off' | 'light' | 'full'
}
