// Auth events for [AuthBloc].
//
// Uses `freezed` for immutable, sealed event classes.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
sealed class AuthEvent with _$AuthEvent {
  /// Sign in with email + password credentials.
  const factory AuthEvent.signInWithEmailPassword({
    required String email,
    required String password,
  }) = SignInWithEmailPassword;

  /// Create a new account with email + password, optionally setting a full name.
  const factory AuthEvent.signUp({
    required String email,
    required String password,
    String? fullName,
  }) = SignUp;

  /// Request an OTP sent via SMS to [phone] (E.164 format).
  const factory AuthEvent.requestOtp({required String phone}) = RequestOtp;

  /// Verify the SMS OTP for [phone] to complete sign-in.
  const factory AuthEvent.verifyOtp({
    required String phone,
    required String otp,
  }) = VerifyOtp;

  /// Sign out the current user and clear the local session.
  const factory AuthEvent.signOut() = SignOut;

  /// Emitted internally by [AuthBloc] when the Supabase auth state changes.
  ///
  /// Not intended to be dispatched by UI code directly — the BLoC subscribes
  /// to [AuthRepository.isAuthenticated] and adds this event automatically.
  // ignore: library_private_types_in_public_api
  const factory AuthEvent.authStateChanged({
    required bool isAuthenticated,
  }) = AuthStateChanged;
}
