# Inspirationsappen - Artist Inspiration Feature

## Overview

Inspirationsappen is a dedicated mode within the 2do app designed to inspire artists and art enthusiasts. It provides a platform to discover artistic inspiration, explore different themes and styles, save favorite images, and share your own artwork with the community.

## Features

### 🎨 Theme Selection
Choose from a variety of artistic themes:
- **Djur** (Animals) - Animal-themed artwork
- **Natur** (Nature) - Natural landscapes and scenery
- **Fantasy** - Fantasy and imaginative themes
- **Människor** (People) - Portraits and people
- **Blommor** (Flowers) - Floral artwork
- **Abstrakt** (Abstract) - Abstract art
- **Landskap** (Landscape) - Landscape scenes
- **Porträtt** (Portrait) - Portrait art
- **Stilleben** (Still Life) - Still life compositions

### 🖌️ Style Selection
Select from various artistic styles:
- **Enkel med bakgrund** - Simple with background
- **Enkel utan bakgrund** - Simple without background
- **Tropisk med mycket detaljer** - Tropical with detailed elements
- **Tropisk med enkla detaljer** - Tropical with simple details
- **Naturtrogen med mycket detaljer** - Realistic with detailed elements
- **Naturtrogen med enkla detaljer** - Realistic with simple details
- **Bohemisk stil med mycket detaljer** - Bohemian style with detailed elements
- **Bohemisk stil med lite detaljer** - Bohemian style with simple details

### 📷 Image Sources
Toggle between two exclusive image sources:
- **Internet bilder** - Images from the internet
- **Användare bilder** - Images uploaded by app users

**Note:** You cannot combine both sources simultaneously.

### 🔍 Search & Discovery
1. Select your preferred image source
2. Choose a theme that inspires you
3. Pick an artistic style
4. Get 4 curated image suggestions
5. Remove and replace individual images if desired
6. Refresh all suggestions for a new set

### 💾 Save & Organize
- **Download Images** - Save inspiring images to your local collection
- **Automatic Cleanup** - Saved images are automatically removed after 3 months
- **Gallery View** - View all your saved images in one place
- **Date Tracking** - See when each image was saved

### 🎭 Share Your Art
Upload your own artwork to inspire others:
1. Enter your username
2. Provide the image URL
3. Select the theme and style
4. Share with the community

Your username will be displayed on all images you upload.

### 💬 Community Engagement
For user-uploaded artwork only:
- **View Artworks** - Browse all artwork uploaded by community members
- **Add Comments** - Share your thoughts and appreciation
- **View All Comments** - Read what others think
- **User Attribution** - Every artwork shows the creator's username

**Important:** Comments are only available for user-uploaded images, not internet images.

## Design & Colors

### Color Palette
The app uses a vintage, matte color scheme:
- **Orange** (#E67E22) - Primary accent
- **Light Orange** (#F39C12) - Secondary accent
- **Dark Green** (#27AE60) - Nature tones
- **Light Green** (#52BE80) - Fresh accents
- **Copper** (#B87333) - Warm metallic
- **Yellow** (#F4D03F) - Bright highlights
- **Turquoise** (#1ABC9C) - Cool accents
- **Gold** (#FFD700) - Sun banner
- **Red** (#E74C3C) - Sun gradient

### Typography
- **Font Color:** Black for main text
- **Style:** Simple, clean typeface
- **Headers:** Bold black text
- **Secondary Text:** Dark gray for subtitles

### Banner Design
The welcome banner features:
- Smiling sun icon (☀️)
- Gold and red gradient background
- "Inspirationsappen" title
- Tagline: "Din kreativa inspirationskälla"

## Navigation

### Main Dashboard
Four main actions available:
1. **Sök inspiration** (Search Inspiration) - Find new motifs and themes
2. **Valda bilder** (Saved Images) - View your saved inspiration images
3. **Ladda upp konst** (Upload Art) - Share your own artwork
4. **Användargalleri** (User Gallery) - View and comment on community art

### Mode Switching
Use the app switcher icon (⊞) in the top-left corner to switch between:
- Health Mode - Health reminders and wellness tracking
- Inspirationsappen - Artistic inspiration and sharing

## Usage Guide

### Finding Inspiration

1. **Start from Dashboard**
   - Tap "Sök inspiration"

2. **Select Source**
   - Choose between Internet or User images
   - Selection is exclusive - cannot combine

3. **Choose Theme**
   - Browse available themes
   - Tap your preferred theme
   - Icon turns highlighted when selected

4. **Pick Style**
   - Scroll through style options
   - Select one that matches your preference
   - Card highlights when selected

5. **View Results**
   - Tap "Visa inspiration"
   - See 4 curated suggestions
   - Each image has a close (×) button

6. **Refine Results**
   - Remove individual images to get new suggestions
   - Or use refresh icon to reload all 4 images
   - Continue until you find perfect inspiration

7. **Save Favorites**
   - Tap "Spara" button on any image
   - Image saved to your collection
   - Access later from "Valda bilder"

### Sharing Your Art

1. **Navigate to Upload**
   - From dashboard, tap "Ladda upp konst"

2. **Enter Details**
   - Username: Your artist name
   - Image URL: Link to your artwork
   - Theme: Category of your art
   - Style: Artistic style used

3. **Upload**
   - Tap "Ladda upp"
   - Your art appears in user gallery
   - Username displayed on image

### Engaging with Community

1. **Browse Gallery**
   - From dashboard, tap "Användargalleri"
   - Scroll through all user artworks

2. **View Artwork**
   - See creator's username
   - View theme and style tags
   - Read existing comments

3. **Add Comments**
   - Tap "Lägg till kommentar"
   - Write your thoughts
   - Tap "Skicka" to post

4. **Save to Collection**
   - Tap "Spara" button
   - Artwork added to your saved images

## Technical Details

### Data Storage
- **Local Storage:** All data stored using SharedPreferences
- **Saved Images:** Persisted with 3-month expiration
- **User Artworks:** Permanently stored locally
- **Comments:** Stored with associated artwork

### Models
- `AppMode` - Health/Inspiration mode selection
- `InspirationTheme` - Theme categories
- `ImageStyle` - Style options
- `InspirationImage` - Image data with metadata
- `SavedImage` - Saved image with timestamp
- `ImageSource` - Internet vs User source

### Providers
- `InspirationProvider` - Central state management
  - Manages saved images
  - Handles user artworks
  - Generates suggestions
  - Processes comments

### Screens
- `AppModeSelectionScreen` - Mode selection entry point
- `InspirationHomeScreen` - Main dashboard
- `InspirationSearchScreen` - Theme and style selection
- `ImageResultsScreen` - Display suggestions
- `SavedImagesScreen` - Saved images gallery
- `UploadArtworkScreen` - Upload your art
- `UserGalleryScreen` - Community artwork with comments

## Future Enhancements

Potential improvements for future versions:
- Integration with real image APIs
- Image upload from device camera/gallery
- Like/favorite system for artworks
- User profiles and followers
- Search and filter in user gallery
- Export saved collections
- Push notifications for comments
- Direct sharing to social media
- Collaborative art projects
- Art challenges and themes

## Support

For questions or issues with Inspirationsappen:
- Check the main README for general app information
- Review this documentation for feature-specific help
- Contact support through the app settings

---

**Made with ❤️ for artists and creators**
