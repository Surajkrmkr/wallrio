import 'package:flutter/material.dart';

import '../services/dark_mode_services.dart';

class DarkThemeProvider with ChangeNotifier {
  bool _darkTheme = true;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    ThemeService().saveThemeMode(value);
    notifyListeners();
  }

  DarkThemeProvider() {
    getDarkTheme();
  }

  void getDarkTheme() {
    _darkTheme = ThemeService.darkTheme;
    notifyListeners();
  }
}
