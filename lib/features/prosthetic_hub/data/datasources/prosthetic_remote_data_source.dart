// Remote data source for Prosthetic Hub feature tables.
//
// This is the only place in the prosthetic_hub feature that calls
// `SupabaseClientProvider.client` directly.
// Callers (repository impls) must never import this file from the domain layer.
//
// SECURITY NOTES:
// - `anthropometric_data` is owner-only (RLS). Never join into catalog/tutorial selects.
// - `eye_photos` is owner-only (RLS). Reads are via signed URL only.
// - `prosthetic_orders` is owner + caregiver. Never expose sensitive join columns.
// See: https://supabase.com/docs/guides/database/postgres/row-level-security
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:opto/core/constants/prosthetic_enums.dart';
import 'package:opto/core/error/failures.dart';
import 'package:opto/core/supabase/supabase_client_provider.dart';
import 'package:opto/core/supabase/supabase_error_mapper.dart';
import 'package:opto/features/prosthetic_hub/data/models/anthropometric_model.dart';
import 'package:opto/features/prosthetic_hub/data/models/care_tutorial_model.dart';
import 'package:opto/features/prosthetic_hub/data/models/prosthetic_product_model.dart';
import 'package:opto/features/prosthetic_hub/data/models/vendor_model.dart';

// =============================================================================
// ABSTRACT CONTRACT
// =============================================================================

/// Contract for the Prosthetic Hub remote data source.
///
/// Catalog methods are declared here. Additional methods (tutorials,
/// measurements, orders) will be added in subsequent tasks.
abstract class ProstheticRemoteDataSource {
  // ── catalog ───────────────────────────────────────────────────────────────

  /// Returns all active catalog products, with optional filters.
  ///
  /// Selects only explicit, non-sensitive columns — never joins
  /// `anthropometric_data` or `eye_photos`.
  Future<List<ProstheticProductModel>> getProducts({
    ProductType? typeFilter,
    String? irisColorFilter,
    String? sizeFilter,
  });

  /// Returns a single product by [id].
  ///
  /// Throws [ServerFailure('Product not found')] on PGRST116.
  Future<ProstheticProductModel> getProductById(String id);

  /// Returns a vendor by [vendorId], or `null` if PGRST116 is received
  /// (vendor is optional on products).
  Future<VendorModel?> getVendor(String vendorId);

  // ── tutorials ─────────────────────────────────────────────────────────────

  /// Returns all care tutorials, ordered by [sort_order].
  ///
  /// Pass [categoryFilter] to restrict results to a single [TutorialCategory].
  /// Selects only explicit, non-sensitive columns.
  Future<List<CareTutorialModel>> getTutorials({
    TutorialCategory? categoryFilter,
  });

  /// Returns a single tutorial by [id].
  ///
  /// Throws [ServerFailure('Tutorial not found')] on PGRST116.
  Future<CareTutorialModel> getTutorialById(String id);

  // ── anthropometric_data 🔒 ────────────────────────────────────────────────

  /// Returns the current user's measurement record, or `null` if none exists.
  ///
  /// 🔒 Scoped to [auth.currentUser.id] — never expose this in catalog/feed.
  Future<AnthropometricModel?> getMyAnthropometric();

  /// Creates or updates the current user's measurement record.
  ///
  /// 🔒 Inserts with [user_id = auth.uid()] (required by RLS insert policy).
  Future<void> upsertAnthropometric(Map<String, dynamic> fields);
}

// =============================================================================
// IMPLEMENTATION
// =============================================================================

/// Production implementation backed by Supabase PostgREST.
///
/// All [PostgrestException]s are mapped to [ServerFailure] via
/// [SupabaseErrorMapper.fromPostgrest] before being rethrown.
class ProstheticRemoteDataSourceImpl implements ProstheticRemoteDataSource {
  SupabaseClient get _client => SupabaseClientProvider.client;

