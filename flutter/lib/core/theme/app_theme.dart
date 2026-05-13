// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Base Colors
  static const Color primary    = Color(0xFF10B981); // Emerald 500
  static const Color accent     = Color(0xFF34D399); // Emerald 400
  static const Color income     = Color(0xFF10B981);
  static const Color expense    = Color(0xFFF43F5E); // Rose 500
  
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkSurface    = Color(0xFF080808);
  static const Color darkCard       = Color(0xFF0C0C0C);
  static const Color darkTextMain   = Colors.white;
  static const Color darkTextDim    = Color(0xFFA1A1AA);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF8FAFC); // Slate 50
  static const Color lightSurface    = Colors.white;
  static const Color lightCard       = Colors.white;
  static const Color lightTextMain   = Color(0xFF0F172A); // Slate 900
  static const Color lightTextDim    = Color(0xFF64748B); // Slate 500

  // Adaptive Helpers
  static Color getBackground(BuildContext context) => 
    Theme.of(context).brightness == Brightness.dark ? darkBackground : lightBackground;
  static Color getSurface(BuildContext context) => 
    Theme.of(context).brightness == Brightness.dark ? darkSurface : lightSurface;
  static Color getTextMain(BuildContext context) => 
    Theme.of(context).brightness == Brightness.dark ? darkTextMain : lightTextMain;
  static Color getTextDim(BuildContext context) => 
    Theme.of(context).brightness == Brightness.dark ? darkTextDim : lightTextDim;

  // Static aliases
  static const Color background = darkBackground;
  static const Color surface    = darkSurface;
  static const Color cardBg     = darkCard;
  static const Color textMain   = darkTextMain;
  static const Color textDim    = darkTextDim;
  static const Color textPrimary   = Colors.white;
  static const Color textSecondary = Color(0xFF64748B);
  static const Color primaryLight  = Color(0xFF10B981);
  static const Color divider       = Color(0x1A64748B);

  static ThemeData get dark => _buildTheme(Brightness.dark);
  static ThemeData get light => _buildTheme(Brightness.light);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final bg     = isDark ? darkBackground : lightBackground;
    final surf   = isDark ? darkSurface : lightSurface;
    final txt    = isDark ? darkTextMain : lightTextMain;
    final txtDim = isDark ? darkTextDim : lightTextDim;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: isDark ? Colors.black : Colors.white,
        secondary: accent,
        onSecondary: Colors.black,
        surface: surf,
        onSurface: txt,
        error: expense,
        onError: Colors.white,
        surfaceVariant: isDark ? darkCard : Colors.white,
        onSurfaceVariant: txtDim,
        outline: isDark ? Colors.white10 : Colors.black12,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(
        TextTheme(
          headlineLarge: TextStyle(fontWeight: FontWeight.w800, color: txt),
          headlineMedium: TextStyle(fontWeight: FontWeight.w700, color: txt),
          titleLarge: TextStyle(fontWeight: FontWeight.w600, color: txt),
          bodyLarge: TextStyle(color: txt),
          bodyMedium: TextStyle(color: txt),
        ),
      ).apply(
        bodyColor: txt,
        displayColor: txt,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: txt,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: txt,
        ),
      ),
      cardTheme: CardThemeData(
        color: surf,
        surfaceTintColor: Colors.transparent,
        elevation: isDark ? 0.0 : 2.0,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: isDark ? Colors.white10 : const Color(0x0D000000), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: isDark ? Colors.black : Colors.white,
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
        fillColor: surf,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        labelStyle: GoogleFonts.spaceGrotesk(color: txtDim, fontWeight: FontWeight.bold, fontSize: 12),
        hintStyle: TextStyle(color: isDark ? Colors.white24 : Colors.black26, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      ),
    );
  }
}
