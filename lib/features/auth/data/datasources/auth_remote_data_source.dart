// Remote data source for Supabase Auth operations.
//
// This is the only place in the auth feature that calls
// `SupabaseClientProvider.client.auth` directly.
// Callers (repository impls) must never import this file from the domain layer.
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/core/supabase/supabase_client_provider.dart';
import 'package:opto/core/supabase/supabase_error_mapper.dart';

/// Contract for the auth remote data source.
abstract class AuthRemoteDataSource {
  Future<void> signInWithPassword({
    required String email,
    required String password,
  });

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
  });

  Future<void> signInWithOtp({required String phone});

  Future<void> verifyOtp({required String phone, required String otp});

  Future<void> signOut();

  /// Returns the currently signed-in user, or `null` if no session exists.
  User? get currentUser;

  /// Stream of Supabase auth state changes mapped to a simple boolean:
  /// `true` = signed in, `false` = signed out / session expired.
  Stream<bool> get authStateChanges;
}

// =============================================================================
// IMPLEMENTATION
// =============================================================================

/// Production implementation backed by Supabase Auth.
///
/// All [AuthException]s are mapped to [AuthFailure] via
/// [SupabaseErrorMapper.fromAuth] before being rethrown — keeping typed
/// failures in the Supabase SDK out of higher layers.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  GoTrueClient get _auth => SupabaseClientProvider.client.auth;

  // ── sign in ────────────────────────────────────────────────────────────────

  @override
  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      throw SupabaseErrorMapper.fromAuth(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // ── sign up ────────────────────────────────────────────────────────────────

  /// Signs up a new user and returns the [AuthResponse] so the repository
  /// can upsert the initial `profiles` row using [AuthResponse.user].
  @override
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final response = await _auth.signUp(
        email: email,
        password: password,
        data: fullName != null ? {'full_name': fullName} : null,
      );
      return response;
    } on AuthException catch (e) {
      throw SupabaseErrorMapper.fromAuth(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // ── OTP (phone) ────────────────────────────────────────────────────────────

  @override
  Future<void> signInWithOtp({required String phone}) async {
    try {
      await _auth.signInWithOtp(phone: phone);
    } on AuthException catch (e) {
      throw SupabaseErrorMapper.fromAuth(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> verifyOtp({required String phone, required String otp}) async {
    try {
      await _auth.verifyOTP(
        type: OtpType.sms,
        phone: phone,
        token: otp,
      );
    } on AuthException catch (e) {
      throw SupabaseErrorMapper.fromAuth(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // ── sign out ───────────────────────────────────────────────────────────────

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on AuthException catch (e) {
      throw SupabaseErrorMapper.fromAuth(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // ── session helpers ────────────────────────────────────────────────────────

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Stream<bool> get authStateChanges =>
      _auth.onAuthStateChange.map((event) => event.session != null);
}
