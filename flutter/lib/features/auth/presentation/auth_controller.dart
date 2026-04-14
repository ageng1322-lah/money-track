import 'package:get/get.dart';
import '../../transaction/domain/transaction_entity.dart';
import '../data/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _repo = Get.find();

  final user = Rxn<UserEntity>();
  final isLoading = false.obs;
  final error = RxnString();

  bool get isLoggedIn => user.value != null;

  @override
  void onInit() {
    super.onInit();
    checkAuth();
  }

  Future<void> checkAuth() async {
    final hasToken = await _repo.hasToken();
    if (!hasToken) {
      user.value = null;
      return;
    }
    try {
      user.value = await _repo.getMe();
    } catch (_) {
      user.value = null;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      error.value = null;
      final result = await _repo.login(email: email, password: password);
      user.value = result.user;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      isLoading.value = true;
      error.value = null;
      final result = await _repo.register(
        name:                 name,
        email:                email,
        password:             password,
        passwordConfirmation: password,
      );
      user.value = result.user;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    user.value = null;
    Get.offAllNamed('/login');
  }
}
