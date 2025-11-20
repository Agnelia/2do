import 'package:todo_health_reminders/models/inspiration_theme.dart';
import 'package:todo_health_reminders/models/image_style.dart';

/// Source of the inspiration image
enum ImageSource {
  internet,
  userUploaded,
}

class InspirationImage {
  final String id;
  final String imageUrl;
  final InspirationTheme theme;
  final ImageStyle style;
  final ImageSource source;
  final String? uploaderUsername;
  final DateTime createdAt;
  final List<String> comments;
  
  InspirationImage({
    required this.id,
    required this.imageUrl,
    required this.theme,
    required this.style,
    required this.source,
    this.uploaderUsername,
    required this.createdAt,
    List<String>? comments,
  }) : comments = comments ?? [];
  
  factory InspirationImage.fromJson(Map<String, dynamic> json) {
    return InspirationImage(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      theme: InspirationTheme.values[json['theme'] as int],
      style: ImageStyle.values[json['style'] as int],
      source: ImageSource.values[json['source'] as int],
      uploaderUsername: json['uploaderUsername'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'theme': theme.index,
      'style': style.index,
      'source': source.index,
      'uploaderUsername': uploaderUsername,
      'createdAt': createdAt.toIso8601String(),
      'comments': comments,
    };
  }
  
  InspirationImage copyWith({
    String? id,
    String? imageUrl,
    InspirationTheme? theme,
    ImageStyle? style,
    ImageSource? source,
    String? uploaderUsername,
    DateTime? createdAt,
    List<String>? comments,
  }) {
    return InspirationImage(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      theme: theme ?? this.theme,
      style: style ?? this.style,
      source: source ?? this.source,
      uploaderUsername: uploaderUsername ?? this.uploaderUsername,
      createdAt: createdAt ?? this.createdAt,
      comments: comments ?? this.comments,
    );
  }
}

class SavedImage {
  final String id;
  final InspirationImage image;
  final DateTime savedAt;
  
  SavedImage({
    required this.id,
    required this.image,
    required this.savedAt,
  });
  
  factory SavedImage.fromJson(Map<String, dynamic> json) {
    return SavedImage(
      id: json['id'] as String,
      image: InspirationImage.fromJson(json['image'] as Map<String, dynamic>),
      savedAt: DateTime.parse(json['savedAt'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image.toJson(),
      'savedAt': savedAt.toIso8601String(),
    };
  }
  
  bool shouldBeRemoved() {
    final threeMonthsAgo = DateTime.now().subtract(const Duration(days: 90));
    return savedAt.isBefore(threeMonthsAgo);
  }
}
