import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import 'package:todo_health_reminders/models/inspiration_image.dart';
import 'package:todo_health_reminders/models/inspiration_theme.dart';
import 'package:todo_health_reminders/models/image_style.dart';

class InspirationProvider extends ChangeNotifier {
  static const String _savedImagesKey = 'saved_images';
  static const String _userArtworksKey = 'user_artworks';
  
  List<SavedImage> _savedImages = [];
  List<InspirationImage> _userArtworks = [];
  List<InspirationImage> _currentSuggestions = [];
  InspirationTheme? _selectedTheme;
  ImageStyle? _selectedStyle;
  ImageSource _selectedSource = ImageSource.internet;
  
  List<SavedImage> get savedImages => _savedImages;
  List<InspirationImage> get userArtworks => _userArtworks;
  List<InspirationImage> get currentSuggestions => _currentSuggestions;
  InspirationTheme? get selectedTheme => _selectedTheme;
  ImageStyle? get selectedStyle => _selectedStyle;
  ImageSource get selectedSource => _selectedSource;
  
  InspirationProvider() {
    _loadData();
  }
  
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load saved images
    final savedImagesJson = prefs.getString(_savedImagesKey);
    if (savedImagesJson != null) {
      try {
        final List<dynamic> decoded = json.decode(savedImagesJson);
        _savedImages = decoded
            .map((item) => SavedImage.fromJson(item))
            .toList();
        
        // Remove images older than 3 months
        _savedImages.removeWhere((img) => img.shouldBeRemoved());
        await _saveSavedImages();
      } catch (e) {
        debugPrint('Error loading saved images: $e');
      }
    }
    
    // Load user artworks
    final userArtworksJson = prefs.getString(_userArtworksKey);
    if (userArtworksJson != null) {
      try {
        final List<dynamic> decoded = json.decode(userArtworksJson);
        _userArtworks = decoded
            .map((item) => InspirationImage.fromJson(item))
            .toList();
      } catch (e) {
        debugPrint('Error loading user artworks: $e');
      }
    }
    
    notifyListeners();
  }
  
  Future<void> _saveSavedImages() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(_savedImages.map((img) => img.toJson()).toList());
    await prefs.setString(_savedImagesKey, encoded);
  }
  
  Future<void> _saveUserArtworks() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(_userArtworks.map((img) => img.toJson()).toList());
    await prefs.setString(_userArtworksKey, encoded);
  }
  
  void setTheme(InspirationTheme theme) {
    _selectedTheme = theme;
    notifyListeners();
  }
  
  void setStyle(ImageStyle style) {
    _selectedStyle = style;
    notifyListeners();
  }
  
  void setSource(ImageSource source) {
    _selectedSource = source;
    _currentSuggestions.clear();
    notifyListeners();
  }
  
  void generateSuggestions() {
    if (_selectedTheme == null || _selectedStyle == null) {
      return;
    }
    
    _currentSuggestions = _generateMockImages(4);
    notifyListeners();
  }
  
  void removeAndReplaceSuggestion(String imageId) {
    _currentSuggestions.removeWhere((img) => img.id == imageId);
    
    // Generate one new suggestion
    if (_currentSuggestions.length < 4) {
      final newImages = _generateMockImages(4 - _currentSuggestions.length);
      _currentSuggestions.addAll(newImages);
    }
    
    notifyListeners();
  }
  
  Future<void> saveImage(InspirationImage image) async {
    final savedImage = SavedImage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      image: image,
      savedAt: DateTime.now(),
    );
    
    _savedImages.insert(0, savedImage);
    await _saveSavedImages();
    notifyListeners();
  }
  
  Future<void> removeSavedImage(String savedImageId) async {
    _savedImages.removeWhere((img) => img.id == savedImageId);
    await _saveSavedImages();
    notifyListeners();
  }
  
  Future<void> uploadArtwork(String imageUrl, String username) async {
    if (_selectedTheme == null || _selectedStyle == null) {
      return;
    }
    
    final artwork = InspirationImage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imageUrl: imageUrl,
      theme: _selectedTheme!,
      style: _selectedStyle!,
      source: ImageSource.userUploaded,
      uploaderUsername: username,
      createdAt: DateTime.now(),
    );
    
    _userArtworks.insert(0, artwork);
    await _saveUserArtworks();
    notifyListeners();
  }
  
  Future<void> addComment(String imageId, String comment) async {
    final index = _userArtworks.indexWhere((img) => img.id == imageId);
    if (index != -1) {
      final updatedComments = List<String>.from(_userArtworks[index].comments)
        ..add(comment);
      _userArtworks[index] = _userArtworks[index].copyWith(
        comments: updatedComments,
      );
      await _saveUserArtworks();
      notifyListeners();
    }
  }
  
  void clearSelection() {
    _selectedTheme = null;
    _selectedStyle = null;
    _currentSuggestions.clear();
    notifyListeners();
  }
  
  // Mock image generation - in a real app, this would fetch from an API
  List<InspirationImage> _generateMockImages(int count) {
    final random = Random();
    final images = <InspirationImage>[];
    
    for (int i = 0; i < count; i++) {
      final source = _selectedSource;
      images.add(InspirationImage(
        id: '${DateTime.now().millisecondsSinceEpoch}_$i',
        imageUrl: 'https://picsum.photos/400/300?random=${random.nextInt(10000)}',
        theme: _selectedTheme!,
        style: _selectedStyle!,
        source: source,
        uploaderUsername: source == ImageSource.userUploaded
            ? 'user${random.nextInt(100)}'
            : null,
        createdAt: DateTime.now(),
      ));
    }
    
    return images;
  }
}
