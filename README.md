# 2do Health Reminders

A responsive Flutter application for health-related reminders with charts, diagnostics, and statistics. This app helps users maintain their health goals through personalized reminders and comprehensive progress tracking.

## Features

### 🏥 Health Reminders
- **Smart Reminders**: Create reminders for medications, exercise, water intake, sleep, nutrition, and mental health
- **Flexible Scheduling**: Daily, weekly, monthly, or custom frequency options
- **Priority Levels**: Set urgency levels (Low, Medium, High, Urgent) for better prioritization
- **Rich Categories**: Pre-defined health categories with custom icons and colors

### 📊 Analytics & Statistics
- **Interactive Charts**: Beautiful line charts showing completion trends over time
- **Progress Tracking**: Daily, weekly, monthly, and yearly views of your health progress
- **Health Score**: Comprehensive scoring system based on completion rates
- **Category Breakdown**: Visual breakdown of different health activities
- **Streak Tracking**: Monitor your consistency with streak counters

### 📱 Responsive Design
- **Multi-Platform**: Works seamlessly on mobile, tablet, and desktop
- **Adaptive UI**: Responsive layouts that adjust to different screen sizes
- **Material Design 3**: Modern, clean interface following Material Design guidelines
- **Dark/Light Theme**: Automatic theme switching based on system preferences

### 🔔 Smart Notifications
- **Timely Alerts**: Get notified when it's time for your health activities
- **Snooze Options**: Flexible snooze durations (15min, 30min, 1hr, tomorrow)
- **Completion Tracking**: Mark reminders as complete with a single tap
- **Overdue Indicators**: Visual indicators for missed reminders

## Screenshots

*Note: Screenshots will be available once the app is built and running*

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Agnelia/2do.git
   cd 2do
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (if needed)**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   # For mobile development
   flutter run
   
   # For web development
   flutter run -d chrome
   
   # For desktop development
   flutter run -d windows  # or macos, linux
   ```

## Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

### Web Application
```bash
flutter build web --release
```

### iOS (macOS required)
```bash
flutter build ios --release
```

## Deployment

### Cloud Deployment (Web)

#### Firebase Hosting
1. Install Firebase CLI: `npm install -g firebase-tools`
2. Login to Firebase: `firebase login`
3. Initialize Firebase: `firebase init hosting`
4. Build the web app: `flutter build web`
5. Deploy: `firebase deploy`

#### Netlify
1. Build the web app: `flutter build web`
2. Upload the `build/web` folder to Netlify
3. Configure redirects for SPA routing

#### Vercel
1. Install Vercel CLI: `npm install -g vercel`
2. Build the web app: `flutter build web`
3. Deploy: `vercel --prod`

#### Azure Static Web Apps (Recommended)
**Automated deployment with GitHub Actions**
1. Follow setup instructions in `SETUP-INSTRUCTIONS.md`
2. Run deployment script: `./deploy-azure.sh setup test && ./deploy-azure.sh setup prod`
3. Configure GitHub secrets with Azure deployment tokens
4. Create PRs targeting `test` branch for testing, `main` branch for production

**Environment URLs:**
- Test: https://test-2do-health-reminders.azurestaticapps.net
- Production: https://2do-health-reminders.azurestaticapps.net

For detailed deployment information, see `DEPLOYMENT.md`.

### Mobile App Stores

#### Google Play Store
1. Build the app bundle: `flutter build appbundle --release`
2. Upload to Google Play Console
3. Follow Google's review process

#### Apple App Store
1. Build for iOS: `flutter build ios --release`
2. Archive in Xcode
3. Upload via App Store Connect

## Architecture

The app follows a clean architecture pattern with the following structure:

```
lib/
├── models/          # Data models and entities
├── providers/       # State management (Provider pattern)
├── screens/         # UI screens and pages
├── services/        # Business logic and external services
├── widgets/         # Reusable UI components
└── utils/           # Helper functions and utilities
```

### Key Technologies
- **Flutter**: Cross-platform UI framework
- **Provider**: State management
- **FL Chart**: Beautiful charts and graphs
- **Shared Preferences**: Local data persistence
- **Material Design 3**: Modern UI components

## Data Persistence

The app uses SharedPreferences for local data storage, ensuring:
- **Offline Functionality**: Works without internet connection
- **Data Persistence**: Your reminders and progress are saved locally
- **Privacy**: No data is sent to external servers
- **Backup Ready**: Easy to implement cloud backup features

## Customization

### Adding New Categories
1. Update the `_categories` list in `add_reminder_screen.dart`
2. Add corresponding icons in `reminder_card.dart`
3. Update category colors as needed

### Extending Chart Types
1. Create new chart widgets in `widgets/` directory
2. Add chart data processing in `StatisticsProvider`
3. Integrate with the statistics screen

### Theme Customization
Update the theme configuration in `main.dart`:
```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.teal, // Change this color
    brightness: Brightness.light,
  ),
  useMaterial3: true,
),
```

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-feature`
3. Commit your changes: `git commit -am 'Add new feature'`
4. Push to the branch: `git push origin feature/new-feature`
5. Submit a pull request

## Testing

Run tests with:
```bash
flutter test
```

For integration tests:
```bash
flutter drive --target=test_driver/app.dart
```

## Performance

The app is optimized for performance with:
- **Lazy Loading**: Lists and charts load data as needed
- **Efficient State Management**: Provider pattern prevents unnecessary rebuilds
- **Responsive Design**: Adapts to different screen sizes efficiently
- **Minimal Dependencies**: Only essential packages included

## Security

- **Local Storage**: All data stored locally on device
- **No External APIs**: No sensitive data transmitted
- **Secure Preferences**: Using Flutter's secure storage patterns

## Roadmap

- [ ] Cloud synchronization
- [ ] Advanced notification scheduling
- [ ] Health data integration (Apple Health, Google Fit)
- [ ] Social features and challenges
- [ ] AI-powered health insights
- [ ] Voice commands
- [ ] Wearable device integration

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support, questions, or contributions:
- Create an issue on GitHub
- Email: support@2dohealth.com
- Documentation: [Wiki](https://github.com/Agnelia/2do/wiki)

---

**Made with ❤️ and Flutter**
