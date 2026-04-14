import 'package:get/get.dart';
import '../../dashboard/presentation/dashboard_controller.dart';
import '../data/transaction_repository_impl.dart';
import '../domain/transaction_entity.dart';

class TransactionListController extends GetxController with StateMixin<PaginatedTransactions> {
  final TransactionRepository _repo = Get.find();

  // Filter state
  final type = RxnString();
  final order = 'desc'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
    
    // Auto-fetch when filters change
    ever(type, (_) => fetchTransactions());
    ever(order, (_) => fetchTransactions());
  }

  Future<void> fetchTransactions() async {
    change(null, status: RxStatus.loading());
    try {
      final result = await _repo.getTransactions(
        type:  type.value,
        order: order.value,
      );
      change(result, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> deleteTransaction(int id) async {
    try {
      await _repo.deleteTransaction(id);
      fetchTransactions();
      // Also refresh dashboard balance
      Get.find<DashboardController>().refreshDashboard();
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus transaksi: $e');
    }
  }

  void setType(String? newType) => type.value = newType;
  void setOrder(String newOrder) => order.value = newOrder;
}
