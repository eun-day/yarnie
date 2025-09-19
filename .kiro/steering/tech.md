# Technology Stack

## Framework & Language
- **Flutter**: Cross-platform mobile/desktop/web framework
- **Dart**: Programming language (SDK ^3.8.1)
- **Material Design 3**: UI design system with deep purple theme

## State Management & Architecture
- **Riverpod**: State management solution (flutter_riverpod ^3.0.0)
- **Provider pattern**: Used for dependency injection and state sharing

## Database & Persistence
- **Drift**: Type-safe SQL database ORM (^2.28.1) 
- **SQLite**: Local database via sqlite3_flutter_libs
- **Code Generation**: Uses drift_dev and build_runner for database code generation

## Key Dependencies
- `path_provider`: File system path access
- `modal_bottom_sheet`: Custom bottom sheet implementations
- `cupertino_icons`: iOS-style icons

## Development Tools
- `flutter_lints`: Dart/Flutter linting rules
- `build_runner`: Code generation tool
- `riverpod_generator`: Riverpod code generation

## Common Commands

### Development
```bash
# Get dependencies
flutter pub get

# Run code generation (for Drift database)
dart run build_runner build

# Watch for changes and regenerate
dart run build_runner watch

# Run the app
flutter run

# Run on specific platform
flutter run -d chrome        # Web
flutter run -d macos         # macOS
flutter run -d android       # Android
```

### Build & Release
```bash
# Build for production
flutter build apk           # Android APK
flutter build ios           # iOS
flutter build macos         # macOS
flutter build web           # Web

# Analyze code
flutter analyze

# Run tests
flutter test
```

### Database Management
```bash
# Clean and rebuild generated files
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```