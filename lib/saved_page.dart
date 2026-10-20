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
import 'services/article_database.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final ArticleDatabase _articleDatabase = ArticleDatabase.instance;

  List<Article> _articles = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSavedArticles();
  }

  // ==========================================================
  // LOAD SAVED ARTICLES
  // ==========================================================

  Future<void> _loadSavedArticles() async {
    try {
      // First load SQLite.
      //
      // This is important because SQLite works even when
      // there is no internet connection.
      final localArticles = await _articleDatabase.getSavedArticles();

      if (mounted) {
        setState(() {
          _articles = localArticles;
          _isLoading = false;
        });
      }

      // If the user is signed in, try to synchronize with
      // Firestore in the background.
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await _syncFromFirestore(user.uid);
      }
    } catch (e) {
      debugPrint('Failed to load saved articles: $e');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  // ==========================================================
  // SYNC FIRESTORE → SQLITE
  // ==========================================================

  Future<void> _syncFromFirestore(String uid) async {
    try {
      final firestoreArticles = await _firestoreService
          .savedArticlesStream(uid)
          .first;

      // Save every Firestore article locally.
      for (final article in firestoreArticles) {
        if (article.articleUrl.trim().isEmpty) {
          continue;
        }

        await _articleDatabase.saveArticle(article);
      }

      // Remove local articles that are no longer saved
      // in Firestore.
      final firestoreUrls = firestoreArticles
          .map((article) => article.articleUrl)
          .where((url) => url.trim().isNotEmpty)
          .toSet();

      final localArticles = await _articleDatabase.getSavedArticles();

      for (final localArticle in localArticles) {
        if (!firestoreUrls.contains(localArticle.articleUrl)) {
          await _articleDatabase.deleteArticle(localArticle.articleUrl);
        }
      }

      final updatedArticles = await _articleDatabase.getSavedArticles();

      if (!mounted) return;

      setState(() {
        _articles = updatedArticles;
        _error = null;
      });
    } catch (e) {
      // Do NOT clear the local articles if Firestore is
      // unavailable.
      //
      // The whole point of SQLite is that saved articles
      // remain available offline.
      debugPrint('Firestore sync failed: $e');
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

    if (user == null) {
      return;
    }

    final s = AppStrings.of(context);

    try {
      // Remove from Firestore.
      await _firestoreService.removeSavedArticle(user.uid, article.articleUrl);

      // Remove from SQLite.
      await _articleDatabase.deleteArticle(article.articleUrl);

      if (!mounted) return;

      setState(() {
        _articles.removeWhere((item) => item.articleUrl == article.articleUrl);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s.articleRemoved),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      debugPrint('Failed to remove saved article: $e');

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
  // REFRESH
  // ==========================================================

  Future<void> _refresh() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      await _loadSavedArticles();
      return;
    }

    try {
      await _syncFromFirestore(user.uid);
    } catch (e) {
      debugPrint('Refresh failed: $e');
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

    Widget centered(String text) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: accentColor, fontSize: 15),
          ),
        ),
      );
    }

    Widget body;

    // ========================================================
    // LOADING
    // ========================================================

    if (_isLoading) {
      body = Center(child: CircularProgressIndicator(color: accentColor));
    }
    // ========================================================
    // ERROR
    // ========================================================
    else if (_error != null && _articles.isEmpty) {
      body = centered(s.couldNotLoadSaved);
    }
    // ========================================================
    // EMPTY
    // ========================================================
    else if (_articles.isEmpty) {
      body = centered(s.noSavedArticles);
    }
    // ========================================================
    // ARTICLES
    // ========================================================
    else {
      body = RefreshIndicator(
        onRefresh: _refresh,
        color: accentColor,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _articles.length,
          itemBuilder: (context, index) {
            final article = _articles[index];

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
                      // ==================================================
                      // TITLE
                      // ==================================================

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

                      // ==================================================
                      // DESCRIPTION
                      // ==================================================
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

                      // ==================================================
                      // SOURCE + DATE
                      // ==================================================
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

                          Flexible(
                            child: Text(
                              article.publishedAt,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // ==================================================
                      // ACTIONS
                      // ==================================================
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
                            tooltip: s.articleRemoved,
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
        ),
      );
    }

    // ========================================================
    // PAGE
    // ========================================================

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
