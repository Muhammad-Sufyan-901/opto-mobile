// Domain entity for a single row in the Home dashboard's "Up next" or
// "Recent activity" sections.
//
// Pure-Dart representation used in the cubit state — no Supabase /
// serialisation dependencies. Aggregates several source tables
// (consultation_bookings, prosthetic_orders, care_reminders, posts,
// post_replies, post_bookmarks, consultations 🔒) into one display shape;
// see `home_remote_data_source.dart` for the per-source mapping.
//
// ponytail: no copyWith/== — this is a read-only display row built fresh on
// every load, never mutated or compared. Add them if a future feature needs
// to diff/update individual items in place.

/// What kind of underlying record a [HomeSummaryItem] represents.
///
/// Drives icon selection in the presentation layer (domain stays UI-free).
enum HomeItemKind {
  appointment,
  order,
  reminder,
  post,
  reply,
  bookmark,
  booking,
  consultation,
}

/// Immutable, aggregated row for the Home dashboard's summary lists.
class HomeSummaryItem {
  const HomeSummaryItem({
    required this.kind,
    required this.title,
    required this.subtitle,
    this.time,
    this.targetRoute,
    this.avatarInitials,
  });

  final HomeItemKind kind;

  final String title;
  final String subtitle;

  /// Sort key. For "Up next" this is the item's future occurrence time (null
  /// when the source has no real due date, e.g. [HomeItemKind.reminder]).
  /// For "Recent activity" this is the record's creation time.
  final DateTime? time;

  /// Route to push when the row is tapped; null renders a non-interactive row.
  final String? targetRoute;

  /// 1-2 character initials for a doctor avatar row; null falls back to an
  /// icon chip (see [HomeItemKind] → icon mapping in the presentation layer).
  final String? avatarInitials;
}
