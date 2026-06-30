// Extension methods on [ConsultationMessageModel] to produce domain entities.
//
// Kept in a separate file so the freezed-generated code does not need to be
// regenerated when entity mapping logic changes.
//
// 🔒 MEDICALLY SENSITIVE — maps the `consultation_messages` table DTO.
//    Never use [ConsultationMessageEntity] in community feeds, map queries,
//    or public joins.  Cache only for the duration of the session.
import 'package:opto/features/consultation/data/models/consultation_message_model.dart';
import 'package:opto/features/consultation/domain/entities/consultation_message_entity.dart';

/// Maps [ConsultationMessageModel] to the pure-Dart [ConsultationMessageEntity]
/// used in the domain and presentation layers.
///
/// 🔒 [ConsultationMessageEntity] contains medically sensitive data — access
/// is restricted to the patient and their assigned doctor via RLS.
extension ConsultationMessageModelX on ConsultationMessageModel {
  ConsultationMessageEntity toEntity() => ConsultationMessageEntity(
        id: id,
        bookingId: bookingId,
        senderId: senderId,
        body: body,
        createdAt: createdAt,
      );
}
