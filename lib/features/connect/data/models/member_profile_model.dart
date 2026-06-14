// Freezed + json_serializable DTO for the `profiles` Supabase table
// (community-visible fields only).
//
// Security note: this model includes ONLY non-sensitive public fields.
// Never add 🔒 fields (anthropometric_data, eye_photos, etc.) to this model.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_profile_model.freezed.dart';
part 'member_profile_model.g.dart';

/// Data-layer representation of the public community fields from `profiles`.
///
/// Use [MemberProfileModel.fromJson] to deserialise a Supabase response map.
/// The matching domain entity lives in
/// `lib/features/connect/domain/entities/member_profile_entity.dart`.
@freezed
abstract class MemberProfileModel with _$MemberProfileModel {
  const factory MemberProfileModel({
    /// Primary key (UUID).
    required String id,

    /// Display name of the member.
    @JsonKey(name: 'full_name') required String fullName,

    /// Optional public avatar storage URL.
    @JsonKey(name: 'avatar_url') String? avatarUrl,

    /// Whether this profile has been verified by moderators.
    @JsonKey(name: 'is_verified') @Default(false) bool isVerified,

    /// Whether this member is a community mentor.
    @JsonKey(name: 'is_mentor') @Default(false) bool isMentor,

    /// Optional member bio/tagline.
    String? bio,

    /// Optional @handle displayed on the profile.
    String? handle,

    /// Row creation timestamp — used to derive the joinedYear.
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _MemberProfileModel;

  /// Deserialises a Supabase / JSON map to a [MemberProfileModel].
  factory MemberProfileModel.fromJson(Map<String, dynamic> json) =>
      _$MemberProfileModelFromJson(json);
}
