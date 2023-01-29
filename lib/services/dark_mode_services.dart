import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  final darkKey = "isDarkMode";
  final accentColorKey = "accent";

  static bool darkTheme = true;

  Future getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isDarkMode = prefs.getBool(darkKey) ?? true;
    darkTheme = isDarkMode;
  }

  void saveThemeMode(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(darkKey, val);
  }
}
