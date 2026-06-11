// Extension methods to convert [AccessibilityPoiModel] → domain entity.
//
// Kept in a separate file so generated code is not invalidated by mapping
// logic changes.
import 'package:opto/features/accessibility_map/data/models/accessibility_poi_model.dart';
import 'package:opto/features/accessibility_map/domain/entities/accessibility_poi_entity.dart';

/// Maps [AccessibilityPoiModel] → [AccessibilityPoiEntity].
///
/// [distanceMeters] is computed client-side after the list is fetched; it
/// is not part of the DB row, so it defaults to null here.
extension AccessibilityPoiModelX on AccessibilityPoiModel {
  AccessibilityPoiEntity toEntity({double? distanceMeters}) =>
      AccessibilityPoiEntity(
        id: id,
        name: name,
        lat: lat,
        lng: lng,
        attributes: attributes,
        verifiedCount: verifiedCount,
        createdBy: createdBy,
        distanceMeters: distanceMeters,
      );
}
