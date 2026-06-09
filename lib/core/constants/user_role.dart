/// Typed role enum for Opto users.
///
/// Mirrors the `profiles.role` Postgres enum defined in the database schema.
/// Use this instead of bare strings for [RolesMiddleware.requireRole] and
/// any business logic that branches on the current user's role.
enum UserRole {
  user,
  caregiver,
  doctor,
  admin;

  /// Parses a raw string value (e.g. from secure storage or Supabase) to a
  /// [UserRole]. Returns [UserRole.user] as the safe fallback for unknown values.
  static UserRole fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'caregiver':
        return UserRole.caregiver;
      case 'doctor':
        return UserRole.doctor;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.user;
    }
  }

  /// Returns the canonical lowercase string used in RLS policies and storage.
  String get value => name; // e.g. UserRole.doctor.value == 'doctor'
}
