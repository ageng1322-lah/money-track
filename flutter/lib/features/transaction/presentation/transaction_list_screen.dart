// lib/features/transaction/presentation/transaction_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../domain/transaction_entity.dart';
import 'transaction_list_controller.dart';

class TransactionListScreen extends GetView<TransactionListController> {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    final controller = Get.put(TransactionListController());

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Catatan', style: TextStyle(fontSize: 22,
                  fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                Row(children: [
                  IconButton(
                    icon: const Icon(Icons.picture_as_pdf_outlined, color: AppTheme.primary),
                    onPressed: () => _exportPdf(context),
                    tooltip: 'Export PDF',
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed('/transactions/add'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color:        AppTheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(children: [
                        Icon(Icons.add, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text('Tambah', style: TextStyle(color: Colors.white,
                          fontSize: 13, fontWeight: FontWeight.w600)),
                      ]),
                    ),
                  ),
                ]),
              ],
            ),
          ),

          // Filter chips
          SizedBox(
            height: 48,
            child: Obx(() => ListView(
              padding:      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              scrollDirection: Axis.horizontal,
              children: [
                _FilterChip(label: 'Semua',       selected: controller.type.value == null,
                  onTap: () => controller.setType(null)),
                _FilterChip(label: 'Pemasukan',   selected: controller.type.value == 'income',
                  onTap: () => controller.setType('income')),
                _FilterChip(label: 'Pengeluaran', selected: controller.type.value == 'expense',
                  onTap: () => controller.setType('expense')),
                _FilterChip(label: 'Terbaru → Lama', selected: controller.order.value == 'desc',
                  onTap: () => controller.setOrder('desc')),
              ],
            )),
          ),

          // List
          Expanded(child: controller.obx(
            (paginated) {
              if (paginated == null || paginated.data.isEmpty) {
                return const Center(child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('📭', style: TextStyle(fontSize: 48)),
                    SizedBox(height: 12),
                    Text('Belum ada transaksi',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary)),
                    SizedBox(height: 4),
                    Text('Tap tombol Tambah untuk mulai mencatat',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  ],
                ));
              }

              // Group by date
              final grouped = <String, List<TransactionEntity>>{};
              for (final tx in paginated.data) {
                final key = DateFormatter.relativeDate(tx.date);
                grouped.putIfAbsent(key, () => []).add(tx);
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                itemCount: grouped.length,
                itemBuilder: (context, i) {
                  final dateKey = grouped.keys.elementAt(i);
                  final txList  = grouped[dateKey]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(dateKey, style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary)),
                      ),
                      ...txList.map((tx) => _TransactionTile(
                        tx: tx,
                        onTap:    () => Get.toNamed('/transactions/edit/${tx.id}'),
                        onDelete: () => _confirmDelete(context, tx.id),
                      )),
                    ],
                  );
                },
              );
            },
            onLoading: const Center(child: CircularProgressIndicator()),
            onError: (error) => Center(child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: AppTheme.textSecondary, size: 48),
                const SizedBox(height: 12),
                Text(error ?? 'Terjadi kesalahan',
                  style: const TextStyle(color: AppTheme.textSecondary),
                  textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchTransactions(),
                  child: const Text('Coba lagi'),
                ),
              ],
            )),
          )),
        ]),
      ),
    );
  }

  void _exportPdf(BuildContext context) {
    Get.snackbar('Berhasil', 'Mengekspor laporan PDF...', 
      backgroundColor: AppTheme.primary, colorText: Colors.white);
  }

  void _confirmDelete(BuildContext context, int id) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus transaksi?'),
        content: const Text('Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteTransaction(id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.expense),
            child: const Text('Hapus'),
          ),
        ],
      )
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label; final bool selected; final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color:        selected ? AppTheme.primary : AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border:       Border.all(color: selected ? AppTheme.primary : AppTheme.divider),
      ),
      child: Text(label, style: TextStyle(
        fontSize:   12,
        fontWeight: FontWeight.w500,
        color:      selected ? Colors.white : AppTheme.textSecondary,
      )),
    ),
  );
}

class _TransactionTile extends StatelessWidget {
  final TransactionEntity tx;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  const _TransactionTile({required this.tx, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key:         Key('tx-${tx.id}'),
      direction:   DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding:   const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color:        AppTheme.expense,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color:        AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border:       Border.all(color: AppTheme.divider, width: 0.5),
          ),
          child: Row(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: tx.isIncome ? AppTheme.primaryLight : const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(tx.category?.icon ?? '💰',
                style: const TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.title, style: const TextStyle(fontSize: 14,
                  fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
                  overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(tx.category?.name ?? 'Umum',
                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              ],
            )),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('${tx.isIncome ? '+' : '-'}${CurrencyFormatter.formatCompact(tx.amount)}',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                  color: tx.isIncome ? AppTheme.income : AppTheme.expense)),
            ]),
          ]),
        ),
      ),
    );
  }
}
