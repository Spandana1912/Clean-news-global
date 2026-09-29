import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'models/article.dart';
import 'services/news_api_service.dart';
import 'profile_page.dart';
import 'saved_page.dart';
import 'settings_page.dart';
import 'theme.dart';


class ArticleWebViewPage extends StatefulWidget {
  final String articleUrl;

  const ArticleWebViewPage({
    super.key,
    required this.articleUrl,
  });

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
    return WillPopScope(
      onWillPop: _handleBack,
      child: Scaffold(
        backgroundColor: paperColor,
        appBar: AppBar(
          backgroundColor: paperColor,
          foregroundColor: inkColor,
          elevation: 0,
          title: const Text(
            'ARTICLE',
            style: TextStyle(
              color: inkColor,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          bottom: _loadingProgress < 100
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(2),
                  child: LinearProgressIndicator(
                    value: _loadingProgress / 100,
                    backgroundColor: fadedColor,
                    color: brownColor,
                  ),
                )
              : null,
        ),
        body: SafeArea(
          child: WebViewWidget(
            controller: _controller,
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // ==========================================================
  // NEWS API
  // ==========================================================

  final NewsApiService _newsApiService = NewsApiService();

  List<Article> _articles = [];
  bool _isLoadingNews = true;
  String? _newsError;

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

  // News region: India is the default.
  bool _isInternational = false;

  int bottomIndex = 0;

  // ==========================================================
  // BOOKMARK STATES
  // ==========================================================

  List<bool> bookmarked = [];

  // ==========================================================
  // FETCH NEWS
  // ==========================================================

  Future<void> _fetchNews({String? category}) async {
    if (mounted) {
      setState(() {
        _isLoadingNews = true;
        _newsError = null;
      });
    }

    try {
      final List<Article> articles;

      if (_isInternational) {
        // International mode uses NewsAPI's global search endpoint.
        articles = await _newsApiService.getInternationalNews(
          category: category,
        );
      } else {
        // India is the default news region.
        articles = await _newsApiService.getIndiaNews(
          category: category,
        );
      }

      if (!mounted) return;

      setState(() {
        _articles = articles;

        // The article list changes when the category changes, so reset
        // bookmark states to avoid attaching an old bookmark to a
        // different article.
        bookmarked = List<bool>.filled(articles.length, false);

        _isLoadingNews = false;
        _newsError = null;
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
  }

  // ==========================================================
  // SAVED PAGE COMPATIBILITY
  // ==========================================================

  // SavedPage currently expects the older Map-based news format.
  // This converts the live Article objects without changing SavedPage.
  List<Map<String, String>> get news {
    return _articles.map((article) {
      return {
        "title": article.title,
        "description": article.description,
        "source": article.source,
        "time": article.publishedAt,
      };
    }).toList();
  }

  // ==========================================================
  // YOUR EXISTING CODE CONTINUES BELOW
  // ==========================================================

  // ==========================================================
  // TOGGLE BOOKMARK
  // ==========================================================

  void toggleBookmark(int index) {
    if (index < 0 || index >= bookmarked.length) return;

    setState(() {
      bookmarked[index] = !bookmarked[index];
    });

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(

        duration:
            const Duration(seconds: 1),

        backgroundColor:
            brownColor,

        content: Text(

          bookmarked[index]
              ? "Article saved to your archive."
              : "Article removed from your archive.",

          style: const TextStyle(
            color: paperColor,
          ),
        ),

        behavior:
            SnackBarBehavior.floating,

        shape:
            const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.zero,
        ),
      ),
    );
  }

  // ==========================================================
  // SHARE
  // ==========================================================

  void shareNews() {

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(

        backgroundColor:
            brownColor,

        content: Text(
          "Article ready to share.",
          style: TextStyle(
            color: paperColor,
          ),
        ),

        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }

  // ==========================================================
  // READ MORE
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

    // On Android/iOS/macOS, keep the reader inside Clean News Global.
    // On Flutter Web, use the browser because webview_flutter does not
    // provide the same embedded WebView experience on web.
    if (!kIsWeb) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ArticleWebViewPage(
            articleUrl: url,
          ),
        ),
      );
      return;
    }

    // Chrome/web fallback.
    final opened = await launchUrl(
      uri,
      mode: LaunchMode.platformDefault,
    );

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open the article.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }


  void showArticle(
      BuildContext context,
      int index) {

    final article = _articles[index];

    showDialog(

      context: context,

      builder: (context) {

        return AlertDialog(

          backgroundColor:
              paperColor,

          shape:
              const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.zero,

            side: BorderSide(
              color: borderColor,
            ),
          ),

          title: Text(

            article.title,

            style: const TextStyle(
              color: inkColor,
              fontWeight:
                  FontWeight.w900,
            ),
          ),

          content: SingleChildScrollView(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Container(
                  height: 2,
                  color: inkColor,
                ),

                const SizedBox(height: 15),

                Text(
                  article.description,

                  style: const TextStyle(
                    color: brownColor,
                    height: 1.6,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  "${article.source}  •  ${article.publishedAt}",

                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    color: inkColor,
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

              child: const Text(
                "CLOSE",
                style: TextStyle(
                  color: brownColor,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // NEWS CARD
  // ==========================================================

  Widget newsCard(
      BuildContext context,
      int index) {

    final item =
        _articles[index];

    return Container(

      margin:
          const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 20,
      ),

      decoration:
          BoxDecoration(

        color:
            cardColor,

        border:
            Border.all(
          color:
              borderColor,
          width: 1,
        ),

        boxShadow: const [

          BoxShadow(
            color:
                Color(0x221F1712),
            blurRadius:
                6,
            offset:
                Offset(3, 4),
          ),
        ],
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          // ==================================================
          // IMAGE
          // ==================================================

          Stack(

            children: [

              ClipRRect(

                child:
                    Image.network(

                  item.imageUrl,

                  height:
                      190,

                  width:
                      double.infinity,

                  fit:
                      BoxFit.cover,

                  errorBuilder:
                      (context,
                          error,
                          stackTrace) {

                    return Container(

                      height:
                          190,

                      width:
                          double.infinity,

                      color:
                          fadedColor,

                      child:
                          const Center(

                        child:
                            Icon(
                          Icons
                              .image_not_supported,
                          size:
                              50,
                          color:
                              brownColor,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ==================================================
              // CATEGORY BADGE
              // ==================================================

              Positioned(

                top: 12,
                left: 12,

                child:
                    Container(

                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),

                  color:
                      inkColor,

                  child:
                      Text(

                    categories[
                        selectedCategory],

                    style:
                        const TextStyle(

                      color:
                          paperColor,

                      fontWeight:
                          FontWeight.bold,

                      fontSize:
                          11,

                      letterSpacing:
                          1,
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

                child:
                    Container(

                  decoration:
                      BoxDecoration(

                    color:
                        paperColor,

                    border:
                        Border.all(
                      color:
                          brownColor,
                    ),
                  ),

                  child:
                      IconButton(

                    icon:
                        Icon(

                      bookmarked[index]
                          ? Icons.bookmark
                          : Icons.bookmark_border,

                      color:
                          brownColor,
                    ),

                    onPressed: () {

                      toggleBookmark(
                          index);
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

            padding:
                const EdgeInsets.all(17),

            child:
                Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                // HEADLINE

                Text(

                  item.title,

                  maxLines:
                      3,

                  overflow:
                      TextOverflow.ellipsis,

                  style:
                      const TextStyle(

                    fontSize:
                        22,

                    fontWeight:
                        FontWeight.w900,

                    color:
                        inkColor,

                    height:
                        1.15,
                  ),
                ),

                const SizedBox(
                    height: 8),

                // DIVIDER

                Container(
                  height: 1,
                  color: borderColor,
                ),

                const SizedBox(
                    height: 10),

                // DESCRIPTION

                Text(

                  item.description,

                  maxLines:
                      3,

                  overflow:
                      TextOverflow.ellipsis,

                  style:
                      const TextStyle(

                    fontSize:
                        14,

                    color:
                        brownColor,

                    height:
                        1.5,
                  ),
                ),

                const SizedBox(
                    height: 15),

                // SOURCE + TIME

                Row(

                  children: [

                    const Icon(
                      Icons.public,
                      size: 18,
                      color: brownColor,
                    ),

                    const SizedBox(
                        width: 7),

                    Text(

                      item.source,

                      style:
                          const TextStyle(

                        fontWeight:
                            FontWeight.bold,

                        fontSize:
                            13,

                        color:
                            inkColor,
                      ),
                    ),

                    const Spacer(),

                    Text(

                      item.publishedAt,

                      style:
                          const TextStyle(

                        color:
                            brownColor,

                        fontSize:
                            11,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                    height: 12),

                // BOTTOM DIVIDER

                Container(
                  height: 1,
                  color: borderColor,
                ),

                const SizedBox(
                    height: 8),

                // ACTIONS

                Row(

                  children: [

                    TextButton.icon(

                      onPressed: () {

                        _openArticle(
                          item.articleUrl,
                        );
                      },

                      icon:
                          const Icon(
                        Icons
                            .menu_book_outlined,
                        size: 18,
                      ),

                      label:
                          const Text(
                        "READ ARTICLE",
                      ),

                      style:
                          TextButton.styleFrom(

                        foregroundColor:
                            brownColor,
                      ),
                    ),

                    const Spacer(),

                    IconButton(

                      onPressed:
                          shareNews,

                      icon:
                          const Icon(
                        Icons.share_outlined,
                        color:
                            brownColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SECTION HEADER
  // ==========================================================

  Widget sectionHeader(
      String title) {

    return Padding(

      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
      ),

      child:
          Column(

        children: [

          Text(

            title,

            style:
                const TextStyle(

              fontSize:
                  22,

              fontWeight:
                  FontWeight.w900,

              letterSpacing:
                  2,

              color:
                  inkColor,
            ),
          ),

          const SizedBox(
              height: 5),

          Container(
            height: 2,
            color: inkColor,
          ),

          const SizedBox(
              height: 3),

          Container(
            height: 1,
            color: borderColor,
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      backgroundColor:
          paperColor,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(

        backgroundColor:
            paperColor,

        title:

            const Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Text(

              "THE CLEAN NEWS",

              style:
                  TextStyle(

                fontSize:
                    25,

                fontWeight:
                    FontWeight.w900,

                letterSpacing:
                    1,

                color:
                    inkColor,
              ),
            ),

            Text(

              "GLOBAL EDITION  •  DAILY NEWS",

              style:
                  TextStyle(

                fontSize:
                    9,

                letterSpacing:
                    1.5,

                color:
                    brownColor,
              ),
            ),
          ],
        ),

        actions: [

          IconButton(

            onPressed: () {

              ScaffoldMessenger.of(context)
                  .showSnackBar(

                const SnackBar(

                  backgroundColor:
                      brownColor,

                  content:
                      Text(
                    "No new notifications.",
                    style:
                        TextStyle(
                      color:
                          paperColor,
                    ),
                  ),
                ),
              );
            },

            icon:
                const Icon(
              Icons.notifications_none,
              color:
                  inkColor,
            ),
          ),

          const SizedBox(
              width: 8),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================

      body:

          RefreshIndicator(

        color:
            brownColor,

        backgroundColor:
            paperColor,

        onRefresh: () async {
          await _fetchNews();

          if (!mounted) return;

          ScaffoldMessenger.of(context)
              .showSnackBar(

            const SnackBar(

              backgroundColor:
                  brownColor,

              content:
                  Text(
                "Today's edition has been refreshed.",
                style:
                    TextStyle(
                  color:
                      paperColor,
                ),
              ),
            ),
          );
        },

        child:
            CustomScrollView(

          slivers: [

            // ==================================================
            // DATE HEADER
            // ==================================================

            SliverToBoxAdapter(

              child:
                  Padding(

                padding:
                    const EdgeInsets.fromLTRB(
                  16,
                  5,
                  16,
                  12,
                ),

                child:
                    Row(

                  children: [

                    const Text(
                      "WEDNESDAY",
                      style:
                          TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize:
                            11,
                        letterSpacing:
                            1.5,
                        color:
                            brownColor,
                      ),
                    ),

                    const Spacer(),

                    const Text(
                      "23 SEPTEMBER 2026",
                      style:
                          TextStyle(
                        fontSize:
                            11,
                        color:
                            brownColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ==================================================
            // MAIN LINE
            // ==================================================

            SliverToBoxAdapter(

              child:
                  Padding(

                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                ),

                child:
                    Container(
                  height:
                      2,
                  color:
                      inkColor,
                ),
              ),
            ),

            // ==================================================
            // SEARCH
            // ==================================================

            SliverToBoxAdapter(

              child:
                  Padding(

                padding:
                    const EdgeInsets.all(
                  16,
                ),

                child:
                    TextField(

                  decoration:
                      InputDecoration(

                    hintText:
                        "Search the day's news...",

                    prefixIcon:
                        const Icon(
                      Icons.search,
                      color:
                          brownColor,
                    ),

                    suffixIcon:
                        IconButton(

                      icon:
                          const Icon(
                        Icons.tune,
                        color:
                            brownColor,
                      ),

                      onPressed: () {

                        ScaffoldMessenger
                            .of(context)
                            .showSnackBar(

                          const SnackBar(
                            content:
                                Text(
                              "Filter options coming soon.",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // ==================================================
            // TRENDING
            // ==================================================

            SliverToBoxAdapter(

              child:
                  Padding(

                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                ),

                child:
                    Row(

                  children: [

                    const Icon(
                      Icons.trending_up,
                      color:
                          brownColor,
                    ),

                    const SizedBox(
                        width: 7),

                    const Text(
                      "TRENDING TODAY",
                      style:
                          TextStyle(
                        fontSize:
                            14,
                        fontWeight:
                            FontWeight.w900,
                        letterSpacing:
                            1.5,
                        color:
                            inkColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child:
                  SizedBox(height: 12),
            ),

            // ==================================================
            // NEWS REGION
            // ==================================================

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text(
                      'NEWS FROM',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: inkColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text('INDIA'),
                      selected: !_isInternational,
                      onSelected: (value) {
                        if (!value) return;

                        setState(() {
                          _isInternational = false;
                          selectedCategory = 0;
                        });

                        _fetchNews();
                      },
                      selectedColor: brownColor,
                      backgroundColor: cardColor,
                      labelStyle: TextStyle(
                        color: !_isInternational ? paperColor : inkColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        side: BorderSide(color: borderColor),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('INTERNATIONAL'),
                      selected: _isInternational,
                      onSelected: (value) {
                        if (!value) return;

                        setState(() {
                          _isInternational = true;
                          selectedCategory = 0;
                        });

                        _fetchNews();
                      },
                      selectedColor: brownColor,
                      backgroundColor: cardColor,
                      labelStyle: TextStyle(
                        color: _isInternational ? paperColor : inkColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        side: BorderSide(color: borderColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 14),
            ),

            // ==================================================
            // CATEGORY CHIPS
            // ==================================================

            SliverToBoxAdapter(

              child:
                  SizedBox(

                height:
                    42,

                child:
                    ListView.builder(

                  scrollDirection:
                      Axis.horizontal,

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),

                  itemCount:
                      categories.length,

                  itemBuilder:
                      (context, index) {

                    bool selected =
                        selectedCategory ==
                            index;

                    return Padding(

                      padding:
                          const EdgeInsets.only(
                        right: 8,
                      ),

                      child:
                          ChoiceChip(

                        label:
                            Text(
                          categories[index],
                        ),

                        selected:
                            selected,

                        onSelected:
                            (value) {

                          if (!value) return;

                          setState(() {
                            selectedCategory = index;
                          });

                          final category =
                              index == 0
                                  ? null
                                  : categories[index].toLowerCase();

                          _fetchNews(category: category);
                        },

                        selectedColor:
                            brownColor,

                        backgroundColor:
                            cardColor,

                        labelStyle:
                            TextStyle(

                          color:

                              selected
                                  ? paperColor
                                  : inkColor,

                          fontWeight:
                              FontWeight.bold,

                          fontSize:
                              12,
                        ),

                        shape:
                            const RoundedRectangleBorder(

                          borderRadius:
                              BorderRadius.zero,

                          side:
                              BorderSide(
                            color:
                                borderColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child:
                  SizedBox(height: 22),
            ),

            // ==================================================
            // TOP STORIES
            // ==================================================

            SliverToBoxAdapter(

              child:
                  sectionHeader(
                "TOP STORIES",
              ),
            ),

            const SliverToBoxAdapter(
              child:
                  SizedBox(height: 18),
            ),

            // ==================================================
            // NEWS LIST
            // ==================================================

            if (_isLoadingNews)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),

            if (!_isLoadingNews && _newsError != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 40,
                          color: brownColor,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Unable to load today's news.",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: inkColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _newsError!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: brownColor,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: _fetchNews,
                          child: const Text("TRY AGAIN"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            if (!_isLoadingNews &&
                _newsError == null &&
                _articles.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      "No news articles available right now.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

            if (!_isLoadingNews &&
                _newsError == null &&
                _articles.isNotEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return newsCard(
                      context,
                      index,
                    );
                  },
                  childCount: _articles.length,
                ),
              ),

            // ==================================================
            // FOOTER
            // ==================================================

            const SliverToBoxAdapter(

              child:
                  Padding(

                padding:
                    EdgeInsets.all(25),

                child:
                    Column(

                  children: [

                    Divider(
                      color:
                          borderColor,
                      thickness:
                          2,
                    ),

                    SizedBox(
                        height: 8),

                    Text(
                      "THE CLEAN NEWS GLOBAL",

                      style:
                          TextStyle(

                        fontWeight:
                            FontWeight.w900,

                        letterSpacing:
                            2,

                        color:
                            inkColor,
                      ),
                    ),

                    SizedBox(
                        height: 5),

                    Text(
                      "READ • DISCOVER • UNDERSTAND",

                      style:
                          TextStyle(

                        fontSize:
                            9,

                        letterSpacing:
                            2,

                        color:
                            brownColor,
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

      bottomNavigationBar:

          NavigationBar(

        backgroundColor:
            cardColor,

        indicatorColor:
            fadedColor,

        selectedIndex:
            bottomIndex,

        onDestinationSelected:
            (index) {

          setState(() {

            bottomIndex =
                index;

          });

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

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsPage(),
              ),
            );
          }

          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ),
            );
          }
        },

        destinations: const [

          NavigationDestination(

            icon:
                Icon(
              Icons.home_outlined,
              color:
                  brownColor,
            ),

            selectedIcon:
                Icon(
              Icons.home,
              color:
                  inkColor,
            ),

            label:
                "Home",
          ),

          NavigationDestination(

            icon:
                Icon(
              Icons.bookmark_outline,
              color:
                  brownColor,
            ),

            selectedIcon:
                Icon(
              Icons.bookmark,
              color:
                  inkColor,
            ),

            label:
                "Saved",
          ),

          NavigationDestination(

            icon:
                Icon(
              Icons.settings_outlined,
              color:
                  brownColor,
            ),

            selectedIcon:
                Icon(
              Icons.settings,
              color:
                  inkColor,
            ),

            label:
                "Settings",
          ),

          NavigationDestination(

            icon:
                Icon(
              Icons.person_outline,
              color:
                  brownColor,
            ),

            selectedIcon:
                Icon(
              Icons.person,
              color:
                  inkColor,
            ),

            label:
                "Profile",
          ),
        ],
      ),
    );
  }
}
