/// Supabase credentials are provided at build time via `--dart-define`.
class SupabaseConfig {
  static const String url = String.fromEnvironment('SUPABASE_URL');
  static const String anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static void ensureSet() {
    if (url.isEmpty || anonKey.isEmpty) {
      throw StateError(
        'Supabase config missing. Pass --dart-define=SUPABASE_URL=... '
        '--dart-define=SUPABASE_ANON_KEY=... when running or building the app.',
      );
    }
  }
}
