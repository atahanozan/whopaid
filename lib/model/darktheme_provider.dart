import 'package:flutter/material.dart';
import 'package:whopayed/helper/themes_custom.dart';

class DarkThemeProvider with ChangeNotifier {
  ThemeClass darkThemePreference = ThemeClass();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}
