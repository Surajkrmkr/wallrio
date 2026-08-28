import 'package:flutter/material.dart';

/// Semantic color tokens layered on top of the existing ColorScheme/TextTheme.
///
/// This does NOT replace `bgDarkAccentColor`/`bgDark2Color`/etc from
/// theme_data.dart — those constants remain valid for call sites that don't
/// need theme-awareness. `AppSemanticColors` exists so that widgets which
/// SHOULD react to the user's chosen accent/background style/premium theme
/// can look the value up via `Theme.of(context).extension<AppSemanticColors>()`
/// instead of hardcoding a literal `Color(0x...)`.
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  final Color background;
  final Color surface;
  final Color surfaceElevated;
  final Color card;
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color accentContainer;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color divider;
  final Color icon;
  final Color buttonPrimary;
  final Color buttonSecondary;
  final Color danger;
  final Color success;
  final Color warning;

  const AppSemanticColors({
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.card,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.accentContainer,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.divider,
    required this.icon,
    required this.buttonPrimary,
    required this.buttonSecondary,
    required this.danger,
    required this.success,
    required this.warning,
  });

  @override
  AppSemanticColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceElevated,
    Color? card,
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? accentContainer,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? divider,
    Color? icon,
    Color? buttonPrimary,
    Color? buttonSecondary,
    Color? danger,
    Color? success,
    Color? warning,
  }) {
    return AppSemanticColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      card: card ?? this.card,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      accentContainer: accentContainer ?? this.accentContainer,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      divider: divider ?? this.divider,
      icon: icon ?? this.icon,
      buttonPrimary: buttonPrimary ?? this.buttonPrimary,
      buttonSecondary: buttonSecondary ?? this.buttonSecondary,
      danger: danger ?? this.danger,
      success: success ?? this.success,
      warning: warning ?? this.warning,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t) ?? a;
    return AppSemanticColors(
      background: l(background, other.background),
      surface: l(surface, other.surface),
      surfaceElevated: l(surfaceElevated, other.surfaceElevated),
      card: l(card, other.card),
      primary: l(primary, other.primary),
      secondary: l(secondary, other.secondary),
      accent: l(accent, other.accent),
      accentContainer: l(accentContainer, other.accentContainer),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      textTertiary: l(textTertiary, other.textTertiary),
      divider: l(divider, other.divider),
      icon: l(icon, other.icon),
      buttonPrimary: l(buttonPrimary, other.buttonPrimary),
      buttonSecondary: l(buttonSecondary, other.buttonSecondary),
      danger: l(danger, other.danger),
      success: l(success, other.success),
      warning: l(warning, other.warning),
    );
  }
}

/// Convenience accessor: `context.appColors`.
extension AppSemanticColorsX on BuildContext {
  AppSemanticColors get appColors =>
      Theme.of(this).extension<AppSemanticColors>() ??
      const AppSemanticColors(
        background: Colors.black,
        surface: Color(0xFF171921),
        surfaceElevated: Color(0xFF1E212B),
        card: Color(0xFF171921),
        primary: Color(0xFF37C3A3),
        secondary: Color(0xFF2ABFAA),
        accent: Color(0xFF37C3A3),
        accentContainer: Color(0x2637C3A3),
        textPrimary: Colors.white,
        textSecondary: Color(0xB3FFFFFF),
        textTertiary: Color(0x66FFFFFF),
        divider: Color(0x14FFFFFF),
        icon: Colors.white,
        buttonPrimary: Color(0xFF37C3A3),
        buttonSecondary: Color(0x1AFFFFFF),
        danger: Color(0xFFE05252),
        success: Color(0xFF4CAF50),
        warning: Color(0xFFF2A93B),
      );
}
