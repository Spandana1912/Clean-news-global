Clean News Global
Clean News Global is a Flutter news application designed to help readers browse news articles, open full articles, save articles for later, and manage their reading experience. The project uses Firebase services for account-related functionality and data, and includes an AI article-summary feature built with Firebase AI Logic.
Project status: The Flutter web app has been launched in Chrome during development. The AI summary feature and the Dart analyzer issue still require further verification; see Known Issues.

Features
- User authentication: Registration and login screens, with an email-verification flow.
- News browsing: View news articles and their available descriptions and details.
- Open articles: Open article links from within the app or through the browser, depending on platform.
- Saved articles: Access articles saved for later.
- Profile and settings: User profile and application preference screens.
- Theme support: Theme-related settings for the reading experience.
- Notifications screen: A dedicated screen for notification-related functionality.
- AI article summaries: An AI summary service using Firebase AI Logic. This feature is still being tested and should not be considered reliable until verified.
Built With
- Flutter and Dart — application UI and app logic
- Firebase Authentication — user authentication
- Cloud Firestore — cloud database functionality
- Firebase AI Logic — generative AI summary functionality
- Firebase App Check — app verification support
- HTTP — network requests
- Google Fonts — typography
- URL Launcher — opening article links
- WebView Flutter — displaying web content in supported app platforms
- Flutter Dotenv — configuration support, where used by the project
Getting Started
Prerequisites
Install the following before running the project:
- Flutter SDK compatible with the project's Dart SDK constraint
- Dart SDK (included with Flutter)
- Git
- A code editor such as Visual Studio Code or Android Studio
- A Firebase project configured for the platforms you intend to run
