// Domain entity for a user profile.
//
// This is the pure-Dart representation used in use-cases and BLoC states —
// no Supabase / serialisation dependencies. It mirrors [ProfileModel] but
// lives in the domain layer so the data layer can evolve independently.
import 'package:opto/core/constants/identity_enums.dart';
import 'package:opto/core/constants/user_role.dart';

/// Immutable domain representation of the `profiles` table row.
class ProfileEntity {
  const ProfileEntity({
    required this.id,
    required this.role,
    this.fullName,
    this.phone,
    this.visionProfile,
    this.avatarUrl,
    required this.createdAt,
  });

  /// Primary key — matches `auth.users.id` (UUID).
  final String id;

  /// User's role in the Opto ecosystem.
  final UserRole role;

  /// User's display name (null until explicitly set).
  final String? fullName;

  /// Contact phone number (null until explicitly set).
  final String? phone;

  /// How the user perceives vision (null until set during onboarding).
  final VisionProfile? visionProfile;

  /// Supabase Storage public URL for the user's avatar (null if not uploaded).
  final String? avatarUrl;

  /// Row creation timestamp.
  final DateTime createdAt;

  /// Creates a copy with the given fields replaced.
  ///
  /// Note: passing `null` for a nullable field leaves it unchanged (does not
  /// clear it). To explicitly clear a nullable field, create a new instance
  /// with `ProfileEntity(...)`.
  ProfileEntity copyWith({
    String? id,
    UserRole? role,
    String? fullName,
    String? phone,
    VisionProfile? visionProfile,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      visionProfile: visionProfile ?? this.visionProfile,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          role == other.role &&
          fullName == other.fullName &&
          phone == other.phone &&
          visionProfile == other.visionProfile &&
          avatarUrl == other.avatarUrl &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(
        id,
        role,
        fullName,
        phone,
        visionProfile,
        avatarUrl,
        createdAt,
      );
}
