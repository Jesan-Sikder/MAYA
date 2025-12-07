# MAYA AI - Mental Health Assistant

A beautiful Flutter chatbot powered by Gemini Pro AI to support mental health and wellness. 

## Features

- 🔐 **Multiple Authentication Options**
  - Google Sign-In
  - Apple Sign-In
  - Email/Password
  
- 💬 **Intelligent Conversations**
  - Powered by Google's Gemini Pro
  - Mental health focused responses
  - Empathetic and supportive
  
- 🎨 **Beautiful UI**
  - ChatGPT-inspired design
  - Smooth animations
  - Clean, modern interface

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Firebase account
- Google AI Studio account (for Gemini API key)
- iOS/Android development environment

## Setup Instructions

### 1. Clone and Install Dependencies

```bash
git clone <your-repo-url>
cd maya_ai
flutter pub get
```

### 2. Get Gemini API Key

1. Go to [Google AI Studio](https://aistudio.google.com/)
2. Sign in with your Google account
3. Click "Get API Key"
4. Copy your API key

### 3. Setup Environment Variables

1. Create `. env` file in the root directory
2. Add your Gemini API key:

```
GEMINI_API_KEY=your_api_key_here
```

### 4. Firebase Setup

#### Create Firebase Project
1. Go to [Firebase Console](https://console.firebase. google.com/)
2. Click "Add Project"
3. Follow the setup wizard

#### Android Setup

1. In Firebase Console, add an Android app
2. Download `google-services.json`
3. Place it in `android/app/`
4. Update `android/build.gradle`:

```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
}
```

5. Update `android/app/build.gradle`:

```gradle
apply plugin: 'com.google.gms.google-services'

dependencies {
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
}
```

#### iOS Setup

1. In Firebase Console, add an iOS app
2. Download `GoogleService-Info.plist`
3. Open Xcode: `open ios/Runner.xcworkspace`
4.  Drag `GoogleService-Info.plist` into Runner folder
5. Update `ios/Podfile`:

```ruby
platform :ios, '12.0'
```

6. Run:

```bash
cd ios
pod install
cd ..
```

### 5.  Enable Authentication Methods in Firebase

1. Go to Firebase Console → Authentication → Sign-in method
2. Enable:
   - Google
   - Apple (for iOS)
   - Email/Password

#### For Apple Sign-In (iOS only)
1. Add capability in Xcode: Signing & Capabilities → + Capability → Sign in with Apple
2. Configure in Apple Developer Portal

#### For Google Sign-In
1. Download OAuth client ID from Firebase
2. Add to your app configuration

### 6. Run the App

```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── message.dart          # Message data model
├── screens/
│   ├── login_screen.dart     # Login UI
│   ├── email_auth_screen.dart # Email authentication
│   └── chat_screen.dart      # Chat interface
├── services/
│   ├── auth_service.dart     # Firebase authentication
│   └── gemini_service.dart   # Gemini AI integration
└── widgets/
    ├── message_bubble.dart   # Chat message UI
    └── chat_input. dart       # Message input field
```

## Security Notes

⚠️ **IMPORTANT:**
- Never commit `. env` file to git
- Never share your API keys
- `. env` is already in `.gitignore`
- Use `. env.example` as a template

## Future Enhancements

- 📚 RAG system for mental health book knowledge
- 📊 Mood tracking
- 📝 Journaling feature
- 📈 Progress monitoring
- 🆘 Crisis resources integration
- 🔔 Push notifications
- 💾 Cloud storage for chat history

## Troubleshooting

### "GEMINI_API_KEY not found"
- Ensure `. env` file exists in root directory
- Check that the key name matches exactly

### Firebase initialization error
- Verify `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are in correct locations
- Ensure Firebase is initialized before app starts

### Google Sign-In not working
- Check SHA-1 fingerprint is added to Firebase (Android)
- Verify OAuth client ID is configured

## License

MIT License

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

For issues and questions, please open an issue on GitHub. 

---

Made with ❤️ for mental health awareness