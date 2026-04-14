// lib/features/transaction/presentation/transaction_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/providers/providers.dart';
import '../domain/transaction_entity.dart';

final _transactionListProvider = FutureProvider.autoDispose<PaginatedTransactions>((ref) async {
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

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(_transactionListProvider);
    final filter  = ref.watch(transactionFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('RECORDING'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined, color: AppTheme.primary),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(children: [
        // Filter section
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(children: [
            _FilterChip(label: 'ALL', selected: filter.type == null, 
              onTap: () => ref.read(transactionFilterProvider.notifier).state = filter.copyWith(clearType: true)),
            const SizedBox(width: 8),
            _FilterChip(label: 'INCOME', selected: filter.type == 'income', 
              onTap: () => ref.read(transactionFilterProvider.notifier).state = filter.copyWith(type: 'income')),
            const SizedBox(width: 8),
            _FilterChip(label: 'EXPENSE', selected: filter.type == 'expense', 
              onTap: () => ref.read(transactionFilterProvider.notifier).state = filter.copyWith(type: 'expense')),
          ]),
        ),

        Expanded(child: txAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
          error:   (e, _) => Center(child: Text(e.toString(), style: const TextStyle(color: AppTheme.textDim))),
          data: (paginated) {
            if (paginated.data.isEmpty) {
              return Center(child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('📭', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  const Text('NO RECORDS YET', style: TextStyle(color: AppTheme.textDim, fontWeight: FontWeight.w900, letterSpacing: 2)),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => context.push('/transactions/add'),
                    style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
                    child: const Text('CREATE ONE'),
                  )
                ],
              ));
            }

            // Group by date
            final grouped = <String, List<TransactionEntity>>{};
            for (final tx in paginated.data) {
              final key = DateFormat('EEEE, dd MMMM').format(tx.date);
              grouped.putIfAbsent(key, () => []).add(tx);
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: grouped.length,
              itemBuilder: (context, i) {
                final dateKey = grouped.keys.elementAt(i);
                final txList  = grouped[dateKey]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(dateKey.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.textDim, letterSpacing: 1.5)),
                    ),
                    ...txList.map((tx) => _TransactionTile(
                      tx: tx,
                      onTap:    () => context.push('/transactions/edit/${tx.id}'),
                      onDelete: () => _confirmDelete(context, ref, tx.id),
                    )),
                  ],
                );
              },
            );
          },
        )),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/transactions/add'),
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add_rounded, color: Colors.black, size: 32),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('DELETE RECORD?', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w900)),
        content: const Text('This entry will be permanently removed from your history.', style: TextStyle(color: AppTheme.textDim)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: AppTheme.textDim, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(transactionRepositoryProvider).deleteTransaction(id);
              ref.invalidate(_transactionListProvider);
              ref.read(dashboardProvider.notifier).refresh();
            },
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
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color:        selected ? AppTheme.primary : AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border:       Border.all(color: selected ? AppTheme.primary : Colors.white10),
      ),
      child: Text(label, style: TextStyle(
        fontSize:   10,
        fontWeight: FontWeight.w900,
        letterSpacing: 1,
        color:      selected ? Colors.black : AppTheme.textDim,
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
        padding:   const EdgeInsets.only(right: 24),
        margin:    const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color:        AppTheme.expense,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(Icons.delete_sweep_rounded, color: Colors.black, size: 28),
      ),
      onDismissed: (_) => onDelete(),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          margin:  const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color:        AppTheme.surface,
            borderRadius: BorderRadius.circular(24),
            border:       Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(child: Text(tx.category?.icon ?? '💰', style: const TextStyle(fontSize: 20))),
            ),
            const SizedBox(width: 16),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(tx.category?.name?.toUpperCase() ?? 'GENERAL', style: TextStyle(fontSize: 9, color: AppTheme.textDim, fontWeight: FontWeight.w900, letterSpacing: 1)),
              ],
            )),
            Text('${tx.isIncome ? '+' : '-'}${CurrencyFormatter.formatCompact(tx.amount)}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, fontFamily: 'Outfit', color: tx.isIncome ? AppTheme.income : AppTheme.expense)),
          ]),
        ),
      ),
    );
  }
}
