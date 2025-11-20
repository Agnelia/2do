import 'package:flutter_test/flutter_test.dart';
import 'package:todo_health_reminders/providers/inspiration_provider.dart';
import 'package:todo_health_reminders/models/inspiration_theme.dart';
import 'package:todo_health_reminders/models/image_style.dart';
import 'package:todo_health_reminders/models/inspiration_image.dart';

void main() {
  group('InspirationProvider Tests', () {
    test('InspirationProvider initial state', () {
      final provider = InspirationProvider();
      
      expect(provider.savedImages, isEmpty);
      expect(provider.userArtworks, isEmpty);
      expect(provider.currentSuggestions, isEmpty);
      expect(provider.selectedTheme, isNull);
      expect(provider.selectedStyle, isNull);
      expect(provider.selectedSource, equals(ImageSource.internet));
    });

    test('Set theme updates selected theme', () {
      final provider = InspirationProvider();
      
      provider.setTheme(InspirationTheme.animals);
      
      expect(provider.selectedTheme, equals(InspirationTheme.animals));
    });

    test('Set style updates selected style', () {
      final provider = InspirationProvider();
      
      provider.setStyle(ImageStyle.simpleWithBackground);
      
      expect(provider.selectedStyle, equals(ImageStyle.simpleWithBackground));
    });

    test('Set source updates selected source and clears suggestions', () {
      final provider = InspirationProvider();
      
      // Generate some suggestions first
      provider.setTheme(InspirationTheme.nature);
      provider.setStyle(ImageStyle.realisticDetailed);
      provider.generateSuggestions();
      
      expect(provider.currentSuggestions, isNotEmpty);
      
      // Change source should clear suggestions
      provider.setSource(ImageSource.userUploaded);
      
      expect(provider.selectedSource, equals(ImageSource.userUploaded));
      expect(provider.currentSuggestions, isEmpty);
    });

    test('Generate suggestions creates 4 images', () {
      final provider = InspirationProvider();
      
      provider.setTheme(InspirationTheme.flowers);
      provider.setStyle(ImageStyle.bohemianDetailed);
      provider.generateSuggestions();
      
      expect(provider.currentSuggestions.length, equals(4));
      expect(provider.currentSuggestions.first.theme, equals(InspirationTheme.flowers));
      expect(provider.currentSuggestions.first.style, equals(ImageStyle.bohemianDetailed));
    });

    test('Remove and replace suggestion maintains 4 suggestions', () {
      final provider = InspirationProvider();
      
      provider.setTheme(InspirationTheme.fantasy);
      provider.setStyle(ImageStyle.tropicalSimple);
      provider.generateSuggestions();
      
      final firstImageId = provider.currentSuggestions.first.id;
      
      provider.removeAndReplaceSuggestion(firstImageId);
      
      expect(provider.currentSuggestions.length, equals(4));
      expect(provider.currentSuggestions.any((img) => img.id == firstImageId), isFalse);
    });

    test('Clear selection resets all selections', () {
      final provider = InspirationProvider();
      
      provider.setTheme(InspirationTheme.people);
      provider.setStyle(ImageStyle.simpleWithoutBackground);
      provider.generateSuggestions();
      
      provider.clearSelection();
      
      expect(provider.selectedTheme, isNull);
      expect(provider.selectedStyle, isNull);
      expect(provider.currentSuggestions, isEmpty);
    });

    test('SavedImage shouldBeRemoved returns true after 3 months', () {
      final image = InspirationImage(
        id: 'test',
        imageUrl: 'https://example.com/image.jpg',
        theme: InspirationTheme.abstract,
        style: ImageStyle.realisticSimple,
        source: ImageSource.internet,
        createdAt: DateTime.now(),
      );
      
      // Create saved image from 4 months ago
      final oldDate = DateTime.now().subtract(const Duration(days: 120));
      final savedImage = SavedImage(
        id: 'saved1',
        image: image,
        savedAt: oldDate,
      );
      
      expect(savedImage.shouldBeRemoved(), isTrue);
      
      // Create recent saved image
      final recentSavedImage = SavedImage(
        id: 'saved2',
        image: image,
        savedAt: DateTime.now(),
      );
      
      expect(recentSavedImage.shouldBeRemoved(), isFalse);
    });
  });
}
