import 'package:flutter/material.dart';

import 'theme.dart';
import 'home_page.dart';
import 'settings_page.dart';
import 'settings_controller.dart';
import 'app_strings.dart';

class NotificationsPage extends StatelessWidget {
  final List<Map<String, String>> trendingNews;
  final bool notificationsEnabled;
  final SettingsController settingsController;

  const NotificationsPage({
    super.key,
    required this.trendingNews,
    required this.notificationsEnabled,
    required this.settingsController,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? darkPaperColor : paperColor;
    final cardBackgroundColor = isDark ? darkCardColor : cardColor;
    final textColor = isDark ? darkInkColor : inkColor;
    final accentColor = isDark ? darkBrownColor : brownColor;
    final dividerColor = isDark ? darkBorderColor : borderColor;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        title: Text(
          s.notifications.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: textColor,
          ),
        ),
      ),

      body: !notificationsEnabled
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off_outlined,
                      color: accentColor,
                      size: 60,
                    ),

                    const SizedBox(height: 20),

                    Text(
                      s.notificationsDisabledTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      s.enableNotificationsHint,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 25),

                    ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SettingsPage(
                              settingsController: settingsController,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings_outlined),
                      label: Text(
                        s.goToSettings.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: backgroundColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : trendingNews.isEmpty
          ? Center(
              child: Text(
                s.noNewNotifications,
                style: TextStyle(color: accentColor, fontSize: 15),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: trendingNews.length,
              itemBuilder: (context, index) {
                final article = trendingNews[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardBackgroundColor,
                    border: Border.all(color: dividerColor),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,

                    onTap: () {
                      final articleUrl = article["url"];

                      if (articleUrl == null || articleUrl.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(s.linkUnavailable),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ArticleWebViewPage(articleUrl: articleUrl),
                        ),
                      );
                    },

                    leading: Icon(
                      Icons.notifications_active_outlined,
                      color: accentColor,
                      size: 30,
                    ),

                    title: Text(
                      article["title"] ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),

                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "${article["source"] ?? s.defaultNewsSource} • ${article["time"] ?? ""}",
                        style: TextStyle(color: accentColor),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}