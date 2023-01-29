import 'package:shared_preferences/shared_preferences.dart';

import '../ui/theme/theme_data.dart';

class ThemeService {
  final darkKey = "isDarkMode";
  final gradientKey = "gradient";

  static bool darkTheme = true;
  static GradientType gradType = GradientType.defaultType;

  Future getData() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isDarkMode = prefs.getBool(darkKey) ?? true;
    final GradientType savedGradType = getGradType(prefs);
    darkTheme = isDarkMode;
    gradType = savedGradType;
  }

  void saveThemeMode(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(darkKey, val);
  }

  void saveGradient(GradientType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(gradientKey, type.name);
  }

  GradientType getGradType(prefs) {
    final val = prefs.getString(gradientKey);
    if (val == null) {
      return GradientType.defaultType;
    }
    final GradientType type =
        GradientType.values.firstWhere((grad) => grad.name == val);
    return type;
  }
}
