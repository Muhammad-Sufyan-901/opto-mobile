// 🔒 MEDICALLY SENSITIVE — Concrete implementation of [ConsultationChatRepository].
//
// Delegates to [ConsultationRemoteDataSource] for all PostgREST / Realtime
// calls on the `consultation_messages` table, which is owner-only (RLS).
// Maps data-layer models to domain entities via the `toEntity()` extension.
//
// SECURITY CONTRACT (mirrors the domain contract):
//   • [ConsultationMessageEntity] data MUST NOT appear in community feeds,
//     map queries, or any public join — ever.
//   • Do not cache responses beyond the lifetime of the current app session.
//   • RLS is the authoritative boundary; the data source adds a client-side
//     auth guard as defence-in-depth only.
import 'package:opto/core/error/failures.dart';
import 'package:opto/features/consultation/data/datasources/consultation_remote_data_source.dart';
import 'package:opto/features/consultation/data/models/consultation_message_model_ext.dart';
import 'package:opto/features/consultation/domain/entities/consultation_message_entity.dart';
import 'package:opto/features/consultation/domain/repositories/consultation_chat_repository.dart';

/// Production implementation of [ConsultationChatRepository].
///
/// 🔒 This implementation surfaces medically sensitive chat messages between
/// a patient and their doctor.  Access is controlled exclusively by Supabase
/// RLS; no client-side access checks substitute for server-enforced policies.
class ConsultationChatRepositoryImpl implements ConsultationChatRepository {
  ConsultationChatRepositoryImpl({
    required ConsultationRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final ConsultationRemoteDataSource _remoteDataSource;

  // ── chat messages 🔒 ───────────────────────────────────────────────────────

  @override
  Stream<List<ConsultationMessageEntity>> watchMessages(String bookingId) {
    return _remoteDataSource.watchMessages(bookingId).map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Future<void> sendMessage({
    required String bookingId,
    required String body,
  }) async {
    try {
      await _remoteDataSource.sendMessage(bookingId: bookingId, body: body);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  String? get currentUserId => _remoteDataSource.currentUserId;
}
