// Remote data source for all `consultation`-feature tables.
//
// This is the ONLY place in the consultation feature that calls
// `SupabaseClientProvider.client` directly.
// Callers (repository impls) must never import this file from the domain layer.
//
// SECURITY NOTES:
// - Never join 🔒 tables (anthropometric_data, eye_photos, consultations,
//   sos_events) into catalog or availability queries here.
// - Doctor display name / avatar comes ONLY from the `profiles` table join and
//   is populated at the REPOSITORY level, not inside this data source.
// - Use only `SupabaseClientProvider.client` — never `Supabase.instance.client`
//   directly.
// - `consultations` 🔒 methods are at the END of this file — treat them with
//   extra care.
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/core/supabase/supabase_client_provider.dart';
import 'package:opto/core/supabase/supabase_error_mapper.dart';
import 'package:opto/features/consultation/data/models/clinic_model.dart';
import 'package:opto/features/consultation/data/models/consultation_booking_model.dart';
import 'package:opto/features/consultation/data/models/consultation_model.dart';
import 'package:opto/features/consultation/data/models/doctor_availability_model.dart';
import 'package:opto/features/consultation/data/models/doctor_model.dart';
import 'package:opto/features/consultation/data/models/eye_care_exercise_model.dart';

/// Contract for the consultation remote data source.
abstract class ConsultationRemoteDataSource {
  // CATALOG ─────────────────────────────────────────────────────────────────────
  Future<List<ClinicModel>> getClinics();
  Future<List<DoctorModel>> searchDoctors({String? query, String? specialty});
  Future<DoctorModel> getDoctorById(String doctorId);
  Future<List<DoctorAvailabilityModel>> getAvailability(String doctorId);
  Future<List<EyeCareExerciseModel>> getEyeCareExercises();

  // BOOKING ─────────────────────────────────────────────────────────────────────
  Future<ConsultationBookingModel> createBooking({
    required String doctorId,
    required String slotId,
    required String mode,
    required bool bookedViaVoice,
  });
  Future<List<ConsultationBookingModel>> getMyBookings();
  Future<void> cancelBooking(String bookingId);

  // CONSULTATION HISTORY 🔒 ─────────────────────────────────────────────────────
  Future<List<ConsultationModel>> getMyConsultations();
  Future<ConsultationModel> getConsultationByBookingId(String bookingId);
}

// =============================================================================
// IMPLEMENTATION
// =============================================================================

/// Production implementation backed by Supabase PostgREST.
///
/// All [PostgrestException]s are mapped to typed [Failure]s via
/// [SupabaseErrorMapper.fromPostgrest] before being rethrown.
class ConsultationRemoteDataSourceImpl implements ConsultationRemoteDataSource {
  SupabaseClient get _client => SupabaseClientProvider.client;

  // CATALOG ─────────────────────────────────────────────────────────────────────

  @override
  Future<List<ClinicModel>> getClinics() async {
    try {
      final rows = await _client.from('clinics').select();
      return rows.map(ClinicModel.fromJson).toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<DoctorModel>> searchDoctors({
    String? query,
    String? specialty,
  }) async {
    try {
      var builder = _client.from('doctors').select().eq('is_verified', true);
      if (query != null) {
        builder = builder.ilike('specialty', '%$query%');
      }
      if (specialty != null) {
        builder = builder.eq('specialty', specialty);
      }
      final rows = await builder;
      return rows.map(DoctorModel.fromJson).toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<DoctorModel> getDoctorById(String doctorId) async {
    try {
      final row = await _client
          .from('doctors')
          .select()
          .eq('id', doctorId)
          .single();
      return DoctorModel.fromJson(row);
    } on PostgrestException catch (e) {
      // PGRST116 — no rows returned — already mapped to NotFoundFailure by the
      // error mapper; re-throw whatever the mapper produces.
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<DoctorAvailabilityModel>> getAvailability(
    String doctorId,
  ) async {
    try {
      final rows = await _client
          .from('doctor_availability')
          .select()
          .eq('doctor_id', doctorId)
          .gte('slot_start', DateTime.now().toUtc().toIso8601String())
          .order('slot_start');
      return rows.map(DoctorAvailabilityModel.fromJson).toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<EyeCareExerciseModel>> getEyeCareExercises() async {
    try {
      final rows = await _client
          .from('eye_care_exercises')
          .select()
          .order('title');
      return rows.map(EyeCareExerciseModel.fromJson).toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // BOOKING ─────────────────────────────────────────────────────────────────────

  @override
  Future<ConsultationBookingModel> createBooking({
    required String doctorId,
    required String slotId,
    required String mode,
    required bool bookedViaVoice,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const AuthFailure('Sesi tidak ditemukan. Silakan masuk kembali.');
    }
    try {
      final row = await _client
          .from('consultation_bookings')
          .insert({
            'user_id': userId,
            'doctor_id': doctorId,
            'slot_id': slotId,
            'mode': mode,
            'booked_via_voice': bookedViaVoice,
          })
          .select()
          .single();
      return ConsultationBookingModel.fromJson(row);
    } on PostgrestException catch (e) {
      // 23505: unique violation — slot already taken by another patient.
      if (e.code == '23505') {
        throw const ConflictFailure('Slot sudah dipesan oleh pasien lain.');
      }
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<ConsultationBookingModel>> getMyBookings() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const AuthFailure('Sesi tidak ditemukan. Silakan masuk kembali.');
    }
    try {
      final rows = await _client
          .from('consultation_bookings')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return rows.map(ConsultationBookingModel.fromJson).toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const AuthFailure('Sesi tidak ditemukan. Silakan masuk kembali.');
    }
    try {
      // The `user_id` filter is a client-side defence-in-depth guard;
      // RLS on `consultation_bookings` is the authoritative boundary.
      await _client
          .from('consultation_bookings')
          .update({'status': 'cancelled'})
          .eq('id', bookingId)
          .eq('user_id', userId);
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // CONSULTATION HISTORY 🔒 ─────────────────────────────────────────────────────
  // These methods touch the `consultations` table which is owner-only (RLS).
  // Never reference this table from catalog, map, or community queries.

  @override
  Future<List<ConsultationModel>> getMyConsultations() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const AuthFailure('Sesi tidak ditemukan. Silakan masuk kembali.');
    }
    try {
      // RLS on `consultations` ensures only the authenticated patient's rows
      // are returned — no explicit `eq('user_id', ...)` filter is required,
      // but the auth guard above ensures we never execute this unauthenticated.
      final rows = await _client
          .from('consultations')
          .select()
          .order('created_at', ascending: false);
      return rows.map(ConsultationModel.fromJson).toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ConsultationModel> getConsultationByBookingId(
    String bookingId,
  ) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const AuthFailure('Sesi tidak ditemukan. Silakan masuk kembali.');
    }
    try {
      final row = await _client
          .from('consultations')
          .select()
          .eq('booking_id', bookingId)
          .single();
      return ConsultationModel.fromJson(row);
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
