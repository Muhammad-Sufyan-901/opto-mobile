// Cubit for emergency contacts management.
//
// Owns the list of [EmergencyContactEntity] for the current user and exposes
// load / add / update / delete operations.  All repository calls throw typed
// [Failure] subclasses on error; the cubit maps them to [EmergencyContactsError].
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/profile/domain/entities/emergency_contact_entity.dart';
import 'package:opto/features/profile/domain/repositories/emergency_contact_repository.dart';

// ── States ────────────────────────────────────────────────────────────────────

sealed class EmergencyContactsState {}

class EmergencyContactsInitial extends EmergencyContactsState {}

class EmergencyContactsLoading extends EmergencyContactsState {}

class EmergencyContactsLoaded extends EmergencyContactsState {
  EmergencyContactsLoaded(this.contacts);
  final List<EmergencyContactEntity> contacts;
}

class EmergencyContactsError extends EmergencyContactsState {
  EmergencyContactsError(this.message);
  final String message;
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

/// Manages [EmergencyContactsState] for the emergency contacts screen.
///
/// Call [load] once (with the current user's id) when the screen mounts.
/// Subsequent [add], [update], and [delete] operations automatically reload
/// the full list so the UI stays in sync with the server.
class EmergencyContactsCubit extends Cubit<EmergencyContactsState> {
  final EmergencyContactRepository _repo;

  /// Cached userId from the first [load] call, reused by mutation methods.
  String? _userId;

  EmergencyContactsCubit(this._repo) : super(EmergencyContactsInitial());

  // ── LOAD ───────────────────────────────────────────────────────────────────

  /// Fetches all emergency contacts for [userId] ordered by priority.
  ///
  /// Emits [EmergencyContactsLoading] then [EmergencyContactsLoaded] on
  /// success, or [EmergencyContactsError] on failure.
  Future<void> load(String userId) async {
    _userId = userId;
    emit(EmergencyContactsLoading());
    try {
      final contacts = await _repo.getContacts(userId);
      emit(EmergencyContactsLoaded(contacts));
    } on Failure catch (f) {
      emit(EmergencyContactsError(f.message));
    } catch (e) {
      debugPrint('EmergencyContactsCubit.load: unexpected error — $e');
      emit(EmergencyContactsError('Failed to load emergency contacts.'));
    }
  }

  // ── ADD ────────────────────────────────────────────────────────────────────

  /// Inserts [contact] and reloads the list on success.
  ///
  /// On failure emits [EmergencyContactsError] then restores the previous list.
  Future<void> add(EmergencyContactEntity contact) async {
    final previous = state;
    try {
      await _repo.addContact(contact);
      await _reload();
    } on Failure catch (f) {
      emit(EmergencyContactsError(f.message));
      emit(previous);
    } catch (e) {
      debugPrint('EmergencyContactsCubit.add: unexpected error — $e');
      emit(EmergencyContactsError('Failed to add contact.'));
      emit(previous);
    }
  }

  // ── UPDATE ─────────────────────────────────────────────────────────────────

  /// Updates [contact] (matched by id) and reloads the list on success.
  Future<void> update(EmergencyContactEntity contact) async {
    final previous = state;
    try {
      await _repo.updateContact(contact);
      await _reload();
    } on Failure catch (f) {
      emit(EmergencyContactsError(f.message));
      emit(previous);
    } catch (e) {
      debugPrint('EmergencyContactsCubit.update: unexpected error — $e');
      emit(EmergencyContactsError('Failed to update contact.'));
      emit(previous);
    }
  }

  // ── DELETE ─────────────────────────────────────────────────────────────────

  /// Deletes the contact identified by [contactId] and reloads the list.
  Future<void> delete(String contactId) async {
    final previous = state;
    try {
      await _repo.deleteContact(contactId);
      await _reload();
    } on Failure catch (f) {
      emit(EmergencyContactsError(f.message));
      emit(previous);
    } catch (e) {
      debugPrint('EmergencyContactsCubit.delete: unexpected error — $e');
      emit(EmergencyContactsError('Failed to delete contact.'));
      emit(previous);
    }
  }

  // ── INTERNAL ───────────────────────────────────────────────────────────────

  Future<void> _reload() async {
    final uid = _userId;
    if (uid == null) return;
    final contacts = await _repo.getContacts(uid);
    emit(EmergencyContactsLoaded(contacts));
  }
}
