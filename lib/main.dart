import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';
import 'login_page.dart';
import 'email_verification_page.dart';
import 'home_page.dart';
import 'theme.dart';
import 'settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Firebase App Check
  await FirebaseAppCheck.instance.activate(
    providerWeb: WebDebugProvider(),
    providerAndroid: const AndroidDebugProvider(),
  );

  // Create settings controller
  final settingsController = SettingsController();

  runApp(NewsApp(settingsController: settingsController));
}

class NewsApp extends StatelessWidget {
  final SettingsController settingsController;
  final Widget? home;

  const NewsApp({super.key, required this.settingsController, this.home});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "The Clean News",

          // LIGHT THEME
          theme: lightTheme,
          darkTheme: darkTheme,

          // Change theme when Dark Mode is enabled
          themeMode: settingsController.darkMode
              ? ThemeMode.dark
              : ThemeMode.light,

          // Change text size throughout the app
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(settingsController.textScale),
              ),
              child: child!,
            );
          },

          // Authentication and email-verification gate
          home: home ?? AuthGate(settingsController: settingsController),
        );
      },
    );
  }
}

// ============================================================
// AUTH GATE
// ============================================================

class AuthGate extends StatelessWidget {
  final SettingsController settingsController;

  const AuthGate({super.key, required this.settingsController});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // userChanges also reacts when the Firebase user is reloaded.
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        // Firebase is checking the current authentication state.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        // No signed-in user.
        if (user == null) {
          return LoginPage(settingsController: settingsController);
        }

        // Signed in, but email verification is incomplete.
        if (!user.emailVerified) {
          return EmailVerificationPage(settingsController: settingsController);
        }

        // Only verified users can access the news feed.
        return HomePage(settingsController: settingsController);
      },
    );
  }
}
