import 'package:flutter/material.dart';
import 'dark_theme.dart';
import 'light_theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _currentTheme = lightTheme;
  bool _isDark = false;

  ThemeData get theme => _currentTheme;
  bool get isDark => _isDark;

  void toggleTheme() {
    if (_isDark) {
      _currentTheme = lightTheme;
      _isDark = false;
    } else {
      _currentTheme = darkTheme;
      _isDark = true;
    }
    notifyListeners();
  }

  // Eğer sistem teması ile eşleşmek istersen:
  void setSystemTheme(Brightness brightness) {
    if (brightness == Brightness.dark) {
      _currentTheme = darkTheme;
      _isDark = true;
    } else {
      _currentTheme = lightTheme;
      _isDark = false;
    }
    notifyListeners();
  }
}