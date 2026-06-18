// Extension methods on data-layer models to produce domain entities.
//
// Kept in a separate file so the freezed-generated code does not need to be
// regenerated when entity mapping logic changes.
import 'package:opto/features/profile/data/models/vision_clinical_model.dart';
import 'package:opto/features/profile/domain/entities/vision_clinical_entity.dart';

/// Maps [VisionClinicalModel] to the pure-Dart [VisionClinicalEntity] used in
/// the domain and presentation layers.
extension VisionClinicalModelX on VisionClinicalModel {
  VisionClinicalEntity toEntity() => VisionClinicalEntity(
        userId: userId,
        diagnosis: diagnosis,
        diagnosisSeverity: diagnosisSeverity,
        affectedEyes: affectedEyes,
        diagnosedYear: diagnosedYear,
        lightPerception: lightPerception,
        centralAcuity: centralAcuity,
        visualField: visualField,
        prosthesisEye: prosthesisEye,
        prosthesisType: prosthesisType,
        prosthesisMaterial: prosthesisMaterial,
        prosthesisFittedDate: prosthesisFittedDate,
        prosthesisFittedClinic: prosthesisFittedClinic,
        lastPolishDate: lastPolishDate,
        nextPolishDue: nextPolishDue,
        assistiveTech: assistiveTech,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
