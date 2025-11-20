/// Enum representing the app modes available in the application
enum AppMode {
  health,
  inspiration,
}

/// Extension to provide human-readable names for app modes
extension AppModeExtension on AppMode {
  String get displayName {
    switch (this) {
      case AppMode.health:
        return 'Health';
      case AppMode.inspiration:
        return 'Inspirationsappen';
    }
  }
  
  String get description {
    switch (this) {
      case AppMode.health:
        return 'Track your health reminders and goals';
      case AppMode.inspiration:
        return 'Find artistic inspiration and share your work';
    }
  }
}
