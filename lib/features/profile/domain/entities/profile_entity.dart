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
    this.username,
    this.pronouns,
    this.bio,
    this.location,
    required this.createdAt,
    this.preferredLanguage = 'en',
    this.clinicId,
    this.clinicName,
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

  /// The user's @handle (null until set).
  final String? username;

  /// The user's preferred pronouns (null until set).
  final String? pronouns;

  /// Short bio shown on the community profile card (null until set).
  final String? bio;

  /// City / region the user is based in (null until set).
  final String? location;

  /// Row creation timestamp.
  final DateTime createdAt;

  /// User's preferred UI language (ISO 639-1 code, e.g. 'en', 'id'). Defaults to 'en'.
  final String preferredLanguage;

  /// FK to `clinics.id` (nullable — user may not have a linked clinic).
  final String? clinicId;

  /// Clinic display name derived from a DB join (nullable). Not stored in profiles directly.
  final String? clinicName;

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
    String? username,
    String? pronouns,
    String? bio,
    String? location,
    DateTime? createdAt,
    String? preferredLanguage,
    String? clinicId,
    String? clinicName,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      visionProfile: visionProfile ?? this.visionProfile,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      username: username ?? this.username,
      pronouns: pronouns ?? this.pronouns,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      clinicId: clinicId ?? this.clinicId,
      clinicName: clinicName ?? this.clinicName,
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
          username == other.username &&
          pronouns == other.pronouns &&
          bio == other.bio &&
          location == other.location &&
          createdAt == other.createdAt &&
          preferredLanguage == other.preferredLanguage &&
          clinicId == other.clinicId &&
          clinicName == other.clinicName;

  @override
  int get hashCode => Object.hash(
        id,
        role,
        fullName,
        phone,
        visionProfile,
        avatarUrl,
        username,
        pronouns,
        bio,
        location,
        createdAt,
        preferredLanguage,
        clinicId,
        clinicName,
      );
}
