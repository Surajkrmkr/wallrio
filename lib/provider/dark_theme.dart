import 'package:flutter/material.dart';

import '../services/dark_mode_services.dart';
import '../ui/theme/theme_data.dart';
import '../ui/widgets/toast_widget.dart';

class DarkThemeProvider with ChangeNotifier {
  bool _darkTheme = true;

  GradientType _gradType = GradientType.sunset;

  bool get darkTheme => _darkTheme;

  GradientType get gradType => _gradType;

  set darkTheme(bool value) {
    _darkTheme = value;
    ThemeService().saveThemeMode(value);
    notifyListeners();
  }

  set gradType(GradientType type) {
    _gradType = type;
    ThemeService().saveGradient(type);
    ToastWidget.showToast("Gradient Changed");
    notifyListeners();
  }

  DarkThemeProvider() {
    getData();
  }

  void getData() {
    _darkTheme = ThemeService.darkTheme;
    _gradType = ThemeService.gradType;
    notifyListeners();
  }
}
