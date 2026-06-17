// Cubit for the consultation booking flow — slot selection, submission,
// booking list, and cancellation.
//
// State is defined in `booking_state.dart` using `freezed` to match the
// project convention (see `post_thread_cubit.dart`).
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/constants/consultation_enums.dart';
import 'package:opto/core/error/failures.dart';
import 'package:opto/features/consultation/domain/entities/doctor_availability_entity.dart';
import 'package:opto/features/consultation/domain/repositories/booking_repository.dart';
import 'package:opto/features/consultation/presentation/cubit/booking_state.dart';

export 'booking_state.dart';

/// Cubit that drives the consultation booking flow.
///
/// Responsibilities:
/// - Slot selection via [selectSlot].
/// - Booking confirmation via [confirmBooking] — submits to
///   [BookingRepository.createBooking] and emits [BookingConfirmed] on
///   success. On failure the error state is emitted then immediately reverted
///   to [BookingSlotSelected] so the user can retry without losing their
///   slot selection.
/// - Booking list via [loadMyBookings] — emits [BookingBookingsLoaded].
/// - Cancellation via [cancelBooking].
/// - Reset via [reset] — returns to [BookingInitial].
///
/// [bookedViaVoice] is forwarded to the repository as an accessibility KPI —
/// set it to `true` when the entire booking flow was completed via Aura Voice.
class BookingCubit extends Cubit<BookingState> {
  BookingCubit(this._bookingRepo) : super(const BookingState.initial());

  final BookingRepository _bookingRepo;

  // ---------------------------------------------------------------------------
  // PUBLIC API
  // ---------------------------------------------------------------------------

  /// Records the selected [slot] and [mode] without submitting.
  ///
  /// Transitions to [BookingSlotSelected].  Call [confirmBooking] afterward
  /// to actually create the booking.
  void selectSlot(
    DoctorAvailabilityEntity slot, {
    ConsultMode mode = ConsultMode.video,
  }) {
    emit(BookingState.slotSelected(slot: slot, mode: mode));
  }

  /// Creates the booking for the slot captured by [selectSlot].
  ///
  /// No-op when the current state is not [BookingSlotSelected].
  ///
  /// [doctorId] — UUID of the doctor being booked.
  /// [bookedViaVoice] — pass `true` when booked via Aura Voice (KPI field).
  Future<void> confirmBooking({
    required String doctorId,
    bool bookedViaVoice = false,
  }) async {
    final current = state;
    if (current is! BookingSlotSelected) return;

    emit(const BookingState.submitting());
    try {
      final booking = await _bookingRepo.createBooking(
        doctorId: doctorId,
        slotStart: current.slot.slotStart,
        mode: current.mode,
        bookedViaVoice: bookedViaVoice,
      );
      emit(BookingState.confirmed(booking: booking));
    } on Failure catch (e) {
      emit(BookingState.error(e.message));
      // Revert to slot selected so the user can retry without re-selecting.
      // Guard: cubit may have been closed (screen popped) before the revert emit.
      if (!isClosed) {
        emit(BookingState.slotSelected(slot: current.slot, mode: current.mode));
      }
    } catch (_) {
      emit(BookingState.error('Terjadi kesalahan. Silakan coba lagi.'));
      // Guard: cubit may have been closed (screen popped) before the revert emit.
      if (!isClosed) {
        emit(BookingState.slotSelected(slot: current.slot, mode: current.mode));
      }
    }
  }

  /// Loads all bookings for the currently signed-in patient.
  ///
  /// Emits [BookingBookingsLoaded] on success.
  Future<void> loadMyBookings() async {
    try {
      final bookings = await _bookingRepo.getMyBookings();
      emit(BookingState.bookingsLoaded(bookings: bookings));
    } on Failure catch (e) {
      emit(BookingState.error(e.message));
    } catch (_) {
      emit(BookingState.error('Terjadi kesalahan. Silakan coba lagi.'));
    }
  }

  /// Cancels the booking identified by [bookingId] then reloads the list.
  ///
  /// On failure the error state is emitted; the booking list is not reloaded.
  Future<void> cancelBooking(String bookingId) async {
    try {
      await _bookingRepo.cancelBooking(bookingId);
      // Reload to reflect the cancelled status.
      await loadMyBookings();
    } on Failure catch (e) {
      emit(BookingState.error(e.message));
    } catch (_) {
      emit(BookingState.error('Terjadi kesalahan. Silakan coba lagi.'));
    }
  }

  /// Resets the cubit back to [BookingInitial].
  void reset() => emit(const BookingState.initial());
}
