import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const NewsApp());
}

// ============================================================
// VINTAGE COLOR PALETTE
// ============================================================

const Color paperColor = Color(0xFFF1E7D0);
const Color cardColor = Color(0xFFE8DCC3);
const Color inkColor = Color(0xFF211A16);
const Color brownColor = Color(0xFF5C4033);
const Color borderColor = Color(0xFF8B7355);
const Color fadedColor = Color(0xFFD2C09F);

// ============================================================
// APP
// ============================================================

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "The Clean News",

      theme: ThemeData(
        useMaterial3: true,

        scaffoldBackgroundColor: paperColor,

        colorScheme: ColorScheme.fromSeed(
          seedColor: brownColor,
          brightness: Brightness.light,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: paperColor,
          foregroundColor: inkColor,
          elevation: 0,
          centerTitle: false,
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cardColor,

          labelStyle: const TextStyle(
            color: brownColor,
          ),

          hintStyle: const TextStyle(
            color: Color(0xFF806D59),
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.zero,

            borderSide: BorderSide(
              color: borderColor,
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,

            borderSide: BorderSide(
              color: borderColor,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,

            borderSide: BorderSide(
              color: brownColor,
              width: 2,
            ),
          ),
        ),
      ),

      home: const LoginPage(),
    );
  }
}

