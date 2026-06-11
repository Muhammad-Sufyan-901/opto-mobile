// Domain entity for an eye-care doctor / specialist.
//
// Pure-Dart representation used in use-cases and BLoC states —
// no Supabase / serialisation dependencies.
//
// Corresponds to the `doctors` table in the Supabase database.
// The `doctors` table joins `profiles` (for display name and avatar) and
// `clinics` (for clinic name) at the repository level.

/// Immutable domain representation of a doctor.
///
/// [fullName], [avatarUrl], and [clinicName] are joined from `profiles` and
/// `clinics` at the repository level and may be null until hydrated.
class DoctorEntity {
  // Sentinel value used by [copyWith] to distinguish "not provided" from null
  // for nullable fields.
  static const _unset = Object();

  const DoctorEntity({
    required this.id,
    required this.profileId,
    required this.specialty,
    required this.isVerified,
    this.clinicId,
    this.fullName,
    this.avatarUrl,
    this.clinicName,
  });

  /// Primary key (UUID).
  final String id;

  /// UUID of the doctor's user profile — foreign key to `profiles.id`
  /// (role = doctor).
  final String profileId;

  /// Medical specialty description (e.g. "Ophthalmology", "Optometry").
  final String specialty;

  /// UUID of the clinic this doctor is affiliated with; nullable.
  final String? clinicId;

  /// Whether the doctor's credentials have been verified by the platform.
  final bool isVerified;

  /// Display name joined from `profiles`; null until hydrated by the
  /// repository.
  final String? fullName;

  /// Avatar public URL joined from `profiles`; null until hydrated.
  final String? avatarUrl;

  /// Clinic name joined from `clinics`; null until hydrated or if the doctor
  /// is not affiliated with a clinic.
  final String? clinicName;

  DoctorEntity copyWith({
    String? id,
    String? profileId,
    String? specialty,
    Object? clinicId = _unset,
    bool? isVerified,
    Object? fullName = _unset,
    Object? avatarUrl = _unset,
    Object? clinicName = _unset,
  }) {
    return DoctorEntity(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      specialty: specialty ?? this.specialty,
      clinicId: identical(clinicId, _unset)
          ? this.clinicId
          : clinicId as String?,
      isVerified: isVerified ?? this.isVerified,
      fullName: identical(fullName, _unset)
          ? this.fullName
          : fullName as String?,
      avatarUrl: identical(avatarUrl, _unset)
          ? this.avatarUrl
          : avatarUrl as String?,
      clinicName: identical(clinicName, _unset)
          ? this.clinicName
          : clinicName as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          profileId == other.profileId &&
          specialty == other.specialty &&
          clinicId == other.clinicId &&
          isVerified == other.isVerified &&
          fullName == other.fullName &&
          avatarUrl == other.avatarUrl &&
          clinicName == other.clinicName;

  @override
  int get hashCode => Object.hash(
        id,
        profileId,
        specialty,
        clinicId,
        isVerified,
        fullName,
        avatarUrl,
        clinicName,
      );
}
