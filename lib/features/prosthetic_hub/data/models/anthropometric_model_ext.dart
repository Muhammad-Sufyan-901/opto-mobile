// Extension methods on the data-layer model to produce domain entities.
import 'package:opto/features/prosthetic_hub/data/models/anthropometric_model.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/anthropometric_entity.dart';

/// Maps [AnthropometricModel] → [AnthropometricEntity].
extension AnthropometricModelX on AnthropometricModel {
  AnthropometricEntity toEntity() => AnthropometricEntity(
        id: id,
        userId: userId,
        socketSizeMm: socketSizeMm,
        curvature: curvature,
        irisDiameterMm: irisDiameterMm,
        matchedIrisHex: matchedIrisHex,
        source: source,
        createdAt: createdAt,
      );
}
