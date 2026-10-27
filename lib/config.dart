class SupabaseConfig {
  // Ganti dengan Project URL dan anon/publishable key dari dashboard Supabase.
  // JANGAN masukkan service_role key ke aplikasi Android.
  static const String url = 'https://omckqyxtcmqeuioyyfoo.supabase.co/rest/v1/';
  static const String anonKey = 'sb_publishable_bFZGvgKzceTewiv2UzFX5g_E9c8XUDV';

  static bool get isConfigured =>
      url.startsWith('https://') &&
      !url.contains('PASTE_') &&
      anonKey.isNotEmpty &&
      !anonKey.contains('PASTE_');
}
