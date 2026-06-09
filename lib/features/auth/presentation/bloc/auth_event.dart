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

  /// Internal event emitted by [AuthBloc] when the Supabase session changes.
  ///
  /// Do NOT dispatch this event from UI code. It is dispatched only by the
  /// [AuthBloc] constructor's auth-state stream subscription.
  // ignore: library_private_types_in_public_api
  const factory AuthEvent.authStateChanged({
    required bool isAuthenticated,
  }) = AuthStateChanged;
}
