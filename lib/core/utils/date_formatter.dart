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
