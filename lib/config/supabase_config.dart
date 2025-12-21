/// Supabase credentials are provided at build time via `--dart-define`.
class SupabaseConfig {
  // Read-only fallback credentials for demo/testing.
  static const String _fallbackUrl = 'https://ervulxvqxhmoqeiefjut.supabase.co';
  static const String _fallbackAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVydnVseHZxeGhtb3FlaWVmanV0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU0NzA5NzAsImV4cCI6MjA1MTA0Njk3MH0.Wt48Pyn8835CpLO66kDCa5bCEs1RZx1p5ByxjCfCZ2g';

  static const String url = String.fromEnvironment('SUPABASE_URL', defaultValue: _fallbackUrl);
  static const String anonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: _fallbackAnonKey);

  static void ensureSet() {
    if (url.isEmpty || anonKey.isEmpty) {
      throw StateError(
        'Supabase config missing. Pass --dart-define=SUPABASE_URL=... '
        '--dart-define=SUPABASE_ANON_KEY=... when running or building the app.',
      );
    }
  }
}
