// Extension methods on data-layer models to produce domain entities.
//
// Kept in a separate file so the freezed-generated code does not need to be
// regenerated when entity mapping logic changes.
//
// 🔒 MEDICALLY SENSITIVE — this ext file maps the `consultations` table DTO.
//    Never use [ConsultationEntity] in community feeds, map queries, or public
//    joins.  Cache only for the duration of the session.
import 'package:opto/features/consultation/data/models/consultation_model.dart';
import 'package:opto/features/consultation/domain/entities/consultation_entity.dart';

/// Maps [ConsultationModel] to the pure-Dart [ConsultationEntity] used in the
/// domain and presentation layers.
///
/// 🔒 [ConsultationEntity] contains medically sensitive data — access is
/// restricted to the patient and their assigned doctor via RLS.
extension ConsultationModelX on ConsultationModel {
  ConsultationEntity toEntity() => ConsultationEntity(
        id: id,
        bookingId: bookingId,
        summary: summary,
        prescription: prescription,
        recordingPath: recordingPath,
        createdAt: createdAt,
      );
}
