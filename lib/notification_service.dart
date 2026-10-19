import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // This will be set by main.dart
  static void Function(String articleUrl)? onArticleNotificationTap;

  // Stores the article URL if the app UI is not ready yet
  static String? pendingArticleUrl;

  static Future<void> initialize() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('Notification permission: ${settings.authorizationStatus}');

    final token = await _messaging.getToken();

    print('FCM TOKEN: $token');

    await _saveToken(token);

    _messaging.onTokenRefresh.listen((newToken) async {
      print('New FCM TOKEN: $newToken');
      await _saveToken(newToken);
    });

    // Notification received while app is open
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Notification received');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Data: ${message.data}');
    });

    // App was in background and user tapped notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification tapped');

      _handleNotificationTap(message);
    });

    // App was completely closed and user tapped notification
    final initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      print('App opened from notification');

      _handleNotificationTap(initialMessage);
    }
  }

  static void _handleNotificationTap(RemoteMessage message) {
    final articleUrl = message.data['articleUrl'];

    if (articleUrl == null || articleUrl.toString().trim().isEmpty) {
      print('No article URL found in notification.');
      return;
    }

    final url = articleUrl.toString();

    print('Opening article: $url');

    // If the app UI is ready, open the article immediately.
    if (onArticleNotificationTap != null) {
      onArticleNotificationTap!(url);
    } else {
      // Otherwise save it until the UI is ready.
      pendingArticleUrl = url;

      print('App UI not ready. Article URL saved.');
    }
  }

  // Call this after the Flutter UI is ready.
  static void openPendingArticle() {
    if (pendingArticleUrl == null) {
      return;
    }

    final url = pendingArticleUrl!;

    pendingArticleUrl = null;

    if (onArticleNotificationTap != null) {
      print('Opening pending article: $url');

      onArticleNotificationTap!(url);
    }
  }

  static Future<void> _saveToken(String? token) async {
    if (token == null) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('No logged-in user. FCM token not saved.');
      return;
    }

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'fcmToken': token,
    }, SetOptions(merge: true));

    print('FCM token saved to Firestore.');
  }
}