  /// Explicit column list for `prosthetic_products`.
  ///
  /// NEVER add `anthropometric_data` or `eye_photos` columns here — they are
  /// owner-only (RLS enforced) and medically sensitive.
  static const String _productColumns =
      'id, type, name, audio_description, material, '
      'iris_color, size, is_custom, price_idr, vendor_id, is_active';

  // ── catalog ───────────────────────────────────────────────────────────────

  @override
  Future<List<ProstheticProductModel>> getProducts({
    ProductType? typeFilter,
    String? irisColorFilter,
    String? sizeFilter,
  }) async {
    try {
      var query = _client
          .from('prosthetic_products')
          .select(_productColumns)
          .eq('is_active', true);

      if (typeFilter != null) {
        query = query.eq('type', typeFilter.dbValue);
      }
      if (irisColorFilter != null) {
        query = query.eq('iris_color', irisColorFilter);
      }
      if (sizeFilter != null) {
        query = query.eq('size', sizeFilter);
      }

      final rows = await query;
      return rows
          .map((row) => ProstheticProductModel.fromJson(row))
          .toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ProstheticProductModel> getProductById(String id) async {
    try {
      final row = await _client
          .from('prosthetic_products')
          .select(_productColumns)
          .eq('is_active', true)
          .eq('id', id)
          .single();
      return ProstheticProductModel.fromJson(row);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw const ServerFailure('Product not found');
      }
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      if (e is ServerFailure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  /// Explicit column list for `care_tutorials`.
  ///
  /// Public read (no sensitive joins).
  static const String _tutorialColumns =
      'id, title, category, video_path, audio_narration_path, '
      'transcript, sort_order';

  // ── tutorials ─────────────────────────────────────────────────────────────

  @override
  Future<List<CareTutorialModel>> getTutorials({
    TutorialCategory? categoryFilter,
  }) async {
    try {
      // Build filter query first (PostgrestFilterBuilder), then apply order.
      // .order() returns a PostgrestTransformBuilder which no longer accepts .eq().
      var filterQuery = _client
          .from('care_tutorials')
          .select(_tutorialColumns);

      if (categoryFilter != null) {
        filterQuery = filterQuery.eq('category', categoryFilter.dbValue);
      }

      final rows = await filterQuery.order('sort_order');
      return rows.map((row) => CareTutorialModel.fromJson(row)).toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<CareTutorialModel> getTutorialById(String id) async {
    try {
      final row = await _client
          .from('care_tutorials')
          .select(_tutorialColumns)
          .eq('id', id)
          .single();
      return CareTutorialModel.fromJson(row);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw const ServerFailure('Tutorial not found');
      }
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      if (e is ServerFailure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<VendorModel?> getVendor(String vendorId) async {
    try {
      final row = await _client
          .from('vendors')
          .select('id, name, is_verified, clinic_id')
          .eq('id', vendorId)
          .single();
      return VendorModel.fromJson(row);
    } on PostgrestException catch (e) {
      // PGRST116 = no row — vendor is optional, return null gracefully.
      if (e.code == 'PGRST116') return null;
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  /// Explicit column list for `anthropometric_data`.
  ///
  /// 🔒 NEVER embed these columns in catalog, vendor, or tutorial selects.
  static const String _anthropometricColumns =
      'id, user_id, socket_size_mm, curvature, iris_diameter_mm, '
      'matched_iris_hex, source, created_at';

  // ── anthropometric_data 🔒 ────────────────────────────────────────────────

  @override
  Future<AnthropometricModel?> getMyAnthropometric() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw const AuthFailure('Not authenticated');
    try {
      final row = await _client
          .from('anthropometric_data')
          .select(_anthropometricColumns)
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();
      if (row == null) return null;
      return AnthropometricModel.fromJson(row);
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> upsertAnthropometric(Map<String, dynamic> fields) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw const AuthFailure('Not authenticated');
    // Ensure user_id is always set from the session — client cannot spoof it.
    final payload = {...fields, 'user_id': userId};
    try {
      await _client
          .from('anthropometric_data')
          .upsert(payload, onConflict: 'user_id');
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw ServerFailure(e.toString());
    }
  }
}
