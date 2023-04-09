abstract class Constants {
  static const String redirectUri = "com.shadowteam.wallrio://login-callback/";
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );

  static const String supabaseAnnonKey = String.fromEnvironment(
    'SUPABASE_ANNON_KEY',
    defaultValue: '',
  );
}
