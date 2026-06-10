// Profile states for [ProfileBloc].
//
// Uses `freezed` for immutable, sealed state classes.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/features/profile/domain/entities/profile_entity.dart';

part 'profile_state.freezed.dart';

@freezed
sealed class ProfileState with _$ProfileState {
  /// Initial state — profile not yet loaded.
  const factory ProfileState.initial() = ProfileInitial;

  /// Profile operation in progress (fetch or update).
  const factory ProfileState.loading() = ProfileLoading;

  /// Profile loaded successfully.
  const factory ProfileState.loaded({required ProfileEntity profile}) =
      ProfileLoaded;

  /// Profile operation failed with [message].
  const factory ProfileState.error({required String message}) = ProfileError;
}
