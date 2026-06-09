// BLoC for authentication — sits between [AuthRepository] and the auth screens.
//
// Subscribes to [AuthRepository.isAuthenticated] to react to session changes
// (deep-link sign-ins, token refresh failures, etc.) and maps user-dispatched
// events to repository calls + corresponding states.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/auth/domain/repositories/auth_repository.dart';
import 'package:opto/features/auth/presentation/bloc/auth_event.dart';
import 'package:opto/features/auth/presentation/bloc/auth_state.dart';

export 'auth_event.dart';
export 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _auth;
  StreamSubscription<bool>? _authSub;

  AuthBloc(this._auth) : super(const AuthState.initial()) {
    // Mirror Supabase session changes into the BLoC event queue so that
    // deep-link sign-ins and token-expiry sign-outs are handled automatically.
    _authSub = _auth.isAuthenticated.listen(
      (isAuthenticated) {
        add(AuthEvent.authStateChanged(isAuthenticated: isAuthenticated));
      },
      onError: (Object error) {
        debugPrint('AuthBloc: auth stream error — $error');
      },
    );

    on<SignInWithEmailPassword>(_onSignInWithEmailPassword);
    on<SignUp>(_onSignUp);
    on<RequestOtp>(_onRequestOtp);
    on<VerifyOtp>(_onVerifyOtp);
    on<SignOut>(_onSignOut);
    on<AuthStateChanged>(_onAuthStateChanged);
  }

  // ---------------------------------------------------------------------------
  // HANDLERS
  // ---------------------------------------------------------------------------

  Future<void> _onSignInWithEmailPassword(
    SignInWithEmailPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      await _auth.signInWithPassword(
        email: event.email,
        password: event.password,
      );
      // Authenticated state is emitted by _onAuthStateChanged once the
      // Supabase session stream fires — no need to emit here.
    } on Failure catch (f) {
      emit(AuthState.error(message: f.message));
    } catch (e) {
      emit(const AuthState.error(message: 'An unexpected error occurred.'));
    }
  }

  Future<void> _onSignUp(
    SignUp event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      await _auth.signUp(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
      );
      // Authenticated state follows from _onAuthStateChanged.
    } on Failure catch (f) {
      emit(AuthState.error(message: f.message));
    } catch (e) {
      emit(const AuthState.error(message: 'An unexpected error occurred.'));
    }
  }

  Future<void> _onRequestOtp(
    RequestOtp event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      await _auth.signInWithOtp(phone: event.phone);
      emit(AuthState.otpSent(phone: event.phone));
    } on Failure catch (f) {
      emit(AuthState.error(message: f.message));
    } catch (e) {
      emit(const AuthState.error(message: 'An unexpected error occurred.'));
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtp event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      await _auth.verifyOtp(phone: event.phone, otp: event.otp);
      // Authenticated state follows from _onAuthStateChanged.
    } on Failure catch (f) {
      emit(AuthState.error(message: f.message));
    } catch (e) {
      emit(const AuthState.error(message: 'An unexpected error occurred.'));
    }
  }

  Future<void> _onSignOut(
    SignOut event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      await _auth.signOut();
      // Unauthenticated state follows from _onAuthStateChanged.
    } on Failure catch (f) {
      emit(AuthState.error(message: f.message));
    } catch (e) {
      emit(const AuthState.error(message: 'An unexpected error occurred.'));
    }
  }

  void _onAuthStateChanged(
    AuthStateChanged event,
    Emitter<AuthState> emit,
  ) {
    if (event.isAuthenticated) {
      emit(const AuthState.authenticated());
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  // ---------------------------------------------------------------------------
  // LIFECYCLE
  // ---------------------------------------------------------------------------

  @override
  Future<void> close() {
    _authSub?.cancel();
    return super.close();
  }
}
