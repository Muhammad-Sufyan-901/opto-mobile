// Domain contract for the Home dashboard's "Up next" and "Recent activity"
// aggregations.
//
// Implementations live in the data layer
// (`lib/features/home/data/repositories/home_summary_repository_impl.dart`).
//
// NOTE: No Supabase or infrastructure imports — domain layer stays pure Dart.
import 'package:opto/core/error/failures.dart';
import 'package:opto/features/home/domain/entities/home_summary_item.dart';

/// Abstract contract for the Home dashboard summary sections.
///
/// Methods throw [Failure] subclasses on error; the cubit catches and maps
/// them to error states.
abstract class HomeSummaryRepository {
  /// Upcoming items for the signed-in user — booked consultation
  /// appointments, in-transit prosthetic orders, and active care reminders —
  /// merged and ordered for display (soonest first; undated items last).
  ///
  /// Throws [AuthFailure] when unauthenticated.
  /// Throws [ServerFailure] on network / RLS error.
  Future<List<HomeSummaryItem>> getUpNext();

  /// Recent actions for the signed-in user — own posts, replies, bookmarks,
  /// consultation bookings, and completed consultations 🔒 — merged and
  /// ordered newest first.
  ///
  /// 🔒 May include medically sensitive [HomeItemKind.consultation] rows.
  /// Callers must not persist the result beyond the current app session.
  ///
  /// Throws [AuthFailure] when unauthenticated.
  /// Throws [ServerFailure] on network / RLS error.
  Future<List<HomeSummaryItem>> getRecentActivity();
}
