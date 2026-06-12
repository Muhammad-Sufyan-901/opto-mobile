// Domain entity for a prosthetic specialist available for messaging
// in the Opto Prosthetic Hub.
//
// Pure-Dart representation — no Supabase / serialization dependencies.

/// A specialist (ocularist / ophthalmologist / ocular prosthetic technician)
/// available for messaging via the Prosthetic Hub.
class Specialist {
  // Sentinel object used in copyWith to distinguish "not provided" from null.
  static const Object _unset = Object();

  const Specialist({
    required this.id,
    required this.fullName,
    required this.specialty,
    required this.isVerified,
    required this.repliesLabel,
    this.clinicName,
    this.avatarUrl,
  });

  /// Primary key (string slug or UUID).
  final String id;

  /// Full display name (e.g. 'Dr. Anwar Santoso').
  final String fullName;

  /// Specialty description (e.g. 'Ocularist & Prosthetic Specialist').
  final String specialty;

  /// Whether this specialist has been verified by Opto's clinical team.
  final bool isVerified;

  /// Human-readable response time label (e.g. 'usually replies same day').
  final String repliesLabel;

  /// Name of the clinic / hospital, if available.
  final String? clinicName;

  /// URL to the specialist's avatar image, if available.
  final String? avatarUrl;

  // ---------------------------------------------------------------------------
  // copyWith — uses _unset sentinel so nullable fields can be cleared
  // ---------------------------------------------------------------------------

  Specialist copyWith({
    String? id,
    String? fullName,
    String? specialty,
    bool? isVerified,
    String? repliesLabel,
    Object? clinicName = _unset,
    Object? avatarUrl = _unset,
  }) {
    return Specialist(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      specialty: specialty ?? this.specialty,
      isVerified: isVerified ?? this.isVerified,
      repliesLabel: repliesLabel ?? this.repliesLabel,
      clinicName: identical(clinicName, _unset)
          ? this.clinicName
          : (clinicName as String?),
      avatarUrl: identical(avatarUrl, _unset)
          ? this.avatarUrl
          : (avatarUrl as String?),
    );
  }

  // ---------------------------------------------------------------------------
  // Equality & hashCode
  // ---------------------------------------------------------------------------

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Specialist &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          fullName == other.fullName &&
          specialty == other.specialty &&
          isVerified == other.isVerified &&
          repliesLabel == other.repliesLabel &&
          clinicName == other.clinicName &&
          avatarUrl == other.avatarUrl;

  @override
  int get hashCode => Object.hash(
        id,
        fullName,
        specialty,
        isVerified,
        repliesLabel,
        clinicName,
        avatarUrl,
      );
}
