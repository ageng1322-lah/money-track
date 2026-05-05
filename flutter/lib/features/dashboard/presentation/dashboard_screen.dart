// lib/features/dashboard/presentation/dashboard_screen.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart' as getx;
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/widgets/animations.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashAsync = ref.watch(dashboardProvider);
    final user = ref.watch(authProvider).valueOrNull;

    return Scaffold(
      body: dashAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppTheme.primary)),
        error: (e, _) => Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('⚠️', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            const Text('Gagal sinkronisasi data',
                style: TextStyle(
                    color: AppTheme.lightTextDim, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref.read(dashboardProvider.notifier).refresh(),
              style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
              child: const Text('COBA LAGI'),
            ),
          ],
        )),
        data: (data) {
          final summary = data['summary'] as Map<String, dynamic>;
          final chart =
              (data['chart_data'] as List).cast<Map<String, dynamic>>();
          final recent = (data['recent'] as List).cast<Map<String, dynamic>>();

          return RefreshIndicator(
            color: AppTheme.primary,
            onRefresh: () => ref.read(dashboardProvider.notifier).refresh(),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  toolbarHeight: 80,
                  title: Row(children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppTheme.primary,
                      backgroundImage: user?.photoUrl != null
                          ? NetworkImage(user!.photoUrl!)
                          : null,
                      child: user?.photoUrl == null
                          ? Text(user?.name[0].toUpperCase() ?? '?',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900))
                          : null,
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome back,',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1)),
                        Text(user?.name.split(' ').first ?? 'User',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Outfit')),
                      ],
                    ),
                  ]),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none_rounded,
                          size: 28),
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
                        FadeInAnimation(
                          delay: const Duration(milliseconds: 50),
                          child: _DashboardFilter(),
                        ),
                        const SizedBox(height: 20),
                        FadeInAnimation(
                          delay: const Duration(milliseconds: 100),
                          child: _DashboardCards(summary: summary),
                        ),
                        const SizedBox(height: 32),
                        const FadeInAnimation(
                          delay: Duration(milliseconds: 200),
                          child: Text('FINANCIAL ANALYSIS',
                              style: TextStyle(
                                  color: AppTheme.lightTextDim,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2)),
                        ),
                        const SizedBox(height: 16),
                        FadeInAnimation(
                          delay: const Duration(milliseconds: 300),
                          child: _BarChartCard(chartData: chart),
                        ),
                        const SizedBox(height: 32),
                        FadeInAnimation(
                          delay: const Duration(milliseconds: 400),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('RECENT ACTIVITY',
                                  style: TextStyle(
                                      color: AppTheme.lightTextDim,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2)),
                              GestureDetector(
                                onTap: () => getx.Get.toNamed('/transactions'),
                                child: const Text('SEE ALL →',
                                    style: TextStyle(
                                        color: AppTheme.primary,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...recent.asMap().entries.map((e) => FadeInAnimation(
                              delay:
                                  Duration(milliseconds: 500 + (e.key * 100)),
                              child: _RecentTransactionTile(tx: e.value),
                            )),
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
    );
  }
}

class _DashboardCards extends StatelessWidget {
  final Map<String, dynamic> summary;
  const _DashboardCards({required this.summary});

  @override
  Widget build(BuildContext context) {
    final balance = (summary['balance'] as num).toDouble();
    final income = (summary['total_income'] as num).toDouble();
    final expense = (summary['total_expense'] as num).toDouble();
    final incomeCount = summary['income_count'] ?? 0;
    final expenseCount = summary['expense_count'] ?? 0;
    final largestIncome = summary['largest_income'] ?? 'N/A';

    final monthName = _getMonthName(summary['month'] ?? DateTime.now().month);

    return Column(
      children: [
        // Top Card: Balance
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.primary, // Using app primary color (Emerald)
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Saldo Anda',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  Row(
                    children: [
                      const Icon(Icons.wallet_outlined,
                          color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      const Text('Tersedia',
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(CurrencyFormatter.format(balance),
                  style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontFamily: 'Outfit')),
              const SizedBox(height: 12),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Middle Card: Income
        _DetailCard(
          title: 'Pemasukan Bulan Ini',
          amount: income,
          month: monthName,
          amountColor: AppTheme.income,
          details: [
            _CardDetailRow(
              label: 'SUMBER TERBESAR',
              value: largestIncome,
              valueWidget: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(largestIncome,
                    style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            _CardDetailRow(
              label: 'TOTAL TRANSAKSI',
              value: '$incomeCount transaksi',
            ),
          ],
          footer: '↑ Naik dari bulan lalu', // Placeholder trend
        ),
        const SizedBox(height: 16),

        // Bottom Card: Expense
        _DetailCard(
          title: 'Pengeluaran Bulan Ini',
          amount: expense,
          month: monthName,
          amountColor: AppTheme.expense,
          details: [
            _CardDetailRow(
              label: 'TOTAL TRANSAKSI',
              value: '$expenseCount transaksi',
            ),
          ],
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'JANUARI',
      'FEBRUARI',
      'MARET',
      'APRIL',
      'MEI',
      'JUNI',
      'JULI',
      'AGUSTUS',
      'SEPTEMBER',
      'OKTOBER',
      'NOVEMBER',
      'DESEMBER'
    ];
    return months[month - 1];
  }
}

class _DetailCard extends StatelessWidget {
  final String title;
  final double amount;
  final String month;
  final Color amountColor;
  final List<_CardDetailRow> details;
  final String? footer;

  const _DetailCard({
    required this.title,
    required this.amount,
    required this.month,
    required this.amountColor,
    required this.details,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 13,
                      fontWeight: FontWeight.w500)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined,
                        size: 12, color: AppTheme.lightTextDim),
                    const SizedBox(width: 4),
                    Text(month,
                        style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(CurrencyFormatter.format(amount),
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: amountColor,
                  fontFamily: 'Outfit')),
          const SizedBox(height: 20),
          ...details,
          if (footer != null) ...[
            const SizedBox(height: 12),
            Text(footer!,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 11)),
          ],
        ],
      ),
    );
  }
}

class _CardDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? valueWidget;

  const _CardDetailRow(
      {required this.label, required this.value, this.valueWidget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        .withOpacity(0.5),
                    shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(label,
                  style: const TextStyle(
                      color: AppTheme.textDim,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5)),
            ],
          ),
          valueWidget ??
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _BarChartCard extends StatelessWidget {
  final List<Map<String, dynamic>> chartData;
  const _BarChartCard({required this.chartData});

  @override
  Widget build(BuildContext context) {
    // Show 6 months ending in the current month
    final currentMonth = DateTime.now().month;
    int startIdx = currentMonth - 6;
    if (startIdx < 0) startIdx = 0;

    // Ensure we don't overflow if list is somehow small
    final validEnd =
        currentMonth <= chartData.length ? currentMonth : chartData.length;
    final recentMonths = chartData.sublist(startIdx, validEnd);

    final maxVal = recentMonths.fold<double>(
        0,
        (m, d) => [
              m,
              (d['income'] as num).toDouble(),
              (d['expense'] as num).toDouble()
            ].reduce((a, b) => a > b ? a : b));
    final computedMaxY = maxVal == 0 ? 1000.0 : maxVal * 1.2;

    return Container(
      height: 240,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05)),
      ),
      child: BarChart(BarChartData(
        maxY: computedMaxY,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            getTitlesWidget: (v, _) {
              final idx = v.toInt();
              if (idx < 0 || idx >= recentMonths.length)
                return const SizedBox();
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(recentMonths[idx]['label'] as String,
                    style: TextStyle(
                        fontSize: 9,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold)),
              );
            },
          )),
        ),
        barGroups: recentMonths.asMap().entries.map((e) {
          return BarChartGroupData(x: e.key, barsSpace: 4, barRods: [
            BarChartRodData(
                toY: (e.value['income'] as num).toDouble(),
                color: AppTheme.income,
                width: 8,
                borderRadius: BorderRadius.circular(4)),
            BarChartRodData(
                toY: (e.value['expense'] as num).toDouble(),
                color: AppTheme.expense,
                width: 8,
                borderRadius: BorderRadius.circular(4)),
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
        color: Theme.of(context).brightness == Brightness.dark 
            ? Theme.of(context).colorScheme.surface.withOpacity(0.5) 
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05)),
      ),
      child: Row(children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.black 
                : Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.05)),
          ),
          child: Center(
              child: Text(cat?['icon'] ?? '💰',
                  style: const TextStyle(fontSize: 20))),
        ),
        const SizedBox(width: 16),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tx['title'] as String,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(cat?['name']?.toUpperCase() ?? 'GENERAL',
                style: TextStyle(
                    fontSize: 9,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1)),
          ],
        )),
        Text(
            '${isIncome ? '+' : '-'}${CurrencyFormatter.formatCompact(amount)}',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                fontFamily: 'Outfit',
                color: isIncome ? AppTheme.income : AppTheme.expense)),
      ]),
    );
  }
}

class _DashboardFilter extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(dashboardDateProvider);
    final months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MEI',
      'JUN',
      'JUL',
      'AGU',
      'SEP',
      'OKT',
      'NOV',
      'DES'
    ];

    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(12, (index) {
                final isSelected = selectedDate.month == index + 1;
                return GestureDetector(
                  onTap: () => ref.read(dashboardDateProvider.notifier).state =
                      DateTime(selectedDate.year, index + 1),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primary
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.05),
                      ),
                    ),
                    child: Text(
                      months[index],
                      style: TextStyle(
                        color: isSelected
                            ? Colors.black
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.05)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              dropdownColor: Theme.of(context).colorScheme.surface,
              value: selectedDate.year,
              items: [2024, 2025, 2026, 2027]
                  .map((y) => DropdownMenuItem(
                        value: y,
                        child: Text(y.toString(),
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ))
                  .toList(),
              onChanged: (y) {
                if (y != null) {
                  ref.read(dashboardDateProvider.notifier).state =
                      DateTime(y, selectedDate.month);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
