# Toilet Finder London

A Flutter MVP application that helps users find clean, accessible toilets in Central London. Built with modern Flutter architecture using Supabase as the backend, Google Maps integration, and user authentication.

## 🚀 Features

- **Location-based search**: Find nearby toilets using GPS
- **Cleanliness ratings**: User-submitted reviews and ratings
- **Google Maps integration**: Visual map with toilet locations
- **User authentication**: Sign in with Google or Apple
- **Real-time data**: Live updates from Supabase database
- **Offline support**: Cached data for offline viewing
- **Accessibility information**: Details about disabled access
- **Photo uploads**: Users can upload toilet photos

## 🛠️ Tech Stack

### Frontend
- **Flutter** - Cross-platform mobile development
- **Dart** - Programming language
- **Riverpod** - State management
- **Google Maps Flutter** - Maps integration
- **Geolocator** - Location services

### Backend
- **Supabase** - Backend-as-a-Service
- **PostgreSQL** - Database
- **Supabase Auth** - Authentication

### UI/UX
- **Material Design 3** - Design system
- **Google Fonts** - Typography
- **Lottie** - Animations
- **Shimmer** - Loading states

## 📋 Prerequisites

- Flutter SDK (^3.8.1)
- Dart SDK (^3.8.1)
- Android Studio / Xcode for mobile development
- Supabase account and project

## 🚀 Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/justanothernibble/Flutter-Toilet-Finder-MVP.git
cd Flutter-Toilet-Finder-MVP
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Environment Setup

Create a `.env` file in the root directory:
```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
```

For iOS, also add to `ios/Flutter/Env.xcconfig`:
```
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

For Android, add to `android/app/build.gradle.kts`:
```kotlin
buildTypes.forEach {
    it.buildConfigField("String", "SUPABASE_URL", "\"your_supabase_project_url\"")
    it.buildConfigField("String", "SUPABASE_ANON_KEY", "\"your_supabase_anon_key\"")
}
```

### 4. Run the app
```bash
# For Android
flutter run

# For iOS
flutter run --flavor development

# For Web (Note: Maps may not work fully)
flutter run -d web
```

## 📁 Project Structure

```
lib/
├── config/
│   └── theme/
│       └── app_theme.dart          # App theming
├── core/
│   ├── models/                     # Data models
│   │   ├── toilet.dart
│   │   ├── review.dart
│   │   ├── favorite.dart
│   │   └── report.dart
│   ├── repositories/               # Data access layer
│   │   └── toilet_repository.dart
│   ├── services/                   # External services
│   │   └── supabase_service.dart
│   └── utils/                      # Utilities
│       └── logger.dart
├── pages/                          # UI screens
│   ├── auth_gate.dart
│   ├── home_screen.dart
│   ├── list_toilets.dart
│   ├── sign_in_screen.dart
│   └── sign_up_screen.dart
└── main.dart                       # App entry point
```

## 🔧 Development

### Code Generation
```bash
flutter pub run build_runner build
```

### Testing
```bash
flutter test
```

### Linting
```bash
flutter analyze
```

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ⚠️ Web (Maps integration limited)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

MIT

## 🙏 Acknowledgments

- Built to solve the real problem of finding clean toilets in London
- Learning project for database integration and Flutter development
- Special thanks to the Supabase and Flutter communities
