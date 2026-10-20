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
import 'services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  final List<Map<String, String>> news;
  final SettingsController settingsController;

  const ProfilePage({
    super.key,
    required this.news,
    required this.settingsController,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // null  = still loading
  // ''    = loaded, but no username stored (shows the default "User" label)
  String? _username;
  String? _email;

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  String _usernameText(AppStrings s) {
    if (_username == null) return s.loading;
    if (_username!.isEmpty) return s.defaultUser;
    return _username!;
  }

  String _emailText(AppStrings s) => _email ?? s.loading;

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
        _email = user.email ?? "";

        if (doc.exists) {
          _username = (doc.data()?["username"] ?? "").toString();
        } else {
          _username = "";
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _username = "";
        _email = user.email ?? "";
      });
    }
  }

  void _showDetails() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBackgroundColor = isDark ? darkCardColor : cardColor;

    final textColor = isDark ? darkInkColor : inkColor;

    final accentColor = isDark ? darkBrownColor : brownColor;

    final s = AppStrings.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardBackgroundColor,

          title: Text(
            s.yourDetails.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.w900, color: textColor),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.usernameLabel.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                _usernameText(s),
                style: TextStyle(fontSize: 15, color: textColor),
              ),

              const SizedBox(height: 20),

              Text(
                s.emailLabel.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                _emailText(s),
                style: TextStyle(fontSize: 15, color: textColor),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                s.close.toUpperCase(),
                style: TextStyle(color: accentColor),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final s = AppStrings.of(context);

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
            s.profileTitle.toUpperCase(),
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
                _usernameText(s),
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
                s.welcomeToApp,
                textAlign: TextAlign.center,
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
                      s.savedArticles,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    subtitle: Text(
                      s.manageSavedNews,
                      style: TextStyle(color: accentColor),
                    ),
                    trailing: Icon(Icons.chevron_right, color: accentColor),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SavedPage(),
                        ),
                      );
                    },
                  ),

                  Divider(color: dividerColor),

                  // NOTIFICATIONS
                  ListTile(
                    leading: Icon(Icons.notifications_none, color: accentColor),
                    title: Text(
                      s.notifications,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    subtitle: Text(
                      s.manageNewsNotifications,
                      style: TextStyle(color: accentColor),
                    ),
                    trailing: Icon(Icons.chevron_right, color: accentColor),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationsPage(
                            trendingNews: widget.news,
                            notificationsEnabled:
                                widget.settingsController.notificationsEnabled,
                            settingsController: widget.settingsController,
                          ),
                        ),
                      );
                    },
                  ),

                  Divider(color: dividerColor),

                  // DETAILS
                  ListTile(
                    leading: Icon(Icons.person_outline, color: accentColor),
                    title: Text(
                      s.details,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    subtitle: Text(
                      s.viewUsernameEmail,
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
                      s.aboutUs,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    subtitle: Text(
                      s.aboutCleanNews,
                      style: TextStyle(color: accentColor),
                    ),
                    trailing: Icon(Icons.chevron_right, color: accentColor),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: s.brandName,
                        applicationVersion: "1.0.0",
                        applicationIcon: Icon(
                          Icons.newspaper,
                          color: accentColor,
                        ),
                        children: [Text(s.aboutCleanNewsDescription)],
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
                  s.logout.toUpperCase(),
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
                onPressed: () async {
                  // Actually sign out of Firebase, otherwise the user would
                  // still be signed in the next time the app opens.
                  await AuthService().logout();

                  if (!context.mounted) return;

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
                s.brandName.toUpperCase(),
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