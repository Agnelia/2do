import 'package:flutter/material.dart';

/// Color palette for the Inspiration app - vintage colorful with matte finish
class InspirationColors {
  // Main vintage color palette
  static const Color orange = Color(0xFFE67E22); // Warm orange
  static const Color lightOrange = Color(0xFFF39C12); // Light orange
  static const Color darkGreen = Color(0xFF27AE60); // Dark green
  static const Color lightGreen = Color(0xFF52BE80); // Light green
  static const Color copper = Color(0xFFB87333); // Copper
  static const Color yellow = Color(0xFFF4D03F); // Mellow yellow
  static const Color turquoise = Color(0xFF1ABC9C); // Turquoise-green
  
  // Banner colors
  static const Color gold = Color(0xFFFFD700); // Gold for sun
  static const Color red = Color(0xFFE74C3C); // Red for sun gradient
  
  // Background and text
  static const Color background = Colors.white;
  static const Color text = Colors.black;
  static const Color textSecondary = Color(0xFF555555);
  
  // Card and surface colors with matte finish
  static Color cardBackground = Colors.white.withOpacity(0.95);
  static Color surfaceHighlight = orange.withOpacity(0.1);
  
  /// Get a random color from the palette for variety
  static Color getRandomColor() {
    final colors = [
      orange,
      lightOrange,
      darkGreen,
      lightGreen,
      copper,
      yellow,
      turquoise,
    ];
    return colors[(DateTime.now().millisecondsSinceEpoch % colors.length)];
  }
}
