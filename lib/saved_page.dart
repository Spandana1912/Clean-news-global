import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'theme.dart';
import 'home_page.dart';
import 'app_strings.dart';
import 'models/article.dart';
import 'services/firestore_service.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  final FirestoreService _firestoreService = FirestoreService();

  Stream<List<Article>>? _savedStream;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _savedStream = _firestoreService.savedArticlesStream(user.uid);
    }
  }

  // ==========================================================
  // OPEN ARTICLE
  // ==========================================================

  Future<void> _openArticle(String url) async {
    if (url.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.of(context).linkUnavailable),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final uri = Uri.tryParse(url);

    if (uri == null || !uri.hasScheme) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.of(context).invalidLink),
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

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.of(context).couldNotOpenArticle),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ==========================================================
  // REMOVE FROM SAVED
  // ==========================================================

  Future<void> _remove(Article article) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final s = AppStrings.of(context);

    try {
      await _firestoreService.removeSavedArticle(user.uid, article.articleUrl);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s.articleRemoved),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s.couldNotUpdateSaved),
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
    final s = AppStrings.of(context);

    final backgroundColor = isDark ? darkPaperColor : paperColor;
    final cardBackgroundColor = isDark ? darkCardColor : cardColor;
    final textColor = isDark ? darkInkColor : inkColor;
    final accentColor = isDark ? darkBrownColor : brownColor;
    final dividerColor = isDark ? darkBorderColor : borderColor;

    Widget centered(String text) => Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: accentColor, fontSize: 15),
        ),
      ),
    );

    Widget body;

    if (_savedStream == null) {
      body = centered(s.noSavedArticles);
    } else {
      body = StreamBuilder<List<Article>>(
        stream: _savedStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return centered(s.couldNotLoadSaved);
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: accentColor));
          }

          final articles = snapshot.data!;

          if (articles.isEmpty) {
            return centered(s.noSavedArticles);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: cardBackgroundColor,
                  border: Border.all(color: dividerColor),
                ),
                child: InkWell(
                  onTap: () => _openArticle(article.articleUrl),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: textColor,
                            height: 1.3,
                          ),
                        ),

                        const SizedBox(height: 10),
                        Container(height: 1, color: dividerColor),
                        const SizedBox(height: 10),

                        if (article.description.isNotEmpty)
                          Text(
                            article.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: accentColor,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Icon(Icons.public, size: 17, color: accentColor),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                article.source,
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
                              article.publishedAt,
                              style: TextStyle(color: accentColor, fontSize: 10),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () => _openArticle(article.articleUrl),
                              icon: Icon(
                                Icons.menu_book_outlined,
                                size: 18,
                                color: accentColor,
                              ),
                              label: Text(
                                s.readArticle,
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
                              onPressed: () => _remove(article),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    }

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
          elevation: 0,
          title: Text(
            s.savedArticles.toUpperCase(),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ),
        body: body,
      ),
    );
  }
}