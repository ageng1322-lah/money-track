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
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: dashAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error:   (e, _) => Center(child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Gagal memuat data', style: TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.read(dashboardProvider.notifier).refresh(),
                child: const Text('Coba lagi'),
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
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  // Header
                  Row(children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Halo, ${user?.name.split(' ').first ?? 'Pengguna'} 👋',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary)),
                        const SizedBox(height: 4),
                        Text(DateFormatter.formatMonth(
                          summary['month'] as int, summary['year'] as int),
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                      ],
                    )),
                    CircleAvatar(
                      radius:     22,
                      backgroundColor: AppTheme.primaryLight,
                      backgroundImage: user?.photoUrl != null
                          ? NetworkImage(user!.photoUrl!) : null,
                      child: user?.photoUrl == null
                          ? Text(user?.name[0].toUpperCase() ?? '?',
                              style: const TextStyle(color: AppTheme.primary,
                                fontWeight: FontWeight.w700, fontSize: 17))
                          : null,
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // Balance Card
                  _BalanceCard(summary: summary),
                  const SizedBox(height: 20),

                  // Bar Chart
                  _BarChartCard(chartData: chart),
                  const SizedBox(height: 20),

                  // Recent Transactions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Transaksi Terbaru',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary)),
                      GestureDetector(
                        onTap: () => context.go('/transactions'),
                        child: const Text('Lihat semua',
                          style: TextStyle(color: AppTheme.primary, fontSize: 13,
                            fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...recent.map((tx) => _RecentTransactionTile(tx: tx)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final Map<String, dynamic> summary;
  const _BalanceCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final balance = (summary['balance'] as num).toDouble();
    final income  = (summary['total_income'] as num).toDouble();
    final expense = (summary['total_expense'] as num).toDouble();

    return Container(
      padding:       const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D9E75), Color(0xFF0F6E56)],
          begin:  Alignment.topLeft,
          end:    Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(
          color:   AppTheme.primary.withOpacity(.35),
          blurRadius:  20,
          offset:      const Offset(0, 8),
        )],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Saldo Bulan Ini',
            style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 8),
          Text(CurrencyFormatter.format(balance),
            style: const TextStyle(color: Colors.white, fontSize: 28,
              fontWeight: FontWeight.w700, letterSpacing: -0.5)),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: _IncExpItem(
              label: 'Pemasukan', amount: income,
              icon:  Icons.arrow_downward_rounded, color: Colors.white,
            )),
            Container(width: 1, height: 40, color: Colors.white24),
            Expanded(child: _IncExpItem(
              label: 'Pengeluaran', amount: expense,
              icon:  Icons.arrow_upward_rounded, color: Colors.white70,
            )),
          ]),
        ],
      ),
    );
  }
}

class _IncExpItem extends StatelessWidget {
  final String label; final double amount;
  final IconData icon; final Color color;
  const _IncExpItem({required this.label, required this.amount,
    required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Row(children: [
      Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
          color: Colors.white12, borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 16),
      ),
      const SizedBox(width: 10),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
          style: const TextStyle(color: Colors.white70, fontSize: 11)),
        Text(CurrencyFormatter.formatCompact(amount),
          style: const TextStyle(color: Colors.white, fontSize: 13,
            fontWeight: FontWeight.w600)),
      ]),
    ]),
  );
}

class _BarChartCard extends StatelessWidget {
  final List<Map<String, dynamic>> chartData;
  const _BarChartCard({required this.chartData});

  @override
  Widget build(BuildContext context) {
    final recent6 = chartData.length > 6
        ? chartData.sublist(chartData.length - 6) : chartData;
    final maxVal  = recent6.fold<double>(0, (m, d) =>
        [m, (d['income'] as num).toDouble(), (d['expense'] as num).toDouble()]
            .reduce((a, b) => a > b ? a : b));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:        AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border:       Border.all(color: AppTheme.divider, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pemasukan vs Pengeluaran',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Row(children: [
            _Legend(color: AppTheme.income,  label: 'Pemasukan'),
            const SizedBox(width: 16),
            _Legend(color: AppTheme.expense, label: 'Pengeluaran'),
          ]),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: BarChart(BarChartData(
              maxY:           maxVal * 1.2,
              gridData:       FlGridData(show: false),
              borderData:     FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles:   AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:  AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(sideTitles: SideTitles(
                  showTitles:   true,
                  reservedSize: 26,
                  getTitlesWidget: (v, _) {
                    final idx = v.toInt();
                    if (idx < 0 || idx >= recent6.length) return const SizedBox();
                    return Text(recent6[idx]['label'] as String,
                      style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary));
                  },
                )),
              ),
              barGroups: recent6.asMap().entries.map((e) {
                final idx     = e.key;
                final income  = (e.value['income']  as num).toDouble();
                final expense = (e.value['expense'] as num).toDouble();
                return BarChartGroupData(x: idx, barRods: [
                  BarChartRodData(toY: income,  color: AppTheme.income,
                    width: 8, borderRadius: BorderRadius.circular(3)),
                  BarChartRodData(toY: expense, color: AppTheme.expense,
                    width: 8, borderRadius: BorderRadius.circular(3)),
                ]);
              }).toList(),
            )),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color; final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Row(children: [
    Container(width: 10, height: 10, decoration: BoxDecoration(
      color: color, borderRadius: BorderRadius.circular(2))),
    const SizedBox(width: 4),
    Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
  ]);
}

class _RecentTransactionTile extends StatelessWidget {
  final Map<String, dynamic> tx;
  const _RecentTransactionTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    final isIncome = tx['type'] == 'income';
    final cat      = tx['category'] as Map<String, dynamic>?;
    final amount   = (tx['amount'] as num).toDouble();

    return Container(
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
            color:        isIncome ? AppTheme.primaryLight : const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text(cat?['icon'] ?? '💰',
            style: const TextStyle(fontSize: 18))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tx['title'] as String,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary),
              overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text(cat?['name'] ?? 'Umum',
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          ],
        )),
        Text('${isIncome ? '+' : '-'}${CurrencyFormatter.formatCompact(amount)}',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
            color: isIncome ? AppTheme.income : AppTheme.expense)),
      ]),
    );
  }
}
