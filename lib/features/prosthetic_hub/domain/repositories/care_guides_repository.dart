// Abstract repository contract for the Care Guides feature.
//
// Implementations live in `data/repositories/`.

import 'package:opto/features/prosthetic_hub/domain/entities/care_guide.dart';

/// Contract for retrieving prosthetic care guides.
///
/// A mock implementation ([CareGuidesRepositoryMock]) is used during the
/// current development phase. A real Supabase-backed implementation will
/// replace it once the backend table is provisioned.
abstract class CareGuidesRepository {
  /// Returns all available care guides, ordered by [CareGuide.sortOrder].
  Future<List<CareGuide>> getCareGuides();
}
