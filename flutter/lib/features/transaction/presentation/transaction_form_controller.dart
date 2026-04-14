import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/formatters.dart';
import '../../dashboard/presentation/dashboard_controller.dart';
import '../data/transaction_repository_impl.dart';
import 'transaction_list_controller.dart';

class TransactionFormController extends GetxController {
  final TransactionRepository _repo = Get.find();

  final titleCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  final noteCtrl = TextEditingController();

  final type = 'expense'.obs;
  final date = DateTime.now().obs;
  final categoryId = RxnInt();
  final loading = false.obs;
  final error = RxnString();

  int? transactionId;
  bool get isEdit => transactionId != null;

  @override
  void onInit() {
    super.onInit();
    // In a real app, if you had the full object you'd populate it here.
    // For now we assume title/amount etc are handled by the screen if passed.
  }

  void setType(String newType) => type.value = newType;
  void setDate(DateTime newDate) => date.value = newDate;

  Future<void> submit() async {
    loading.value = true;
    error.value = null;

    try {
      final amount = double.parse(amountCtrl.text.replaceAll('.', ''));
      final apiDate = DateFormatter.toApiDate(date.value);

      if (isEdit) {
        await _repo.updateTransaction(transactionId!, {
          'title': titleCtrl.text.trim(),
          'amount': amount,
          'type': type.value,
          'date': apiDate,
          'category_id': categoryId.value,
          'note': noteCtrl.text.isEmpty ? null : noteCtrl.text.trim(),
        });
      } else {
        await _repo.createTransaction(
          title: titleCtrl.text.trim(),
          amount: amount,
          type: type.value,
          date: apiDate,
          categoryId: categoryId.value,
          note: noteCtrl.text.isEmpty ? null : noteCtrl.text.trim(),
        );
      }

      // Refresh other controllers
      Get.find<DashboardController>().refreshDashboard();
      if (Get.isRegistered<TransactionListController>()) {
        Get.find<TransactionListController>().fetchTransactions();
      }

      Get.back();
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  @override
  void onClose() {
    titleCtrl.dispose();
    amountCtrl.dispose();
    noteCtrl.dispose();
    super.onClose();
  }
}
