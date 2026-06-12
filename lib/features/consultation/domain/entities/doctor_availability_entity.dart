// Domain entity for a bookable time slot offered by a doctor.
//
// Pure-Dart representation used in use-cases and BLoC states —
// no Supabase / serialisation dependencies.
//
// Corresponds to the `doctor_availability` table in the Supabase database.

/// Immutable domain representation of a single bookable availability slot.
///
/// [slotStart] and [slotEnd] are UTC timestamps; present these to the user
/// in their local time zone using `DateTime.toLocal()`.
class DoctorAvailabilityEntity {
  const DoctorAvailabilityEntity({
    required this.id,
    required this.doctorId,
    required this.slotStart,
    required this.slotEnd,
    this.isBooked = false,
  });

  /// Primary key (UUID).
  final String id;

  /// UUID of the doctor who owns this slot — foreign key to `doctors.id`.
  final String doctorId;

  /// Start of the bookable time window (UTC).
  final DateTime slotStart;

  /// End of the bookable time window (UTC).
  final DateTime slotEnd;

  /// Whether this slot has already been claimed by a booking.
  final bool isBooked;

  DoctorAvailabilityEntity copyWith({
    String? id,
    String? doctorId,
    DateTime? slotStart,
    DateTime? slotEnd,
    bool? isBooked,
  }) {
    return DoctorAvailabilityEntity(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      slotStart: slotStart ?? this.slotStart,
      slotEnd: slotEnd ?? this.slotEnd,
      isBooked: isBooked ?? this.isBooked,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorAvailabilityEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          doctorId == other.doctorId &&
          slotStart == other.slotStart &&
          slotEnd == other.slotEnd &&
          isBooked == other.isBooked;

  @override
  int get hashCode =>
      Object.hash(id, doctorId, slotStart, slotEnd, isBooked);
}
