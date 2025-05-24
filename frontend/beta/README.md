# BETA - AI Diabetes Companion

BETA is an AI-powered companion app designed to help people with diabetes lead healthier, happier lives. The app provides personalized insights, easy logging, and continuous support throughout your diabetes management journey.

## Features

- Modern, intuitive user interface
- Secure authentication
- AI-powered insights and recommendations
- Easy glucose and health metrics logging
- Personalized support and guidance

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Firebase account
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/beta.git
cd beta
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Create a new Firebase project
   - Add Android/iOS apps to your Firebase project
   - Download and add the configuration files:
     - Android: `google-services.json` to `android/app/`
     - iOS: `GoogleService-Info.plist` to `ios/Runner/`

4. Run the app:
```bash
flutter run
```

## Development

The project uses:
- Flutter for the UI framework
- Firebase for authentication and backend
- Provider for state management
- Go Router for navigation
- Material Design 3 for theming

### Project Structure

```
lib/
  ├── main.dart              # App entry point
  ├── theme/                 # Theme configuration
  ├── screens/              # App screens
  ├── widgets/              # Reusable widgets
  ├── services/             # Business logic and services
  └── models/               # Data models
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- All contributors who help improve BETA
