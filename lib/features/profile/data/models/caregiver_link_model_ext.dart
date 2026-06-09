// Extension methods on data-layer models to produce domain entities.
//
// Kept in a separate file so the freezed-generated code does not need to be
// regenerated when entity mapping logic changes.
import 'package:opto/features/profile/data/models/caregiver_link_model.dart';
import 'package:opto/features/profile/domain/entities/caregiver_link_entity.dart';

/// Maps [CaregiverLinkModel] to the pure-Dart [CaregiverLinkEntity] used in
/// the domain and presentation layers.
extension CaregiverLinkModelX on CaregiverLinkModel {
  CaregiverLinkEntity toEntity() => CaregiverLinkEntity(
        id: id,
        userId: userId,
        caregiverId: caregiverId,
        status: status,
        permissions: permissions,
        createdAt: createdAt,
      );
}
