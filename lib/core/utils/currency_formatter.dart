import 'package:intl/intl.dart';

/// Formats an integer IDR price as a string with dots as thousands separators.
/// Example: 45000 → '45.000', 1350000 → '1.350.000'
String formatRupiah(int priceIdr) {
  return NumberFormat('#,##0', 'id_ID').format(priceIdr);
}
