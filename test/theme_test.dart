import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todo_health_reminders/providers/theme_provider.dart';
import 'package:todo_health_reminders/utils/constants.dart';
import 'package:todo_health_reminders/screens/settings_screen.dart';

void main() {
  group('Theme System Tests', () {
    testWidgets('ThemeProvider initializes with default teal theme', (WidgetTester tester) async {
      final themeProvider = ThemeProvider();
      
      // Should start with teal theme
      expect(themeProvider.currentTheme, AppThemeType.teal);
      expect(themeProvider.themeName, 'Ocean Teal');
      expect(themeProvider.primaryColor, ThemeConfig.tealPrimary);
    });

    testWidgets('ThemeProvider can switch to sunny day theme', (WidgetTester tester) async {
      final themeProvider = ThemeProvider();
      
      // Switch to sunny day theme
      await themeProvider.setTheme(AppThemeType.sunnyDay);
      
      expect(themeProvider.currentTheme, AppThemeType.sunnyDay);
      expect(themeProvider.themeName, 'Sunny Day');
      expect(themeProvider.primaryColor, ThemeConfig.sunnyPrimary);
    });

    testWidgets('Settings screen shows theme options', (WidgetTester tester) async {
      final themeProvider = ThemeProvider();
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<ThemeProvider>.value(
            value: themeProvider,
            child: const SettingsScreen(),
          ),
        ),
      );

      // Should show settings title
      expect(find.text('Settings'), findsOneWidget);
      
      // Should show theme section
      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('Choose your preferred color theme'), findsOneWidget);
      
      // Should show both theme options
      expect(find.text('Ocean Teal'), findsOneWidget);
      expect(find.text('Sunny Day'), findsOneWidget);
      
      // Should show theme descriptions
      expect(find.text('Cool and calming teal theme'), findsOneWidget);
      expect(find.text('Bright and energetic orange & yellow theme'), findsOneWidget);
    });

    testWidgets('Can select sunny day theme in settings', (WidgetTester tester) async {
      final themeProvider = ThemeProvider();
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<ThemeProvider>.value(
            value: themeProvider,
            child: const SettingsScreen(),
          ),
        ),
      );

      // Initially teal should be selected
      expect(themeProvider.currentTheme, AppThemeType.teal);
      
      // Tap on Sunny Day option
      await tester.tap(find.text('Sunny Day'));
      await tester.pumpAndSettle();

      // Should have switched to sunny day theme
      expect(themeProvider.currentTheme, AppThemeType.sunnyDay);
    });

    test('Theme colors are configured correctly', () {
      // Test teal theme colors
      expect(ThemeConfig.getPrimaryColor(AppThemeType.teal), ThemeConfig.tealPrimary);
      expect(ThemeConfig.getSecondaryColor(AppThemeType.teal), ThemeConfig.tealSecondary);
      
      // Test sunny day theme colors
      expect(ThemeConfig.getPrimaryColor(AppThemeType.sunnyDay), ThemeConfig.sunnyPrimary);
      expect(ThemeConfig.getSecondaryColor(AppThemeType.sunnyDay), ThemeConfig.sunnySecondary);
    });

    test('Theme data generation works for both themes', () {
      // Test light themes
      final tealLightTheme = AppTheme.getLightTheme(AppThemeType.teal);
      final sunnyLightTheme = AppTheme.getLightTheme(AppThemeType.sunnyDay);
      
      expect(tealLightTheme.colorScheme.brightness, Brightness.light);
      expect(sunnyLightTheme.colorScheme.brightness, Brightness.light);
      
      // Test dark themes
      final tealDarkTheme = AppTheme.getDarkTheme(AppThemeType.teal);
      final sunnyDarkTheme = AppTheme.getDarkTheme(AppThemeType.sunnyDay);
      
      expect(tealDarkTheme.colorScheme.brightness, Brightness.dark);
      expect(sunnyDarkTheme.colorScheme.brightness, Brightness.dark);
    });
  });
}