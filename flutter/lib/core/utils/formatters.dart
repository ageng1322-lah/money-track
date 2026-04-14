// lib/core/utils/currency_formatter.dart
import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final _fmt = NumberFormat.currency(
    locale:        'id_ID',
    symbol:        'Rp ',
    decimalDigits: 0,
  );

  static String format(double amount) => _fmt.format(amount);

  static String formatCompact(double amount) {
    if (amount >= 1000000000) return 'Rp ${(amount / 1000000000).toStringAsFixed(1)}M';
    if (amount >= 1000000)    return 'Rp ${(amount / 1000000).toStringAsFixed(1)}Jt';
    if (amount >= 1000)       return 'Rp ${(amount / 1000).toStringAsFixed(0)}K';
    return format(amount);
  }
}

// lib/core/utils/date_formatter.dart
class DateFormatter {
  static String formatDate(DateTime date) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  static String formatMonth(int month, int year) {
    const months = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${months[month]} $year';
  }

  static String toApiDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  static String relativeDate(DateTime date) {
    final now  = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Hari ini';
    if (diff.inDays == 1) return 'Kemarin';
    if (diff.inDays < 7)  return '${diff.inDays} hari lalu';
    return formatDate(date);
  }
}
