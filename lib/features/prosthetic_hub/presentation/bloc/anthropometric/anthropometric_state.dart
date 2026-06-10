// States for [AnthropometricCubit].
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/features/prosthetic_hub/domain/entities/anthropometric_entity.dart';

part 'anthropometric_state.freezed.dart';

@freezed
sealed class AnthropometricState with _$AnthropometricState {
  /// Initial state — data not yet loaded.
  const factory AnthropometricState.initial() = AnthropometricInitial;

  /// Load/save in progress.
  const factory AnthropometricState.loading() = AnthropometricLoading;

  /// Measurements loaded successfully (may be null if no record exists yet).
  const factory AnthropometricState.loaded(
    AnthropometricEntity? measurements,
  ) = AnthropometricLoaded;

  /// Save completed — emit this so the screen can announce success.
  const factory AnthropometricState.saved() = AnthropometricSaved;

  /// Operation failed.
  const factory AnthropometricState.error(String message) = AnthropometricError;
}
