// Extension methods on data-layer models to produce domain entities.
//
// Kept in a separate file so the freezed-generated code does not need to be
// regenerated when entity mapping logic changes.
import 'package:opto/features/prosthetic_hub/data/models/vendor_model.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/vendor_entity.dart';

/// Maps [VendorModel] to the pure-Dart [VendorEntity] used in the domain and
/// presentation layers.
extension VendorModelX on VendorModel {
  VendorEntity toEntity() => VendorEntity(
        id: id,
        name: name,
        isVerified: isVerified,
        clinicId: clinicId,
      );
}
