// lib/features/dashboard/presentation/dashboard_screen.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart' as getx;
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/widgets/animations.dart';
import '../../transaction/domain/transaction_entity.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashAsync = ref.watch(dashboardProvider);
    final user = ref.watch(authProvider).valueOrNull;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: dashAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          final summary = data['summary'] as Map<String, dynamic>;
          final chart = (data['chart_data'] as List).cast<Map<String, dynamic>>();
          final recent = (data['recent'] as List).cast<Map<String, dynamic>>();

          return CustomScrollView(
            slivers: [
                SliverAppBar(
                  floating: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  toolbarHeight: 80,
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: colorScheme.surfaceVariant,
                        backgroundImage: user?.photoUrl != null ? NetworkImage(user!.photoUrl!) : null,
                        child: user?.photoUrl == null 
                          ? Text(user?.name[0].toUpperCase() ?? '?', style: GoogleFonts.spaceGrotesk(color: AppTheme.primary, fontWeight: FontWeight.bold))
                          : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'MoneyTrack',
                        style: GoogleFonts.spaceGrotesk(
                          color: AppTheme.primary,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          shadows: [Shadow(color: AppTheme.primary.withOpacity(0.5), blurRadius: 10)],
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        // Balance Card
                        FadeInAnimation(
                          delay: const Duration(milliseconds: 100),
                          child: _BalanceCard(summary: summary)
                        ),
                        const SizedBox(height: 20),
                        // Income/Expense Cards
                        FadeInAnimation(
                          delay: const Duration(milliseconds: 200),
                          child: _IncomeExpenseRow(
                            income: (summary['total_income'] as num).toDouble(),
                            expense: (summary['total_expense'] as num).toDouble(),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Chart
                        FadeInAnimation(
                          delay: const Duration(milliseconds: 300),
                          child: _BarChartCard(chartData: chart)
                        ),
                        const SizedBox(height: 32),
                        // Recent Activity Header
                        FadeInAnimation(
                          delay: const Duration(milliseconds: 400),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Recent Activity', style: GoogleFonts.spaceGrotesk(color: colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold)),
                              GestureDetector(
                                onTap: () => getx.Get.toNamed('/transactions'),
                                child: Text('View All', style: GoogleFonts.spaceGrotesk(color: AppTheme.primary, fontSize: 14, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        FadeInAnimation(
                          delay: const Duration(milliseconds: 500),
                          child: Column(
                            children: recent.take(5).map((tx) => _RecentTransactionTile(tx: tx)).toList(),
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            );
        },
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final Map<String, dynamic> summary;
  const _BalanceCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final balance = (summary['balance'] as num).toDouble();
    final largestIncomeSource = summary['largest_income'] ?? 'Tidak ada data';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1416) : colorScheme.surfaceVariant,
        gradient: RadialGradient(
          colors: [AppTheme.primary.withOpacity(0.15), Colors.transparent],
          center: const Alignment(1.2, -1.2),
          radius: 1.5,
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppTheme.primary.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(isDark ? 0.05 : 0.03),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TOTAL PORTFOLIO BALANCE', style: GoogleFonts.spaceGrotesk(color: colorScheme.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(CurrencyFormatter.format(balance), style: GoogleFonts.spaceGrotesk(color: colorScheme.onSurface, fontSize: 40, fontWeight: FontWeight.w900)),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.analytics_rounded, color: AppTheme.primary, size: 16),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SUMBER PEMASUKAN UTAMA', style: GoogleFonts.spaceGrotesk(color: AppTheme.primary, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                    const SizedBox(height: 2),
                    Text(largestIncomeSource, style: GoogleFonts.spaceGrotesk(color: colorScheme.onSurface, fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IncomeExpenseRow extends StatelessWidget {
  final double income;
  final double expense;
  const _IncomeExpenseRow({required this.income, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummarySmallCard(
            title: 'Income',
            amount: income,
            icon: Icons.arrow_downward_rounded,
            iconColor: AppTheme.income,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SummarySmallCard(
            title: 'Expenses',
            amount: expense,
            icon: Icons.arrow_upward_rounded,
            iconColor: AppTheme.expense,
          ),
        ),
      ],
    );
  }
}

class _SummarySmallCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color iconColor;

  const _SummarySmallCard({required this.title, required this.amount, required this.icon, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1416) : colorScheme.surfaceVariant,
        gradient: RadialGradient(
          colors: [AppTheme.primary.withOpacity(0.1), Colors.transparent],
          center: const Alignment(1.5, -1.5),
          radius: 1.8,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primary.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(isDark ? 0.05 : 0.02),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 14),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title, 
                  style: GoogleFonts.spaceGrotesk(color: colorScheme.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(CurrencyFormatter.formatCompact(amount), style: GoogleFonts.spaceGrotesk(color: colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.w900)),
          ),
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
    final colorScheme = Theme.of(context).colorScheme;
    // Show months leading up to current date
    final currentMonth = DateTime.now().month;
    int startIdx = currentMonth - 6;
    if (startIdx < 0) startIdx = 0;
    
    // Ensure we take up to 6 months including the current one
    final validEnd = currentMonth <= chartData.length ? currentMonth : chartData.length;
    final recentMonths = chartData.sublist(startIdx, validEnd);
    
    double maxVal = 0;
    for (var m in recentMonths) {
      final inc = (m['income'] as num).toDouble();
      final exp = (m['expense'] as num).toDouble();
      if (inc > maxVal) maxVal = inc;
      if (exp > maxVal) maxVal = exp;
    }
    
    final computedMaxY = maxVal == 0 ? 1000.0 : maxVal * 1.3;

    return Container(
      height: 300,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        gradient: RadialGradient(
          colors: [AppTheme.primary.withOpacity(0.1), Colors.transparent],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppTheme.primary.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.05),
            blurRadius: 40,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Monthly Overview', style: GoogleFonts.spaceGrotesk(color: colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
              Row(children: [
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppTheme.income, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppTheme.expense, shape: BoxShape.circle)),
              ]),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: BarChart(
              BarChartData(
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
                      reservedSize: 30,
                      getTitlesWidget: (v, _) {
                        final idx = v.toInt();
                        if (idx < 0 || idx >= recentMonths.length) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(recentMonths[idx]['label'] as String, style: GoogleFonts.spaceGrotesk(color: colorScheme.onSurfaceVariant.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.bold)),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: recentMonths.asMap().entries.map((e) {
                  return BarChartGroupData(
                    x: e.key,
                    barsSpace: 6,
                    barRods: [
                      BarChartRodData(
                        toY: (e.value['income'] as num).toDouble(),
                        color: AppTheme.income,
                        width: 10,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                      BarChartRodData(
                        toY: (e.value['expense'] as num).toDouble(),
                        color: AppTheme.expense,
                        width: 10,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ],
                  );
                }).toList(),
              ),
              swapAnimationDuration: const Duration(milliseconds: 250),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentTransactionTile extends StatelessWidget {
  final Map<String, dynamic> tx;
  const _RecentTransactionTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isIncome = tx['type'] == 'income';
    final amount = (tx['amount'] as num).toDouble();
    final cat = tx['category'] as Map<String, dynamic>?;

    return GestureDetector(
      onTap: () => getx.Get.toNamed('/transactions/detail', arguments: TransactionEntity.fromJson(tx)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0D1416) : colorScheme.surfaceVariant,
          gradient: RadialGradient(
            colors: [AppTheme.primary.withOpacity(0.08), Colors.transparent],
            center: const Alignment(1.5, -1.5),
            radius: 2.0,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.primary.withOpacity(0.12)),
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: isDark 
                    ? colorScheme.surface 
                    : colorScheme.onSurface.withOpacity(0.05), 
                borderRadius: BorderRadius.circular(16)
              ),
              child: Center(child: Text(cat?['icon'] ?? '💰', style: const TextStyle(fontSize: 20))),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tx['title'], style: GoogleFonts.spaceGrotesk(color: colorScheme.onSurface, fontSize: 14, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(cat?['name'] ?? 'General', style: GoogleFonts.spaceGrotesk(color: colorScheme.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Text(
              '${isIncome ? '+' : '-'}${CurrencyFormatter.format(amount)}',
              style: GoogleFonts.spaceGrotesk(color: isIncome ? AppTheme.income : AppTheme.expense, fontSize: 15, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}
