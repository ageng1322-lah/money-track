// lib/core/constants/app_constants.dart

import 'package:flutter/foundation.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'MoneyTrack';

  // API
  static String get baseUrl {
    // 1. Cek dari environment variable di terminal (--dart-define)
    const String envUrl = String.fromEnvironment('API_URL');
    if (envUrl.isNotEmpty) return envUrl;

    // 2. Jika di production / release
    if (kReleaseMode) {
      return 'https://api.moneytrack.com/api/v1/'; // Ganti dengan URL asli jika sudah live
    }

    // 3. Konfigurasi otomatis untuk Local Development berdasarkan platform
    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api/v1/';
    }
    
    if (defaultTargetPlatform == TargetPlatform.android) {
      // 10.0.2.2 adalah IP localhost komputer untuk Android Emulator
      // Jika pakai HP Fisik, IP ini tidak jalan (akan fallback ke opsi bawah atau --dart-define)
      return 'http://10.0.2.2:8000/api/v1/'; 
    }
    
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // localhost untuk iOS Simulator
      return 'http://127.0.0.1:8000/api/v1/';
    }

    // Fallback: IP lokal PC kamu yang terakhir (jaga-jaga jika pakai HP fisik tapi tidak pakai dart-define)
    return 'http://172.18.20.212:8000/api/v1/';
  }

  static const int    connectTimeout = 30;
  static const int    receiveTimeout = 30;

  // Storage keys
  static const String tokenKey   = 'auth_token';
  static const String userKey    = 'cached_user';

  // Pagination
  static const int perPage = 15;
}

class AppColors {
  AppColors._();

  static const int primaryGreen  = 0xFF1D9E75;
  static const int darkGreen     = 0xFF0F6E56;
  static const int lightGreen    = 0xFFE1F5EE;
  static const int incomeColor   = 0xFF1D9E75;
  static const int expenseColor  = 0xFFE24B4A;
  static const int background    = 0xFFF5F7FA;
  static const int cardBg        = 0xFFFFFFFF;
  static const int textPrimary   = 0xFF1A1A2E;
  static const int textSecondary = 0xFF6B7280;
  static const int divider       = 0xFFE5E7EB;
}
