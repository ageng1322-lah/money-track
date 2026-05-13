import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/transaction/presentation/transaction_list_screen.dart';
import '../../features/transaction/presentation/transaction_form_screen.dart';
import '../../features/transaction/presentation/transaction_success_screen.dart';
import '../../features/transaction/presentation/transaction_detail_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/detail_profile_screen.dart';
import '../../features/profile/presentation/setting_screen.dart';
import '../../features/profile/presentation/security_screen.dart';
import '../../features/profile/presentation/help_support_screen.dart';
import '../../features/dashboard/presentation/summary_screen.dart';
import '../../shared/widgets/main_scaffold.dart';
import '../../features/transaction/domain/transaction_entity.dart';
import '../../features/auth/presentation/auth_controller.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/otp_verification_screen.dart';
import '../../features/category/presentation/category_form_screen.dart';

class AppPages {
  static const INITIAL = '/splash';

  static final routes = [
    GetPage(
      name: '/splash',
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: '/login',
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: '/register',
      page: () => const RegisterScreen(),
    ),
    GetPage(
      name: '/verify-otp',
      page: () => const OtpVerificationScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/dashboard',
      page: () => const MainScaffold(child: DashboardScreen()),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/transactions',
      page: () => const MainScaffold(child: TransactionListScreen()),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/summary',
      page: () => const MainScaffold(child: SummaryScreen()),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/profile',
      page: () => const MainScaffold(child: ProfileScreen()),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/profile/edit',
      page: () => const DetailProfileScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/profile/security',
      page: () => const SecurityScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/profile/help',
      page: () => const HelpSupportScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/preferences',
      page: () => const MainScaffold(child: PreferencesScreen()),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/transactions/add',
      page: () => const TransactionFormScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/transactions/edit/:id',
      page: () => TransactionFormScreen(
        transactionId: int.tryParse(Get.parameters['id'] ?? '0'),
      ),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/transactions/success',
      page: () => TransactionSuccessScreen(
        amount: Get.arguments['amount'] ?? 0.0,
        categoryName: Get.arguments['categoryName'] ?? '',
        categoryIcon: Get.arguments['categoryIcon'] ?? '',
        type: Get.arguments['type'] ?? 'expense',
      ),
    ),
    GetPage(
      name: '/transactions/detail',
      page: () => TransactionDetailScreen(
        transaction: Get.arguments as TransactionEntity,
      ),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/categories/add',
      page: () => CategoryFormScreen(
        initialType: Get.parameters['type'],
      ),
      middlewares: [AuthMiddleware()],
    ),
  ];
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    final isLoggedIn = authController.isLoggedIn;
    final isAuthRoute = route == '/login' || route == '/register';

    if (!isLoggedIn && !isAuthRoute) return const RouteSettings(name: '/login');
    
    if (isLoggedIn) {
      final isVerified = authController.user.value?.isVerified ?? false;
      if (!isVerified && route != '/verify-otp') {
        return const RouteSettings(name: '/verify-otp');
      }
      if (isVerified && isAuthRoute) {
        return const RouteSettings(name: '/dashboard');
      }
    }
    return null;
  }
}