// ============================================================
// VINTAGE NEWSPAPER LOGIN PAGE
// ============================================================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController usernameController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool hidePassword = true;

  // ==========================================================
  // LOGIN
  // ==========================================================

  void login() {

    if (usernameController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF30251E),

          content: Text(
            "Please enter your username and password.",
            style: GoogleFonts.libreBaskerville(
              color: const Color(0xFFF3E8D0),
              fontSize: 12,
            ),
          ),

          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ==========================================================
  // LOGIN PAGE
  // ==========================================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFFE8D9BA),

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(

            padding:
                const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 18,
            ),

            child: Column(

              children: [

                // ==================================================
                // NEWSPAPER HEADER
                // ==================================================

                Container(

                  width: double.infinity,

                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 8,
                  ),

                  child: Column(

                    children: [

                      // TOP METADATA

                      Row(

                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,

                        children: [

                          Text(
                            "THE DAILY EDITION",

                            style:
                                GoogleFonts.cinzel(
                              fontSize: 8,
                              fontWeight:
                                  FontWeight.bold,
                              letterSpacing: 1.5,
                              color:
                                  const Color(0xFF3A2E26),
                            ),
                          ),

                          Text(
                            "VOL. I • NO. 01",

                            style:
                                GoogleFonts.cinzel(
                              fontSize: 8,
                              fontWeight:
                                  FontWeight.bold,
                              letterSpacing: 1,
                              color:
                                  const Color(0xFF3A2E26),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 7),

                      // TOP LINE

                      Container(
                        height: 1.5,
                        color:
                            const Color(0xFF30251E),
                      ),

                      const SizedBox(height: 8),

                      // ==================================================
                      // MAIN NEWSPAPER MASTHEAD
                      // ==================================================

                      Text(

                        "CLEAN NEWS",

                        textAlign:
                            TextAlign.center,

                        style:
                            GoogleFonts.bodoniModa(
                          fontSize: 43,
                          fontWeight:
                              FontWeight.w900,
                          letterSpacing: 1,
                          height: 0.95,
                          color:
                              const Color(0xFF2C231D),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(

                        "GLOBAL",

                        style:
                            GoogleFonts.cinzel(
                          fontSize: 14,
                          fontWeight:
                              FontWeight.bold,
                          letterSpacing: 8,
                          color:
                              const Color(0xFF59463A),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ==================================================
                      // DOUBLE RULE
                      // ==================================================

                      Container(
                        height: 4,

                        decoration:
                            const BoxDecoration(

                          border: Border.symmetric(
                            horizontal:
                                BorderSide(
                              color:
                                  Color(0xFF30251E),
                              width: 1,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      // ==================================================
                      // NEWSPAPER INFO
                      // ==================================================

                      Row(

                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,

                        children: [

                          Text(
                            "EST. 2026",

                            style:
                                GoogleFonts.cinzel(
                              fontSize: 8,
                              fontWeight:
                                  FontWeight.bold,
                              letterSpacing: 1,
                              color:
                                  const Color(0xFF59463A),
                            ),
                          ),

                          Text(
                            "NEWS • CULTURE • WORLD",

                            style:
                                GoogleFonts.cinzel(
                              fontSize: 7,
                              fontWeight:
                                  FontWeight.bold,
                              letterSpacing: 1,
                              color:
                                  const Color(0xFF59463A),
                            ),
                          ),

                          Text(
                            "DAILY",

                            style:
                                GoogleFonts.cinzel(
                              fontSize: 8,
                              fontWeight:
                                  FontWeight.bold,
                              letterSpacing: 1,
                              color:
                                  const Color(0xFF59463A),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 7),

                      Container(
                        height: 1,
                        color:
                            const Color(0xFF30251E),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // EDITORIAL TAGLINE
                // ==================================================

                Row(

                  children: [

                    Expanded(
                      child: Container(
                        height: 1,
                        color:
                            const Color(0xFF806B57),
                      ),
                    ),

                    Padding(

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),

                      child: Text(

                        "WELCOME, READER",

                        style:
                            GoogleFonts.cinzel(
                          fontSize: 10,
                          fontWeight:
                              FontWeight.bold,
                          letterSpacing: 1.5,
                          color:
                              const Color(0xFF3A2E26),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        height: 1,
                        color:
                            const Color(0xFF806B57),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(

                  "Your daily window to the world.",

                  textAlign:
                      TextAlign.center,

                  style:
                      GoogleFonts.libreBaskerville(
                    fontSize: 12,
                    fontStyle:
                        FontStyle.italic,
                    color:
                        const Color(0xFF665548),
                  ),
                ),

                const SizedBox(height: 22),

                // ==================================================
                // LOGIN PAPER
                // ==================================================

                Container(

                  width: double.infinity,

                  padding:
                      const EdgeInsets.all(20),

                  decoration:
                      BoxDecoration(

                    color:
                        const Color(0xFFEFE2C7),

                    border:
                        Border.all(
                      color:
                          const Color(0xFF806B57),
                      width: 1,
                    ),

                    boxShadow: const [

                      BoxShadow(
                        color:
                            Color(0x301F1712),
                        blurRadius:
                            5,
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
                      // SECTION TITLE
                      // ==================================================

                      Text(

                        "TODAY'S READER",

                        style:
                            GoogleFonts.bodoniModa(
                          fontSize: 24,
                          fontWeight:
                              FontWeight.w900,
                          color:
                              const Color(0xFF2C231D),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Container(
                        height: 2,
                        color:
                            const Color(0xFF30251E),
                      ),

                      const SizedBox(height: 3),

                      Container(
                        height: 1,
                        color:
                            const Color(0xFF806B57),
                      ),

                      const SizedBox(height: 20),

                      // ==================================================
                      // USERNAME LABEL
                      // ==================================================

                      Text(

                        "USERNAME",

                        style:
                            GoogleFonts.cinzel(
                          fontSize: 9,
                          fontWeight:
                              FontWeight.bold,
                          letterSpacing: 1.2,
                          color:
                              const Color(0xFF59463A),
                        ),
                      ),

                      const SizedBox(height: 7),

                      // ==================================================
                      // USERNAME FIELD
                      // ==================================================

                      TextField(

                        controller:
                            usernameController,

                        style:
                            GoogleFonts.libreBaskerville(
                          fontSize: 13,
                          color:
                              const Color(0xFF2C231D),
                        ),

                        decoration:
                            InputDecoration(

                          hintText:
                              "Enter your username",

                          hintStyle:
                              GoogleFonts.libreBaskerville(
                            fontSize: 12,
                            color:
                                const Color(0xFF806B57),
                          ),

                          prefixIcon:
                              const Icon(
                            Icons.person_outline,
                            color:
                                Color(0xFF59463A),
                            size: 20,
                          ),

                          filled:
                              true,

                          fillColor:
                              const Color(0xFFE2D2B3),

                          border:
                              const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.zero,

                            borderSide:
                                BorderSide(
                              color:
                                  Color(0xFF806B57),
                            ),
                          ),

                          enabledBorder:
                              const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.zero,

                            borderSide:
                                BorderSide(
                              color:
                                  Color(0xFF806B57),
                            ),
                          ),

                          focusedBorder:
                              const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.zero,

                            borderSide:
                                BorderSide(
                              color:
                                  Color(0xFF30251E),
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ==================================================
                      // PASSWORD LABEL
                      // ==================================================

                      Text(

                        "PASSWORD",

                        style:
                            GoogleFonts.cinzel(
                          fontSize: 9,
                          fontWeight:
                              FontWeight.bold,
                          letterSpacing: 1.2,
                          color:
                              const Color(0xFF59463A),
                        ),
                      ),

                      const SizedBox(height: 7),

                      // ==================================================
                      // PASSWORD FIELD
                      // ==================================================

                      TextField(

                        controller:
                            passwordController,

                        obscureText:
                            hidePassword,

                        style:
                            GoogleFonts.libreBaskerville(
                          fontSize: 13,
                          color:
                              const Color(0xFF2C231D),
                        ),

                        decoration:
                            InputDecoration(

                          hintText:
                              "Enter your password",

                          hintStyle:
                              GoogleFonts.libreBaskerville(
                            fontSize: 12,
                            color:
                                const Color(0xFF806B57),
                          ),

                          prefixIcon:
                              const Icon(
                            Icons.lock_outline,
                            color:
                                Color(0xFF59463A),
                            size: 20,
                          ),

                          suffixIcon:
                              IconButton(

                            icon:
                                Icon(
                              hidePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,

                              color:
                                  const Color(0xFF59463A),

                              size: 20,
                            ),

                            onPressed: () {

                              setState(() {

                                hidePassword =
                                    !hidePassword;

                              });
                            },
                          ),

                          filled:
                              true,

                          fillColor:
                              const Color(0xFFE2D2B3),

                          border:
                              const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.zero,

                            borderSide:
                                BorderSide(
                              color:
                                  Color(0xFF806B57),
                            ),
                          ),

                          enabledBorder:
                              const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.zero,

                            borderSide:
                                BorderSide(
                              color:
                                  Color(0xFF806B57),
                            ),
                          ),

                          focusedBorder:
                              const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.zero,

                            borderSide:
                                BorderSide(
                              color:
                                  Color(0xFF30251E),
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 23),

                      // ==================================================
                      // LOGIN BUTTON
                      // ==================================================

                      SizedBox(

                        width:
                            double.infinity,

                        height:
                            52,

                        child:
                            ElevatedButton(

                          onPressed:
                              login,

                          style:
                              ElevatedButton.styleFrom(

                            backgroundColor:
                                const Color(0xFF3A2E26),

                            foregroundColor:
                                const Color(0xFFF3E8D0),

                            elevation:
                                2,

                            shape:
                                const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.zero,
                            ),
                          ),

                          child:
                              Text(

                            "LOGIN",

                            style:
                                GoogleFonts.cinzel(
                              fontSize: 11,
                              fontWeight:
                                  FontWeight.bold,
                              letterSpacing:
                                  1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ==================================================
                      // SUBSCRIBE
                      // ==================================================

                      Center(

                        child:
                            Wrap(

                          alignment:
                              WrapAlignment.center,

                          children: [

                            Text(

                              "First time reading? ",

                              style:
                                  GoogleFonts.libreBaskerville(
                                fontSize: 11,
                                color:
                                    const Color(0xFF665548),
                              ),
                            ),

                            GestureDetector(

                              onTap: () {

                                ScaffoldMessenger
                                    .of(context)
                                    .showSnackBar(

                                  SnackBar(

                                    backgroundColor:
                                        const Color(
                                      0xFF3A2E26,
                                    ),

                                    content:
                                        Text(

                                      "Registration coming soon.",

                                      style:
                                          GoogleFonts.libreBaskerville(
                                        fontSize: 11,
                                        color:
                                            const Color(
                                          0xFFF3E8D0,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },

                              child:
                                  Text(

                                "Subscribe",

                                style:
                                    GoogleFonts.libreBaskerville(
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.bold,
                                  color:
                                      const Color(
                                    0xFF3A2E26,
                                  ),
                                  decoration:
                                      TextDecoration
                                          .underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // ==================================================
                // FOOTER
                // ==================================================

                Container(
                  height: 1,
                  color:
                      const Color(0xFF806B57),
                ),

                const SizedBox(height: 8),

                Text(

                  "READ • DISCOVER • UNDERSTAND",

                  style:
                      GoogleFonts.cinzel(
                    fontSize: 8,
                    fontWeight:
                        FontWeight.bold,
                    letterSpacing: 2,
                    color:
                        const Color(0xFF665548),
                  ),
                ),

                const SizedBox(height: 4),

                Text(

                  "A DAILY COLLECTION OF STORIES FROM AROUND THE WORLD",

                  textAlign:
                      TextAlign.center,

                  style:
                      GoogleFonts.libreBaskerville(
                    fontSize: 7,
                    letterSpacing: 0.5,
                    color:
                        const Color(0xFF806B57),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// HOME PAGE
// ============================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState extends State<HomePage> {

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

  int bottomIndex = 0;

  // ==========================================================
  // BOOKMARK STATES
  // ==========================================================

  final List<bool> bookmarked =
      List.generate(8, (index) => false);

  // ==========================================================
  // NEWS DATA
  // ==========================================================

  final List<Map<String, String>> news = [

    {
      "title":
          "Technology is transforming the way we live",

      "description":
          "Discover the latest technology trends and innovations shaping our future.",

      "source":
          "Tech Daily",

      "time":
          "1 hour ago",
    },

    {
      "title":
          "Global markets show strong movement",

      "description":
          "Markets around the world respond to the latest economic developments.",

      "source":
          "Business Today",

      "time":
          "2 hours ago",
    },

    {
      "title":
          "New discoveries changing modern science",

      "description":
          "Researchers make important discoveries that could influence the future.",

      "source":
          "Science World",

      "time":
          "3 hours ago",
    },

    {
      "title":
          "Sports world prepares for a major event",

      "description":
          "Athletes around the world are getting ready for an exciting competition.",

      "source":
          "Sports Daily",

      "time":
          "4 hours ago",
    },

    {
      "title":
          "Health experts share useful wellness tips",

      "description":
          "Simple lifestyle changes can contribute to a healthier everyday life.",

      "source":
          "Health News",

      "time":
          "5 hours ago",
    },

    {
      "title":
          "Entertainment industry announces new projects",

      "description":
          "The latest announcements from movies, music and entertainment.",

      "source":
          "Entertainment Weekly",

      "time":
          "6 hours ago",
    },

    {
      "title":
          "Artificial Intelligence continues to evolve",

      "description":
          "AI research is creating new possibilities across multiple industries.",

      "source":
          "AI Today",

      "time":
          "7 hours ago",
    },

    {
      "title":
          "Important global updates you should know",

      "description":
          "Here are some of the most important stories developing around the world.",

      "source":
          "Global News",

      "time":
          "8 hours ago",
    },
  ];

  // ==========================================================
  // TOGGLE BOOKMARK
  // ==========================================================

  void toggleBookmark(int index) {

    setState(() {

      bookmarked[index] =
          !bookmarked[index];

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

  void showArticle(
      BuildContext context,
      int index) {

    final article = news[index];

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

            article["title"]!,

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
                  article["description"]!,

                  style: const TextStyle(
                    color: brownColor,
                    height: 1.6,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  "${article["source"]}  •  ${article["time"]}",

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
        news[index];

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

                  "https://picsum.photos/600/300?random=$index",

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

                  item["title"]!,

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

                  item["description"]!,

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

                      item["source"]!,

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

                      item["time"]!,

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

                        showArticle(
                          context,
                          index,
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

          await Future.delayed(
            const Duration(
              seconds: 1,
            ),
          );

          setState(() {});

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

                          setState(() {

                            selectedCategory =
                                index;

                          });
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

            SliverList(

              delegate:
                  SliverChildBuilderDelegate(

                (context, index) {

                  return newsCard(
                    context,
                    index,
                  );
                },

                childCount:
                    news.length,
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

            ScaffoldMessenger.of(context)
                .showSnackBar(

              const SnackBar(
                backgroundColor:
                    brownColor,

                content:
                    Text(
                  "Your saved articles.",
                  style:
                      TextStyle(
                    color:
                        paperColor,
                  ),
                ),
              ),
            );
          }

          if (index == 2) {

            ScaffoldMessenger.of(context)
                .showSnackBar(

              const SnackBar(
                backgroundColor:
                    brownColor,

                content:
                    Text(
                  "Settings opened.",
                  style:
                      TextStyle(
                    color:
                        paperColor,
                  ),
                ),
              ),
            );
          }

          if (index == 3) {

            ScaffoldMessenger.of(context)
                .showSnackBar(

              const SnackBar(
                backgroundColor:
                    brownColor,

                content:
                    Text(
                  "Profile opened.",
                  style:
                      TextStyle(
                    color:
                        paperColor,
                  ),
                ),
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