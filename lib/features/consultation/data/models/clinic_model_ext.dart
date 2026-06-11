// Extension methods on data-layer models to produce domain entities.
//
// Kept in a separate file so the freezed-generated code does not need to be
// regenerated when entity mapping logic changes.
import 'package:opto/features/consultation/data/models/clinic_model.dart';
import 'package:opto/features/consultation/domain/entities/clinic_entity.dart';

/// Maps [ClinicModel] to the pure-Dart [ClinicEntity] used in the domain
/// and presentation layers.
extension ClinicModelX on ClinicModel {
  ClinicEntity toEntity() => ClinicEntity(
        id: id,
        name: name,
        isManufacturer: isManufacturer,
        lat: lat,
        lng: lng,
        address: address,
      );
}
