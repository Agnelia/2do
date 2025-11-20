import 'package:flutter/material.dart';

/// Available themes for inspiration search
enum InspirationTheme {
  animals,
  nature,
  fantasy,
  people,
  flowers,
  abstract,
  landscape,
  portrait,
  stillLife,
}

extension InspirationThemeExtension on InspirationTheme {
  String get displayName {
    switch (this) {
      case InspirationTheme.animals:
        return 'Djur';
      case InspirationTheme.nature:
        return 'Natur';
      case InspirationTheme.fantasy:
        return 'Fantasy';
      case InspirationTheme.people:
        return 'Människor';
      case InspirationTheme.flowers:
        return 'Blommor';
      case InspirationTheme.abstract:
        return 'Abstrakt';
      case InspirationTheme.landscape:
        return 'Landskap';
      case InspirationTheme.portrait:
        return 'Porträtt';
      case InspirationTheme.stillLife:
        return 'Stilleben';
    }
  }
  
  IconData get icon {
    switch (this) {
      case InspirationTheme.animals:
        return Icons.pets;
      case InspirationTheme.nature:
        return Icons.forest;
      case InspirationTheme.fantasy:
        return Icons.auto_awesome;
      case InspirationTheme.people:
        return Icons.people;
      case InspirationTheme.flowers:
        return Icons.local_florist;
      case InspirationTheme.abstract:
        return Icons.brush;
      case InspirationTheme.landscape:
        return Icons.landscape;
      case InspirationTheme.portrait:
        return Icons.face;
      case InspirationTheme.stillLife:
        return Icons.coffee;
    }
  }
}
