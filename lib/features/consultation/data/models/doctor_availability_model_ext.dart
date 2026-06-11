// Extension methods on data-layer models to produce domain entities.
//
// Kept in a separate file so the freezed-generated code does not need to be
// regenerated when entity mapping logic changes.
import 'package:opto/features/consultation/data/models/doctor_availability_model.dart';
import 'package:opto/features/consultation/domain/entities/doctor_availability_entity.dart';

/// Maps [DoctorAvailabilityModel] to the pure-Dart [DoctorAvailabilityEntity]
/// used in the domain and presentation layers.
extension DoctorAvailabilityModelX on DoctorAvailabilityModel {
  DoctorAvailabilityEntity toEntity() => DoctorAvailabilityEntity(
        id: id,
        doctorId: doctorId,
        slotStart: slotStart,
        slotEnd: slotEnd,
        isBooked: isBooked,
      );
}
