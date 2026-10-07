import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme.dart';
import 'login_page.dart';
import 'saved_page.dart';
import 'notifications_page.dart';
import 'settings_controller.dart';
import 'app_strings.dart';

class ProfilePage extends StatefulWidget {
  final List<Map<String, String>> news;
  final List<bool> bookmarked;
  final ValueChanged<int> onBookmarkChanged;
  final SettingsController settingsController;

  const ProfilePage({
    super.key,
    required this.news,
    required this.bookmarked,
    required this.onBookmarkChanged,
    required this.settingsController,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "Loading...";
  String email = "Loading...";

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  Future<void> loadUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (!mounted) return;

      setState(() {
        email = user.email ?? "";

        if (doc.exists) {
          username = doc.data()?["username"] ?? "User";
        } else {
          username = "User";
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        username = "User";
        email = user.email ?? "";
      });
    }
  }

  void _showDetails() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBackgroundColor = isDark ? darkCardColor : cardColor;

    final textColor = isDark ? darkInkColor : inkColor;

    final accentColor = isDark ? darkBrownColor : brownColor;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: cardBackgroundColor,

          title: Text(
            "YOUR DETAILS",
            style: TextStyle(fontWeight: FontWeight.w900, color: textColor),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "USERNAME",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),

              const SizedBox(height: 5),

              Text(username, style: TextStyle(fontSize: 15, color: textColor)),

              const SizedBox(height: 20),

              Text(
                "EMAIL",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),

              const SizedBox(height: 5),

              Text(email, style: TextStyle(fontSize: 15, color: textColor)),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("CLOSE", style: TextStyle(color: accentColor)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final strings = AppStrings(widget.settingsController.language);

    final backgroundColor = isDark ? darkPaperColor : paperColor;

    final cardBackgroundColor = isDark ? darkCardColor : cardColor;

    final textColor = isDark ? darkInkColor : inkColor;

    final accentColor = isDark ? darkBrownColor : brownColor;

    final dividerColor = isDark ? darkBorderColor : borderColor;

    final fadedBackgroundColor = isDark ? darkFadedColor : fadedColor;
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.libreBaskervilleTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryTextTheme: GoogleFonts.libreBaskervilleTextTheme(
          Theme.of(context).primaryTextTheme,
        ),
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,

        appBar: AppBar(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          title: Text(
            "PROFILE",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              color: textColor,
            ),
          ),
        ),

        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: fadedBackgroundColor,
              child: Icon(Icons.person, size: 50, color: accentColor),
            ),

            const SizedBox(height: 18),

            Center(
              child: Text(
                username,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
            ),

            const SizedBox(height: 6),

            Center(
              child: Text(
                "Welcome to The Clean News Global",
                style: TextStyle(fontSize: 12, color: accentColor),
              ),
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardBackgroundColor,
                border: Border.all(color: dividerColor),
              ),
              child: Column(
                children: [
                  // SAVED ARTICLES
                  ListTile(
                    leading: Icon(Icons.bookmark_outline, color: accentColor),
                    title: Text(
                      strings.savedArticles,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    subtitle: Text(
                      "Manage your saved news",
                      style: TextStyle(color: accentColor),
                    ),
                    trailing: Icon(Icons.chevron_right, color: accentColor),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SavedPage(
                            news: widget.news,
                            bookmarked: widget.bookmarked,
                            onBookmarkChanged: widget.onBookmarkChanged,
                          ),
                        ),
                      );
                    },
                  ),

                  Divider(color: dividerColor),

                  // NOTIFICATIONS
                  ListTile(
                    leading: Icon(Icons.notifications_none, color: accentColor),
                    title: Text(
                      strings.notifications,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    subtitle: Text(
                      strings.manageNewsNotifications,
                      style: TextStyle(color: accentColor),
                    ),
                    trailing: Icon(Icons.chevron_right, color: accentColor),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NotificationsPage(trendingNews: widget.news),
                        ),
                      );
                    },
                  ),

                  Divider(color: dividerColor),

                  // DETAILS
                  ListTile(
                    leading: Icon(Icons.person_outline, color: accentColor),
                    title: Text(
                      strings.details,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    subtitle: Text(
                      strings.viewUsernameEmail,
                      style: TextStyle(color: accentColor),
                    ),
                    trailing: Icon(Icons.chevron_right, color: accentColor),
                    onTap: _showDetails,
                  ),

                  Divider(color: dividerColor),

                  // ABOUT
                  ListTile(
                    leading: Icon(Icons.info_outline, color: accentColor),
                    title: Text(
                      strings.aboutUs,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    subtitle: Text(
                      strings.aboutCleanNews,
                      style: TextStyle(color: accentColor),
                    ),
                    trailing: Icon(Icons.chevron_right, color: accentColor),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: "The Clean News Global",
                        applicationVersion: "1.0.0",
                        applicationIcon: Icon(
                          Icons.newspaper,
                          color: accentColor,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // LOG OUT
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                icon: Icon(Icons.logout, color: accentColor),
                label: Text(
                  strings.logout,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: accentColor,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: accentColor),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(
                        settingsController: widget.settingsController,
                      ),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                "THE CLEAN NEWS GLOBAL",
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 2,
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
