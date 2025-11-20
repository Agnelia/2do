# 2do App Architecture

## Overview

The 2do app is a dual-mode Flutter application that combines health reminder functionality with an artistic inspiration platform. The app follows a clean architecture pattern with clear separation of concerns.

## App Structure

```
┌─────────────────────────────────────┐
│      App Mode Selection Screen      │
│   (Entry Point - Choose Mode)       │
└────────────┬───────────┬────────────┘
             │           │
    ┌────────┘           └────────┐
    │                              │
┌───▼──────────────┐   ┌──────────▼───────────┐
│   Health Mode    │   │  Inspirationsappen   │
│  (Original App)  │   │   (New Feature)      │
└──────────────────┘   └──────────────────────┘
```

## Dual Mode System

### Health Mode
- Health reminders and tracking
- Statistics and progress charts
- Stand-up timer
- Office templates
- Settings and preferences

### Inspirationsappen Mode
- Artistic inspiration search
- Image suggestions (4 at a time)
- Saved images gallery
- Upload artwork
- User gallery with comments

## Inspirationsappen Architecture

### Data Flow

```
┌──────────────────────────────────────────────────────┐
│                    User Interface                     │
│  (Screens: Dashboard, Search, Results, Gallery, etc) │
└─────────────────────┬────────────────────────────────┘
                      │
                      ▼
┌──────────────────────────────────────────────────────┐
│                 InspirationProvider                   │
│         (State Management - ChangeNotifier)           │
│                                                       │
│  • Manages selected theme/style/source               │
│  • Generates image suggestions                       │
│  • Handles saved images (3-month cleanup)            │
│  • Manages user artworks and comments                │
└─────────────────────┬────────────────────────────────┘
                      │
                      ▼
┌──────────────────────────────────────────────────────┐
│                SharedPreferences                      │
│              (Local Data Persistence)                 │
│                                                       │
│  • saved_images: List of SavedImage                  │
│  • user_artworks: List of InspirationImage           │
└──────────────────────────────────────────────────────┘
```

### Model Structure

```
InspirationImage
├── id: String
├── imageUrl: String
├── theme: InspirationTheme (enum)
├── style: ImageStyle (enum)
├── source: ImageSource (enum)
├── uploaderUsername: String?
├── createdAt: DateTime
└── comments: List<String>

SavedImage
├── id: String
├── image: InspirationImage
├── savedAt: DateTime
└── shouldBeRemoved(): bool (3 months check)

InspirationTheme (enum)
├── animals
├── nature
├── fantasy
├── people
├── flowers
├── abstract
├── landscape
├── portrait
└── stillLife

ImageStyle (enum)
├── simpleWithBackground
├── simpleWithoutBackground
├── tropicalDetailed
├── tropicalSimple
├── realisticDetailed
├── realisticSimple
├── bohemianDetailed
└── bohemianSimple

ImageSource (enum)
├── internet
└── userUploaded
```

## Screen Navigation Flow

### App Entry and Mode Selection
```
AppModeSelectionScreen (/)
    │
    ├─── [Health Mode] ──> HomeScreen (Health Dashboard)
    │                        │
    │                        ├─── Statistics
    │                        ├─── Profile & Settings
    │                        └─── Add Reminder
    │
    └─── [Inspiration Mode] ──> InspirationHomeScreen (Dashboard)
                                  │
                                  ├─── InspirationSearchScreen
                                  │     │
                                  │     └─── ImageResultsScreen
                                  │
                                  ├─── SavedImagesScreen
                                  │
                                  ├─── UploadArtworkScreen
                                  │
                                  └─── UserGalleryScreen
```

### Inspirationsappen User Journey

```
1. Dashboard
   │
   ├─> Search Inspiration
   │    │
   │    ├─> Select Source (Internet / User)
   │    ├─> Choose Theme (9 options)
   │    ├─> Pick Style (8 options)
   │    └─> View Results (4 images)
   │         │
   │         ├─> Remove individual image (get new one)
   │         ├─> Refresh all images
   │         └─> Save favorite images
   │
   ├─> Saved Images
   │    │
   │    ├─> View all saved images
   │    ├─> See save date and theme
   │    └─> Delete saved images
   │
   ├─> Upload Artwork
   │    │
   │    ├─> Enter username
   │    ├─> Provide image URL
   │    ├─> Select theme and style
   │    └─> Share with community
   │
   └─> User Gallery
        │
        ├─> Browse all user artworks
        ├─> View artist info
        ├─> Read comments
        ├─> Add new comments
        └─> Save artworks to collection
```

## State Management

### Provider Pattern
- **InspirationProvider**: Manages all Inspirationsappen state
  - Selected theme, style, and source
  - Current suggestions (4 images)
  - Saved images collection
  - User artworks with comments
  - Persistent storage operations

### Other Providers (Health Mode)
- **ReminderProvider**: Health reminders management
- **StatisticsProvider**: Health statistics and charts
- **ThemeProvider**: App theme preferences
- **LocaleProvider**: Internationalization
- **WorkHoursProvider**: Office hours settings
- **AdminProvider**: Admin mode features

## Data Persistence

### SharedPreferences Keys
- `saved_images`: JSON array of SavedImage objects
- `user_artworks`: JSON array of InspirationImage objects

