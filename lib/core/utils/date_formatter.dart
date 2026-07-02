import 'package:intl/intl.dart';

class DateFormatter {
  /// Format: 1 Maret 2026
  static String toDayMonthYear(DateTime date) {
    return DateFormat('d MMMM yyyy', 'id_ID').format(date);
  }

  /// Format: Minggu, 1 Maret 2026
  static String toDayNameMonthYear(DateTime date) {
    return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
  }

  /// Format: 01/03/2026 (Format pendek untuk tabel/laporan)
  static String toShortDate(DateTime date) {
    return DateFormat('dd/MM/yyyy', 'id_ID').format(date);
  }

  /// Format: 11:36 (Waktu/Jam)
  static String toTime(DateTime date) {
    return DateFormat('HH:mm', 'id_ID').format(date);
  }

  /// Format: 1 Maret 2026, 11:36 WIB
  static String toDateTime(DateTime date) {
    final datePart = DateFormat('d MMMM yyyy', 'id_ID').format(date);
    final timePart = DateFormat('HH:mm', 'id_ID').format(date);
    return '$datePart, $timePart WIB';
  }

  /// Format: "Today · 09:00" / "Tomorrow · 09:00" / "Yesterday · 09:00",
  /// falling back to "18 Apr · 09:00" for dates outside that ±1-day window.
  ///
  /// Used by the Home dashboard's "Up next" / "Recent activity" rows —
  /// English copy to match the surrounding screen (unlike the Indonesian
  /// helpers above).
  static String toRelativeDayTime(DateTime date) {
    final local = date.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(local.year, local.month, local.day);
    final diff = day.difference(today).inDays;
    final time = DateFormat('HH:mm').format(local);

    if (diff == 0) return 'Today · $time';
    if (diff == 1) return 'Tomorrow · $time';
    if (diff == -1) return 'Yesterday · $time';
    return '${DateFormat('d MMM').format(local)} · $time';
  }

  /// Greeting based on time
  static String getGreeting(DateTime date) {
    final hour = date.hour;
    if (hour >= 3 && hour < 11) {
      return 'Selamat Pagi';
    } else if (hour >= 11 && hour < 15) {
      return 'Selamat Siang';
    } else if (hour >= 15 && hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }
}
