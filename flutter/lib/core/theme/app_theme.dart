// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary    = Color(0xFF10B981); // Emerald 500
  static const Color accent     = Color(0xFF34D399); // Emerald 400
  static const Color background = Color(0xFF000000); // Black
  static const Color surface    = Color(0xFF111111); // Dark Gray
  static const Color cardBg     = Color(0xFF1A1A1A); // Lighter Gray for cards
  static const Color income     = Color(0xFF10B981);
  static const Color expense    = Color(0xFFF43F5E); // Rose 500
  static const Color textMain   = Colors.white;
  static const Color textDim    = Color(0xFF64748B); // Slate 400

  // Compatibility aliases for older screens
  static const Color textPrimary   = Colors.white;
  static const Color textSecondary = Color(0xFF64748B);
  static const Color primaryLight  = Color(0xFF10B981);
  static const Color divider       = Color(0x1A64748B);

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: accent,
      surface: surface,
      background: background,
    ),
    textTheme: GoogleFonts.interTextTheme(
      const TextTheme(
        headlineLarge: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w800),
        headlineMedium: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w700),
        titleLarge: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w600),
      ),
    ).apply(
      bodyColor: textMain,
      displayColor: textMain,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      foregroundColor: textMain,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Outfit',
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: textMain,
      ),
    ),
    // Fix: Using the correct class name for the specific Flutter version
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: Colors.white10, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.white10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      labelStyle: const TextStyle(color: textDim, fontWeight: FontWeight.bold, fontSize: 12),
      hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    ),
  );

  static ThemeData get light => dark;
}
