// Concrete implementation of [AnthropometricRepository].
//
// 🔒 All operations are owner-scoped via RLS + explicit user_id binding.
import 'package:opto/core/constants/prosthetic_enums.dart';
import 'package:opto/features/prosthetic_hub/data/datasources/prosthetic_remote_data_source.dart';
import 'package:opto/features/prosthetic_hub/data/models/anthropometric_model_ext.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/anthropometric_entity.dart';
import 'package:opto/features/prosthetic_hub/domain/repositories/anthropometric_repository.dart';

class AnthropometricRepositoryImpl implements AnthropometricRepository {
  const AnthropometricRepositoryImpl({
    required ProstheticRemoteDataSource remoteDataSource,
  }) : _remote = remoteDataSource;

  final ProstheticRemoteDataSource _remote;

  @override
  Future<AnthropometricEntity?> getMyAnthropometric() async {
    final model = await _remote.getMyAnthropometric();
    return model?.toEntity();
  }

  @override
  Future<void> upsertAnthropometric({
    double? socketSizeMm,
    double? curvature,
    double? irisDiameterMm,
    String? matchedIrisHex,
    required DataSource source,
  }) async {
    final fields = <String, dynamic>{
      'source': source.dbValue,
      'socket_size_mm': ?socketSizeMm,
      'curvature': ?curvature,
      'iris_diameter_mm': ?irisDiameterMm,
      'matched_iris_hex': ?matchedIrisHex,
    };
    await _remote.upsertAnthropometric(fields);
  }
}
