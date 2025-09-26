import 'package:flutter/material.dart';

// Theme Enums
enum AppThemeType {
  teal,
  sunnyDay,
}

class AppConstants {
  // App Information
  static const String appName = '2do Health Reminders';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'A responsive Flutter app for health-related reminders';

  // Colors
  static const Color primaryColor = Colors.teal;
  static const Color secondaryColor = Colors.tealAccent;
  static const Color errorColor = Colors.red;
  static const Color warningColor = Colors.orange;
  static const Color successColor = Colors.green;
  static const Color infoColor = Colors.blue;

  // Priority Colors
  static const Color urgentColor = Colors.red;
  static const Color highColor = Colors.orange;
  static const Color mediumColor = Colors.yellow;
  static const Color lowColor = Colors.green;

  // Category Colors
  static const Map<String, Color> categoryColors = {
    'Medication': Colors.red,
    'Exercise': Colors.orange,
    'Water': Colors.blue,
    'Sleep': Colors.purple,
    'Nutrition': Colors.green,
    'Mental Health': Colors.teal,
    'Other': Colors.grey,
  };

  // Sunny Day Category Colors - more vibrant variants
  static const Map<String, Color> sunnyCategoryColors = {
    'Medication': Color(0xFFE91E63), // Pink 500 - keep as vibrant pink
    'Exercise': Color(0xFFFF3D00), // Deep Orange 700 - more vibrant orange
    'Water': Color(0xFF1976D2), // Blue 700 - more vibrant blue
    'Sleep': Color(0xFF7B1FA2), // Purple 700 - more vibrant purple
    'Nutrition': Color(0xFF388E3C), // Green 700 - more vibrant green
    'Mental Health': Color(0xFF0097A7), // Cyan 700 - more vibrant cyan
    'Other': Color(0xFF455A64), // Blue Grey 700 - more vibrant grey
  };
  
  // Get category colors based on theme
  static Map<String, Color> getCategoryColors(AppThemeType theme) {
    switch (theme) {
      case AppThemeType.teal:
        return categoryColors;
      case AppThemeType.sunnyDay:
        return sunnyCategoryColors;
    }
  }

  // Category Icons
  static const Map<String, IconData> categoryIcons = {
    'Medication': Icons.medication,
    'Exercise': Icons.fitness_center,
    'Water': Icons.water_drop,
    'Sleep': Icons.bedtime,
    'Nutrition': Icons.restaurant,
    'Mental Health': Icons.psychology,
    'Other': Icons.health_and_safety,
  };

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;

  // Border Radius
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 16.0;

  // Responsive Breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1200.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Default Values
  static const int defaultSnoozeMinutes = 15;
  static const int maxTagsPerReminder = 5;
  static const int maxReminderTitleLength = 100;
  static const int maxReminderDescriptionLength = 500;
  static const int maxNotesLength = 1000;

  // Storage Keys
  static const String remindersStorageKey = 'health_reminders';
  static const String settingsStorageKey = 'app_settings';
  static const String themeStorageKey = 'theme_mode';

  // Default Reminders Categories
  static const List<String> defaultCategories = [
    'Medication',
    'Exercise',
    'Water',
    'Sleep',
    'Nutrition',
    'Mental Health',
    'Other',
  ];

  // Snooze Options (in minutes)
  static const List<int> snoozeOptions = [15, 30, 60, 120, 1440]; // 15min, 30min, 1h, 2h, 24h

  // Chart Colors
  static const List<Color> chartColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
  ];

  // Health Score Thresholds
  static const int excellentHealthScore = 90;
  static const int goodHealthScore = 70;
  static const int fairHealthScore = 50;

  // Notification Settings
  static const String notificationChannelId = 'health_reminders';
  static const String notificationChannelName = 'Health Reminders';
  static const String notificationChannelDescription = 'Notifications for health reminders';

  // URLs
  static const String privacyPolicyUrl = 'https://2dohealth.com/privacy';
  static const String termsOfServiceUrl = 'https://2dohealth.com/terms';
  static const String supportUrl = 'https://2dohealth.com/support';
  static const String feedbackUrl = 'https://2dohealth.com/feedback';

  // Regular Expressions
  static final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final RegExp phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');

  // Error Messages
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'Please check your internet connection.';
  static const String validationErrorMessage = 'Please check your input and try again.';

  // Success Messages
  static const String reminderAddedMessage = 'Reminder added successfully!';
  static const String reminderUpdatedMessage = 'Reminder updated successfully!';
  static const String reminderDeletedMessage = 'Reminder deleted successfully!';
  static const String reminderCompletedMessage = 'Reminder completed!';

  // Feature Flags
  static const bool enableCloudSync = false;
  static const bool enableNotifications = true;
  static const bool enableAnalytics = false;
  static const bool enableDarkMode = true;

  // Limits
  static const int maxRemindersPerDay = 50;
  static const int maxCustomInterval = 365; // days
  static const int minCustomInterval = 1; // days
}

// Theme Configuration
class ThemeConfig {
  // Teal Theme Colors (original)
  static const Color tealPrimary = Colors.teal;
  static const Color tealSecondary = Colors.tealAccent;
  
  // Sunny Day Theme Colors - More vibrant versions
  static const Color sunnyPrimary = Color(0xFFFF6D00); // Deep Orange 400 - vibrant orange
  static const Color sunnySecondary = Color(0xFFFFEB3B); // Yellow 500 - vibrant yellow
  static const Color sunnyAccent = Color(0xFFFF5722); // Deep Orange 500 - intense orange
  static const Color sunnyHighlight = Color(0xFFFDD835); // Yellow 600 - bright golden yellow
  
  // Get primary color for theme
  static Color getPrimaryColor(AppThemeType theme) {
    switch (theme) {
      case AppThemeType.teal:
        return tealPrimary;
      case AppThemeType.sunnyDay:
        return sunnyPrimary;
    }
  }
  
  // Get secondary color for theme
  static Color getSecondaryColor(AppThemeType theme) {
    switch (theme) {
      case AppThemeType.teal:
        return tealSecondary;
      case AppThemeType.sunnyDay:
        return sunnySecondary;
    }
  }
}

class AppTheme {
  // Generate light theme for a specific theme type
  static ThemeData getLightTheme(AppThemeType themeType) {
    final primaryColor = ThemeConfig.getPrimaryColor(themeType);
    
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        filled: true,
      ),
    );
  }

  // Generate dark theme for a specific theme type
  static ThemeData getDarkTheme(AppThemeType themeType) {
    final primaryColor = ThemeConfig.getPrimaryColor(themeType);
    
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        filled: true,
      ),
    );
  }

  // Legacy getters for backward compatibility
  static ThemeData get lightTheme => getLightTheme(AppThemeType.teal);
  static ThemeData get darkTheme => getDarkTheme(AppThemeType.teal);
}