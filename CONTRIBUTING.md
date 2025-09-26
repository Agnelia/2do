# Contributing to 2do Health Reminders

Thank you for your interest in contributing to 2do Health Reminders! This document provides guidelines for contributing to the project.

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Git
- Android Studio or VS Code (recommended)

### Setting up the Development Environment

1. **Fork the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/2do.git
   cd 2do
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the development script**
   ```bash
   ./scripts/dev.sh setup
   ```

4. **Start the app**
   ```bash
   ./scripts/dev.sh run
   ```

## Development Workflow

### Code Style
- Follow Dart's official style guide
- Use `dart format` to format your code
- Run `flutter analyze` to check for issues
- Ensure all tests pass with `flutter test`

### Making Changes

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Write clean, readable code
   - Add tests for new functionality
   - Update documentation if needed

3. **Test your changes**
   ```bash
   ./scripts/dev.sh test
   ./scripts/dev.sh analyze
   ```

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request**
   - Go to the original repository
   - Click "New Pull Request"
   - Provide a clear description of your changes

### Commit Message Convention

We use conventional commits:
- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation changes
- `style:` - Code style changes
- `refactor:` - Code refactoring
- `test:` - Adding tests
- `chore:` - Maintenance tasks

Examples:
```
feat: add reminder snooze functionality
fix: resolve chart rendering issue on mobile
docs: update installation instructions
style: format code according to style guide
refactor: extract reminder validation logic
test: add tests for statistics provider
chore: update dependencies
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── reminder.dart
│   └── reminder.g.dart
├── providers/                # State management
│   ├── reminder_provider.dart
│   └── statistics_provider.dart
├── screens/                  # UI screens
│   ├── home_screen.dart
│   ├── add_reminder_screen.dart
│   └── statistics_screen.dart
├── services/                 # Business logic
│   └── storage_service.dart
├── utils/                    # Utilities
│   ├── constants.dart
│   └── date_utils.dart
└── widgets/                  # Reusable widgets
    ├── reminder_card.dart
    ├── statistics_chart.dart
    ├── progress_ring.dart
    └── responsive_layout.dart
```

## Guidelines

### Adding New Features

1. **Health Categories**: When adding new reminder categories:
   - Update `constants.dart` with the new category
   - Add appropriate icons and colors
   - Update the UI components to handle the new category

2. **Chart Types**: When adding new chart types:
   - Create the chart widget in `widgets/`
   - Add data processing logic in the appropriate provider
   - Ensure responsive design principles

3. **Storage**: When modifying data models:
   - Update the model classes
   - Regenerate JSON serialization code: `dart run build_runner build`
   - Handle migration for existing users

### Testing

- Write unit tests for business logic
- Write widget tests for UI components
- Test on multiple screen sizes
- Test both light and dark themes

### Documentation

- Update README.md for significant changes
- Add inline comments for complex logic
- Update this CONTRIBUTING.md if development process changes

## Pull Request Checklist

Before submitting a pull request, ensure:

- [ ] Code follows the project's style guidelines
- [ ] All tests pass (`flutter test`)
- [ ] Code analysis passes (`flutter analyze`) 
- [ ] New features include tests
- [ ] Documentation is updated if needed
- [ ] Commit messages follow the convention
- [ ] Changes are backward compatible
- [ ] UI works on mobile, tablet, and desktop
- [ ] Both light and dark themes are supported

## Bug Reports

When reporting bugs, please include:

1. **Flutter version**: `flutter --version`
2. **Device/Platform**: iOS, Android, Web, etc.
3. **Steps to reproduce**: Clear steps to reproduce the issue
4. **Expected behavior**: What should happen
5. **Actual behavior**: What actually happens
6. **Screenshots**: If applicable
7. **Error logs**: Any console errors or stack traces

## Feature Requests

When requesting features:

1. **Use case**: Describe why this feature would be useful
2. **Proposed solution**: How you think it should work
3. **Alternatives**: Other solutions you've considered
4. **Mock-ups**: Visual representations if applicable

## Code Review Process

1. All submissions require review from maintainers
2. Reviewers may request changes
3. Address feedback promptly
4. Once approved, maintainers will merge the PR

## Release Process

1. Features are merged into `main` branch
2. Releases are tagged with semantic versioning
3. Release notes are generated from commit messages
4. Automated builds create artifacts for all supported platforms

## Community Guidelines

- Be respectful and inclusive
- Help others learn and grow
- Provide constructive feedback
- Follow the project's code of conduct

## Getting Help

- **Issues**: Create a GitHub issue for bugs or features
- **Discussions**: Use GitHub Discussions for questions
- **Email**: Contact maintainers directly for sensitive issues

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to 2do Health Reminders! 🎉