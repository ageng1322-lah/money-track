// lib/features/dashboard/presentation/dashboard_screen.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/providers/providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashAsync = ref.watch(dashboardProvider);
    final user      = ref.watch(authProvider).valueOrNull;

    return Scaffold(
      body: dashAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
        error:   (e, _) => Center(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('⚠️', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            const Text('Gagal sinkronisasi data', style: TextStyle(color: AppTheme.textDim, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref.read(dashboardProvider.notifier).refresh(),
              style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
              child: const Text('COBA LAGI'),
            ),
          ],
        )),
        data: (data) {
          final summary  = data['summary']    as Map<String, dynamic>;
          final chart    = (data['chart_data'] as List).cast<Map<String, dynamic>>();
          final recent   = (data['recent']    as List).cast<Map<String, dynamic>>();

          return RefreshIndicator(
            color:  AppTheme.primary,
            onRefresh: () => ref.read(dashboardProvider.notifier).refresh(),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  toolbarHeight: 80,
                  title: Row(children: [
                    CircleAvatar(
                      radius:     20,
                      backgroundColor: AppTheme.primary,
                      backgroundImage: user?.photoUrl != null ? NetworkImage(user!.photoUrl!) : null,
                      child: user?.photoUrl == null
                          ? Text(user?.name[0].toUpperCase() ?? '?', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900))
                          : null,
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome back,', style: TextStyle(color: AppTheme.textDim, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
                        Text(user?.name.split(' ').first ?? 'User', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'Outfit')),
                      ],
                    ),
                  ]),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none_rounded, size: 28),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _BalanceGrid(summary: summary),
                        const SizedBox(height: 32),
                        const Text('FINANCIAL ANALYSIS', style: TextStyle(color: AppTheme.textDim, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
                        const SizedBox(height: 16),
                        _BarChartCard(chartData: chart),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('RECENT ACTIVITY', style: TextStyle(color: AppTheme.textDim, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
                            GestureDetector(
                              onTap: () => context.go('/transactions'),
                              child: const Text('SEE ALL →', style: TextStyle(color: AppTheme.primary, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...recent.map((tx) => _RecentTransactionTile(tx: tx)),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/transactions/add'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.black,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        label: const Text('NEW RECORD', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1)),
        icon: const Icon(Icons.add_rounded, size: 24),
      ),
    );
  }
}

class _BalanceGrid extends StatelessWidget {
  final Map<String, dynamic> summary;
  const _BalanceGrid({required this.summary});

  @override
  Widget build(BuildContext context) {
    final balance = (summary['balance'] as num).toDouble();
    final income  = (summary['total_income'] as num).toDouble();
    final expense = (summary['total_expense'] as num).toDouble();

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TOTAL BALANCE', style: TextStyle(color: AppTheme.textDim, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              const SizedBox(height: 12),
              Text(CurrencyFormatter.format(balance), 
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, fontFamily: 'Outfit')),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: _SummaryCard(label: 'INCOME', amount: income, color: AppTheme.income)),
          const SizedBox(width: 16),
          Expanded(child: _SummaryCard(label: 'EXPENSE', amount: expense, color: AppTheme.expense)),
        ]),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label; final double amount; final Color color;
  const _SummaryCard({required this.label, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: Colors.white.withOpacity(0.05)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AppTheme.textDim, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        Text(CurrencyFormatter.formatCompact(amount), 
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color, fontFamily: 'Outfit')),
      ],
    ),
  );
}

class _BarChartCard extends StatelessWidget {
  final List<Map<String, dynamic>> chartData;
  const _BarChartCard({required this.chartData});

  @override
  Widget build(BuildContext context) {
    final recent6 = chartData.length > 5 ? chartData.sublist(chartData.length - 5) : chartData;
    final maxVal  = recent6.fold<double>(0, (m, d) => [m, (d['income'] as num).toDouble(), (d['expense'] as num).toDouble()].reduce((a, b) => a > b ? a : b));

    return Container(
      height: 240,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: BarChart(BarChartData(
        maxY: maxVal * 1.5,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (v, _) {
              final idx = v.toInt();
              if (idx < 0 || idx >= recent6.length) return const SizedBox();
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(recent6[idx]['label'] as String, style: TextStyle(fontSize: 9, color: AppTheme.textDim, fontWeight: FontWeight.bold)),
              );
            },
          )),
        ),
        barGroups: recent6.asMap().entries.map((e) {
          return BarChartGroupData(x: e.key, barRods: [
            BarChartRodData(toY: (e.value['income'] as num).toDouble(), color: AppTheme.income, width: 10, borderRadius: BorderRadius.circular(4)),
            BarChartRodData(toY: (e.value['expense'] as num).toDouble(), color: AppTheme.expense, width: 10, borderRadius: BorderRadius.circular(4)),
          ]);
        }).toList(),
      )),
    );
  }
}

class _RecentTransactionTile extends StatelessWidget {
  final Map<String, dynamic> tx;
  const _RecentTransactionTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    final isIncome = tx['type'] == 'income';
    final cat = tx['category'] as Map<String, dynamic>?;
    final amount = (tx['amount'] as num).toDouble();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.02)),
      ),
      child: Row(children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Center(child: Text(cat?['icon'] ?? '💰', style: const TextStyle(fontSize: 20))),
        ),
        const SizedBox(width: 16),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tx['title'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(cat?['name']?.toUpperCase() ?? 'GENERAL', style: TextStyle(fontSize: 9, color: AppTheme.textDim, fontWeight: FontWeight.w900, letterSpacing: 1)),
          ],
        )),
        Text('${isIncome ? '+' : '-'}${CurrencyFormatter.formatCompact(amount)}',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, fontFamily: 'Outfit', color: isIncome ? AppTheme.income : AppTheme.expense)),
      ]),
    );
  }
}
