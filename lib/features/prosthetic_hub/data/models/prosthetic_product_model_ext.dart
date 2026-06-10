// Extension methods on data-layer models to produce domain entities.
//
// Kept in a separate file so the freezed-generated code does not need to be
// regenerated when entity mapping logic changes.
import 'package:opto/features/prosthetic_hub/data/models/prosthetic_product_model.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/prosthetic_product_entity.dart';

/// Maps [ProstheticProductModel] to the pure-Dart [ProstheticProductEntity]
/// used in the domain and presentation layers.
extension ProstheticProductModelX on ProstheticProductModel {
  ProstheticProductEntity toEntity() => ProstheticProductEntity(
        id: id,
        type: type,
        name: name,
        audioDescription: audioDescription,
        material: material,
        irisColor: irisColor,
        size: size,
        isCustom: isCustom,
        priceIdr: priceIdr,
        vendorId: vendorId,
        isActive: isActive,
      );
}
