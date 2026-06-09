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

  // ── accessibility_settings ─────────────────────────────────────────────────
  Future<AccessibilitySettingsModel> getSettings(String userId);
  Future<void> upsertSettings(Map<String, dynamic> json);

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
  Future<void> requestLink(Map<String, dynamic> json);
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
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> upsertSettings(Map<String, dynamic> json) async {
    try {
      await _client.from('accessibility_settings').upsert(json);
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
      return (rows as List)
          .map((r) => EmergencyContactModel.fromJson(r as Map<String, dynamic>))
          .toList();
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
      return (rows as List)
          .map((r) => CaregiverLinkModel.fromJson(r as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> requestLink(Map<String, dynamic> json) async {
    try {
      await _client.from('caregiver_links').insert(json);
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
