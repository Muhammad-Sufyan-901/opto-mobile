// Extension methods on ProstheticOrderModel to produce domain entities.
import 'package:opto/features/prosthetic_hub/data/models/prosthetic_order_model.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/prosthetic_order_entity.dart';

extension ProstheticOrderModelX on ProstheticOrderModel {
  ProstheticOrderEntity toEntity() => ProstheticOrderEntity(
        id: id,
        userId: userId,
        productId: productId,
        anthropometricId: anthropometricId,
        status: status,
        consentGiven: consentGiven,
        totalIdr: totalIdr,
        createdAt: createdAt,
      );
}
