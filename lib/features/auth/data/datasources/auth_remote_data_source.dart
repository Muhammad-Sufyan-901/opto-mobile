// Remote data source for Supabase Auth operations.
//
// This is the only place in the auth feature that calls
// `SupabaseClientProvider.client.auth` (and `client.from('profiles')`) directly.
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
  ///
  /// The stream seeds with the current session state immediately on
  /// subscription, then emits real-time changes.
  Stream<bool> get authStateChanges;

  /// Reads the `role` column from `profiles` for [userId].
  ///
  /// Returns `null` when the row does not yet exist (e.g. the DB trigger
  /// hasn't committed yet for a brand-new sign-up).
  /// Throws a [Failure] on RLS or network error.
  Future<String?> getRoleForCurrentUser(String userId);

  /// Upserts a minimal `profiles` row for [userId].
  ///
  /// Only `id` (and optionally `full_name`) are written.  `role` is
  /// intentionally omitted so the DB default and `prevent_role_change`
  /// trigger remain the sole authority.
  Future<void> upsertMinimalProfile({required String userId, String? fullName});
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
  SupabaseClient get _client => SupabaseClientProvider.client;

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

  // IMPORTANT 4: seed with the current session state so subscribers get an
  // immediate value before any real-time event fires.
  @override
  Stream<bool> get authStateChanges => Stream.multi((controller) {
        // Emit the current state immediately.
        controller.add(_auth.currentSession != null);
        // Then relay every subsequent auth-state change.
        final sub = _auth.onAuthStateChange
            .map((event) => event.session != null)
            .listen(controller.add, onError: controller.addError);
        controller.onCancel = sub.cancel;
      });

  // ── profiles table helpers ─────────────────────────────────────────────────

  @override
  Future<String?> getRoleForCurrentUser(String userId) async {
    try {
      final data = await _client
          .from('profiles')
          .select('role')
          .eq('id', userId)
          .single();
      return data['role'] as String?;
    } on PostgrestException catch (e) {
      // PGRST116 = no row yet (new user, trigger not yet committed) — not an error.
      if (e.code == 'PGRST116') return null;
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> upsertMinimalProfile({
    required String userId,
    String? fullName,
  }) async {
    try {
      await _client.from('profiles').upsert(
        {
          'id': userId,
          'full_name': ?fullName,
          // DO NOT send 'role' — DB default + prevent_role_change trigger own it.
        },
        onConflict: 'id',
      );
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
