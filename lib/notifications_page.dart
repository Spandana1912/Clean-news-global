import 'package:flutter/material.dart';

import 'theme.dart';

class NotificationsPage extends StatelessWidget {
  final List<Map<String, String>> trendingNews;

  const NotificationsPage({super.key, required this.trendingNews});

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

      body: trendingNews.isEmpty
          ? const Center(
              child: Text(
                "No trending news right now.",
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

                    leading: const Icon(
                      Icons.trending_up,
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
