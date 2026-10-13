import 'package:flutter/material.dart';

// ============================================================
// LIGHT THEME COLORS
// ============================================================

const Color paperColor = Color(0xFFF1E7D0);
const Color cardColor = Color(0xFFE8DCC3);
const Color inkColor = Color(0xFF211A16);
const Color brownColor = Color(0xFF5C4033);
const Color borderColor = Color(0xFF8B7355);
const Color fadedColor = Color(0xFFD2C09F);

// ============================================================
// DARK THEME COLORS
// ============================================================

const Color darkPaperColor = Color(0xFF1C1815);
const Color darkCardColor = Color(0xFF2A2420);
const Color darkInkColor = Color(0xFFF3E8D0);
const Color darkBrownColor = Color(0xFFD2B48C);
const Color darkBorderColor = Color(0xFF6B5848);
const Color darkFadedColor = Color(0xFF4A4038);

// ============================================================
// LIGHT THEME
// ============================================================

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  scaffoldBackgroundColor: paperColor,

  colorScheme: ColorScheme.fromSeed(
    seedColor: brownColor,
    brightness: Brightness.light,
    surface: paperColor,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: paperColor,
    foregroundColor: inkColor,
    elevation: 0,
    centerTitle: false,
  ),

  cardTheme: const CardThemeData(color: cardColor),

  dividerTheme: const DividerThemeData(color: borderColor, thickness: 1),

  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: cardColor,

    labelStyle: TextStyle(color: brownColor),

    hintStyle: TextStyle(color: Color(0xFF806D59)),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: borderColor),
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: borderColor),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: brownColor, width: 2),
    ),
  ),
);

// ============================================================
// DARK THEME
// ============================================================

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  scaffoldBackgroundColor: darkPaperColor,

  colorScheme: ColorScheme.fromSeed(
    seedColor: darkBrownColor,
    brightness: Brightness.dark,
    surface: darkPaperColor,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: darkPaperColor,
    foregroundColor: darkInkColor,
    elevation: 0,
    centerTitle: false,
  ),

  cardTheme: const CardThemeData(color: darkCardColor),

  dividerTheme: const DividerThemeData(color: darkBorderColor, thickness: 1),

  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: darkCardColor,

    labelStyle: TextStyle(color: darkBrownColor),

    hintStyle: TextStyle(color: Color(0xFFAA9A88)),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: darkBorderColor),
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: darkBorderColor),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: darkBrownColor, width: 2),
    ),
  ),
);
