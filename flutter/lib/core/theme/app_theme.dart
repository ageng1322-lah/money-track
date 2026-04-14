// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary       = Color(0xFF1D9E75);
  static const Color primaryDark   = Color(0xFF0F6E56);
  static const Color primaryLight  = Color(0xFFE1F5EE);
  static const Color income        = Color(0xFF1D9E75);
  static const Color expense       = Color(0xFFE24B4A);
  static const Color background    = Color(0xFFF5F7FA);
  static const Color surface       = Color(0xFFFFFFFF);
  static const Color textPrimary   = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color divider       = Color(0xFFE5E7EB);

  static ThemeData get light => ThemeData(
    useMaterial3:     true,

    colorScheme: ColorScheme.fromSeed(
      seedColor:   primary,
      brightness:  Brightness.light,
      background:  background,
      surface:     surface,
    ),
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(
      backgroundColor:  surface,
      foregroundColor:  textPrimary,
      elevation:        0,
      centerTitle:      true,
      titleTextStyle: TextStyle(

        fontSize:    17,
        fontWeight:  FontWeight.w600,
        color:       textPrimary,
      ),
    ),
    cardTheme: CardThemeData(
      color:       surface,
      elevation:   0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: divider, width: 0.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor:  primary,
        foregroundColor:  Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(

          fontSize:    16,
          fontWeight:  FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled:      true,
      fillColor:   const Color(0xFFF9FAFB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:   const BorderSide(color: divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:   const BorderSide(color: divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:   const BorderSide(color: primary, width: 1.5),
      ),
      labelStyle: const TextStyle(color: textSecondary),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3:  true,

    brightness:    Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor:   primary,
      brightness:  Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF0F1117),
  );
}
