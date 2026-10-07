import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme.dart';
import 'home_page.dart';

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

  // ==========================================================
  // OPEN ARTICLE
  // ==========================================================

  Future<void> _openArticle(BuildContext context, String url) async {
    if (url.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Article link is not available."),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    final uri = Uri.tryParse(url);

    if (uri == null || !uri.hasScheme) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid article link."),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    // Android / iOS / macOS
    if (!kIsWeb) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ArticleWebViewPage(articleUrl: url)),
      );

      return;
    }

    // Flutter Web
    final opened = await launchUrl(uri, mode: LaunchMode.platformDefault);

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Could not open the article."),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? darkPaperColor : paperColor;

    final cardBackgroundColor = isDark ? darkCardColor : cardColor;

    final textColor = isDark ? darkInkColor : inkColor;

    final accentColor = isDark ? darkBrownColor : brownColor;

    final dividerColor = isDark ? darkBorderColor : borderColor;

    final savedIndexes = <int>[
      for (int i = 0; i < bookmarked.length; i++)
        if (bookmarked[i]) i,
    ];

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

        // ======================================================
        // APP BAR
        // ======================================================
        appBar: AppBar(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,

          title: Text(
            "SAVED ARTICLES",
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ),

        // ======================================================
        // BODY
        // ======================================================
        body: savedIndexes.isEmpty
            ? Center(
                child: Text(
                  "No saved articles yet.",
                  style: TextStyle(color: accentColor, fontSize: 15),
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

                    decoration: BoxDecoration(
                      color: cardBackgroundColor,

                      border: Border.all(color: dividerColor),
                    ),

                    child: InkWell(
                      // ========================================
                      // TAP ARTICLE
                      // ========================================

                      onTap: () {
                        _openArticle(context, article["url"] ?? "");
                      },

                      child: Padding(
                        padding: const EdgeInsets.all(16),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            // ==================================
                            // TITLE
                            // ==================================

                            Text(
                              article["title"] ?? "",

                              style: TextStyle(
                                fontWeight: FontWeight.w900,

                                fontSize: 18,

                                color: textColor,

                                height: 1.3,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // ==================================
                            // DIVIDER
                            // ==================================
                            Container(height: 1, color: dividerColor),

                            const SizedBox(height: 10),

                            // ==================================
                            // DESCRIPTION
                            // ==================================
                            if ((article["description"] ?? "").isNotEmpty)
                              Text(
                                article["description"] ?? "",

                                maxLines: 3,

                                overflow: TextOverflow.ellipsis,

                                style: TextStyle(
                                  color: accentColor,
                                  fontSize: 13,
                                  height: 1.5,
                                ),
                              ),

                            const SizedBox(height: 12),

                            // ==================================
                            // SOURCE + TIME
                            // ==================================
                            Row(
                              children: [
                                Icon(
                                  Icons.public,
                                  size: 17,
                                  color: accentColor,
                                ),

                                const SizedBox(width: 7),

                                Expanded(
                                  child: Text(
                                    article["source"] ?? "",

                                    overflow: TextOverflow.ellipsis,

                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,

                                      fontSize: 12,

                                      color: textColor,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 8),

                                Text(
                                  article["time"] ?? "",

                                  style: TextStyle(
                                    color: accentColor,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // ==================================
                            // BOTTOM ACTIONS
                            // ==================================
                            Row(
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    _openArticle(context, article["url"] ?? "");
                                  },

                                  icon: Icon(
                                    Icons.menu_book_outlined,
                                    size: 18,
                                    color: accentColor,
                                  ),

                                  label: Text(
                                    "READ ARTICLE",
                                    style: TextStyle(
                                      color: accentColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                const Spacer(),

                                IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: accentColor,
                                  ),

                                  onPressed: () {
                                    onBookmarkChanged(index);

                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
