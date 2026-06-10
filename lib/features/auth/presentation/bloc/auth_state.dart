// Auth states for [AuthBloc].
//
// Uses `freezed` for immutable, sealed state classes.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  /// Initial state — auth status is not yet known (before stream subscription fires).
  const factory AuthState.initial() = AuthInitial;

  /// An auth operation is in progress (sign-in, sign-up, OTP request, etc.).
  const factory AuthState.loading() = AuthLoading;

  /// The user is authenticated (active Supabase session present).
  const factory AuthState.authenticated() = AuthAuthenticated;

  /// The user is unauthenticated (signed out or no session).
  const factory AuthState.unauthenticated() = AuthUnauthenticated;

  /// An OTP has been sent — the user should now enter it.
  const factory AuthState.otpSent({required String phone}) = AuthOtpSent;

  /// Sign-up succeeded but the user must confirm their email before they can
  /// sign in.  No Supabase session exists yet — [email] is the address the
  /// confirmation link was sent to.
  const factory AuthState.emailConfirmationRequired({required String email}) =
      AuthEmailConfirmationRequired;

  /// An auth operation failed with [message].
  const factory AuthState.error({required String message}) = AuthError;
}
