// BLoC for profile operations — sits between [ProfileRepository] and the
// profile screens.
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/profile/domain/repositories/profile_repository.dart';
import 'package:opto/features/profile/presentation/bloc/profile_event.dart';
import 'package:opto/features/profile/presentation/bloc/profile_state.dart';

export 'profile_event.dart';
export 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profile;

  ProfileBloc(this._profile) : super(const ProfileState.initial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  // ---------------------------------------------------------------------------
  // HANDLERS
  // ---------------------------------------------------------------------------

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileState.loading());
    try {
      final profile = await _profile.getProfile(event.userId);
      emit(ProfileState.loaded(profile: profile));
    } on Failure catch (f) {
      emit(ProfileState.error(message: f.message));
    } catch (e) {
      emit(const ProfileState.error(message: 'An unexpected error occurred.'));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    // Preserve the previously loaded profile during an in-flight update so
    // the UI can show an overlay spinner without losing current data.
    final previous = state;
    emit(const ProfileState.loading());
    try {
      await _profile.updateProfile(
        event.userId,
        fullName: event.fullName,
        phone: event.phone,
        visionProfile: event.visionProfile,
      );
      // Reload the updated profile to get the server-confirmed state.
      final updated = await _profile.getProfile(event.userId);
      emit(ProfileState.loaded(profile: updated));
    } on Failure catch (f) {
      // Restore previous state so the UI isn't left in loading on error.
      emit(previous is ProfileLoaded
          ? previous
          : ProfileState.error(message: f.message));
      if (previous is ProfileLoaded) {
        // Also surface the error without replacing the loaded data.
        emit(ProfileState.error(message: f.message));
      }
    } catch (e) {
      emit(previous is ProfileLoaded ? previous : const ProfileState.error(message: 'An unexpected error occurred.'));
      if (previous is ProfileLoaded) {
        emit(const ProfileState.error(message: 'An unexpected error occurred.'));
      }
    }
  }
}
