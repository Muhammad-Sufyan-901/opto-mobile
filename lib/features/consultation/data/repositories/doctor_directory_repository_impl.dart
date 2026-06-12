// Concrete implementation of [DoctorDirectoryRepository].
//
// Delegates to [ConsultationRemoteDataSource] for all PostgREST calls.
// Maps data-layer models to domain entities via the `toEntity()` extensions.
import 'package:opto/core/error/failures.dart';
import 'package:opto/features/consultation/data/datasources/consultation_remote_data_source.dart';
import 'package:opto/features/consultation/data/models/clinic_model_ext.dart';
import 'package:opto/features/consultation/data/models/doctor_availability_model_ext.dart';
import 'package:opto/features/consultation/data/models/doctor_model_ext.dart';
import 'package:opto/features/consultation/data/models/eye_care_exercise_model_ext.dart';
import 'package:opto/features/consultation/domain/entities/clinic_entity.dart';
import 'package:opto/features/consultation/domain/entities/doctor_availability_entity.dart';
import 'package:opto/features/consultation/domain/entities/doctor_entity.dart';
import 'package:opto/features/consultation/domain/entities/eye_care_exercise_entity.dart';
import 'package:opto/features/consultation/domain/repositories/doctor_directory_repository.dart';

/// Production implementation of [DoctorDirectoryRepository].
///
/// Failures that escape the data source are already typed [Failure]
/// subclasses — they propagate up to the BLoC, which catches and maps
/// them to error states.
///
/// NOTE on joined fields: [DoctorEntity.fullName], [DoctorEntity.avatarUrl],
/// and [DoctorEntity.clinicName] are null in this implementation because the
/// datasource queries the `doctors` table without a `profiles` or `clinics`
/// join.  These fields will be populated once the datasource query is updated
/// to include a PostgREST embedded-select (e.g.
/// `doctors.select('*, profiles(full_name, avatar_url), clinics(name)')`).
class DoctorDirectoryRepositoryImpl implements DoctorDirectoryRepository {
  DoctorDirectoryRepositoryImpl({
    required ConsultationRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final ConsultationRemoteDataSource _remoteDataSource;

  // ── catalog ────────────────────────────────────────────────────────────────

  @override
  Future<List<DoctorEntity>> searchDoctors({
    String? query,
    String? specialty,
  }) async {
    try {
      final models = await _remoteDataSource.searchDoctors(
        query: query,
        specialty: specialty,
      );
      return models.map((m) => m.toEntity()).toList();
      // NOTE: DoctorEntity joined fields (fullName, avatarUrl, clinicName)
      // are null until the datasource query includes a profiles+clinics join.
    } on Failure {
      rethrow; // already typed
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<DoctorEntity> getDoctor(String doctorId) async {
    try {
      final model = await _remoteDataSource.getDoctorById(doctorId);
      return model.toEntity();
      // NOTE: DoctorEntity joined fields (fullName, avatarUrl, clinicName)
      // are null until the datasource query includes a profiles+clinics join.
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<DoctorAvailabilityEntity>> getAvailability(
    String doctorId,
  ) async {
    try {
      final models = await _remoteDataSource.getAvailability(doctorId);
      return models.map((m) => m.toEntity()).toList();
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<ClinicEntity>> getClinics() async {
    try {
      final models = await _remoteDataSource.getClinics();
      return models.map((m) => m.toEntity()).toList();
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<EyeCareExerciseEntity>> getEyeCareExercises() async {
    try {
      final models = await _remoteDataSource.getEyeCareExercises();
      return models.map((m) => m.toEntity()).toList();
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
