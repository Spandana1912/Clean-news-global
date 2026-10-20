import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/article.dart';
import 'services/news_api_service.dart';
import 'services/ai_summary_service.dart';
import 'services/firestore_service.dart';
import 'profile_page.dart';
import 'saved_page.dart';
import 'settings_page.dart';
import 'settings_controller.dart';
import 'theme.dart';
import 'notifications_page.dart';
import 'app_strings.dart';
import 'weather_card.dart';
import 'ai_summary_dialog.dart';

// ==========================================================
// ARTICLE WEB VIEW
// ==========================================================

class ArticleWebViewPage extends StatefulWidget {
  final String articleUrl;

  const ArticleWebViewPage({super.key, required this.articleUrl});

  @override
  State<ArticleWebViewPage> createState() => _ArticleWebViewPageState();
}

class _ArticleWebViewPageState extends State<ArticleWebViewPage> {
  late final WebViewController _controller;

  int _loadingProgress = 0;

  @override
  void initState() {
    super.initState();

    final uri = Uri.tryParse(widget.articleUrl);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (!mounted) return;

            setState(() {
              _loadingProgress = progress;
            });
          },

          onPageStarted: (_) {
            if (!mounted) return;

            setState(() {
              _loadingProgress = 0;
            });
          },

          onPageFinished: (_) {
            if (!mounted) return;

            setState(() {
              _loadingProgress = 100;
            });
          },

          onWebResourceError: (error) {
            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppStrings.of(context).unableToLoadArticle),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      );

    if (uri != null) {
      _controller.loadRequest(uri);
    }
  }

  Future<bool> _handleBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? darkPaperColor : paperColor;

    final textColor = isDark ? darkInkColor : inkColor;

    final accentColor = isDark ? darkBrownColor : brownColor;

    final fadedBackgroundColor = isDark ? darkFadedColor : fadedColor;

    return WillPopScope(
      onWillPop: _handleBack,
      child: Scaffold(
        backgroundColor: backgroundColor,

        appBar: AppBar(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,

          title: Text(
            AppStrings.of(context).articleTitle,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),

          bottom: _loadingProgress < 100
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(2),
                  child: LinearProgressIndicator(
                    value: _loadingProgress / 100,
                    backgroundColor: fadedBackgroundColor,
                    color: accentColor,
                  ),
                )
              : null,
        ),

        body: SafeArea(child: WebViewWidget(controller: _controller)),
      ),
    );
  }
}

// ==========================================================
// HOME PAGE
// ==========================================================

class HomePage extends StatefulWidget {
  final SettingsController settingsController;

  const HomePage({super.key, required this.settingsController});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  // ==========================================================
  // NEWS API
  // ==========================================================

  final NewsApiService _newsApiService = NewsApiService();

  final AiSummaryService _aiSummaryService = AiSummaryService();

  List<Article> _articles = [];

  bool _isLoadingNews = true;

  String? _newsError;

  bool hasNotification = false;

  String _username = '';

  List<Article> _newNotifications = [];

  // ==========================================================
  // AUTOMATIC NEWS CHECK
  // ==========================================================

  Timer? _newsCheckTimer;

  bool _isCheckingLatestNews = false;

  // For faculty demonstration:
  // news is checked every 1 minute.
  //
  // For normal use, you can change this to:
  // const Duration(minutes: 5)
  static const Duration _newsCheckInterval = Duration(minutes: 1);

  // ==========================================================
  // SEARCH
  // ==========================================================

  final TextEditingController _searchController = TextEditingController();

  bool _isSearchMode = false;

  bool _isSearching = false;

  String _searchQuery = '';

  // ==========================================================
  // CATEGORIES
  // ==========================================================

  final List<String> categories = [
    "All",
    "Business",
    "Sports",
    "Technology",
    "Health",
    "Science",
    "Entertainment",
  ];

  int selectedCategory = 0;

  int _newsTransitionKey = 0;

  // India is the default region.
  bool _isInternational = false;

  int bottomIndex = 0;

  // ==========================================================
  // SAVED ARTICLES (stored in Firestore)
  // ==========================================================

  final FirestoreService _savedService = FirestoreService();

  StreamSubscription<List<Article>>? _savedSubscription;

  // Article URLs the user has saved.
  Set<String> _savedUrls = {};

  void _listenToSavedArticles() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    _savedSubscription?.cancel();

