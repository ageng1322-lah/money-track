import 'package:get/get.dart';
import '../../../core/network/api_client.dart';

class DashboardController extends GetxController with StateMixin<Map<String, dynamic>> {
  final ApiClient _client = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    change(null, status: RxStatus.loading());
    try {
      final res = await _client.dio.get('/dashboard');
      change(res.data as Map<String, dynamic>, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> refreshDashboard() => fetchDashboard();
}
