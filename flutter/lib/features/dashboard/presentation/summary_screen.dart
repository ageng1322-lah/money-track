// lib/features/dashboard/presentation/summary_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/widgets/animations.dart';

class SummaryScreen extends ConsumerWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashAsync = ref.watch(dashboardProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header matching TransactionListScreen
            FadeInAnimation(
              delay: const Duration(milliseconds: 50),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Text(
                  'Financial Summary',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1B5E20),
                    fontFamily: 'Outfit',
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Filters
            FadeInAnimation(
              delay: const Duration(milliseconds: 100),
              child: const _SummaryFilter()
            ),
            
            Expanded(
              child: dashAsync.maybeWhen(
                data: (data) => _buildSummaryContent(context, data),
                orElse: () {
                  if (dashAsync.hasValue) {
                    return _buildSummaryContent(context, dashAsync.value!);
                  }
                  if (dashAsync.hasError && !dashAsync.hasValue) {
                    return Center(child: Text('Error: ${dashAsync.error}'));
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

  Widget _buildSummaryContent(BuildContext context, Map<String, dynamic> data) {
    final summary = data['summary'] as Map<String, dynamic>;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        children: [
          FadeInAnimation(
            delay: const Duration(milliseconds: 100),
            child: _SummaryDetailCard(
              title: 'Pemasukan',
              amount: (summary['total_income'] as num).toDouble(),
              amountColor: AppTheme.income,
              icon: Icons.trending_up_rounded,
              details: [
                _SummaryRow(label: 'SUMBER TERBESAR', value: summary['largest_income'] ?? 'N/A', isHighlight: true),
                _SummaryRow(label: 'TOTAL TRANSAKSI', value: '${summary['income_count'] ?? 0} Transaksi'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FadeInAnimation(
            delay: const Duration(milliseconds: 200),
            child: _SummaryDetailCard(
              title: 'Pengeluaran',
              amount: (summary['total_expense'] as num).toDouble(),
              amountColor: AppTheme.expense,
              icon: Icons.trending_down_rounded,
              details: [
                _SummaryRow(label: 'TOTAL TRANSAKSI', value: '${summary['expense_count'] ?? 0} Transaksi'),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _SummaryFilter extends ConsumerWidget {
  const _SummaryFilter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(dashboardDateProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final months = ['JAN','FEB','MAR','APR','MEI','JUN','JUL','AGU','SEP','OKT','NOV','DES'];

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: List.generate(12, (index) {
              final isSelected = selectedDate.month == index + 1;
              return GestureDetector(
                onTap: () => ref.read(dashboardDateProvider.notifier).state = DateTime(selectedDate.year, index + 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary : colorScheme.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppTheme.primary : colorScheme.onSurface.withOpacity(0.05),
                    ),
                  ),
                  child: Text(
                    months[index], 
                    style: GoogleFonts.spaceGrotesk(
                      color: isSelected 
                        ? (isDark ? Colors.black : Colors.white) 
                        : colorScheme.onSurfaceVariant, 
                      fontSize: 12, 
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    )
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.onSurface.withOpacity(0.05)),
                ),
                child: DropdownButton<int>(
                  value: selectedDate.year,
                  underline: const SizedBox(),
                  dropdownColor: colorScheme.surface,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
                  items: [2024, 2025, 2026, 2027].map((y) => DropdownMenuItem(
                    value: y, 
                    child: Text(
                      y.toString(), 
                      style: GoogleFonts.spaceGrotesk(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      )
                    )
                  )).toList(),
                  onChanged: (y) { if (y != null) ref.read(dashboardDateProvider.notifier).state = DateTime(y, selectedDate.month); },
                ),
              ),
              const Spacer(),
              Text(
                'FILTER BY PERIOD',
                style: GoogleFonts.spaceGrotesk(
                  color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _SummaryDetailCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color amountColor;
  final IconData icon;
  final List<_SummaryRow> details;

  const _SummaryDetailCard({
    required this.title, 
    required this.amount, 
    required this.amountColor, 
    required this.icon,
    required this.details
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1416) : colorScheme.surfaceVariant,
        gradient: RadialGradient(
          colors: [AppTheme.primary.withOpacity(0.12), Colors.transparent],
          center: const Alignment(1.2, -1.2),
          radius: 1.5,
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppTheme.primary.withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(isDark ? 0.05 : 0.02),
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
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: amountColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: amountColor, size: 20),
              ),
              Text(
                title.toUpperCase(), 
                style: GoogleFonts.spaceGrotesk(
                  color: colorScheme.onSurfaceVariant, 
                  fontSize: 11, 
                  fontWeight: FontWeight.w900, 
                  letterSpacing: 1.5
                )
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            CurrencyFormatter.format(amount), 
            style: GoogleFonts.spaceGrotesk(
              color: colorScheme.onSurface, 
              fontSize: 32, 
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            )
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? colorScheme.surface.withOpacity(0.5) : Colors.black.withOpacity(0.02),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colorScheme.onSurface.withOpacity(0.05)),
            ),
            child: Column(
              children: details,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;
  const _SummaryRow({required this.label, required this.value, this.isHighlight = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label, 
              style: GoogleFonts.spaceGrotesk(
                color: colorScheme.onSurfaceVariant.withOpacity(0.6), 
                fontSize: 10, 
                fontWeight: FontWeight.w800, 
                letterSpacing: 0.5
              )
            ),
          ),
          if (isHighlight) 
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1), 
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
              ),
              child: Text(
                value, 
                style: GoogleFonts.spaceGrotesk(
                  color: AppTheme.primary, 
                  fontSize: 11, 
                  fontWeight: FontWeight.w900
                )
              ),
            )
          else
            Text(
              value, 
              style: GoogleFonts.spaceGrotesk(
                color: colorScheme.onSurface, 
                fontSize: 13, 
                fontWeight: FontWeight.bold
              )
            ),
        ],
      ),
    );
  }
}
