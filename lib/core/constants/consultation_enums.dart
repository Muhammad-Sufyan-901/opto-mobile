/// Typed enums for the Health & Consultation feature.
///
/// These mirror the corresponding Postgres enums defined in the database schema.
/// Use these instead of bare strings in repositories, BLoC state, and business
/// logic.
library;

/// The mode of a consultation session.
///
/// Mirrors the `consult_mode` Postgres enum.
enum ConsultMode {
  voice,
  video,
  nonVerbal,
  inPerson;

  /// Parses a raw Postgres string value to a [ConsultMode].
  /// Postgres values: 'voice', 'video', 'non_verbal', 'in_person'.
  /// Falls back to [ConsultMode.voice] for unknown values.
  static ConsultMode fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'voice':
        return ConsultMode.voice;
      case 'video':
        return ConsultMode.video;
      case 'non_verbal':
        return ConsultMode.nonVerbal;
      case 'in_person':
        return ConsultMode.inPerson;
      default:
        return ConsultMode.voice;
    }
  }

  /// Canonical DB string (maps to Postgres enum value).
  // TODO(db): add 'voice' to the `consult_mode` Postgres enum (migration A-5).
  String get dbValue {
    switch (this) {
      case ConsultMode.voice:
        return 'voice';
      case ConsultMode.video:
        return 'video';
      case ConsultMode.nonVerbal:
        return 'non_verbal';
      case ConsultMode.inPerson:
        return 'in_person';
    }
  }
}

/// The lifecycle status of a consultation booking.
///
/// Mirrors the `booking_status` Postgres enum.
enum BookingStatus {
  booked,
  completed,
  cancelled;

  /// Parses a raw Postgres string value to a [BookingStatus].
  /// Postgres values: 'booked', 'completed', 'cancelled'.
  /// Falls back to [BookingStatus.booked] for unknown values.
  static BookingStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'booked':
        return BookingStatus.booked;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      default:
        return BookingStatus.booked;
    }
  }

  /// Canonical DB string — matches the Postgres enum value exactly.
  // All values are the same in snake_case for this enum.
  String get dbValue => name;
}
