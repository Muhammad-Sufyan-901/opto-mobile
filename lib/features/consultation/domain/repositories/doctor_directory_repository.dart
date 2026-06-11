// Domain contract for read-only doctor directory and catalog operations.
//
// Implementations live in the data layer
// (`lib/features/consultation/data/repositories/doctor_directory_repository_impl.dart`).
//
// NOTE: No Supabase or infrastructure imports — domain layer stays pure Dart.
import 'package:opto/core/error/failures.dart';
import 'package:opto/features/consultation/domain/entities/clinic_entity.dart';
import 'package:opto/features/consultation/domain/entities/doctor_availability_entity.dart';
import 'package:opto/features/consultation/domain/entities/doctor_entity.dart';
import 'package:opto/features/consultation/domain/entities/eye_care_exercise_entity.dart';

/// Abstract contract for doctor directory and public catalog operations.
///
/// All data exposed by this repository is covered by public-read RLS — no
/// authentication is required to browse doctors, availability, clinics, or
/// exercises.  Write operations are not part of this contract.
///
/// Methods throw [Failure] subclasses on error; the BLoC catches and maps them
/// to error states.
abstract class DoctorDirectoryRepository {
  /// Searches the doctor catalog filtered by an optional [query] (matches
  /// against display name or specialty) and/or an optional [specialty] string.
  ///
  /// Returns all verified and unverified doctors when both parameters are null.
  ///
  /// Throws [ServerFailure] on network / RLS error.
  Future<List<DoctorEntity>> searchDoctors({
    String? query,
    String? specialty,
  });

  /// Fetches a single [DoctorEntity] by its UUID [doctorId].
  ///
  /// Throws [NotFoundFailure] when no doctor exists for [doctorId].
  /// Throws [ServerFailure] on network / RLS error.
  Future<DoctorEntity> getDoctor(String doctorId);

  /// Fetches all future availability slots for the doctor identified by
  /// [doctorId], ordered by [slotStart] ascending.
  ///
  /// Includes both booked and available slots so the caller can present a
  /// complete calendar; UI should visually distinguish [DoctorAvailabilityEntity.isBooked].
  ///
  /// Throws [ServerFailure] on network / RLS error.
  Future<List<DoctorAvailabilityEntity>> getAvailability(String doctorId);

  /// Fetches the full list of clinics and prosthetic manufacturers.
  ///
  /// Both entity types share the `clinics` table; use
  /// [ClinicEntity.isManufacturer] to distinguish them.
  ///
  /// Throws [ServerFailure] on network / RLS error.
  Future<List<ClinicEntity>> getClinics();

  /// Fetches all published eye-care exercises.
  ///
  /// Callers MUST display and read aloud
  /// [EyeCareExerciseEntity.medicalDisclaimer] before starting playback —
  /// this is a patient-safety requirement.
  ///
  /// Throws [ServerFailure] on network / RLS error.
  Future<List<EyeCareExerciseEntity>> getEyeCareExercises();
}
