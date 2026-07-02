// Remote data source for the Home dashboard's "Up next" and "Recent
// activity" sections.
//
// This is the ONLY place in the home feature that calls
// `SupabaseClientProvider.client` directly. Aggregates several tables that
// belong to other features (consultation, prosthetic_hub, connect) by
// querying them directly rather than importing those features' repositories
// — cross-feature imports are disallowed by the project's layering rule
// (see CLAUDE.md "Golden rule"); every other feature already reaches shared
// tables like `profiles` the same way instead of importing another feature.
//
// SECURITY NOTES:
// - `getRecentConsultations` 🔒 reads the owner-only `consultations` table.
//   Never join it into catalog/community/map queries; the repository layer
//   must not cache its result beyond session need.
// - Use only `SupabaseClientProvider.client` — never `Supabase.instance.client`
//   directly.
//
// ponytail: rows are mapped straight to [HomeSummaryItem] here — no per-table
// freezed models. Home only ever reads a handful of fields for display and
// never writes. Add per-table models if another feature needs to reuse these
// reads.
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/core/supabase/supabase_client_provider.dart';
import 'package:opto/core/supabase/supabase_error_mapper.dart';
import 'package:opto/core/utils/date_formatter.dart';
import 'package:opto/features/home/domain/entities/home_summary_item.dart';

/// Contract for the home remote data source. One method per source table so
/// the repository can merge/sort/limit results independently per section.
abstract class HomeRemoteDataSource {
  // UP NEXT ─────────────────────────────────────────────────────────────────
  Future<List<HomeSummaryItem>> getUpcomingAppointments();
  Future<List<HomeSummaryItem>> getInTransitOrders();
  Future<List<HomeSummaryItem>> getActiveReminders();

  // RECENT ACTIVITY ────────────────────────────────────────────────────────
  Future<List<HomeSummaryItem>> getMyPosts();
  Future<List<HomeSummaryItem>> getMyReplies();
  Future<List<HomeSummaryItem>> getMyBookmarks();
  Future<List<HomeSummaryItem>> getRecentBookings();

  /// 🔒 Medically sensitive — see class-level SECURITY NOTES.
  Future<List<HomeSummaryItem>> getRecentConsultations();
}

// =============================================================================
// IMPLEMENTATION
// =============================================================================

