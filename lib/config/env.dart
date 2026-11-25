class Env {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static void assertConfigured() {
    assert(
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty,
      'Missing SUPABASE_URL / SUPABASE_ANON_KEY. Run with --dart-define-from-file=env.json',
    );
  }
}