// Domain entity for a consultation booking and its shared enums.
//
// Pure-Dart representation used in use-cases and BLoC states —
// no Supabase / serialisation dependencies.
//
// Corresponds to the `consultation_bookings` table in the Supabase database.
// Enums mirror the Postgres `consult_mode` and `booking_status` custom types.

import 'package:opto/core/constants/consultation_enums.dart';

/// Immutable domain representation of a consultation booking.
///
/// [bookedViaVoice] is a KPI field tracking voice-only booking completions
/// for the Aura Voice accessibility path.
class ConsultationBookingEntity {
  const ConsultationBookingEntity({
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.slotId,
    required this.mode,
    required this.status,
    required this.createdAt,
    this.bookedViaVoice = false,
  });

  /// Primary key (UUID).
  final String id;

  /// UUID of the patient — foreign key to `profiles.id`.
  final String userId;

  /// UUID of the booked doctor — foreign key to `doctors.id`.
  final String doctorId;

  /// UUID of the reserved availability slot — foreign key to
  /// `doctor_availability.id`.
  final String slotId;

  /// Delivery mode chosen by the patient.
  final ConsultMode mode;

  /// Current lifecycle status of the booking.
  final BookingStatus status;

  /// Whether the booking was completed entirely via voice (Aura Voice path).
  /// Used as an accessibility KPI — do not omit from persistence.
  final bool bookedViaVoice;

  /// Timestamp when the booking row was created.
  final DateTime createdAt;

  ConsultationBookingEntity copyWith({
    String? id,
    String? userId,
    String? doctorId,
    String? slotId,
    ConsultMode? mode,
    BookingStatus? status,
    bool? bookedViaVoice,
    DateTime? createdAt,
  }) {
    return ConsultationBookingEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      doctorId: doctorId ?? this.doctorId,
      slotId: slotId ?? this.slotId,
      mode: mode ?? this.mode,
      status: status ?? this.status,
      bookedViaVoice: bookedViaVoice ?? this.bookedViaVoice,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConsultationBookingEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          doctorId == other.doctorId &&
          slotId == other.slotId &&
          mode == other.mode &&
          status == other.status &&
          bookedViaVoice == other.bookedViaVoice &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(
        id,
        userId,
        doctorId,
        slotId,
        mode,
        status,
        bookedViaVoice,
        createdAt,
      );
}
