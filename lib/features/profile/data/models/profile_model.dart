// Freezed + json_serializable DTO for the `profiles` Supabase table.
//
// Mirrors the row shape defined in `database_schema.md` §Identity.profiles.
// All DB columns are snake_case; Dart fields are camelCase via [@JsonKey].
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/core/constants/identity_enums.dart';
import 'package:opto/core/constants/user_role.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

// =============================================================================
// JSON CONVERTERS
// =============================================================================

/// Converts between [UserRole] and the lowercase string stored in Postgres.
class _UserRoleConverter implements JsonConverter<UserRole, String?> {
  const _UserRoleConverter();

  @override
  UserRole fromJson(String? json) => UserRole.fromString(json);

  @override
  String toJson(UserRole role) => role.dbValue;
}

/// Converts between nullable [VisionProfile] and the snake_case Postgres string.
class _VisionProfileConverter
    implements JsonConverter<VisionProfile?, String?> {
  const _VisionProfileConverter();

  @override
  VisionProfile? fromJson(String? json) =>
      json == null ? null : VisionProfile.fromString(json);

  @override
  String? toJson(VisionProfile? profile) => profile?.dbValue;
}

// =============================================================================
// MODEL
// =============================================================================

/// Data-layer representation of a row in the `profiles` table.
///
/// Use [ProfileModel.fromJson] to deserialise a Supabase response map.
/// The matching domain entity lives in
/// `lib/features/profile/domain/entities/profile_entity.dart`.
@freezed
abstract class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    /// Primary key — matches `auth.users.id` (UUID).
    required String id,

    /// User's role in the Opto ecosystem.
    @_UserRoleConverter() required UserRole role,

    /// User's display name (nullable until set).
    @JsonKey(name: 'full_name') String? fullName,

    /// Contact phone number (nullable until set).
    String? phone,

    /// How the user perceives vision (nullable until set during onboarding).
    @JsonKey(name: 'vision_profile')
    @_VisionProfileConverter()
    VisionProfile? visionProfile,

    /// Supabase Storage public URL for the user's avatar (nullable).
    @JsonKey(name: 'avatar_url') String? avatarUrl,

    /// The user's @handle (stored in DB as `handle`).
    @JsonKey(name: 'handle') String? username,

    /// The user's preferred pronouns (e.g. "she/her", "they/them").
    String? pronouns,

    /// Short bio shown on the community profile card.
    String? bio,

    /// City / region the user is based in.
    String? location,

    /// Row creation timestamp — set by Postgres default.
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _ProfileModel;

  /// Deserialises a Supabase / JSON map to a [ProfileModel].
  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}
