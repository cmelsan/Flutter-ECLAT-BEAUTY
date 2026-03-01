import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_constants.dart';

/// Initialize Supabase — call this in main() before runApp()
Future<void> initSupabase() async {
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );
}

/// Convenience accessor
SupabaseClient get supabase => Supabase.instance.client;

/// Provider for the Supabase client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return supabase;
});

/// Provider for the current auth state (stream)
final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  return supabase.auth.onAuthStateChange;
});

/// Provider for the current user (nullable)
final currentUserProvider = Provider<User?>((ref) {
  return supabase.auth.currentUser;
});

/// Provider for the current session (nullable)
final currentSessionProvider = Provider<Session?>((ref) {
  return supabase.auth.currentSession;
});
