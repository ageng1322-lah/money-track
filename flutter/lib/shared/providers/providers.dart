// lib/shared/providers/providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/transaction/data/transaction_repository_impl.dart';
import '../../features/transaction/domain/transaction_entity.dart';

// ─── Core ───────────────────────────────────────────────
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

// ─── Repositories ────────────────────────────────────────
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(apiClientProvider)),
);

final transactionRepositoryProvider = Provider<TransactionRepository>(
  (ref) => TransactionRepository(ref.watch(apiClientProvider)),
);

// ─── Auth State ──────────────────────────────────────────
class AuthNotifier extends AsyncNotifier<UserEntity?> {
  @override
  Future<UserEntity?> build() async {
    final repo    = ref.read(authRepositoryProvider);
    final hasToken = await repo.hasToken();
    if (!hasToken) return null;
    try {
      return await repo.getMe();
    } catch (_) {
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await ref.read(authRepositoryProvider).login(
        email: email, password: password,
      );
      return result.user;
    });
  }

  Future<void> register(String name, String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await ref.read(authRepositoryProvider).register(
        name:                  name,
        email:                 email,
        password:              password,
        passwordConfirmation:  password,
      );
      return result.user;
    });
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(null);
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, UserEntity?>(
  AuthNotifier.new,
);

// ─── Dashboard State ─────────────────────────────────────
class DashboardNotifier extends AsyncNotifier<Map<String, dynamic>> {
  @override
  Future<Map<String, dynamic>> build() => _fetch();

  Future<Map<String, dynamic>> _fetch() async {
    final dio = ref.read(apiClientProvider).dio;
    final res = await dio.get('/dashboard');
    return res.data as Map<String, dynamic>;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

final dashboardProvider = AsyncNotifierProvider<DashboardNotifier, Map<String, dynamic>>(
  DashboardNotifier.new,
);

// ─── Transaction Filter State ────────────────────────────
class TransactionFilter {
  final String? type;
  final int?    categoryId;
  final String? from;
  final String? to;
  final String? search;
  final String  sort;
  final String  order;

  const TransactionFilter({
    this.type,
    this.categoryId,
    this.from,
    this.to,
    this.search,
    this.sort  = 'date',
    this.order = 'desc',
  });

  TransactionFilter copyWith({
    String? type,
    int?    categoryId,
    String? from,
    String? to,
    String? search,
    String? sort,
    String? order,
    bool    clearType       = false,
    bool    clearCategoryId = false,
  }) => TransactionFilter(
    type:       clearType        ? null : type        ?? this.type,
    categoryId: clearCategoryId  ? null : categoryId  ?? this.categoryId,
    from:       from   ?? this.from,
    to:         to     ?? this.to,
    search:     search ?? this.search,
    sort:       sort   ?? this.sort,
    order:      order  ?? this.order,
  );
}

final transactionFilterProvider = StateProvider<TransactionFilter>(
  (_) => const TransactionFilter(),
);
