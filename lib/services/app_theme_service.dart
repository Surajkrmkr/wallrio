import 'package:wallrio/model/export.dart';
import 'package:wallrio/services/packages/export.dart';

/// Persists the "Theme & Appearance" personalization state, following the
/// exact static-cache + read/write pattern used by [ThemeService] (see
/// dark_mode_services.dart) but under its own keys so it never collides with
/// or mutates the existing "isDarkMode"/"gradient" keys.
class AppThemeService {
  static const _modeKey = 'app_theme_mode';
  static const _accentKey = 'app_theme_accent_color';
  static const _backgroundKey = 'app_theme_background_style';
  static const _premiumThemeKey = 'app_theme_premium_theme_id';
  static const _dynamicAccentKey = 'app_theme_dynamic_accent_enabled';
  static const _appliedWallpaperUrlKey = 'app_theme_last_applied_wallpaper_url';

  static AppThemeMode themeMode = AppThemeMode.dark;
  static AccentColorOption accentColor = AccentColorOption.emerald;
  static BackgroundStyleOption backgroundStyle = BackgroundStyleOption.standard;
  static String? premiumThemeId;
  static bool dynamicAccentEnabled = false;
  static String? lastAppliedWallpaperUrl;

  Future<void> getData() async {
    final prefs = await SharedPreferences.getInstance();

    final String? modeVal = prefs.getString(_modeKey);
    themeMode = AppThemeMode.values.firstWhere(
      (m) => m.name == modeVal,
      orElse: () => AppThemeMode.dark,
    );

    final String? accentVal = prefs.getString(_accentKey);
    accentColor = AccentColorOption.values.firstWhere(
      (a) => a.name == accentVal,
      orElse: () => AccentColorOption.emerald,
    );

    final String? bgVal = prefs.getString(_backgroundKey);
    backgroundStyle = BackgroundStyleOption.values.firstWhere(
      (b) => b.name == bgVal,
      orElse: () => BackgroundStyleOption.standard,
    );

    premiumThemeId = prefs.getString(_premiumThemeKey);
    dynamicAccentEnabled = prefs.getBool(_dynamicAccentKey) ?? false;
    lastAppliedWallpaperUrl = prefs.getString(_appliedWallpaperUrlKey);
  }

  Future<void> saveThemeMode(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_modeKey, mode.name);
  }

  Future<void> saveAccentColor(AccentColorOption accent) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accentKey, accent.name);
  }

  Future<void> saveBackgroundStyle(BackgroundStyleOption style) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_backgroundKey, style.name);
  }

  Future<void> savePremiumThemeId(String? id) async {
    final prefs = await SharedPreferences.getInstance();
    if (id == null) {
      await prefs.remove(_premiumThemeKey);
    } else {
      await prefs.setString(_premiumThemeKey, id);
    }
  }

  Future<void> saveDynamicAccentEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dynamicAccentKey, enabled);
  }

  Future<void> saveLastAppliedWallpaperUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_appliedWallpaperUrlKey, url);
  }
}
