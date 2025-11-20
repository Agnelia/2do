/// Available image styles for inspiration search
enum ImageStyle {
  simpleWithBackground,
  simpleWithoutBackground,
  tropicalDetailed,
  tropicalSimple,
  realisticDetailed,
  realisticSimple,
  bohemianDetailed,
  bohemianSimple,
}

extension ImageStyleExtension on ImageStyle {
  String get displayName {
    switch (this) {
      case ImageStyle.simpleWithBackground:
        return 'Enkel med bakgrund';
      case ImageStyle.simpleWithoutBackground:
        return 'Enkel utan bakgrund';
      case ImageStyle.tropicalDetailed:
        return 'Tropisk med mycket detaljer';
      case ImageStyle.tropicalSimple:
        return 'Tropisk med enkla detaljer';
      case ImageStyle.realisticDetailed:
        return 'Naturtrogen med mycket detaljer';
      case ImageStyle.realisticSimple:
        return 'Naturtrogen med enkla detaljer';
      case ImageStyle.bohemianDetailed:
        return 'Bohemisk stil med mycket detaljer';
      case ImageStyle.bohemianSimple:
        return 'Bohemisk stil med lite detaljer';
    }
  }
  
  String get description {
    switch (this) {
      case ImageStyle.simpleWithBackground:
        return 'Enkla motiv med bakgrund';
      case ImageStyle.simpleWithoutBackground:
        return 'Enkla motiv utan bakgrund';
      case ImageStyle.tropicalDetailed:
        return 'Rika tropiska motiv';
      case ImageStyle.tropicalSimple:
        return 'Enkla tropiska motiv';
      case ImageStyle.realisticDetailed:
        return 'Detaljerade realistiska motiv';
      case ImageStyle.realisticSimple:
        return 'Enkla realistiska motiv';
      case ImageStyle.bohemianDetailed:
        return 'Rika bohemiska motiv';
      case ImageStyle.bohemianSimple:
        return 'Enkla bohemiska motiv';
    }
  }
}
