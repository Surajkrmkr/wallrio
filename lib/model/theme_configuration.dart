import 'package:flutter/material.dart';

/// Overall theme mode chosen by the user in Theme & Appearance settings.
/// Distinct from `DarkThemeProvider.darkTheme` (a plain bool with no
/// "system" option) — see AppThemeManager for how the two are reconciled.
enum AppThemeMode { system, light, dark }

/// A small palette record used both by [AccentColorOption] and by the
/// premium theme configurations.
@immutable
class AccentPalette {
  final Color primary;
  final Color primaryContainer;
  final Color secondary;
  final Color secondaryContainer;
  final Color surfaceTint;
  final Color buttonColor;
  final Color selectedColor;
  final Color focusColor;

  const AccentPalette({
    required this.primary,
    required this.primaryContainer,
    required this.secondary,
    required this.secondaryContainer,
    required this.surfaceTint,
    required this.buttonColor,
    required this.selectedColor,
    required this.focusColor,
  });
}

/// Free + Pro accent color choices. `emerald` intentionally mirrors today's
/// `bgDarkAccentColor` (0xFF37C3A3) family so the default look is unchanged.
enum AccentColorOption {
  emerald,
  oceanBlue,
  purpleVelvet,
  sunsetOrange,
  midnightAmber,
  rosePink,
}

const Map<AccentColorOption, AccentPalette> accentPalettes = {
  AccentColorOption.emerald: AccentPalette(
    primary: Color(0xFF37C3A3),
    primaryContainer: Color(0xFF1E4B41),
    secondary: Color(0xFF2ABFAA),
    secondaryContainer: Color(0xFF17392F),
    surfaceTint: Color(0xFF37C3A3),
    buttonColor: Color(0xFF37C3A3),
    selectedColor: Color(0xFF37C3A3),
    focusColor: Color(0xFF2ABFAA),
  ),
  AccentColorOption.oceanBlue: AccentPalette(
    primary: Color(0xFF3B9EFF),
    primaryContainer: Color(0xFF1B3B63),
    secondary: Color(0xFF2C7BE5),
    secondaryContainer: Color(0xFF163050),
    surfaceTint: Color(0xFF3B9EFF),
    buttonColor: Color(0xFF3B9EFF),
    selectedColor: Color(0xFF3B9EFF),
    focusColor: Color(0xFF2C7BE5),
  ),
  AccentColorOption.purpleVelvet: AccentPalette(
    primary: Color(0xFF9B6BF2),
    primaryContainer: Color(0xFF3A2A5C),
    secondary: Color(0xFF7C4FE0),
    secondaryContainer: Color(0xFF2A1F42),
    surfaceTint: Color(0xFF9B6BF2),
    buttonColor: Color(0xFF9B6BF2),
    selectedColor: Color(0xFF9B6BF2),
    focusColor: Color(0xFF7C4FE0),
  ),
  AccentColorOption.sunsetOrange: AccentPalette(
    primary: Color(0xFFFF8A4C),
    primaryContainer: Color(0xFF5C3420),
    secondary: Color(0xFFFF6B35),
    secondaryContainer: Color(0xFF432315),
    surfaceTint: Color(0xFFFF8A4C),
    buttonColor: Color(0xFFFF8A4C),
    selectedColor: Color(0xFFFF8A4C),
    focusColor: Color(0xFFFF6B35),
  ),
  AccentColorOption.midnightAmber: AccentPalette(
    primary: Color(0xFFE8A94A),
    primaryContainer: Color(0xFF4A3A1B),
    secondary: Color(0xFFCF9138),
    secondaryContainer: Color(0xFF362A13),
    surfaceTint: Color(0xFFE8A94A),
    buttonColor: Color(0xFFE8A94A),
    selectedColor: Color(0xFFE8A94A),
    focusColor: Color(0xFFCF9138),
  ),
  AccentColorOption.rosePink: AccentPalette(
    primary: Color(0xFFF25C97),
    primaryContainer: Color(0xFF5C2740),
    secondary: Color(0xFFE0447F),
    secondaryContainer: Color(0xFF421C2F),
    surfaceTint: Color(0xFFF25C97),
    buttonColor: Color(0xFFF25C97),
    selectedColor: Color(0xFFF25C97),
    focusColor: Color(0xFFE0447F),
  ),
};

extension AccentColorOptionX on AccentColorOption {
  AccentPalette get palette => accentPalettes[this]!;

  String get label {
    switch (this) {
      case AccentColorOption.emerald:
        return 'Emerald';
      case AccentColorOption.oceanBlue:
        return 'Ocean Blue';
      case AccentColorOption.purpleVelvet:
        return 'Purple Velvet';
      case AccentColorOption.sunsetOrange:
        return 'Sunset Orange';
      case AccentColorOption.midnightAmber:
        return 'Midnight Amber';
      case AccentColorOption.rosePink:
        return 'Rose Pink';
    }
  }

  /// Emerald stays free (matches today's default identity); the rest are Pro.
  bool get isPro => this != AccentColorOption.emerald;
}

/// A small color-set record describing how surfaces should look for a given
/// background style, in dark mode.
@immutable
class BackgroundColorSet {
  final Color background;
  final Color surface;
  final Color card;
  final Color elevatedCard;
  final Color bottomSheet;
  final Color dialog;
  final Color navBar;