/// Production implementation backed by Supabase PostgREST.
///
/// All [PostgrestException]s are mapped to typed [Failure]s via
/// [SupabaseErrorMapper.fromPostgrest] before being rethrown.
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  SupabaseClient get _client => SupabaseClientProvider.client;

  String get _requireUserId {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const AuthFailure('No signed-in user.');
    }
    return userId;
  }

  // UP NEXT ─────────────────────────────────────────────────────────────────

  @override
  Future<List<HomeSummaryItem>> getUpcomingAppointments() async {
    final userId = _requireUserId;
    try {
      final rows = await _client
          .from('consultation_bookings')
          .select('''
            id, mode, created_at,
            doctor:doctors!doctor_id(
              specialty,
              profile:profiles!profile_id(full_name)
            ),
            slot:doctor_availability!slot_id(slot_start)
          ''')
          .eq('user_id', userId)
          .eq('status', 'booked')
          .order('created_at', ascending: false);

      final now = DateTime.now();
      return rows
          .map((row) {
            final doctor = row['doctor'] as Map<String, dynamic>?;
            final profile = doctor?['profile'] as Map<String, dynamic>?;
            final slot = row['slot'] as Map<String, dynamic>?;
            final name = profile?['full_name'] as String? ?? 'a specialist';
            final slotStartRaw = slot?['slot_start'] as String?;
            final slotStart =
                slotStartRaw != null ? DateTime.parse(slotStartRaw) : null;

            return HomeSummaryItem(
              kind: HomeItemKind.appointment,
              title: 'Consultation — Dr. $name',
              subtitle: slotStart != null
                  ? DateFormatter.toRelativeDayTime(slotStart)
                  : 'Time to be confirmed',
              time: slotStart,
              targetRoute: '/consult',
              avatarInitials: _initials(name),
            );
          })
          // Drop bookings whose slot has already passed (status not yet
          // transitioned server-side) — "Up next" only shows the future.
          .where((item) => item.time == null || item.time!.isAfter(now))
          .toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<HomeSummaryItem>> getInTransitOrders() async {
    final userId = _requireUserId;
    try {
      final rows = await _client
          .from('prosthetic_orders')
          .select('id, status, created_at, product:prosthetic_products!product_id(name)')
          .eq('user_id', userId)
          .inFilter('status', const [
            'submitted',
            'in_review',
            'in_production',
            'shipped',
          ])
          .order('created_at', ascending: false);

      return rows.map((row) {
        final product = row['product'] as Map<String, dynamic>?;
        final name = product?['name'] as String? ?? 'Prosthetic order';
        final status = row['status'] as String;
        return HomeSummaryItem(
          kind: HomeItemKind.order,
          title: 'Order — $name',
          subtitle: _humanizeStatus(status),
          targetRoute: '/prosthetic-hub',
        );
      }).toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<HomeSummaryItem>> getActiveReminders() async {
    final userId = _requireUserId;
    try {
      final rows = await _client
          .from('care_reminders')
          .select('id, label, schedule_cron')
          .eq('user_id', userId)
          .eq('is_active', true);

      // ponytail: `care_reminders` has no next-due timestamp, only a cron
      // string — show it as-is rather than parsing cron client-side.
      // Upgrade path: add a `next_due timestamptz` column, or parse
      // `schedule_cron` if reminders need true chronological placement.
      return rows
          .map(
            (row) => HomeSummaryItem(
              kind: HomeItemKind.reminder,
              title: row['label'] as String,
              subtitle: row['schedule_cron'] as String,
              targetRoute: '/prosthetic-hub/log-care',
            ),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // RECENT ACTIVITY ────────────────────────────────────────────────────────

  @override
  Future<List<HomeSummaryItem>> getMyPosts() async {
    final userId = _requireUserId;
    try {
      final rows = await _client
          .from('posts')
          .select('id, body, topic, created_at')
          .eq('author_id', userId)
          .order('created_at', ascending: false)
          .limit(5);

      return rows.map((row) {
        final topic = row['topic'] as String?;
        final createdAt = DateTime.parse(row['created_at'] as String);
        return HomeSummaryItem(
          kind: HomeItemKind.post,
          title: topic != null
              ? 'Posted in "$topic"'
              : 'Posted: ${_truncate(row['body'] as String)}',
          subtitle: DateFormatter.toRelativeDayTime(createdAt),
          time: createdAt,
          targetRoute: '/community/thread/${row['id']}',
        );
      }).toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<HomeSummaryItem>> getMyReplies() async {
    final userId = _requireUserId;
    try {
      final rows = await _client
          .from('post_replies')
          .select('id, post_id, body, created_at, post:posts!post_id(topic)')
          .eq('author_id', userId)
          .order('created_at', ascending: false)
          .limit(5);

      return rows.map((row) {
        final post = row['post'] as Map<String, dynamic>?;
        final topic = post?['topic'] as String?;
        final createdAt = DateTime.parse(row['created_at'] as String);
        return HomeSummaryItem(
          kind: HomeItemKind.reply,
          title: topic != null
              ? 'Replied in "$topic"'
              : 'Replied: ${_truncate(row['body'] as String)}',
          subtitle: DateFormatter.toRelativeDayTime(createdAt),
          time: createdAt,
          targetRoute: '/community/thread/${row['post_id']}',
        );
      }).toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<HomeSummaryItem>> getMyBookmarks() async {
    final userId = _requireUserId;
    try {
      final rows = await _client
          .from('post_bookmarks')
          .select('id, post_id, created_at, post:posts!post_id(topic)')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(5);

      return rows.map((row) {
        final post = row['post'] as Map<String, dynamic>?;
        final topic = post?['topic'] as String?;
        final createdAt = DateTime.parse(row['created_at'] as String);
        return HomeSummaryItem(
          kind: HomeItemKind.bookmark,
          title: topic != null ? 'Saved a post in "$topic"' : 'Saved a post',
          subtitle: DateFormatter.toRelativeDayTime(createdAt),
          time: createdAt,
          targetRoute: '/community/thread/${row['post_id']}',
        );
      }).toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<HomeSummaryItem>> getRecentBookings() async {
    final userId = _requireUserId;
    try {
      final rows = await _client
          .from('consultation_bookings')
          .select('''
            id, created_at,
            doctor:doctors!doctor_id(
              specialty,
              profile:profiles!profile_id(full_name)
            )
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(3);

      return rows.map((row) {
        final doctor = row['doctor'] as Map<String, dynamic>?;
        final profile = doctor?['profile'] as Map<String, dynamic>?;
        final name = profile?['full_name'] as String? ?? 'a specialist';
        final createdAt = DateTime.parse(row['created_at'] as String);
        return HomeSummaryItem(
          kind: HomeItemKind.booking,
          title: 'Booked Dr. $name',
          subtitle: DateFormatter.toRelativeDayTime(createdAt),
          time: createdAt,
          targetRoute: '/consult',
          avatarInitials: _initials(name),
        );
      }).toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // 🔒 CONSULTATIONS — owner-only via RLS; see class-level SECURITY NOTES.

  @override
  Future<List<HomeSummaryItem>> getRecentConsultations() async {
    // Auth guard as defence-in-depth; RLS on `consultations` is the
    // authoritative boundary (mirrors ConsultationRemoteDataSource).
    _requireUserId;
    try {
      final rows = await _client
          .from('consultations')
          .select('''
            id, created_at,
            booking:consultation_bookings!booking_id(
              doctor:doctors!doctor_id(
                specialty,
                profile:profiles!profile_id(full_name)
              )
            )
          ''')
          .order('created_at', ascending: false)
          .limit(3);

      return rows.map((row) {
        final booking = row['booking'] as Map<String, dynamic>?;
        final doctor = booking?['doctor'] as Map<String, dynamic>?;
        final profile = doctor?['profile'] as Map<String, dynamic>?;
        final name = profile?['full_name'] as String? ?? 'your doctor';
        final createdAt = DateTime.parse(row['created_at'] as String);
        return HomeSummaryItem(
          kind: HomeItemKind.consultation,
          title: 'Consultation with Dr. $name',
          subtitle: DateFormatter.toRelativeDayTime(createdAt),
          time: createdAt,
          targetRoute: '/consult/history',
          avatarInitials: _initials(name),
        );
      }).toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}

// ── shared helpers ──────────────────────────────────────────────────────────

String _truncate(String text, [int max = 40]) =>
    text.length <= max ? text : '${text.substring(0, max)}…';

String _humanizeStatus(String status) {
  final spaced = status.replaceAll('_', ' ');
  return spaced[0].toUpperCase() + spaced.substring(1);
}

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
  final letters = parts.take(2).map((p) => p[0].toUpperCase()).join();
  return letters.isEmpty ? '?' : letters;
}
