import 'package:flutter/material.dart';

import 'theme.dart';
import 'home_page.dart';
import 'settings_page.dart';
import 'settings_controller.dart';

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
    return Scaffold(
      backgroundColor: paperColor,

      appBar: AppBar(
        title: const Text(
          "NOTIFICATIONS",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: inkColor,
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
                    const Icon(
                      Icons.notifications_off_outlined,
                      color: brownColor,
                      size: 60,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Notifications are disabled",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: inkColor,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Enable notifications in Settings to get the latest news updates.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: brownColor,
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
                      label: const Text(
                        "GO TO SETTINGS",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brownColor,
                        foregroundColor: paperColor,
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
          ? const Center(
              child: Text(
                "No new notifications.",
                style: TextStyle(color: brownColor, fontSize: 15),
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
                    color: cardColor,
                    border: Border.all(color: borderColor),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,

                    onTap: () {
                      final articleUrl = article["url"];

                      if (articleUrl == null || articleUrl.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Article link is not available."),
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

                    leading: const Icon(
                      Icons.notifications_active_outlined,
                      color: brownColor,
                      size: 30,
                    ),

                    title: Text(
                      article["title"] ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: inkColor,
                      ),
                    ),

                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "${article["source"] ?? "News"} • ${article["time"] ?? ""}",
                        style: const TextStyle(color: brownColor),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
