import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_health_reminders/utils/constants.dart';

class ThemeProvider extends ChangeNotifier {
  AppThemeType _currentTheme = AppThemeType.sunnyDay;
  static const String _themePreferenceKey = 'selected_theme';

  AppThemeType get currentTheme => _currentTheme;

  ThemeProvider() {
    _loadThemeFromPreferences();
  }

  // Load saved theme from SharedPreferences
  Future<void> _loadThemeFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedThemeIndex = prefs.getInt(_themePreferenceKey);
      if (savedThemeIndex != null && savedThemeIndex < AppThemeType.values.length) {
        _currentTheme = AppThemeType.values[savedThemeIndex];
        notifyListeners();
      }
    } catch (e) {
      // If loading fails, keep default theme
      debugPrint('Failed to load theme preference: $e');
    }
  }

  // Save theme to SharedPreferences
  Future<void> _saveThemeToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themePreferenceKey, _currentTheme.index);
    } catch (e) {
      debugPrint('Failed to save theme preference: $e');
    }
  }

  // Change the current theme
  Future<void> setTheme(AppThemeType theme) async {
    if (_currentTheme != theme) {
      _currentTheme = theme;
      notifyListeners();
      await _saveThemeToPreferences();
    }
  }

  // Get the current light theme
  ThemeData get lightTheme => AppTheme.getLightTheme(_currentTheme);

  // Get the current dark theme
  ThemeData get darkTheme => AppTheme.getDarkTheme(_currentTheme);

  // Get theme name for display
  String get themeName {
    switch (_currentTheme) {
      case AppThemeType.teal:
        return 'Ocean Teal';
      case AppThemeType.sunnyDay:
        return 'Sunny Day';
    }
  }

  // Get theme description
  String get themeDescription {
    switch (_currentTheme) {
      case AppThemeType.teal:
        return 'Cool and calming teal theme';
      case AppThemeType.sunnyDay:
        return 'Bright and energetic orange & yellow theme';
    }
  }

  // Get theme icon
  IconData get themeIcon {
    switch (_currentTheme) {
      case AppThemeType.teal:
        return Icons.water;
      case AppThemeType.sunnyDay:
        return Icons.wb_sunny;
    }
  }

  // Get primary color for current theme
  Color get primaryColor => ThemeConfig.getPrimaryColor(_currentTheme);

  // Get secondary color for current theme
  Color get secondaryColor => ThemeConfig.getSecondaryColor(_currentTheme);

  // Get category colors for current theme
  Map<String, Color> get categoryColors => AppConstants.getCategoryColors(_currentTheme);
}