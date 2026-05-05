// lib/shared/providers/providers.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/profile/data/profile_repository.dart';
import '../../features/category/data/category_repository.dart';
import '../../features/transaction/data/transaction_repository_impl.dart';
import '../../features/transaction/domain/transaction_entity.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import '../../features/auth/presentation/auth_controller.dart';

// API Client Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

// Repository Providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return AuthRepository(client);
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return TransactionRepository(client);
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return ProfileRepository(client);
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return CategoryRepository(client);
});

// Auth Provider
final authProvider = AsyncNotifierProvider<AuthNotifier, UserEntity?>(() {
  return AuthNotifier();
});

class AuthNotifier extends AsyncNotifier<UserEntity?> {
  late AuthRepository _repo;

  @override
  Future<UserEntity?> build() async {
    _repo = ref.watch(authRepositoryProvider);
    final hasToken = await _repo.hasToken();
    if (!hasToken) return null;
    
    try {
      return await _repo.getMe();
    } catch (e) {
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await _repo.login(email: email, password: password);
      // Sync with GetX
      if (getx.Get.isRegistered<AuthController>()) {
        getx.Get.find<AuthController>().user.value = result.user;
      }
      return result.user;
    });
  }

  Future<void> register(String name, String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await _repo.register(
        name:                 name,
        email:                email,
        password:             password,
        passwordConfirmation: password,
      );
      // Sync with GetX
      if (getx.Get.isRegistered<AuthController>()) {
        getx.Get.find<AuthController>().user.value = result.user;
      }
      return result.user;
    });
  }

  Future<void> logout() async {
    await _repo.logout();
    // Sync with GetX
    if (getx.Get.isRegistered<AuthController>()) {
      getx.Get.find<AuthController>().user.value = null;
    }
    state = const AsyncValue.data(null);
    getx.Get.offAllNamed('/login');
  }
}

// Category Provider
final categoriesProvider = FutureProvider.autoDispose<List<CategoryEntity>>((ref) async {
  return ref.watch(categoryRepositoryProvider).getCategories();
});

// Transaction List Provider
final transactionListProvider = FutureProvider.autoDispose<PaginatedTransactions>((ref) async {
  final filter = ref.watch(transactionFilterProvider);
  final repo   = ref.read(transactionRepositoryProvider);
  return repo.getTransactions(
    type:       filter.type,
    categoryId: filter.categoryId,
    from:       filter.from,
    to:         filter.to,
    search:     filter.search,
    sort:       filter.sort,
    order:      filter.order,
  );
});

// Transaction Filter Provider
class TransactionFilter {
  final String? type;
  final int?    categoryId;
  final String? from;
  final String? to;
  final String? search;
  final String  sort;
  final String  order;

  TransactionFilter({
    this.type,
    this.categoryId,
    this.from,
    this.to,
    this.search,
    this.sort = 'date',
    this.order = 'desc',
  });

  TransactionFilter copyWith({
    String? type,
    bool    clearType = false,
    int?    categoryId,
    String? from,
    String? to,
    String? search,
    String? sort,
    String? order,
  }) {
    return TransactionFilter(
      type:       clearType ? null : (type ?? this.type),
      categoryId: categoryId ?? this.categoryId,
      from:       from ?? this.from,
      to:         to ?? this.to,
      search:     search ?? this.search,
      sort:       sort ?? this.sort,
      order:      order ?? this.order,
    );
  }
}

final transactionFilterProvider = StateProvider<TransactionFilter>((ref) {
  return TransactionFilter();
});

// Dashboard Date Filter Provider
final dashboardDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

// Dashboard Provider
final dashboardProvider = AsyncNotifierProvider<DashboardNotifier, Map<String, dynamic>>(() {
  return DashboardNotifier();
});

class DashboardNotifier extends AsyncNotifier<Map<String, dynamic>> {
  @override
  Future<Map<String, dynamic>> build() async {
    final date = ref.watch(dashboardDateProvider);
    final dio  = ref.watch(apiClientProvider).dio;
    
    final res = await dio.get('dashboard', queryParameters: {
      'month': date.month,
      'year':  date.year,
    });
    return res.data as Map<String, dynamic>;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final date = ref.read(dashboardDateProvider);
      final dio  = ref.watch(apiClientProvider).dio;
      final res = await dio.get('dashboard', queryParameters: {
        'month': date.month,
        'year':  date.year,
      });
      return res.data as Map<String, dynamic>;
    });
  }
}

// Theme Provider
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.dark; // Default to dark as requested previously
});
