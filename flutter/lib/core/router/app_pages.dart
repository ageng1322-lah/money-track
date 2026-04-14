import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/transaction/presentation/transaction_list_screen.dart';
import '../../features/transaction/presentation/transaction_form_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../shared/widgets/main_scaffold.dart';
import '../../features/auth/presentation/auth_controller.dart';

class AppPages {
  static const INITIAL = '/dashboard';

  static final routes = [
    GetPage(
      name: '/login',
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: '/register',
      page: () => const RegisterScreen(),
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
      name: '/profile',
      page: () => const MainScaffold(child: ProfileScreen()),
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
  ];
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    final isLoggedIn = authController.isLoggedIn;
    final isAuthRoute = route == '/login' || route == '/register';

    if (!isLoggedIn && !isAuthRoute) return const RouteSettings(name: '/login');
    if (isLoggedIn && isAuthRoute) return const RouteSettings(name: '/dashboard');
    return null;
  }
}
