// Suggested code may be subject to a license. Learn more: ~LicenseLog:3825845726.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1394384464.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1058609424.
import 'package:almacen_de_ofertas/config/app_theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme;

  ThemeProvider({required bool isDarkMode})
      : _currentTheme = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

  ThemeData get currentTheme => _currentTheme;

  setLightMode() {
    _currentTheme = AppTheme.lightTheme;
    notifyListeners();
  }

  setDarkMode() {
    _currentTheme = AppTheme.darkTheme;
    notifyListeners();
  }
}
