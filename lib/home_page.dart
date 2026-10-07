import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/article.dart';
import 'services/news_api_service.dart';
import 'services/firestore_service.dart';
import 'profile_page.dart';
import 'saved_page.dart';
import 'settings_page.dart';
import 'settings_controller.dart';
import 'theme.dart';
import 'notifications_page.dart';

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
              const SnackBar(
                content: Text('Unable to load this article.'),
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
            'ARTICLE',
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

class _HomePageState extends State<HomePage> {
  // ==========================================================
  // NEWS API
  // ==========================================================

  final NewsApiService _newsApiService = NewsApiService();

  List<Article> _articles = [];

  bool _isLoadingNews = true;

  String? _newsError;

  bool hasNotification = false;

  String _username = '';

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
  // BOOKMARK STATES
  // ==========================================================

  List<bool> bookmarked = [];

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
  // FETCH NEWS
  // ==========================================================

  Future<void> _fetchNews({String? category}) async {
    if (mounted) {
      setState(() {
        _newsError = null;
      });
    }

    try {
      final List<Article> articles;

      if (_isInternational) {
        articles = await _newsApiService.getInternationalNews(
          category: category,
        );
      } else {
        articles = await _newsApiService.getIndiaNews(category: category);
      }

      if (!mounted) return;

      setState(() {
        _articles = articles;

        bookmarked = List<bool>.filled(articles.length, false);

        hasNotification =
            widget.settingsController.notificationsEnabled &&
            articles.isNotEmpty;

        _isLoadingNews = false;
        _newsError = null;

        // Change the key AFTER the new articles arrive.
        _newsTransitionKey++;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingNews = false;
        _newsError = e.toString();
      });
    }
  }

  // ==========================================================
  // INITIALIZE HOME PAGE
  // ==========================================================

  @override
  void initState() {
    super.initState();

    _fetchNews();
    _loadUsername();
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

  void toggleBookmark(int index) {
    if (index < 0 || index >= bookmarked.length) {
      return;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final accentColor = isDark ? darkBrownColor : brownColor;

    final snackbarTextColor = isDark ? darkInkColor : paperColor;

    setState(() {
      bookmarked[index] = !bookmarked[index];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor: accentColor,
        content: Text(
          bookmarked[index]
              ? "Article saved to your archive."
              : "Article removed from your archive.",
          style: TextStyle(color: snackbarTextColor),
        ),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
    );
  }

  // ==========================================================
  // SHARE
  // ==========================================================

  void shareNews(String url) {
    if (url.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Article link is not available."),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    //final backgroundColor = isDark ? darkPaperColor : paperColor;

    final cardBackgroundColor = isDark ? darkCardColor : cardColor;

    final textColor = isDark ? darkInkColor : inkColor;

    final accentColor = isDark ? darkBrownColor : brownColor;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: cardBackgroundColor,
          title: Text(
            "Share Article",
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
              child: Text("Close", style: TextStyle(color: accentColor)),
            ),
            ElevatedButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: url));

                Navigator.pop(context);

                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(
                    content: Text("Link copied!"),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: isDark ? darkPaperColor : paperColor,
              ),
              child: const Text("Copy Link"),
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
        const SnackBar(
          content: Text('Article link is not available.'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    final uri = Uri.tryParse(url);

    if (uri == null || !uri.hasScheme) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid article link.'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    // Android / iOS / macOS:
    // open inside Clean News Global.
    if (!kIsWeb) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ArticleWebViewPage(articleUrl: url)),
      );

      return;
    }

    // Flutter Web:
    // use browser.
    final opened = await launchUrl(uri, mode: LaunchMode.platformDefault);

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open the article.'),
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
                "CLOSE",
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

  String _getFallbackImage() {
    switch (categories[selectedCategory].toLowerCase()) {
      case 'business':
        return 'https://images.unsplash.com/39/lIZrwvbeRuuzqOoWJUEn_Photoaday_CSD%20(1%20of%201)-5.jpg?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA==';
      case 'sports':
        return 'https://images.pexels.com/photos/9376460/pexels-photo-9376460.jpeg?h=1000&w=1500&fit=crop';
      case 'technology':
        return 'https://images.unsplash.com/photo-1644088379091-d574269d422f?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8dGVjaG5vbG9neXxlbnwwfHwwfHx8MA==';
      case 'health':
        return 'https://images.unsplash.com/photo-1526256262350-7da7584cf5eb?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bWVkaWNhbCUyMGFzc2lzdGFuY2V8ZW58MHx8MHx8fDA=';
      case 'science':
        return 'https://images.unsplash.com/photo-1628595351029-c2bf17511435?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8c2NpZW5jZXxlbnwwfHwwfHx8MA==';
      case 'entertainment':
        return 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA==';
      case 'all':
      default:
        return 'https://images.unsplash.com/photo-1521295121783-8a321d551ad2?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Z2xvYmV8ZW58MHx8MHx8fDA=';
    }
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

    // Text placed on the dark/light category badge.
    final badgeTextColor = isDark ? darkPaperColor : paperColor;

    // Text placed on selected bookmark background.
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
                      categories[selectedCategory],
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
                        bookmarked[index]
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

                  // DIVIDER
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

                  // BOTTOM DIVIDER
                  Container(height: 1, color: dividerColor),

                  const SizedBox(height: 8),

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
                          "READ ARTICLE",
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

    // Text used on selected chips.
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
                "TODAY'S TEA ☕️",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  color: textColor,
                ),
              ),

              Text(
                "GLOBAL EDITION  •  DAILY NEWS",
                style: TextStyle(
                  fontSize: 9,
                  letterSpacing: 1.5,
                  color: accentColor,
                ),
              ),
            ],
          ),

          actions: [
            if (_username.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Center(
                  child: Text(
                    "Hi, $_username 👋",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ),
              ),

            Stack(
              children: [
                IconButton(
                  onPressed: () async {
                    setState(() {
                      hasNotification = false;
                    });

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NotificationsPage(trendingNews: news),
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
            await _fetchNews();

            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: accentColor,
                content: Text(
                  "Today's edition has been refreshed.",
                  style: TextStyle(color: selectedChipTextColor),
                ),
              ),
            );
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
                        DateFormat('EEEE').format(DateTime.now()).toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 1.5,
                          color: accentColor,
                        ),
                      ),

                      const Spacer(),

                      Text(
                        DateFormat('dd MMMM yyyy')
                            .format(DateTime.now())
                            .toUpperCase(),
                        style: TextStyle(fontSize: 11, color: accentColor),
                      ),
                    ],
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

                      Text(
                        "TRENDING TODAY",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // ==================================================
              // NEWS REGION
              // ==================================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        'NEWS FROM',
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
                        label: const Text('INDIA'),
                        selected: !_isInternational,

                        onSelected: (value) {
                          if (!value) {
                            return;
                          }

                          setState(() {
                            _isInternational = false;
                            selectedCategory = 0;
                          });

                          _fetchNews();
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
                        label: const Text('INTERNATIONAL'),
                        selected: _isInternational,

                        onSelected: (value) {
                          if (!value) {
                            return;
                          }

                          setState(() {
                            _isInternational = true;
                            selectedCategory = 0;
                          });

                          _fetchNews();
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

              const SliverToBoxAdapter(child: SizedBox(height: 14)),

              // ==================================================
              // CATEGORY CHIPS
              // ==================================================
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
                          label: Text(categories[index]),

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

                            _fetchNews(category: category);
                          },

                          selectedColor: accentColor,

                          backgroundColor: cardBackgroundColor,

                          labelStyle: TextStyle(
                            color: selected ? selectedChipTextColor : textColor,
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
              // TOP STORIES
              // ==================================================
              SliverToBoxAdapter(child: sectionHeader(context, "TOP STORIES")),

              const SliverToBoxAdapter(child: SizedBox(height: 18)),

              // ==================================================
              // NEWS LIST
              // ==================================================
              if (!_isLoadingNews && _newsError == null && _articles.isNotEmpty)
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
              if (!_isLoadingNews && _newsError != null)
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
                            "Unable to load today's news.",
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
                            onPressed: _fetchNews,
                            child: Text(
                              "TRY AGAIN",
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
              if (!_isLoadingNews && _newsError == null && _articles.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        "No news articles available right now.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: textColor),
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
                        "THE CLEAN NEWS GLOBAL",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        "READ • DISCOVER • UNDERSTAND",
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
                MaterialPageRoute(
                  builder: (context) => SavedPage(
                    news: news,
                    bookmarked: bookmarked,
                    onBookmarkChanged: (articleIndex) {
                      toggleBookmark(articleIndex);
                    },
                  ),
                ),
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
                    bookmarked: bookmarked,
                    onBookmarkChanged: toggleBookmark,
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
              label: "Home",
            ),

            NavigationDestination(
              icon: Icon(Icons.bookmark_outline, color: accentColor),
              selectedIcon: Icon(Icons.bookmark, color: textColor),
              label: "Saved",
            ),

            NavigationDestination(
              icon: Icon(Icons.settings_outlined, color: accentColor),
              selectedIcon: Icon(Icons.settings, color: textColor),
              label: "Settings",
            ),

            NavigationDestination(
              icon: Icon(Icons.person_outline, color: accentColor),
              selectedIcon: Icon(Icons.person, color: textColor),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
