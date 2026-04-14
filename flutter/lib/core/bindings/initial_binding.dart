import 'package:get/get.dart';
import '../network/api_client.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/transaction/data/transaction_repository_impl.dart';
import '../../features/auth/presentation/auth_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient(), fenix: true);
    Get.lazyPut(() => AuthRepository(Get.find()), fenix: true);
    Get.lazyPut(() => TransactionRepository(Get.find()), fenix: true);
    Get.put(AuthController(), permanent: true);
  }
}
