import 'package:flutter/material.dart';
import 'theme.dart';

class SavedPage extends StatelessWidget {
  final List<Map<String, String>> news;
  final List<bool> bookmarked;
  final ValueChanged<int> onBookmarkChanged;

  const SavedPage({
    super.key,
    required this.news,
    required this.bookmarked,
    required this.onBookmarkChanged,
  });

  @override
  Widget build(BuildContext context) {
    final savedIndexes = <int>[
      for (int i = 0; i < bookmarked.length; i++)
        if (bookmarked[i]) i,
    ];

    return Scaffold(
      backgroundColor: paperColor,
      appBar: AppBar(
        title: const Text(
          "SAVED ARTICLES",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: inkColor,
          ),
        ),
      ),
      body: savedIndexes.isEmpty
          ? const Center(
              child: Text(
                "No saved articles yet.",
                style: TextStyle(
                  color: brownColor,
                  fontSize: 15,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: savedIndexes.length,
              itemBuilder: (context, position) {
                final index = savedIndexes[position];
                final article = news[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    border: Border.all(color: borderColor),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
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
                        "${article["source"]} • ${article["time"]}",
                        style: const TextStyle(color: brownColor),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: brownColor),
                      onPressed: () {
                        onBookmarkChanged(index);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
