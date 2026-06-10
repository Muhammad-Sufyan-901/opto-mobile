// Domain-layer contract for care tutorial read operations.
//
// Depends only on pure-Dart entities and enums — no Supabase or data-layer
// imports allowed here.
import 'package:opto/core/constants/prosthetic_enums.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/care_tutorial_entity.dart';

/// Read-only tutorials repository contract.
///
/// Implementations live in `data/repositories/tutorials_repository_impl.dart`.
/// BLoC/cubit classes depend on this abstract contract — never on the
/// implementation class — so the data source can be swapped without touching
/// the presentation layer.
abstract class TutorialsRepository {
  /// Returns all care tutorials, with an optional [categoryFilter].
  ///
  /// Results are ordered by `sort_order` ascending.
  /// Throws a [Failure] on network / RLS / parse errors.
  Future<List<CareTutorialEntity>> getTutorials({
    TutorialCategory? categoryFilter,
  });

  /// Returns a single tutorial by [id].
  ///
  /// Throws [ServerFailure('Tutorial not found')] when no row matches.
  Future<CareTutorialEntity> getTutorialById(String id);
}
