/// Build-time environment variables.
/// Never hard-code secrets. Always pass via --dart-define.
///
/// Build command:
/// flutter run \
///   --dart-define=SUPABASE_URL=https://xxx.supabase.co \
///   --dart-define=SUPABASE_ANON_KEY=xxx \
///   --dart-define=POSTHOG_KEY=xxx
class Env {
  Env._();

  static const supabaseUrl =
      String.fromEnvironment('SUPABASE_URL', defaultValue: '');

  static const supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

  static const postHogKey =
      String.fromEnvironment('POSTHOG_KEY', defaultValue: '');

  /// Claude API key is NEVER in the Flutter app.
  /// It lives in Supabase Edge Function environment variables only.

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