  const BackgroundColorSet({
    required this.background,
    required this.surface,
    required this.card,
    required this.elevatedCard,
    required this.bottomSheet,
    required this.dialog,
    required this.navBar,
  });
}

/// Free + Pro background styles (dark-mode surface treatments).
enum BackgroundStyleOption { standard, oledBlack, deepNavy, softGradient }

const Map<BackgroundStyleOption, BackgroundColorSet> backgroundColorSets = {
  BackgroundStyleOption.standard: BackgroundColorSet(
    background: Colors.black,
    surface: Color(0xFF171921),
    card: Color(0xFF171921),
    elevatedCard: Color(0xFF1E212B),
    bottomSheet: Colors.black,
    dialog: Colors.black,
    navBar: Color(0xFF171921),
  ),
  // NOTE: OLED is near-black, NOT pure black everywhere — surfaces are kept
  // a shade lighter than background so elevation is still perceivable.
  BackgroundStyleOption.oledBlack: BackgroundColorSet(
    background: Color(0xFF000000),
    surface: Color(0xFF0A0A0A),
    card: Color(0xFF0D0D0D),
    elevatedCard: Color(0xFF141414),
    bottomSheet: Color(0xFF0A0A0A),
    dialog: Color(0xFF0A0A0A),
    navBar: Color(0xFF050505),
  ),
  BackgroundStyleOption.deepNavy: BackgroundColorSet(
    background: Color(0xFF0B0F1A),
    surface: Color(0xFF141A2A),
    card: Color(0xFF141A2A),
    elevatedCard: Color(0xFF1B2337),
    bottomSheet: Color(0xFF0B0F1A),
    dialog: Color(0xFF0B0F1A),
    navBar: Color(0x80101522),
  ),
  BackgroundStyleOption.softGradient: BackgroundColorSet(
    background: Color(0xFF16141F),
    surface: Color(0xFF201C2E),
    card: Color(0xFF201C2E),
    elevatedCard: Color(0xFF2A2440),
    bottomSheet: Color(0xFF16141F),
    dialog: Color(0xFF16141F),
    navBar: Color(0xFF1B1828),
  ),
};

extension BackgroundStyleOptionX on BackgroundStyleOption {
  BackgroundColorSet get colorSet => backgroundColorSets[this]!;

  String get label {
    switch (this) {
      case BackgroundStyleOption.standard:
        return 'Standard';
      case BackgroundStyleOption.oledBlack:
        return 'OLED Black';
      case BackgroundStyleOption.deepNavy:
        return 'Deep Navy';
      case BackgroundStyleOption.softGradient:
        return 'Soft Gradient';
    }
  }

  /// Standard stays free (matches today's default identity); the rest Pro.
  bool get isPro => this != BackgroundStyleOption.standard;
}

/// A fully data-driven premium theme: pairs an accent + background style
/// (with optional per-token overrides) under one named, Pro-only preset.
@immutable
class PremiumThemeConfiguration {
  final String id;
  final String name;
  final bool isPro;
  final AccentColorOption accent;
  final BackgroundStyleOption backgroundStyle;

  const PremiumThemeConfiguration({
    required this.id,
    required this.name,
    required this.accent,
    required this.backgroundStyle,
    this.isPro = true,
  });

  AccentPalette get accentPalette => accent.palette;
  BackgroundColorSet get backgroundColorSet => backgroundStyle.colorSet;
}

/// 8 curated premium themes, purely data — no per-theme UI branching
/// anywhere else in the app.
const List<PremiumThemeConfiguration> premiumThemeConfigurations = [
  PremiumThemeConfiguration(
    id: 'emerald',
    name: 'Emerald',
    accent: AccentColorOption.emerald,
    backgroundStyle: BackgroundStyleOption.standard,
  ),
  PremiumThemeConfiguration(
    id: 'ocean',
    name: 'Ocean',
    accent: AccentColorOption.oceanBlue,
    backgroundStyle: BackgroundStyleOption.deepNavy,
  ),
  PremiumThemeConfiguration(
    id: 'midnight',
    name: 'Midnight',
    accent: AccentColorOption.midnightAmber,
    backgroundStyle: BackgroundStyleOption.deepNavy,
  ),
  PremiumThemeConfiguration(
    id: 'purple_velvet',
    name: 'Purple Velvet',
    accent: AccentColorOption.purpleVelvet,
    backgroundStyle: BackgroundStyleOption.softGradient,
  ),
  PremiumThemeConfiguration(
    id: 'sunset',
    name: 'Sunset',
    accent: AccentColorOption.sunsetOrange,
    backgroundStyle: BackgroundStyleOption.standard,
  ),
  PremiumThemeConfiguration(
    id: 'rose',
    name: 'Rose',
    accent: AccentColorOption.rosePink,
    backgroundStyle: BackgroundStyleOption.softGradient,
  ),
  PremiumThemeConfiguration(
    id: 'cyber',
    name: 'Cyber',
    accent: AccentColorOption.oceanBlue,
    backgroundStyle: BackgroundStyleOption.oledBlack,
  ),
  PremiumThemeConfiguration(
    id: 'amoled',
    name: 'AMOLED',
    accent: AccentColorOption.emerald,
    backgroundStyle: BackgroundStyleOption.oledBlack,
  ),
];