    _savedSubscription = _savedService
        .savedArticlesStream(user.uid)
        .listen(
          (saved) {
            if (!mounted) return;

            setState(() {
              _savedUrls = saved.map((a) => a.articleUrl).toSet();
            });
          },
          onError: (Object e) {
            debugPrint('Saved articles stream error: $e');
          },
        );
  }

  bool _isSaved(Article article) => _savedUrls.contains(article.articleUrl);

  // ==========================================================
  // LOAD USERNAME
  // ==========================================================

  Future<void> _loadUsername() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {
      final firestoreService = FirestoreService();

      final profile = await firestoreService.getUserProfile(user.uid);

      if (!mounted) return;

      final data = profile.data();

      if (data != null && data['username'] != null) {
        setState(() {
          _username = data['username'].toString();
        });
      }
    } catch (e) {
      debugPrint('Could not load username: $e');
    }
  }

  // ==========================================================
  // START AUTOMATIC NEWS CHECK
  // ==========================================================

  void _startNewsCheckTimer() {
    _newsCheckTimer?.cancel();

    _newsCheckTimer = Timer.periodic(_newsCheckInterval, (_) {
      if (!mounted) return;

      // Do not automatically replace search results.
      if (_isSearchMode) return;

      _checkLatestNews(automatic: true);
    });

    debugPrint('Automatic news checking started.');
  }

  // ==========================================================
  // STOP AUTOMATIC NEWS CHECK
  // ==========================================================

  void _stopNewsCheckTimer() {
    _newsCheckTimer?.cancel();
    _newsCheckTimer = null;

    debugPrint('Automatic news checking stopped.');
  }

  // ==========================================================
  // APP LIFECYCLE
  // ==========================================================

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      debugPrint('App resumed. Checking latest news.');

      if (!_isSearchMode) {
        _checkLatestNews(automatic: true);
      }

      _startNewsCheckTimer();
    }

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      debugPrint('App moved to background.');

      _stopNewsCheckTimer();
    }
  }

  // ==========================================================
  // CHECK FOR NEW NEWS
  // ==========================================================

  Future<List<Article>> _checkForNewNews(List<Article> articles) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || articles.isEmpty) {
      return [];
    }

    try {
      final notificationRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('notificationState')
          .doc('news');

      final snapshot = await notificationRef.get();

      final currentFeedKey =
          '${_isInternational ? 'international' : 'india'}_$selectedCategory';

      final currentUrls = articles
          .map((article) => article.articleUrl)
          .where((url) => url.isNotEmpty)
          .take(30)
          .toList();

      // First time checking news.
      if (!snapshot.exists) {
        await notificationRef.set({
          'knownArticleUrls': currentUrls,
          'feedKey': currentFeedKey,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        return [];
      }

      final data = snapshot.data();

      final savedFeedKey = data?['feedKey'] as String?;

      final knownUrls = List<String>.from(data?['knownArticleUrls'] ?? []);

      // If the user changed region/category,
      // establish the new feed without showing
      // false notifications.
      if (savedFeedKey != currentFeedKey) {
        await notificationRef.set({
          'knownArticleUrls': currentUrls,
          'feedKey': currentFeedKey,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        return [];
      }

      // Find articles that weren't seen before.
      final newArticles = articles
          .where(
            (article) =>
                article.articleUrl.isNotEmpty &&
                !knownUrls.contains(article.articleUrl),
          )
          .toList();

      // Save the latest known articles.
      await notificationRef.set({
        'knownArticleUrls': currentUrls,
        'feedKey': currentFeedKey,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return newArticles;
    } catch (e) {
      debugPrint('New news check failed: $e');

      return [];
    }
  }

  // ==========================================================
  // CHECK LATEST NEWS
  // ==========================================================

  Future<void> _checkLatestNews({bool automatic = false}) async {
    // Prevent multiple API requests at the same time.
    if (_isCheckingLatestNews) {
      return;
    }

    // Do not check search results automatically.
    if (_isSearchMode) {
      return;
    }

    _isCheckingLatestNews = true;

    if (mounted && !automatic) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.of(context).checkingLatestSnack),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    try {
      await _fetchNews(checkForNewNews: true, showNoNewMessage: !automatic);
    } finally {
      _isCheckingLatestNews = false;
    }
  }

  // ==========================================================
  // SEARCH NEWS
  // ==========================================================

  Future<void> _searchNews() async {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isSearchMode = true;
      _isSearching = true;
      _isLoadingNews = false;
      _newsError = null;
      _searchQuery = query;
    });

    try {
      final articles = await _newsApiService.searchNews(query);

      if (!mounted) return;

      setState(() {
        _articles = articles;

        _isSearching = false;
        _isSearchMode = true;
        _newsError = null;

        _newsTransitionKey++;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSearching = false;
        _isSearchMode = true;
        _newsError = e.toString();
        _articles = [];
      });
    }
  }

  // ==========================================================
  // CLEAR SEARCH
  // ==========================================================

  Future<void> _clearSearch() async {
    _searchController.clear();

    setState(() {
      _isSearchMode = false;
      _isSearching = false;
      _searchQuery = '';
      _newsError = null;
      _isLoadingNews = true;
    });

    await _fetchNews(checkForNewNews: false);

    _startNewsCheckTimer();
  }

  // ==========================================================
  // FETCH NEWS
  // ==========================================================

  Future<void> _fetchNews({
    String? category,
    bool checkForNewNews = true,
    bool showNoNewMessage = false,
  }) async {
    setState(() {
      _isLoadingNews = true;
      _newsError = null;
    });

    try {
      final articles = _isInternational
          ? await _newsApiService.getInternationalNews(category: category)
          : await _newsApiService.getIndiaNews(category: category);

      List<Article> newArticles = [];

      if (checkForNewNews && !_isSearchMode) {
        newArticles = await _checkForNewNews(articles);
      }

      if (!mounted) return;

      setState(() {
        _articles = articles;

        if (newArticles.isNotEmpty) {
          // Only keep a few articles in
          // the notification list.
          _newNotifications = newArticles.take(3).toList();

          hasNotification = true;
        }

        _isLoadingNews = false;
        _newsError = null;
        _newsTransitionKey++;
      });

      // ======================================================
      // NEW NEWS FOUND
      // ======================================================

      if (newArticles.isNotEmpty && mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppStrings.of(context).newArticlesAvailable(newArticles.length),
            ),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );

        return;
      }

      // ======================================================
      // NO NEW NEWS
      // ======================================================

      if (showNoNewMessage && mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.of(context).upToDate),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingNews = false;
        _newsError = e.toString();
        _articles = [];
      });

      if (showNoNewMessage && mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.of(context).couldNotCheckLatest),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // ==========================================================
  // INITIALIZE HOME PAGE
  // ==========================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _fetchNews();

    _loadUsername();

    _listenToSavedArticles();

    // Start automatic checking.
    _startNewsCheckTimer();
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    _stopNewsCheckTimer();

    _savedSubscription?.cancel();

    WidgetsBinding.instance.removeObserver(this);

    _searchController.dispose();

    super.dispose();
  }

  // ==========================================================
  // SAVED PAGE COMPATIBILITY
  // ==========================================================

  List<Map<String, String>> get news {
    return _articles.map((article) {
      return {
        "title": article.title,
        "description": article.description,
        "source": article.source,
        "time": article.publishedAt,
        "url": article.articleUrl,
      };
    }).toList();
  }

  // ==========================================================
  // TOGGLE BOOKMARK
  // ==========================================================

  Future<void> toggleBookmark(int index) async {
    if (index < 0 || index >= _articles.length) {
      return;
    }

    final article = _articles[index];
    final s = AppStrings.of(context);

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s.signInToSave),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (article.articleUrl.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s.linkUnavailable),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? darkBrownColor : brownColor;
    final snackbarTextColor = isDark ? darkInkColor : paperColor;

    final wasSaved = _isSaved(article);

    // Update the heart instantly; the Firestore stream confirms it.
    setState(() {
      if (wasSaved) {
        _savedUrls = {..._savedUrls}..remove(article.articleUrl);
      } else {
        _savedUrls = {..._savedUrls, article.articleUrl};
      }
    });

    try {
      if (wasSaved) {
        await _savedService.removeSavedArticle(user.uid, article.articleUrl);
      } else {
        await _savedService.saveArticle(user.uid, article);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: accentColor,
          content: Text(
            wasSaved ? s.articleRemoved : s.articleSaved,
            style: TextStyle(color: snackbarTextColor),
          ),
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      );
    } catch (e) {
      debugPrint('Could not update saved article: $e');

      if (!mounted) return;

      // Undo the optimistic change.
      setState(() {
        if (wasSaved) {
          _savedUrls = {..._savedUrls, article.articleUrl};
        } else {
          _savedUrls = {..._savedUrls}..remove(article.articleUrl);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s.couldNotUpdateSaved),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ==========================================================
  // SHARE
  // ==========================================================

  void shareNews(String url) {
    if (url.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.of(context).linkUnavailable),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

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
            AppStrings.of(context).shareArticle,
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),

          content: SelectableText(
            url,
            style: TextStyle(fontSize: 13, color: accentColor),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppStrings.of(context).close, style: TextStyle(color: accentColor)),
            ),

            ElevatedButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: url));

                Navigator.pop(context);

                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(content: Text(AppStrings.of(this.context).linkCopied),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: isDark ? darkPaperColor : paperColor,
              ),

              child: Text(AppStrings.of(context).copyLink),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // OPEN ARTICLE
  // ==========================================================

  Future<void> _openArticle(String url) async {
    if (url.trim().isEmpty) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.of(context).linkUnavailable),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    final uri = Uri.tryParse(url);

    if (uri == null || !uri.hasScheme) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.of(context).invalidLink),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    // Android / iOS / macOS:
    // Open inside Clean News Global.
    if (!kIsWeb) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ArticleWebViewPage(articleUrl: url)),
      );

      return;
    }

    // Flutter Web:
    // Use browser.
    final opened = await launchUrl(uri, mode: LaunchMode.platformDefault);

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.of(context).couldNotOpenArticle),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ==========================================================
  // SHOW ARTICLE
  // ==========================================================

  void showArticle(BuildContext context, int index) {
    final article = _articles[index];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? darkPaperColor : paperColor;

    final textColor = isDark ? darkInkColor : inkColor;

    final accentColor = isDark ? darkBrownColor : brownColor;

    final dividerColor = isDark ? darkBorderColor : borderColor;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: dividerColor),
          ),

          title: Text(
            article.title,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w900),
          ),

          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Container(height: 2, color: textColor),

                const SizedBox(height: 15),

                Text(
                  article.description,
                  style: TextStyle(
                    color: accentColor,
                    height: 1.6,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  "${article.source}  •  ${article.publishedAt}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                AppStrings.of(context).close.toUpperCase(),
                style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // FALLBACK IMAGE
  // ==========================================================

  String _getFallbackImage() {
    switch (categories[selectedCategory].toLowerCase()) {
      case 'business':
        return 'https://images.unsplash.com/39/lIZrwvbeRuuzqOoWJUEn_Photoaday_CSD%20(1%20of%201)-5.jpg?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1zZWFyY2h8M3x8dGVjaG5vbG9neXxlbnwwfHwwfHx8MA==';

      case 'sports':
        return 'https://images.pexels.com/photos/9376460/pexels-photo-9376460.jpeg?h=1000&w=1500&fit=crop';

      case 'technology':
        return 'https://images.unsplash.com/photo-1644088379091-d574269d422f?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8dGVjaG5vbG9neXxlbnwwfHwwfHx8MA==';

      case 'health':
        return 'https://images.unsplash.com/photo-1526256262350-7da7584cf5eb?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1zZWFyY2h8Mnx8bWVkaWNhbCUyMGFzc2lzdGFuY2V8ZW58MHx8MHx8fDA=';

      case 'science':
        return 'https://images.unsplash.com/photo-1628595351029-c2bf17511435?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8c2NpZW5jZXxlbnwwfHwwfHx8MA==';

      case 'entertainment':
        return 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1zZWFyY2h8Mnx8c2NpZW5jZXxlbnwwfHwwfHx8MA==';

      case 'all':
      default:
        return 'https://images.unsplash.com/photo-1521295121783-8a321d551ad2?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Z2xvYmV8ZW58MHx8MHx8fDA=';
    }
  }

  // ==========================================================
  // AI ARTICLE SUMMARY
  // ==========================================================

  Future<void> _showAiSummary(Article article) async {
    final summaryFuture = _aiSummaryService.summarizeArticle(
      article,
      language: widget.settingsController.language,
    );

    await showDialog<void>(
      context: context,
      builder: (_) => AiSummaryDialog(
        summaryFuture: summaryFuture,
        language: widget.settingsController.language,
      ),
    );
  }

  // ==========================================================
  // NEWS CARD
  // ==========================================================

  Widget newsCard(BuildContext context, int index) {
    final item = _articles[index];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBackgroundColor = isDark ? darkCardColor : cardColor;

    final textColor = isDark ? darkInkColor : inkColor;

    final accentColor = isDark ? darkBrownColor : brownColor;

    final dividerColor = isDark ? darkBorderColor : borderColor;

    final badgeTextColor = isDark ? darkPaperColor : paperColor;

    final bookmarkBackgroundColor = isDark ? darkPaperColor : paperColor;

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),

      decoration: BoxDecoration(
        color: cardBackgroundColor,

        border: Border.all(color: dividerColor, width: 1),

        boxShadow: const [
          BoxShadow(
            color: Color(0x221F1712),
            blurRadius: 6,
            offset: Offset(3, 4),
          ),
        ],
      ),

      child: InkWell(
        onTap: () {
          _openArticle(item.articleUrl);
        },

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ==================================================
            // IMAGE
            // ==================================================

            Stack(
              children: [
                ClipRRect(
                  child: item.imageUrl.trim().isNotEmpty
                      ? Image.network(
                          item.imageUrl,
                          height: 190,
                          width: double.infinity,
                          fit: BoxFit.cover,

                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              _getFallbackImage(),
                              height: 190,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.network(
                          _getFallbackImage(),
                          height: 190,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),

                // ==================================================
                // CATEGORY BADGE
                // ==================================================
                Positioned(
                  top: 12,
                  left: 12,

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),

                    color: textColor,

                    child: Text(
                      _isSearchMode
                          ? AppStrings.of(context).searchBadge
                          : AppStrings.of(context).category(selectedCategory),
                      style: TextStyle(
                        color: badgeTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),

                // ==================================================
                // BOOKMARK
                // ==================================================
                Positioned(
                  top: 10,
                  right: 10,

                  child: Container(
                    decoration: BoxDecoration(
                      color: bookmarkBackgroundColor,
                      border: Border.all(color: accentColor),
                    ),

                    child: IconButton(
                      icon: Icon(
                        _isSaved(item)
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: accentColor,
                      ),

                      onPressed: () {
                        toggleBookmark(index);
                      },
                    ),
                  ),
                ),
              ],
            ),

            // ==================================================
            // ARTICLE CONTENT
            // ==================================================
            Padding(
              padding: const EdgeInsets.all(17),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // HEADLINE

                  Text(
                    item.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                      height: 1.15,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(height: 1, color: dividerColor),

                  const SizedBox(height: 10),

                  // DESCRIPTION
                  Text(
                    item.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 14,
                      color: accentColor,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // SOURCE + TIME
                  Row(
                    children: [
                      Icon(Icons.public, size: 18, color: accentColor),

                      const SizedBox(width: 7),

                      Expanded(
                        child: Text(
                          item.source,
                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: textColor,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        item.publishedAt,
                        style: TextStyle(color: accentColor, fontSize: 11),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Container(height: 1, color: dividerColor),

                  const SizedBox(height: 8),

                  // AI SUMMARY
                  Align(
                    alignment: Alignment.centerLeft,

                    child: TextButton.icon(
                      onPressed: () => _showAiSummary(item),

                      icon: Icon(
                        Icons.auto_awesome,
                        size: 18,
                        color: accentColor,
                      ),

                      label: Text(
                        AppStrings.of(context).aiSummary,
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // ACTIONS
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          _openArticle(item.articleUrl);
                        },

                        icon: Icon(
                          Icons.menu_book_outlined,
                          size: 18,
                          color: accentColor,
                        ),

                        label: Text(
                          AppStrings.of(context).readArticle,
                          style: TextStyle(color: accentColor),
                        ),
                      ),

                      const Spacer(),

                      IconButton(
                        icon: Icon(Icons.share, color: accentColor),

                        onPressed: () {
                          shareNews(item.articleUrl);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // SECTION HEADER
  // ==========================================================

  Widget sectionHeader(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark ? darkInkColor : inkColor;

    final dividerColor = isDark ? darkBorderColor : borderColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: textColor,
            ),
          ),

          const SizedBox(height: 5),

          Container(height: 2, color: textColor),

          const SizedBox(height: 3),

          Container(height: 1, color: dividerColor),
        ],
      ),
    );
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

    final fadedBackgroundColor = isDark ? darkFadedColor : fadedColor;

    final selectedChipTextColor = isDark ? darkPaperColor : paperColor;

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

        // ========================================================
        // APP BAR
        // ========================================================
        appBar: AppBar(
          backgroundColor: backgroundColor,

          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                AppStrings.of(context).todaysTea,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  color: textColor,
                ),
              ),

              Text(
                AppStrings.of(context).globalEditionTagline,
                style: TextStyle(
                  fontSize: 9,
                  letterSpacing: 1.5,
                  color: accentColor,
                ),
              ),
            ],
          ),

          actions: [
            // ==================================================
            // SEARCH / CLEAR BUTTON
            // ==================================================

            IconButton(
              tooltip: _isSearchMode ? AppStrings.of(context).clearSearchTooltip : AppStrings.of(context).searchNewsTooltip,

              onPressed: () {
                if (_isSearchMode) {
                  _clearSearch();
                }
              },

              icon: Icon(
                _isSearchMode ? Icons.close : Icons.search,
                color: textColor,
              ),
            ),

            // ==================================================
            // USERNAME
            // ==================================================
            if (_username.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 12),

                child: Center(
                  child: Text(
                    AppStrings.of(context).hiUser(_username),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ),
              ),

            // ==================================================
            // NOTIFICATIONS
            // ==================================================
            Stack(
              children: [
                IconButton(
                  onPressed: () async {
                    setState(() {
                      hasNotification = false;
                    });

                    final notificationNews = _newNotifications.map((article) {
                      return {
                        "title": article.title,
                        "description": article.description,
                        "source": article.source,
                        "time": article.publishedAt,
                        "url": article.articleUrl,
                      };
                    }).toList();

                    setState(() {
                      _newNotifications = [];
                    });

                    await Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) => NotificationsPage(
                          trendingNews: notificationNews,

                          notificationsEnabled:
                              widget.settingsController.notificationsEnabled,

                          settingsController: widget.settingsController,
                        ),
                      ),
                    );
                  },

                  icon: Icon(Icons.notifications_none, color: textColor),
                ),

                if (hasNotification)
                  Positioned(
                    right: 8,
                    top: 8,

                    child: Container(
                      width: 9,
                      height: 9,

                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 8),
          ],
        ),

        // ========================================================
        // BODY
        // ========================================================
        body: RefreshIndicator(
          color: accentColor,
          backgroundColor: backgroundColor,

          onRefresh: () async {
            if (_isSearchMode) {
              await _searchNews();
            } else {
              await _fetchNews(checkForNewNews: true, showNoNewMessage: false);
            }

            if (!mounted) return;

            if (!_isSearchMode) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: accentColor,

                  content: Text(
                    AppStrings.of(context).editionRefreshed,
                    style: TextStyle(color: selectedChipTextColor),
                  ),
                ),
              );
            }
          },

          child: CustomScrollView(
            slivers: [
              // ==================================================
              // DATE HEADER
              // ==================================================

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 5, 16, 12),

                  child: Row(
                    children: [
                      Text(
                        DateFormat('EEEE', AppStrings.of(context).localeCode).format(DateTime.now()).toUpperCase(),

                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 1.5,
                          color: accentColor,
                        ),
                      ),

                      const Spacer(),

                      Text(
                        DateFormat('dd MMMM yyyy', AppStrings.of(context).localeCode)
                            .format(DateTime.now())
                            .toUpperCase(),

                        style: TextStyle(fontSize: 11, color: accentColor),
                      ),
                    ],
                  ),
                ),
              ),

              // WEATHER NOW
              const SliverToBoxAdapter(child: WeatherCard()),

              // ==================================================
              // SEARCH BAR
              // ==================================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 2, 16, 12),

                  child: Container(
                    decoration: BoxDecoration(
                      color: cardBackgroundColor,
                      border: Border.all(color: dividerColor),
                    ),

                    child: TextField(
                      controller: _searchController,

                      textInputAction: TextInputAction.search,

                      onSubmitted: (_) {
                        _searchNews();
                      },

                      decoration: InputDecoration(
                        hintText: AppStrings.of(context).searchNewsHint,

                        hintStyle: TextStyle(color: accentColor, fontSize: 13),

                        prefixIcon: Icon(Icons.search, color: accentColor),

                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.close, color: accentColor),

                                onPressed: _clearSearch,
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.arrow_forward,
                                  color: accentColor,
                                ),

                                onPressed: _searchNews,
                              ),

                        border: InputBorder.none,

                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                      ),

                      style: TextStyle(color: textColor, fontSize: 13),
                    ),
                  ),
                ),
              ),

              // ==================================================
              // MAIN LINE
              // ==================================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),

                  child: Container(height: 2, color: textColor),
                ),
              ),

              // ==================================================
              // TRENDING
              // ==================================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),

                  child: Row(
                    children: [
                      Icon(Icons.trending_up, color: accentColor),

                      const SizedBox(width: 7),

                      Expanded(
                        child: Text(
                          _isSearchMode
                              ? AppStrings.of(context).searchingFor(_searchQuery)
                              : AppStrings.of(context).trendingToday,

                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // ==================================================
              // CHECK LATEST BUTTON
              // ==================================================
              if (!_isSearchMode)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),

                    child: OutlinedButton.icon(
                      onPressed: _isCheckingLatestNews
                          ? null
                          : () {
                              _checkLatestNews();
                            },

                      icon: _isCheckingLatestNews
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: accentColor,
                              ),
                            )
                          : Icon(Icons.refresh, color: accentColor),

                      label: Text(
                        _isCheckingLatestNews
                            ? AppStrings.of(context).checkingLatestNews
                            : AppStrings.of(context).checkLatestNews,
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),

                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44),

                        side: BorderSide(color: dividerColor),

                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                  ),
                ),

              if (!_isSearchMode)
                const SliverToBoxAdapter(child: SizedBox(height: 14)),

              // ==================================================
              // NEWS REGION
              // ==================================================
              if (!_isSearchMode)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),

                    child: Row(
                      children: [
                        Text(
                          AppStrings.of(context).newsFrom,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            color: textColor,
                          ),
                        ),

                        const SizedBox(width: 10),

                        // INDIA
                        ChoiceChip(
                          label: Text(AppStrings.of(context).india),

                          selected: !_isInternational,

                          onSelected: (value) {
                            if (!value) {
                              return;
                            }

                            setState(() {
                              _isInternational = false;

                              selectedCategory = 0;
                            });

                            _fetchNews(checkForNewNews: false);
                          },

                          selectedColor: accentColor,

                          backgroundColor: cardBackgroundColor,

                          labelStyle: TextStyle(
                            color: !_isInternational
                                ? selectedChipTextColor
                                : textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,

                            side: BorderSide(color: dividerColor),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // INTERNATIONAL
                        ChoiceChip(
                          label: Text(AppStrings.of(context).international),

                          selected: _isInternational,

                          onSelected: (value) {
                            if (!value) {
                              return;
                            }

                            setState(() {
                              _isInternational = true;

                              selectedCategory = 0;
                            });

                            _fetchNews(checkForNewNews: false);
                          },

                          selectedColor: accentColor,

                          backgroundColor: cardBackgroundColor,

                          labelStyle: TextStyle(
                            color: _isInternational
                                ? selectedChipTextColor
                                : textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,

                            side: BorderSide(color: dividerColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              if (!_isSearchMode)
                const SliverToBoxAdapter(child: SizedBox(height: 14)),

              // ==================================================
              // CATEGORY CHIPS
              // ==================================================
              if (!_isSearchMode)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 42,

                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,

                      padding: const EdgeInsets.symmetric(horizontal: 16),

                      itemCount: categories.length,

                      itemBuilder: (context, index) {
                        final bool selected = selectedCategory == index;

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),

                          child: ChoiceChip(
                            label: Text(AppStrings.of(context).category(index)),

                            selected: selected,

                            onSelected: (value) {
                              if (!value) {
                                return;
                              }

                              setState(() {
                                selectedCategory = index;
                              });

                              final category = index == 0
                                  ? null
                                  : categories[index].toLowerCase();

                              _fetchNews(
                                category: category,

                                checkForNewNews: false,
                              );
                            },

                            selectedColor: accentColor,

                            backgroundColor: cardBackgroundColor,

                            labelStyle: TextStyle(
                              color: selected
                                  ? selectedChipTextColor
                                  : textColor,

                              fontWeight: FontWeight.bold,

                              fontSize: 12,
                            ),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,

                              side: BorderSide(color: dividerColor),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 22)),

              // ==================================================
              // TOP STORIES / SEARCH RESULTS
              // ==================================================
              SliverToBoxAdapter(
                child: sectionHeader(
                  context,

                  _isSearchMode ? AppStrings.of(context).searchResults : AppStrings.of(context).topStories,
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 18)),

              // ==================================================
              // SEARCH LOADING
              // ==================================================
              if (_isSearching)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(30),

                    child: Center(
                      child: CircularProgressIndicator(color: accentColor),
                    ),
                  ),
                ),

              // ==================================================
              // NEWS LIST
              // ==================================================
              if (!_isLoadingNews &&
                  !_isSearching &&
                  _newsError == null &&
                  _articles.isNotEmpty)
                SliverToBoxAdapter(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),

                    switchInCurve: Curves.easeIn,

                    switchOutCurve: Curves.easeOut,

                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },

                    child: Column(
                      key: ValueKey(_newsTransitionKey),

                      children: List.generate(
                        _articles.length,
                        (index) => newsCard(context, index),
                      ),
                    ),
                  ),
                ),

              // ==================================================
              // ERROR
              // ==================================================
              if (!_isLoadingNews && !_isSearching && _newsError != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),

                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 40,
                            color: accentColor,
                          ),

                          const SizedBox(height: 12),

                          Text(
                            _isSearchMode
                                ? AppStrings.of(context).unableToSearch
                                : AppStrings.of(context).unableToLoadNews,

                            textAlign: TextAlign.center,

                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            _newsError!,
                            textAlign: TextAlign.center,

                            style: TextStyle(color: accentColor, fontSize: 12),
                          ),

                          const SizedBox(height: 16),

                          TextButton(
                            onPressed: _isSearchMode ? _searchNews : _fetchNews,

                            child: Text(
                              AppStrings.of(context).tryAgain,
                              style: TextStyle(color: accentColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // ==================================================
              // NO NEWS
              // ==================================================
              if (!_isLoadingNews &&
                  !_isSearching &&
                  _newsError == null &&
                  _articles.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 50,
                    ),

                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.article_outlined,
                            size: 48,
                            color: accentColor,
                          ),

                          const SizedBox(height: 16),

                          Text(
                            _isSearchMode
                                ? AppStrings.of(context).noSearchResults
                                : AppStrings.of(context).noNews,

                            textAlign: TextAlign.center,

                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          if (_isSearchMode) ...[
                            const SizedBox(height: 8),

                            Text(
                              AppStrings.of(context).tryAnotherTopic,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

              // ==================================================
              // FOOTER
              // ==================================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(25),

                  child: Column(
                    children: [
                      Divider(color: dividerColor, thickness: 2),

                      const SizedBox(height: 8),

                      Text(
                        AppStrings.of(context).brandName.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        AppStrings.of(context).readDiscoverUnderstand,
                        style: TextStyle(
                          fontSize: 9,
                          letterSpacing: 2,
                          color: accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // ========================================================
        // BOTTOM NAVIGATION
        // ========================================================
        bottomNavigationBar: NavigationBar(
          backgroundColor: cardBackgroundColor,

          indicatorColor: fadedBackgroundColor,

          selectedIndex: bottomIndex,

          onDestinationSelected: (index) {
            setState(() {
              bottomIndex = index;
            });

            // SAVED

            if (index == 1) {
              Navigator.push(
                context,

                MaterialPageRoute(builder: (context) => const SavedPage()),
              );
            }

            // SETTINGS

            if (index == 2) {
              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    settingsController: widget.settingsController,
                  ),
                ),
              );
            }

            // PROFILE

            if (index == 3) {
              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    news: news,

                    settingsController: widget.settingsController,
                  ),
                ),
              );
            }
          },

          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: accentColor),

              selectedIcon: Icon(Icons.home, color: textColor),

              label: AppStrings.of(context).home,
            ),

            NavigationDestination(
              icon: Icon(Icons.bookmark_outline, color: accentColor),

              selectedIcon: Icon(Icons.bookmark, color: textColor),

              label: AppStrings.of(context).saved,
            ),

            NavigationDestination(
              icon: Icon(Icons.settings_outlined, color: accentColor),

              selectedIcon: Icon(Icons.settings, color: textColor),

              label: AppStrings.of(context).settings,
            ),

            NavigationDestination(
              icon: Icon(Icons.person_outline, color: accentColor),

              selectedIcon: Icon(Icons.person, color: textColor),

              label: AppStrings.of(context).profile,
            ),
          ],
        ),
      ),
    );
  }
}