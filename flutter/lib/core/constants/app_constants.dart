// lib/core/constants/app_constants.dart

class AppConstants {
  AppConstants._();

  static const String appName = 'FinTrack';

  // API
  static const String baseUrl    = 'http://localhost:8000/api/v1/';
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
