import 'package:flutter/material.dart';

/// ÉCLAT Beauty color palette — matching the Astro web app (Black + Pink theme)
class AppColors {
  AppColors._();

  // ── Primary (Beauty Pink) ─────────────────────────────
  static const Color primary = Color(0xFFec4899);       // beauty.red - Rosa chicle
  static const Color primaryLight = Color(0xFFE8899E);  // beauty.pink - Rosa suave
  static const Color primaryDark = Color(0xFFd63384);   // Darker pink
  static const Color onPrimary = Colors.white;

  // ── Black Theme ───────────────────────────────────────
  static const Color black = Color(0xFF000000);         // Pure black
  static const Color blackSoft = Color(0xFF1a1a1a);     // Soft black (hover)
  static const Color blackUI = Color(0xFF111111);       // UI black (cards)

  // ── Neutral ───────────────────────────────────────────
  static const Color background = Color(0xFFFFFFFF);    // White background
  static const Color surface = Color(0xFFFFFFFF);       // White surface
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color card = Color(0xFFFFFFFF);

  // ── Text ──────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF000000);   // Black text
  static const Color textSecondary = Color(0xFF6B7280); // Gray text
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textOnDark = Colors.white;

  // ── Status ────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ── Stock Status ──────────────────────────────────────
  static const Color inStock = Color(0xFF10B981);
  static const Color lowStock = Color(0xFFF59E0B);
  static const Color outOfStock = Color(0xFFEF4444);

  // ── Order Status ──────────────────────────────────────
  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusPaid = Color(0xFF3B82F6);
  static const Color statusShipped = Color(0xFF8B5CF6);
  static const Color statusDelivered = Color(0xFF10B981);
  static const Color statusCancelled = Color(0xFFEF4444);
  static const Color statusReturn = Color(0xFFF97316);
  static const Color statusRefunded = Color(0xFF6B7280);

  // ── Misc ──────────────────────────────────────────────
  static const Color divider = Color(0xFFE5E7EB);
  static const Color shadow = Color(0x0D000000);
  
  // Missing textDisabled
  static const Color textDisabled = Color(0xFF9CA3AF);

  // ── Legacy/Additional Colors ──────────────────────────
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color overlay = Color(0x80000000);
  static const Color badge = Color(0xFFEF4444);
  static const Color backgroundSecondary = Color(0xFFF8F8F8);
  static const Color flashSale = Color(0xFFEC4899);     // pink-500
  static const Color secondary = Color(0xFFE8899E);     //Compat: same as primaryLight
  static const Color secondaryDark = Color(0xFFd63384);
  static const Color onSecondary = Colors.white;
}
