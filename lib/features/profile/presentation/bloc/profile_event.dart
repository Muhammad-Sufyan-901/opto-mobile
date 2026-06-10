// Profile events for [ProfileBloc].
//
// Uses `freezed` for immutable, sealed event classes.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/core/constants/identity_enums.dart';

part 'profile_event.freezed.dart';

@freezed
sealed class ProfileEvent with _$ProfileEvent {
  /// Load the profile for [userId] from the repository.
  const factory ProfileEvent.loadProfile({
    required String userId,
  }) = LoadProfile;

  /// Partially update the profile for [userId].
  ///
  /// Only non-null fields are written — passing null leaves the existing
  /// value unchanged.
  const factory ProfileEvent.updateProfile({
    required String userId,
    String? fullName,
    String? phone,
    VisionProfile? visionProfile,
    String? avatarUrl,
  }) = UpdateProfile;
}
