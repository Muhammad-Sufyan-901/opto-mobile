// Remote data source for all `profile`-feature tables.
//
// This is the only place in the profile feature that calls
// `SupabaseClientProvider.client` directly.
// Callers (repository impls) must never import this file from the domain layer.
//
// SECURITY NOTES:
// - `emergency_contacts` is owner-only (RLS enforced by Postgres).
//   Never expose these records in community/map/catalog joins.
// - `caregiver_links` is owner-only (RLS enforced by Postgres).
//   Never expose caregiver IDs in community/map surfaces.
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/core/supabase/supabase_client_provider.dart';
import 'package:opto/core/supabase/supabase_error_mapper.dart';
import 'package:opto/features/profile/data/models/accessibility_settings_model.dart';
import 'package:opto/features/profile/data/models/caregiver_link_model.dart';
import 'package:opto/features/profile/data/models/emergency_contact_model.dart';
import 'package:opto/features/profile/data/models/profile_model.dart';

/// Contract for the profile remote data source.
abstract class ProfileRemoteDataSource {
  // ── profiles ──────────────────────────────────────────────────────────────
  Future<ProfileModel> getProfile(String userId);
  Future<void> updateProfile(String userId, Map<String, dynamic> fields);
  Future<void> updateVisionProfile(String dbValue);

  /// Uploads [localPath] to the `avatars` Storage bucket (upsert) and returns
  /// the public URL.  Throws [AuthFailure] if not signed in, [StorageFailure]
  /// on upload error.
  Future<String> uploadAvatar(String localPath);

  // ── accessibility_settings ─────────────────────────────────────────────────
  Future<AccessibilitySettingsModel> getSettings(String userId);
  Future<void> upsertSettings(AccessibilitySettingsModel model);

  // ── emergency_contacts ─────────────────────────────────────────────────────
  Future<List<EmergencyContactModel>> getEmergencyContacts(String userId);
  Future<void> addEmergencyContact(Map<String, dynamic> json);
  Future<void> updateEmergencyContact(
    String contactId,
    Map<String, dynamic> json,
  );
  Future<void> deleteEmergencyContact(String contactId);

  // ── caregiver_links ────────────────────────────────────────────────────────
  Future<List<CaregiverLinkModel>> getCaregiverLinks(String userId);

  /// Inserts a pending caregiver-link row.
  ///
  /// The signed-in user's [SupabaseClient.auth.currentUser] id is used as
  /// `caregiver_id` to satisfy the RLS policy `cl_insert_caregiver`
  /// (`auth.uid() = caregiver_id`).
  Future<void> requestCaregiverLinkFor(String userId);

  Future<void> updateLinkStatus(String linkId, String status);
}

// =============================================================================
// IMPLEMENTATION
// =============================================================================

/// Production implementation backed by Supabase PostgREST.
///
/// All [PostgrestException]s are mapped to [ServerFailure] via
/// [SupabaseErrorMapper.fromPostgrest] before being rethrown.
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  SupabaseClient get _client => SupabaseClientProvider.client;

  // ── profiles ──────────────────────────────────────────────────────────────

  @override
  Future<ProfileModel> getProfile(String userId) async {
    try {
      final row = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return ProfileModel.fromJson(row);
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateProfile(
    String userId,
    Map<String, dynamic> fields,
  ) async {
    try {
      await _client.from('profiles').update(fields).eq('id', userId);
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateVisionProfile(String dbValue) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw const AuthFailure('Not authenticated');
    try {
      await _client
          .from('profiles')
          .update({'vision_profile': dbValue})
          .eq('id', userId);
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<String> uploadAvatar(String localPath) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw const AuthFailure('Not authenticated');
    // Use a fixed path per user so upsert overwrites the previous avatar file
    // rather than accumulating an unbounded number of files in the bucket.
    final ext = localPath.split('.').last.toLowerCase();
    final storagePath = '$userId/avatar.$ext';
    try {
      await _client.storage
          .from('avatars')
          .upload(storagePath, File(localPath),
              fileOptions: const FileOptions(upsert: true));
    } on StorageException catch (e) {
      throw SupabaseErrorMapper.fromStorage(e);
    } catch (e) {
      throw StorageFailure(e.toString());
    }
    return _client.storage.from('avatars').getPublicUrl(storagePath);
  }

  // ── accessibility_settings ─────────────────────────────────────────────────

  @override
  Future<AccessibilitySettingsModel> getSettings(String userId) async {
    try {
      final row = await _client
          .from('accessibility_settings')
          .select()
          .eq('user_id', userId)
          .single();
      return AccessibilitySettingsModel.fromJson(row);
    } on PostgrestException catch (e) {
      // IMPORTANT 2: PGRST116 = no row yet (new user, trigger hasn't committed).
      // Return sensible defaults rather than throwing.
      if (e.code == 'PGRST116') {
        return AccessibilitySettingsModel(userId: userId);
      }
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> upsertSettings(AccessibilitySettingsModel model) async {
    // IMPORTANT 3: strip 'updated_at' from the payload — it is managed by a
    // DB trigger and sending it risks overwriting the trigger's value or
    // causing a permissions error on restricted columns.
    try {
      final payload = model.toJson()..remove('updated_at');
      await _client
          .from('accessibility_settings')
          .upsert(payload, onConflict: 'user_id');
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // ── emergency_contacts ─────────────────────────────────────────────────────

  @override
  Future<List<EmergencyContactModel>> getEmergencyContacts(
    String userId,
  ) async {
    try {
      final rows = await _client
          .from('emergency_contacts')
          .select()
          .eq('user_id', userId)
          .order('priority');
      return rows.map(EmergencyContactModel.fromJson).toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> addEmergencyContact(Map<String, dynamic> json) async {
    try {
      await _client.from('emergency_contacts').insert(json);
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateEmergencyContact(
    String contactId,
    Map<String, dynamic> json,
  ) async {
    try {
      await _client
          .from('emergency_contacts')
          .update(json)
          .eq('id', contactId);
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteEmergencyContact(String contactId) async {
    try {
      await _client
          .from('emergency_contacts')
          .delete()
          .eq('id', contactId);
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // ── caregiver_links ────────────────────────────────────────────────────────

  @override
  Future<List<CaregiverLinkModel>> getCaregiverLinks(String userId) async {
    try {
      final rows = await _client
          .from('caregiver_links')
          .select()
          .or('user_id.eq.$userId,caregiver_id.eq.$userId');
      return rows.map(CaregiverLinkModel.fromJson).toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> requestCaregiverLinkFor(String userId) async {
    // IMPORTANT 5: RLS policy cl_insert_caregiver requires auth.uid() == caregiver_id.
    // Obtain the current user's id from the session and pass it explicitly
    // so the RLS check passes while keeping the server as the ultimate authority.
    final caregiverId = _client.auth.currentUser?.id;
    if (caregiverId == null) throw const AuthFailure('Not authenticated');
    try {
      await _client.from('caregiver_links').insert({
        'user_id': userId,
        'caregiver_id': caregiverId,
        'status': 'pending',
      });
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateLinkStatus(String linkId, String status) async {
    try {
      await _client
          .from('caregiver_links')
          .update({'status': status})
          .eq('id', linkId);
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
