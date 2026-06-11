// States for [BookingCubit].
//
// Uses `freezed` for immutable, sealed state classes — mirrors
// the pattern in `post_thread_cubit.dart`.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/core/constants/consultation_enums.dart';
import 'package:opto/features/consultation/domain/entities/consultation_booking_entity.dart';
import 'package:opto/features/consultation/domain/entities/doctor_availability_entity.dart';

part 'booking_state.freezed.dart';

@freezed
sealed class BookingState with _$BookingState {
  /// No slot selected; initial state.
  const factory BookingState.initial() = BookingInitial;

  /// Patient has selected a slot and a consult mode but not yet confirmed.
  const factory BookingState.slotSelected({
    required DoctorAvailabilityEntity slot,
    required ConsultMode mode,
  }) = BookingSlotSelected;

  /// Booking submission in flight.
  const factory BookingState.submitting() = BookingSubmitting;

  /// Booking confirmed by the server.
  const factory BookingState.confirmed({
    required ConsultationBookingEntity booking,
  }) = BookingConfirmed;

  /// Patient's full booking list loaded.
  const factory BookingState.bookingsLoaded({
    required List<ConsultationBookingEntity> bookings,
  }) = BookingBookingsLoaded;

  /// A booking operation failed with [message].
  const factory BookingState.error(String message) = BookingError;
}
