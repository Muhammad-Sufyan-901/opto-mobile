// 🔒 MEDICALLY SENSITIVE — Concrete implementation of [ConsultationHistoryRepository].
//
// Delegates to [ConsultationRemoteDataSource] for all PostgREST calls on the
// `consultations` table, which is owner-only (Supabase RLS).
// Maps data-layer models to domain entities via the `toEntity()` extension.
//
// SECURITY CONTRACT (mirrors the domain contract):
//   • [ConsultationEntity] data MUST NOT appear in community feeds, map
//     queries, or any public join — ever.
//   • Do not cache responses beyond the lifetime of the current app session.
//   • RLS is the authoritative boundary; the data source adds a client-side
//     auth guard as defence-in-depth only.
import 'package:opto/core/error/failures.dart';
import 'package:opto/features/consultation/data/datasources/consultation_remote_data_source.dart';
import 'package:opto/features/consultation/data/models/consultation_model_ext.dart';
import 'package:opto/features/consultation/domain/entities/consultation_entity.dart';
import 'package:opto/features/consultation/domain/repositories/consultation_history_repository.dart';

/// Production implementation of [ConsultationHistoryRepository].
///
/// 🔒 This implementation surfaces medically sensitive records — patient
/// summaries, prescriptions, and session recordings.  Access is controlled
/// exclusively by Supabase RLS; no client-side access checks substitute for
/// server-enforced policies.
///
/// READ-ONLY this phase — no write operations are exposed.
///
/// Failures that escape the data source are already typed [Failure]
/// subclasses — they propagate up to the BLoC, which catches and maps
/// them to error states.
class ConsultationHistoryRepositoryImpl
    implements ConsultationHistoryRepository {
  ConsultationHistoryRepositoryImpl({
    required ConsultationRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final ConsultationRemoteDataSource _remoteDataSource;

  // ── history 🔒 ─────────────────────────────────────────────────────────────

  @override
  Future<List<ConsultationEntity>> getMyConsultations() async {
    try {
      final models = await _remoteDataSource.getMyConsultations();
      return models.map((m) => m.toEntity()).toList();
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ConsultationEntity> getConsultation(String bookingId) async {
    try {
      // Domain method name: getConsultation
      // Datasource method name: getConsultationByBookingId
      // This repository bridges the naming gap.
      final model =
          await _remoteDataSource.getConsultationByBookingId(bookingId);
      return model.toEntity();
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
