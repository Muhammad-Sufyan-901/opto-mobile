// Extension methods on data-layer models to produce domain entities.
//
// Kept in a separate file so the freezed-generated code does not need to be
// regenerated when entity mapping logic changes.
import 'package:opto/core/constants/consultation_enums.dart';
import 'package:opto/features/consultation/data/models/consultation_booking_model.dart';
import 'package:opto/features/consultation/domain/entities/consultation_booking_entity.dart';

/// Maps [ConsultationBookingModel] to the pure-Dart [ConsultationBookingEntity]
/// used in the domain and presentation layers.
///
/// The raw Postgres enum strings for [mode] and [status] are converted to
/// typed [ConsultMode] and [BookingStatus] enums via their [fromString]
/// factories.
extension ConsultationBookingModelX on ConsultationBookingModel {
  ConsultationBookingEntity toEntity() => ConsultationBookingEntity(
        id: id,
        userId: userId,
        doctorId: doctorId,
        slotId: slotId,
        mode: ConsultMode.fromString(mode),
        status: BookingStatus.fromString(status),
        bookedViaVoice: bookedViaVoice,
        createdAt: createdAt,
      );
}
