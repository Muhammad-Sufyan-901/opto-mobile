// Unit tests for HomeSummaryRepositoryImpl.
//
// Uses a manual fake HomeRemoteDataSource. No mockito/mocktail dependency —
// matches the pattern in `test/features/consultation/booking_cubit_test.dart`.
//
// Covers the merge/sort/cap logic that lives in the repository (not the
// data source): "Up next" puts timed appointments ascending before untimed
// orders/reminders (recency-sorted), and "Recent activity" merges all
// sources by recency — both capped at 5.
import 'package:flutter_test/flutter_test.dart';

import 'package:opto/features/home/data/datasources/home_remote_data_source.dart';
import 'package:opto/features/home/data/repositories/home_summary_repository_impl.dart';
import 'package:opto/features/home/domain/entities/home_summary_item.dart';

// =============================================================================
// FAKE
// =============================================================================

class _FakeHomeRemoteDataSource implements HomeRemoteDataSource {
  List<HomeSummaryItem> appointments = const [];
  List<HomeSummaryItem> orders = const [];
  List<HomeSummaryItem> reminders = const [];
  List<HomeSummaryItem> posts = const [];
  List<HomeSummaryItem> replies = const [];
  List<HomeSummaryItem> bookmarks = const [];
  List<HomeSummaryItem> bookings = const [];
  List<HomeSummaryItem> consultations = const [];

  @override
  Future<List<HomeSummaryItem>> getUpcomingAppointments() async =>
      appointments;
  @override
  Future<List<HomeSummaryItem>> getInTransitOrders() async => orders;
  @override
  Future<List<HomeSummaryItem>> getActiveReminders() async => reminders;
  @override
  Future<List<HomeSummaryItem>> getMyPosts() async => posts;
  @override
  Future<List<HomeSummaryItem>> getMyReplies() async => replies;
  @override
  Future<List<HomeSummaryItem>> getMyBookmarks() async => bookmarks;
  @override
  Future<List<HomeSummaryItem>> getRecentBookings() async => bookings;
  @override
  Future<List<HomeSummaryItem>> getRecentConsultations() async =>
      consultations;
}

HomeSummaryItem _item({
  required HomeItemKind kind,
  required String title,
  DateTime? time,
}) {
  return HomeSummaryItem(kind: kind, title: title, subtitle: '', time: time);
}

void main() {
  late _FakeHomeRemoteDataSource fakeDataSource;
  late HomeSummaryRepositoryImpl repository;

  setUp(() {
    fakeDataSource = _FakeHomeRemoteDataSource();
    repository = HomeSummaryRepositoryImpl(remoteDataSource: fakeDataSource);
  });

  group('getUpNext', () {
    test('sorts timed appointments ascending, before untimed items', () async {
      final now = DateTime(2026, 1, 10);
      fakeDataSource.appointments = [
        _item(
          kind: HomeItemKind.appointment,
          title: 'Later appointment',
          time: now.add(const Duration(days: 5)),
        ),
        _item(
          kind: HomeItemKind.appointment,
          title: 'Soonest appointment',
          time: now.add(const Duration(days: 1)),
        ),
      ];
      fakeDataSource.orders = [
        _item(kind: HomeItemKind.order, title: 'Order A', time: now),
      ];
      fakeDataSource.reminders = [
        _item(kind: HomeItemKind.reminder, title: 'Reminder A'),
      ];

      final result = await repository.getUpNext();

      expect(result.map((i) => i.title).toList(), [
        'Soonest appointment',
        'Later appointment',
        'Order A',
        'Reminder A',
      ]);
    });

    test('does not crash on an appointment with a null time (missing slot)',
        () async {
      final now = DateTime(2026, 1, 10);
      fakeDataSource.appointments = [
        _item(kind: HomeItemKind.appointment, title: 'No slot found'),
        _item(
          kind: HomeItemKind.appointment,
          title: 'Has a slot',
          time: now.add(const Duration(days: 1)),
        ),
      ];

      final result = await repository.getUpNext();

      // Timed appointment sorts first; the undated one falls into the
      // untimed group instead of throwing a null-check error.
      expect(result.map((i) => i.title).toList(), [
        'Has a slot',
        'No slot found',
      ]);
    });

    test('caps the merged list at 5 items', () async {
      final now = DateTime(2026, 1, 10);
      fakeDataSource.appointments = List.generate(
        7,
        (i) => _item(
          kind: HomeItemKind.appointment,
          title: 'Appt $i',
          time: now.add(Duration(days: i + 1)),
        ),
      );

      final result = await repository.getUpNext();

      expect(result, hasLength(5));
      expect(result.first.title, 'Appt 0');
    });
  });

  group('getRecentActivity', () {
    test('merges all sources sorted by recency, capped at 5', () async {
      final now = DateTime(2026, 1, 10);
      fakeDataSource.posts = [
        _item(kind: HomeItemKind.post, title: 'Post', time: now),
      ];
      fakeDataSource.replies = [
        _item(
          kind: HomeItemKind.reply,
          title: 'Reply',
          time: now.subtract(const Duration(days: 1)),
        ),
      ];
      fakeDataSource.bookings = [
        _item(
          kind: HomeItemKind.booking,
          title: 'Booking',
          time: now.add(const Duration(days: 1)),
        ),
      ];

      final result = await repository.getRecentActivity();

      expect(result.map((i) => i.title).toList(), [
        'Booking',
        'Post',
        'Reply',
      ]);
    });
  });
}
