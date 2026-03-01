/// Application-wide constants
class AppConstants {
  AppConstants._();

  // ── Supabase ──────────────────────────────────────────
  static const String supabaseUrl = 'https://bztkmnpojogpjxguwzyo.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ6dGttbnBvam9ncGp4Z3V3enlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgyNDA2MjUsImV4cCI6MjA4MzgxNjYyNX0.991P0P0aJSD2XUhalGeVSGQcksmcGw_HX5kgB4VmauQ';

  // ── Cloudinary ────────────────────────────────────────
  static const String cloudinaryCloudName = 'dmu6ttz2o';
  static const String cloudinaryUploadFolder = 'eclat-beauty/products';

  // ── Stripe ────────────────────────────────────────────
  static const String stripePublishableKey = 'pk_test_51Ss7MwGD1HcPDaNHeuH3qiaysjkE3mXjks5ndyKhg6VElIUYvZeVV1R5K7KpcrzVHvWgkjPRtetLxMjWwUifR0U200lH9cUgYa';

  // ── Site URL (backend API) ────────────────────────────
  static const String siteUrl = 'https://claudiaeclat.victoriafp.online';

  // ── App Info ──────────────────────────────────────────
  static const String appName = 'ÉCLAT Beauty';
  static const String appTagline = 'Belleza Premium';
  static const String currency = 'EUR';
  static const String currencySymbol = '€';
  static const String locale = 'es_ES';

  // ── Business Rules ────────────────────────────────────
  static const int returnWindowDays = 14;
  static const int returnDeadlineDays = 14;
  static const int cartExpirationDays = 7;
  static const int freeShippingThreshold = 5000; // 50.00€ in cents

  // ── Return Address ────────────────────────────────────
  static const Map<String, String> returnAddress = {
    'name': 'ÉCLAT Beauty - Centro de Devoluciones',
    'street': 'Calle de la Moda 123',
    'city': 'Madrid',
    'postalCode': '28031',
    'country': 'ES',
  };

  // ── Pagination ────────────────────────────────────────
  static const int productsPerPage = 12;
  static const int ordersPerPage = 10;
  static const int reviewsPerPage = 5;
}
