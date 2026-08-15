/// Supabase public client configuration is provided at build time via
/// `--dart-define` or `--dart-define-from-file`.
class SupabaseConfig {
  static const String url = String.fromEnvironment('SUPABASE_URL');
  static const String publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );

  static void ensureSet() {
    if (url.isEmpty || publishableKey.isEmpty) {
      throw StateError(
        'Supabase config missing. Pass --dart-define=SUPABASE_URL=... '
        '--dart-define=SUPABASE_PUBLISHABLE_KEY=... when running or building the app.',
      );
    }
  }
}
