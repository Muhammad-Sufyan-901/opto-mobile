// Remote data source for the Accessibility Map feature tables.
//
// This is the ONLY place in the accessibility_map feature that calls
// `SupabaseClientProvider.client` directly.
// Callers (repository impls) must never import this file from the domain layer.
//
// SECURITY NOTES:
// - `accessibility_pois` is public-read (RLS). Use an EXPLICIT column list
//   and NEVER join `anthropometric_data`, `eye_photos`, `consultations`, or
//   `sos_events` into any select here.
// - `poi_contributions` rows are contributor + moderator scoped (RLS).
//   user_id is always stamped from auth.currentUser.id — never from client input.
// - `verified_count` on `accessibility_pois` has NO documented update policy;
//   increment is handled server-side (trigger/RPC). NEVER directly update it.
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/core/supabase/supabase_client_provider.dart';
import 'package:opto/core/supabase/supabase_error_mapper.dart';
import 'package:opto/features/accessibility_map/data/models/accessibility_poi_model.dart';
import 'package:opto/features/accessibility_map/data/models/poi_contribution_model.dart';

// =============================================================================
// ABSTRACT CONTRACT
// =============================================================================

/// Contract for the Accessibility Map remote data source.
abstract class MapRemoteDataSource {
  // ── accessibility_pois ────────────────────────────────────────────────────

  /// Returns POIs within a bounding box defined by [minLat]/[maxLat]/[minLng]/[maxLng].
  ///
  /// Selects only [_poiColumns]. NEVER joins 🔒 tables.
  Future<List<AccessibilityPoiModel>> getPoisInBounds({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
  });

  /// Returns all POIs, ordered by name (fallback when location is unavailable).
  Future<List<AccessibilityPoiModel>> getAllPois();

  /// Returns a single POI by [id].
  ///
  /// Throws [ServerFailure('POI not found')] on PGRST116.
  Future<AccessibilityPoiModel> getPoiById(String id);

  /// Inserts a new POI row for the current authenticated user.
  ///
  /// [created_by] is always set from [auth.currentUser.id] — never from [fields].
  Future<AccessibilityPoiModel> insertPoi({
    required String name,
    required double lat,
    required double lng,
    required Map<String, dynamic> attributes,
  });

  // ── poi_contributions ─────────────────────────────────────────────────────

  /// Inserts a contribution row for [poiId] by the current user.
  ///
  /// [change] is `{}` for a plain verification; a non-empty map for
  /// suggest-edit. [status] is always 'pending' on insert.
  Future<PoiContributionModel> insertContribution({
    required String poiId,
    required Map<String, dynamic> change,
  });

  /// Returns all contribution rows for the current user.
  Future<List<PoiContributionModel>> getMyContributions();
}

// =============================================================================
// IMPLEMENTATION
// =============================================================================

/// Production implementation backed by Supabase PostgREST.
///
/// All [PostgrestException]s are mapped to [ServerFailure] via
/// [SupabaseErrorMapper.fromPostgrest] before being rethrown.
class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  SupabaseClient get _client => SupabaseClientProvider.client;

  /// Explicit column list for `accessibility_pois`.
  ///
  /// NEVER add anthropometric_data, eye_photos, consultations, or sos_events
  /// columns to this list — they are owner-only (RLS) and medically sensitive.
  static const String _poiColumns =
      'id, name, lat, lng, attributes, verified_count, created_by';

  /// Explicit column list for `poi_contributions`.
  static const String _contributionColumns =
      'id, poi_id, user_id, change, status, created_at';

  // ── accessibility_pois ────────────────────────────────────────────────────

  @override
  Future<List<AccessibilityPoiModel>> getPoisInBounds({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
  }) async {
    try {
      final rows = await _client
          .from('accessibility_pois')
          .select(_poiColumns)
          .gte('lat', minLat)
          .lte('lat', maxLat)
          .gte('lng', minLng)
          .lte('lng', maxLng);
      return rows.map((r) => AccessibilityPoiModel.fromJson(r)).toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<AccessibilityPoiModel>> getAllPois() async {
    try {
      final rows = await _client
          .from('accessibility_pois')
          .select(_poiColumns)
          .order('name');
      return rows.map((r) => AccessibilityPoiModel.fromJson(r)).toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<AccessibilityPoiModel> getPoiById(String id) async {
    try {
      final row = await _client
          .from('accessibility_pois')
          .select(_poiColumns)
          .eq('id', id)
          .single();
      return AccessibilityPoiModel.fromJson(row);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw const ServerFailure('POI not found');
      }
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      if (e is ServerFailure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<AccessibilityPoiModel> insertPoi({
    required String name,
    required double lat,
    required double lng,
    required Map<String, dynamic> attributes,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw const AuthFailure('Not authenticated');
    try {
      final row = await _client
          .from('accessibility_pois')
          .insert({
            'name': name,
            'lat': lat,
            'lng': lng,
            'attributes': attributes,
            // created_by is stamped from the session — client cannot spoof it.
            'created_by': userId,
          })
          .select(_poiColumns)
          .single();
      return AccessibilityPoiModel.fromJson(row);
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  // ── poi_contributions ─────────────────────────────────────────────────────

  @override
  Future<PoiContributionModel> insertContribution({
    required String poiId,
    required Map<String, dynamic> change,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw const AuthFailure('Not authenticated');
    try {
      final row = await _client
          .from('poi_contributions')
          .insert({
            'poi_id': poiId,
            'user_id': userId,
            'change': change,
            'status': 'pending',
          })
          .select(_contributionColumns)
          .single();
      return PoiContributionModel.fromJson(row);
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<PoiContributionModel>> getMyContributions() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw const AuthFailure('Not authenticated');
    try {
      final rows = await _client
          .from('poi_contributions')
          .select(_contributionColumns)
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return rows.map((r) => PoiContributionModel.fromJson(r)).toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw ServerFailure(e.toString());
    }
  }
}
