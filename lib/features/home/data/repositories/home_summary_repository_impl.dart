// Concrete implementation of [HomeSummaryRepository].
//
// Fires the per-source queries in parallel via `Future.wait`, then merges,
// sorts, and caps each section in Dart (client-side merge — no aggregation
// RPC/migration; see plan for the upgrade path if round-trips become a
// concern).
//
// 🔒 [getRecentActivity] may include [HomeItemKind.consultation] rows —
// callers (the home cubit) must keep this in memory only, never persist to
// Hive.
import 'package:opto/core/error/failures.dart';
import 'package:opto/features/home/data/datasources/home_remote_data_source.dart';
import 'package:opto/features/home/domain/entities/home_summary_item.dart';
import 'package:opto/features/home/domain/repositories/home_summary_repository.dart';

/// Production implementation of [HomeSummaryRepository].
class HomeSummaryRepositoryImpl implements HomeSummaryRepository {
  HomeSummaryRepositoryImpl({required HomeRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final HomeRemoteDataSource _remoteDataSource;

  static const _upNextLimit = 5;
  static const _recentActivityLimit = 5;

  @override
  Future<List<HomeSummaryItem>> getUpNext() async {
    try {
      final results = await Future.wait([
        _remoteDataSource.getUpcomingAppointments(),
        _remoteDataSource.getInTransitOrders(),
        _remoteDataSource.getActiveReminders(),
      ]);
      // Appointments carry a real future time — soonest first. An
      // appointment can still land here with a null time (e.g. its slot row
      // was not found), so split rather than assume every entry has one.
      final timedAppointments = results[0]
          .where((item) => item.time != null)
          .toList()
        ..sort((a, b) => a.time!.compareTo(b.time!));

      // Orders, reminders, and any undated appointment have no genuine
      // "next occurrence" time, so they follow, most-recently-created first.
      final untimed = [
        ...results[0].where((item) => item.time == null),
        ...results[1],
        ...results[2],
      ]..sort(
          (a, b) => (b.time ?? DateTime(0)).compareTo(a.time ?? DateTime(0)),
        );

      return [...timedAppointments, ...untimed].take(_upNextLimit).toList();
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<HomeSummaryItem>> getRecentActivity() async {
    try {
      final results = await Future.wait([
        _remoteDataSource.getMyPosts(),
        _remoteDataSource.getMyReplies(),
        _remoteDataSource.getMyBookmarks(),
        _remoteDataSource.getRecentBookings(),
        _remoteDataSource.getRecentConsultations(),
      ]);
      final merged = results.expand((list) => list).toList()
        ..sort(
          (a, b) => (b.time ?? DateTime(0)).compareTo(a.time ?? DateTime(0)),
        );

      return merged.take(_recentActivityLimit).toList();
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
