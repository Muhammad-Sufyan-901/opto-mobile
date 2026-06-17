// Concrete implementation of [BookingRepository].
//
// Delegates to [ConsultationRemoteDataSource] for all PostgREST calls.
// Maps data-layer models to domain entities via the `toEntity()` extensions.
// Performs input validation before delegating to the data source.
import 'package:opto/core/constants/consultation_enums.dart';
import 'package:opto/core/error/failures.dart';
import 'package:opto/features/consultation/data/datasources/consultation_remote_data_source.dart';
import 'package:opto/features/consultation/data/models/consultation_booking_model_ext.dart';
import 'package:opto/features/consultation/domain/entities/consultation_booking_entity.dart';
import 'package:opto/features/consultation/domain/repositories/booking_repository.dart';

/// Production implementation of [BookingRepository].
///
/// Failures that escape the data source are already typed [Failure]
/// subclasses — they propagate up to the BLoC, which catches and maps
/// them to error states.
///
/// Input validation (non-empty IDs) is enforced at this layer before
/// delegating to the data source, so invalid parameters never reach
/// the network.
class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl({
    required ConsultationRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final ConsultationRemoteDataSource _remoteDataSource;

  // ── booking ────────────────────────────────────────────────────────────────

  @override
  Future<ConsultationBookingEntity> createBooking({
    required String doctorId,
    required DateTime slotStart,
    required ConsultMode mode,
    bool bookedViaVoice = false,
  }) async {
    if (doctorId.isEmpty) {
      throw const ServerFailure('ID dokter tidak boleh kosong.');
    }
    try {
      final model = await _remoteDataSource.createBooking(
        doctorId: doctorId,
        slotStart: slotStart,
        mode: mode.dbValue, // convert enum → DB string
        bookedViaVoice: bookedViaVoice,
      );
      return model.toEntity();
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<ConsultationBookingEntity>> getMyBookings() async {
    try {
      final models = await _remoteDataSource.getMyBookings();
      return models.map((m) => m.toEntity()).toList();
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    if (bookingId.isEmpty) {
      throw const ServerFailure('ID booking tidak boleh kosong.');
    }
    try {
      await _remoteDataSource.cancelBooking(bookingId);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
