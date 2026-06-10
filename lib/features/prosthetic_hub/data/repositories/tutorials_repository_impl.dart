// Repository implementation for the tutorials domain area.
//
// Delegates all I/O to [ProstheticRemoteDataSource]; maps data-layer models to
// domain entities via the `_ext.dart` extension.
import 'package:opto/core/constants/prosthetic_enums.dart';
import 'package:opto/features/prosthetic_hub/data/datasources/prosthetic_remote_data_source.dart';
import 'package:opto/features/prosthetic_hub/data/models/care_tutorial_model_ext.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/care_tutorial_entity.dart';
import 'package:opto/features/prosthetic_hub/domain/repositories/tutorials_repository.dart';

/// Production [TutorialsRepository] backed by [ProstheticRemoteDataSource].
class TutorialsRepositoryImpl implements TutorialsRepository {
  const TutorialsRepositoryImpl({
    required ProstheticRemoteDataSource remoteDataSource,
  }) : _remote = remoteDataSource;

  final ProstheticRemoteDataSource _remote;

  @override
  Future<List<CareTutorialEntity>> getTutorials({
    TutorialCategory? categoryFilter,
  }) async {
    final models = await _remote.getTutorials(categoryFilter: categoryFilter);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<CareTutorialEntity> getTutorialById(String id) async {
    final model = await _remote.getTutorialById(id);
    return model.toEntity();
  }
}
