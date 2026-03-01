import 'package:intl/intl.dart';

/// Format prices from cents to EUR display string
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Format cents to "12,50 €"
  static String format(int cents) {
    final euros = (cents / 100).toStringAsFixed(2).replaceAll('.', ',');
    return '$euros €';
  }

  /// Format cents to "12,50"
  static String formatWithoutSymbol(int cents) {
    return (cents / 100).toStringAsFixed(2).replaceAll('.', ',');
  }

  /// Parse user input "12,50" or "12.50" to cents
  static int? parse(String input) {
    try {
      final normalized = input.replaceAll(',', '.');
      final euros = double.parse(normalized);
      return (euros * 100).round();
    } catch (e) {
      return null;
    }
  }

  /// Format with NumberFormat (locale-aware)
  static String formatLocale(int cents, {String locale = 'es_ES'}) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: '€',
      decimalDigits: 2,
    );
    return formatter.format(cents / 100);
  }

  /// Format range: "12,50 € - 45,00 €"
  static String formatRange(int minCents, int maxCents) {
    return '${format(minCents)} - ${format(maxCents)}';
  }
}
