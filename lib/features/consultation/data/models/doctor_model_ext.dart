// Extension methods on data-layer models to produce domain entities.
//
// Kept in a separate file so the freezed-generated code does not need to be
// regenerated when entity mapping logic changes.
import 'package:opto/features/consultation/data/models/doctor_model.dart';
import 'package:opto/features/consultation/domain/entities/doctor_entity.dart';

/// Maps [DoctorModel] to the pure-Dart [DoctorEntity] used in the domain
/// and presentation layers.
///
/// [fullName], [avatarUrl], and [clinicName] are joined fields not present
/// on the `doctors` row — they are set to null here and populated by the
/// repository implementation after a profile/clinic join.
extension DoctorModelX on DoctorModel {
  DoctorEntity toEntity() => DoctorEntity(
        id: id,
        profileId: profileId,
        specialty: specialty,
        clinicId: clinicId,
        isVerified: isVerified,
        // Joined fields populated at repository level
        fullName: null,
        avatarUrl: null,
        clinicName: null,
      );
}
