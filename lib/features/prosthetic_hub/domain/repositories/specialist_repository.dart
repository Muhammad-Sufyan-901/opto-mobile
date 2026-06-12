// Repository contract for the Specialist directory in the Prosthetic Hub.
//
// Implementations live in `data/repositories/`. Feature BLoCs / cubits
// depend on this interface — never on a concrete class.

import 'package:opto/features/prosthetic_hub/domain/entities/specialist.dart';

/// Contract for fetching specialists available for messaging.
abstract class SpecialistRepository {
  /// Returns every specialist in the directory, verified ones first.
  Future<List<Specialist>> getAllSpecialists();

  /// Returns the subset of specialists recommended to this user.
  ///
  /// Currently: verified specialists only.
  Future<List<Specialist>> getRecommendedSpecialists();

  /// Returns a single specialist by [id].
  ///
  /// Throws [StateError] if no specialist with [id] exists.
  Future<Specialist> getSpecialistById(String id);
}