### JSON Serialization
- Manual toJson() and fromJson() methods
- Enum serialization via index
- DateTime serialization via ISO8601 strings

### Auto-Cleanup Logic
```dart
// On load, remove images older than 3 months
_savedImages.removeWhere((img) => img.shouldBeRemoved());

// SavedImage.shouldBeRemoved()
bool shouldBeRemoved() {
  final threeMonthsAgo = DateTime.now().subtract(Duration(days: 90));
  return savedAt.isBefore(threeMonthsAgo);
}
```

## Design System

### Color Palette (Inspirationsappen)
```dart
class InspirationColors {
  // Vintage matte colors
  static const orange = Color(0xFFE67E22);      // Primary
  static const lightOrange = Color(0xFFF39C12); // Secondary
  static const darkGreen = Color(0xFF27AE60);   // Nature
  static const lightGreen = Color(0xFF52BE80);  // Fresh
  static const copper = Color(0xFFB87333);      // Metallic
  static const yellow = Color(0xFFF4D03F);      // Bright
  static const turquoise = Color(0xFF1ABC9C);   // Cool
  
  // Banner colors
  static const gold = Color(0xFFFFD700);        // Sun
  static const red = Color(0xFFE74C3C);         // Sun gradient
}
```

### Typography
- **Headers**: Bold black text
- **Body**: Regular black text
- **Secondary**: Dark gray (#555555)
- **Style**: Simple, clean typeface

### Component Design
- **Cards**: Rounded corners (12-16px)
- **Buttons**: Pill-shaped (25px border radius)
- **Icons**: Material Design icons
- **Elevation**: Subtle shadows (1-4px)

## File Structure

```
lib/
├── main.dart                              # App entry point
├── models/
│   ├── app_mode.dart                      # Health/Inspiration enum
│   ├── inspiration_theme.dart             # Theme categories
│   ├── image_style.dart                   # Style options
│   ├── inspiration_image.dart             # Image models
│   └── reminder.dart                      # Health reminder model
├── providers/
│   ├── inspiration_provider.dart          # Inspiration state
│   ├── reminder_provider.dart             # Health state
│   ├── statistics_provider.dart           # Stats state
│   └── [other providers...]
├── screens/
│   ├── app_mode_selection_screen.dart     # Entry point
│   ├── inspiration_home_screen.dart       # Inspiration dashboard
│   ├── inspiration_search_screen.dart     # Theme/style selection
│   ├── image_results_screen.dart          # 4 image display
│   ├── saved_images_screen.dart           # Saved gallery
│   ├── upload_artwork_screen.dart         # Upload form
│   ├── user_gallery_screen.dart           # Community gallery
│   ├── home_screen.dart                   # Health dashboard
│   └── [other health screens...]
├── widgets/
│   └── [reusable components...]
└── utils/
    ├── inspiration_colors.dart            # Color constants
    └── [other utilities...]
```

## Key Features Implementation

### 1. Image Suggestions (4 at a time)
```dart
// Generate 4 suggestions based on theme/style
provider.generateSuggestions();

// Display in GridView with 2 columns
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 0.75,
  ),
  itemCount: provider.currentSuggestions.length,
  ...
)
```

### 2. Remove and Replace Individual Images
```dart
// User can remove specific image
provider.removeAndReplaceSuggestion(imageId);

// Provider logic:
- Remove image from list
- Generate new image to maintain count of 4
- Update UI via notifyListeners()
```

### 3. Source Toggle (Exclusive)
```dart
// Cannot combine internet and user images
provider.setSource(ImageSource.internet);  // Clear previous
provider.setSource(ImageSource.userUploaded);  // Clear again
```

### 4. Comments (User Images Only)
```dart
// Only InspirationImage with source == userUploaded
// allows comments
if (image.source == ImageSource.userUploaded) {
  // Show comment section
  // Allow adding comments
}
```

### 5. 3-Month Auto Cleanup
```dart
// On app start, load saved images
await _loadData();

// Automatically remove old images
_savedImages.removeWhere((img) => img.shouldBeRemoved());

// Save cleaned list
await _saveSavedImages();
```

## Testing Strategy

### Unit Tests
- Provider state management
- Model serialization/deserialization
- Business logic (cleanup, suggestions)

### Widget Tests
- Screen rendering
- Navigation flow
- User interactions
- Empty states

### Integration Tests
- End-to-end user journeys
- Data persistence
- Cross-screen flows

## Future Enhancements

### Technical
- Real API integration for images
- Image upload from device
- Cloud synchronization
- Push notifications
- Performance optimization

### Features
- Like/favorite system
- User profiles
- Follow system
- Art challenges
- Search and filters
- Export collections
- Social sharing

## Performance Considerations

### Optimizations
- Lazy loading of images
- Efficient state updates with Provider
- Minimal rebuilds via Consumer widgets
- Local storage for offline support
- Image caching

### Best Practices
- Responsive layouts for all screens
- Error handling for network images
- Loading states for async operations
- Proper disposal of controllers
- Memory-efficient list rendering

---

**Architecture Version:** 1.0.0  
**Last Updated:** 2025-11-20  
**Maintained by:** 2do Team
