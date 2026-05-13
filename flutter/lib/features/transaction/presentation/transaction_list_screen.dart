// lib/features/transaction/presentation/transaction_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart' as getx;
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/widgets/animations.dart';
import '../domain/transaction_entity.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(transactionListProvider);
    final filter = ref.watch(transactionFilterProvider);
    final deletedIds = ref.watch(deletedTransactionIdsProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Text(
                'Transactions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1B5E20),
                  fontFamily: 'Outfit',
                ),
              ),
            ),

            // Search and Filter Bar
            FadeInAnimation(
              delay: const Duration(milliseconds: 50),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: isDark ? colorScheme.surfaceVariant : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: isDark ? [] : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          onChanged: (v) => ref.read(transactionFilterProvider.notifier).state = filter.copyWith(search: v),
                          decoration: InputDecoration(
                            hintText: 'Search transactions...',
                            hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.5)),
                            prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.tune_rounded, color: AppTheme.primary),
                              onPressed: () => _showFilterSheet(context, ref),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Transaction List
            Expanded(
              child: txAsync.maybeWhen(
                data: (paginated) => _buildTransactionList(context, ref, paginated, deletedIds),
                orElse: () {
                  if (txAsync.hasValue) {
                    return _buildTransactionList(context, ref, txAsync.value!, deletedIds);
                  }
                  if (txAsync.hasError && !txAsync.hasValue) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: 400,
                        alignment: Alignment.center,
                        child: Text(txAsync.error.toString(), style: TextStyle(color: colorScheme.onSurfaceVariant)),
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator(color: AppTheme.primary));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(BuildContext context, WidgetRef ref, PaginatedTransactions paginated, Set<int> deletedIds) {
    // Filter out locally deleted transactions
    final activeData = paginated.data.where((tx) => !deletedIds.contains(tx.id)).toList();

    if (activeData.isEmpty) {
      return _buildEmptyState(context);
    }

    // Group by date and calculate daily sum
    final grouped = <DateTime, List<TransactionEntity>>{};
    final dailyTotals = <DateTime, double>{};
    
    for (final tx in activeData) {
      final dateKey = DateTime(tx.date.year, tx.date.month, tx.date.day);
      grouped.putIfAbsent(dateKey, () => []).add(tx);
      
      final amount = tx.isIncome ? tx.amount : -tx.amount;
      dailyTotals[dateKey] = (dailyTotals[dateKey] ?? 0) + amount;
    }

    final sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: sortedDates.length,
      itemBuilder: (context, i) {
        final date = sortedDates[i];
        final txList = grouped[date]!;
        final dailyTotal = dailyTotals[date]!;
        
        String dateLabel;
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final yesterday = today.subtract(const Duration(days: 1));

        if (date == today) {
          dateLabel = 'Today';
        } else if (date == yesterday) {
          dateLabel = 'Yesterday';
        } else {
          dateLabel = DateFormat('MMMM dd').format(date);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateHeader(context, dateLabel, dailyTotal),
            const SizedBox(height: 12),
            ...txList.map((tx) => FadeInAnimation(
              delay: const Duration(milliseconds: 100),
              child: _TransactionTile(
                tx: tx,
                onTap: () => getx.Get.toNamed('/transactions/detail', arguments: tx),
                onConfirmDismiss: () => _confirmDelete(context, ref, tx.id),
                onDismissed: () async {
                  // Add to deleted set immediately for optimistic UI
                  ref.read(deletedTransactionIdsProvider.notifier).update((state) => {...state, tx.id});
                  
                  await ref.read(transactionRepositoryProvider).deleteTransaction(tx.id);
                  ref.invalidate(transactionListProvider);
                  ref.read(dashboardProvider.notifier).refresh();
                  
                  // Clean up the deleted set after some time or when sync is done
                  Future.delayed(const Duration(seconds: 1), () {
                    ref.read(deletedTransactionIdsProvider.notifier).update(
                      (state) => state.where((id) => id != tx.id).toSet(),
                    );
                  });
                },
              ),
            )),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildDateHeader(BuildContext context, String label, double total) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              fontFamily: 'Outfit',
            ),
          ),
          Text(
            CurrencyFormatter.format(total),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📭', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              'NO RECORDS YET',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => getx.Get.toNamed('/transactions/add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('CREATE ONE'),
            )
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(transactionFilterProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filter Transactions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              children: [
                _FilterChip(
                  label: 'ALL',
                  selected: filter.type == null,
                  onTap: () {
                    ref.read(transactionFilterProvider.notifier).state = filter.copyWith(clearType: true);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 12),
                _FilterChip(
                  label: 'INCOME',
                  selected: filter.type == 'income',
                  onTap: () {
                    ref.read(transactionFilterProvider.notifier).state = filter.copyWith(type: 'income');
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 12),
                _FilterChip(
                  label: 'EXPENSE',
                  selected: filter.type == 'expense',
                  onTap: () {
                    ref.read(transactionFilterProvider.notifier).state = filter.copyWith(type: 'expense');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, WidgetRef ref, int id) async {
    return await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('DELETE RECORD?', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w900)),
        content: Text('This entry will be permanently removed from your history.', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('CANCEL', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.expense, minimumSize: const Size(100, 45)),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label; final bool selected; final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? AppTheme.primary : colorScheme.onSurface.withOpacity(0.05)),
        ),
        child: Text(label, style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
          color: selected 
              ? (isDark ? Colors.black : Colors.white) 
              : colorScheme.onSurfaceVariant,
        )),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionEntity tx;
  final VoidCallback onTap;
  final Future<bool?> Function() onConfirmDismiss;
  final VoidCallback onDismissed;
  
  const _TransactionTile({
    required this.tx, 
    required this.onTap, 
    required this.onConfirmDismiss,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: Key('tx-${tx.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => onConfirmDismiss(),
      onDismissed: (_) => onDismissed(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.expense,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 28),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0D1416) : colorScheme.surfaceVariant,
          gradient: RadialGradient(
            colors: [AppTheme.primary.withOpacity(0.08), Colors.transparent],
            center: const Alignment(1.5, -1.5),
            radius: 2.0,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.primary.withOpacity(0.12)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(isDark ? 0.05 : 0.02),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isDark 
                        ? colorScheme.surface 
                        : const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      tx.category?.icon ?? '💰', 
                      style: const TextStyle(fontSize: 24)
                    )
                  ),
                ),
                const SizedBox(width: 16),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx.title, 
                        style: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold, 
                          color: colorScheme.onSurface
                        ), 
                        overflow: TextOverflow.ellipsis
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tx.category?.name?.toUpperCase() ?? 'GENERAL', 
                          style: const TextStyle(
                            fontSize: 9, 
                            color: AppTheme.primary, 
                            fontWeight: FontWeight.w900, 
                            letterSpacing: 0.5
                          )
                        ),
                      ),
                    ],
                  ),
                ),
                // Amount and Time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${tx.isIncome ? '+' : '-'}${CurrencyFormatter.formatCompact(tx.amount)}',
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.w900, 
                        fontFamily: 'Outfit', 
                        color: tx.isIncome ? AppTheme.income : AppTheme.expense
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('hh:mm a').format(tx.date),
                      style: TextStyle(
                        fontSize: 11, 
                        color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
