// Extension methods on data-layer models to produce domain entities.
//
// Kept in a separate file so the freezed-generated code does not need to be
// regenerated when entity mapping logic changes.
import 'package:opto/features/profile/data/models/emergency_contact_model.dart';
import 'package:opto/features/profile/domain/entities/emergency_contact_entity.dart';

/// Maps [EmergencyContactModel] to the pure-Dart [EmergencyContactEntity]
/// used in the domain and presentation layers.
extension EmergencyContactModelX on EmergencyContactModel {
  EmergencyContactEntity toEntity() => EmergencyContactEntity(
        id: id,
        userId: userId,
        name: name,
        phone: phone,
        relationship: relationship,
        priority: priority,
      );
}
