import 'package:intl/intl.dart';

/// Date formatting utilities matching the Astro app
class DateFormatter {
  DateFormatter._();

  /// Format date as "15 de febrero de 2026" (Spanish long format)
  static String formatLong(DateTime date) {
    final months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }

  /// Format date as "15/02/2026" (DD/MM/YYYY)
  static String formatShort(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  /// Format date as "15 feb. 2026"
  static String formatMedium(DateTime date) {
    final monthsShort = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
    ];
    return '${date.day} ${monthsShort[date.month - 1]}. ${date.year}';
  }

  /// Format time as "14:30"
  static String formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  /// Format date and time as "15/02/2026 14:30"
  static String formatDateTime(DateTime date) {
    return '${formatShort(date)} ${formatTime(date)}';
  }

  /// Relative time: "Hace 2 horas", "Hace 3 días"
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) {
      return 'Hace ${diff.inSeconds} segundos';
    } else if (diff.inMinutes < 60) {
      return 'Hace ${diff.inMinutes} minutos';
    } else if (diff.inHours < 24) {
      return 'Hace ${diff.inHours} horas';
    } else if (diff.inDays < 7) {
      return 'Hace ${diff.inDays} días';
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return 'Hace $weeks semanas';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return 'Hace $months meses';
    } else {
      final years = (diff.inDays / 365).floor();
      return 'Hace $years años';
    }
  }

  /// Format with DateFormat (locale-aware)
  static String formatLocale(DateTime date, String pattern, {String locale = 'es_ES'}) {
    return DateFormat(pattern, locale).format(date);
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is in the past
  static bool isPast(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  /// Check if date is in the future
  static bool isFuture(DateTime date) {
    return date.isAfter(DateTime.now());
  }
}
