// lib/features/transaction/presentation/transaction_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import 'transaction_form_controller.dart';

class TransactionFormScreen extends GetView<TransactionFormController> {
  final int? transactionId;
  const TransactionFormScreen({super.key, this.transactionId});

  @override
  Widget build(BuildContext context) {
    // Initialize controller and set transactionId
    final controller = Get.put(TransactionFormController());
    controller.transactionId = transactionId;

    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(controller.isEdit ? 'Edit Transaksi' : 'Tambah Transaksi'),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Get.back()),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Type toggle
            Container(
              decoration: BoxDecoration(
                color:        AppTheme.surface,
                borderRadius: BorderRadius.circular(14),
                border:       Border.all(color: AppTheme.divider, width: 0.5),
              ),
              child: Obx(() => Row(children: [
                _TypeButton(label: 'Pengeluaran', icon: '↑',
                  active: controller.type.value == 'expense', color: AppTheme.expense,
                  onTap:  () => controller.setType('expense')),
                _TypeButton(label: 'Pemasukan',   icon: '↓',
                  active: controller.type.value == 'income',  color: AppTheme.income,
                  onTap:  () => controller.setType('income')),
              ])),
            ),
            const SizedBox(height: 20),

            Obx(() {
              final error = controller.error.value;
              if (error == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:  const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(error, style: const TextStyle(color: AppTheme.expense, fontSize: 13)),
                ),
              );
            }),

            // Amount (big input)
            Container(
              padding:      const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color:        AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border:       Border.all(color: AppTheme.divider, width: 0.5),
              ),
              child: Column(children: [
                const Text('Nominal',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('Rp ', style: TextStyle(fontSize: 22,
                    fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
                  Expanded(child: Obx(() => TextFormField(
                    controller:   controller.amountCtrl,
                    keyboardType: TextInputType.number,
                    textAlign:    TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700,
                      color: controller.type.value == 'income' ? AppTheme.income : AppTheme.expense),
                    decoration: const InputDecoration(
                      border:         InputBorder.none,
                      enabledBorder:  InputBorder.none,
                      focusedBorder:  InputBorder.none,
                      filled:         false,
                      hintText:       '0',
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Nominal wajib diisi';
                      final n = double.tryParse(v.replaceAll('.', ''));
                      if (n == null || n < 1) return 'Nominal tidak valid';
                      return null;
                    },
                  ))),
                ]),
              ]),
            ),
            const SizedBox(height: 16),

            // Title
            TextFormField(
              controller:  controller.titleCtrl,
              decoration: const InputDecoration(
                labelText:  'Judul transaksi',
                prefixIcon:  Icon(Icons.title),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Judul wajib diisi' : null,
            ),
            const SizedBox(height: 14),

            // Date
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context:    context,
                  initialDate: controller.date.value,
                  firstDate:   DateTime(2020),
                  lastDate:    DateTime.now(),
                  builder: (context, child) => Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: const ColorScheme.light(primary: AppTheme.primary),
                    ),
                    child: child!,
                  ),
                );
                if (picked != null) controller.setDate(picked);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color:        const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border:       Border.all(color: AppTheme.divider),
                ),
                child: Row(children: [
                  const Icon(Icons.calendar_today_outlined,
                    color: AppTheme.textSecondary, size: 20),
                  const SizedBox(width: 12),
                  Obx(() => Text(DateFormatter.formatDate(controller.date.value),
                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15))),
                ]),
              ),
            ),
            const SizedBox(height: 14),

            // Note
            TextFormField(
              controller:  controller.noteCtrl,
              maxLines:    3,
              decoration: const InputDecoration(
                labelText:  'Catatan (opsional)',
                prefixIcon:  Icon(Icons.notes),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 32),

            Obx(() => ElevatedButton(
              onPressed: controller.loading.value ? null : () {
                if (_formKey.currentState!.validate()) {
                  controller.submit();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: controller.type.value == 'income' ? AppTheme.income : AppTheme.expense,
              ),
              child: controller.loading.value
                  ? const SizedBox(width: 22, height: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(controller.isEdit ? 'Simpan Perubahan' : 'Simpan Transaksi'),
            )),
          ],
        ),
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label; final String icon;
  final bool active;  final Color color;
  final VoidCallback onTap;
  const _TypeButton({required this.label, required this.icon,
    required this.active, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:  const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color:        active ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(icon, style: TextStyle(
            fontSize: 16, color: active ? Colors.white : AppTheme.textSecondary,
            fontWeight: FontWeight.w700)),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600,
            color: active ? Colors.white : AppTheme.textSecondary)),
        ]),
      ),
    ),
  );
}
