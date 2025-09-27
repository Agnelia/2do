import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');
  static const String _localePreferenceKey = 'selected_locale';

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('sv'),
  ];

  Locale get currentLocale => _currentLocale;

  LocaleProvider() {
    _loadLocaleFromPreferences();
  }

  // Load saved locale from SharedPreferences
  Future<void> _loadLocaleFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocaleCode = prefs.getString(_localePreferenceKey);
      if (savedLocaleCode != null) {
        final savedLocale = Locale(savedLocaleCode);
        if (supportedLocales.contains(savedLocale)) {
          _currentLocale = savedLocale;
          notifyListeners();
        }
      }
    } catch (e) {
      // If loading fails, keep default locale
      debugPrint('Failed to load locale preference: $e');
    }
  }

  // Save locale to SharedPreferences
  Future<void> _saveLocaleToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localePreferenceKey, _currentLocale.languageCode);
    } catch (e) {
      debugPrint('Failed to save locale preference: $e');
    }
  }

  // Change the current locale
  Future<void> setLocale(Locale locale) async {
    if (_currentLocale != locale && supportedLocales.contains(locale)) {
      _currentLocale = locale;
      notifyListeners();
      await _saveLocaleToPreferences();
    }
  }

  // Get language name for display
  String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'sv':
        return 'Svenska';
      default:
        return locale.languageCode;
    }
  }

  // Get language name in English for display
  String getLanguageNameInEnglish(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'sv':
        return 'Swedish';
      default:
        return locale.languageCode;
    }
  }
}