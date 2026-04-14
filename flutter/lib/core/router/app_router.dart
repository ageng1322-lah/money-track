// lib/core/router/app_router.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/transaction/presentation/transaction_list_screen.dart';
import '../../features/transaction/presentation/transaction_form_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../shared/widgets/main_scaffold.dart';
import '../../shared/providers/providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/dashboard',
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
                          state.matchedLocation == '/register';

      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn  &&  isAuthRoute) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(path: '/login',    builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(path: '/dashboard',    builder: (_, __) => const DashboardScreen()),
          GoRoute(path: '/transactions', builder: (_, __) => const TransactionListScreen()),
          GoRoute(path: '/profile',      builder: (_, __) => const ProfileScreen()),
        ],
      ),
      GoRoute(
        path: '/transactions/add',
        builder: (_, __) => const TransactionFormScreen(),
      ),
      GoRoute(
        path: '/transactions/edit/:id',
        builder: (context, state) => TransactionFormScreen(
          transactionId: int.parse(state.pathParameters['id']!),
        ),
      ),
    ],
  );
});
