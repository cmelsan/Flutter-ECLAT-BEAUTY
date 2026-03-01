import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration using .env file
/// Initialize with: await dotenv.load()
class EnvConfig {
  EnvConfig._();

  // ── Supabase ──────────────────────────────────────────
  static String get supabaseUrl =>
      dotenv.env['SUPABASE_URL'] ?? _throwMissing('SUPABASE_URL');

  static String get supabaseAnonKey =>
      dotenv.env['SUPABASE_ANON_KEY'] ?? _throwMissing('SUPABASE_ANON_KEY');

  // ── Cloudinary ────────────────────────────────────────
  static String get cloudinaryCloudName =>
      dotenv.env['CLOUDINARY_CLOUD_NAME'] ??
      _throwMissing('CLOUDINARY_CLOUD_NAME');

  // ── Stripe ────────────────────────────────────────────
  static String get stripePublishableKey =>
      dotenv.env['STRIPE_PUBLISHABLE_KEY'] ??
      _throwMissing('STRIPE_PUBLISHABLE_KEY');

  // ── Brevo (Email) ─────────────────────────────────────
  static String get brevoApiKey =>
      dotenv.env['BREVO_API_KEY'] ?? '';

  // ── Site URL (backend API) ────────────────────────────
  static String get siteUrl =>
      dotenv.env['SITE_URL'] ?? 'http://localhost:4321';

  // ── Helper ────────────────────────────────────────────
  static String _throwMissing(String key) {
    throw Exception(
      'Missing environment variable: $key\n'
      'Make sure you have a .env file with all required variables.\n'
      'Copy .env.example to .env and fill in your values.',
    );
  }
}
