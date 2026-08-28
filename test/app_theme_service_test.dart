import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallrio/model/export.dart';
import 'package:wallrio/services/app_theme_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('AppThemeService defaults when nothing persisted', () async {
    final service = AppThemeService();
    await service.getData();

    expect(AppThemeService.themeMode, AppThemeMode.dark);
    expect(AppThemeService.accentColor, AccentColorOption.emerald);
    expect(AppThemeService.backgroundStyle, BackgroundStyleOption.standard);
    expect(AppThemeService.premiumThemeId, isNull);
    expect(AppThemeService.dynamicAccentEnabled, isFalse);
  });

  test('AppThemeService persists and round-trips every setting', () async {
    final service = AppThemeService();

    await service.saveThemeMode(AppThemeMode.system);
    await service.saveAccentColor(AccentColorOption.oceanBlue);
    await service.saveBackgroundStyle(BackgroundStyleOption.oledBlack);
    await service.savePremiumThemeId('cyber');
    await service.saveDynamicAccentEnabled(true);
    await service.saveLastAppliedWallpaperUrl('https://example.com/wall.jpg');

    // Simulate a fresh app start reading persisted values back.
    AppThemeService.themeMode = AppThemeMode.dark;
    AppThemeService.accentColor = AccentColorOption.emerald;
    AppThemeService.backgroundStyle = BackgroundStyleOption.standard;
    AppThemeService.premiumThemeId = null;
    AppThemeService.dynamicAccentEnabled = false;
    AppThemeService.lastAppliedWallpaperUrl = null;

    await service.getData();

    expect(AppThemeService.themeMode, AppThemeMode.system);
    expect(AppThemeService.accentColor, AccentColorOption.oceanBlue);
    expect(AppThemeService.backgroundStyle, BackgroundStyleOption.oledBlack);
    expect(AppThemeService.premiumThemeId, 'cyber');
    expect(AppThemeService.dynamicAccentEnabled, isTrue);
    expect(AppThemeService.lastAppliedWallpaperUrl,
        'https://example.com/wall.jpg');
  });

  test('savePremiumThemeId(null) clears the persisted premium theme', () async {
    final service = AppThemeService();
    await service.savePremiumThemeId('rose');
    await service.getData();
    expect(AppThemeService.premiumThemeId, 'rose');

    await service.savePremiumThemeId(null);
    await service.getData();
    expect(AppThemeService.premiumThemeId, isNull);
  });
}
