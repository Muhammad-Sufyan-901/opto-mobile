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

  /// Display name joined from `profiles`; null until hydrated by the repository.
  final String? fullName;

  /// Avatar public URL joined from `profiles`; null until hydrated.
  final String? avatarUrl;

  /// Clinic name joined from `clinics`; null until hydrated or if not affiliated.
  final String? clinicName;

  DoctorEntity copyWith({
    String? id,
    String? profileId,
    String? specialty,
    String? clinicId,
    bool? isVerified,
    String? fullName,
    String? avatarUrl,
    String? clinicName,
  }) {
    return DoctorEntity(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      specialty: specialty ?? this.specialty,
      clinicId: clinicId ?? this.clinicId,
      isVerified: isVerified ?? this.isVerified,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      clinicName: clinicName ?? this.clinicName,
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
