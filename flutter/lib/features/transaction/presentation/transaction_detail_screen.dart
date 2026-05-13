import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/animations.dart';
import '../../../core/utils/receipt_helper.dart';
import '../domain/transaction_entity.dart';

class TransactionDetailScreen extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionDetailScreen({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == 'expense';
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Transaction Details',
          style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            children: [
              // Icon Section
              FadeInAnimation(
                delay: const Duration(milliseconds: 100),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0D1416) : colorScheme.surfaceVariant,
                    gradient: RadialGradient(
                      colors: [AppTheme.primary.withOpacity(0.1), Colors.transparent],
                      center: const Alignment(1.5, -1.5),
                      radius: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppTheme.primary.withOpacity(0.12)),
                  ),
                    child: Text(
                      transaction.category?.icon ?? '💰',
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Title & Amount
              FadeInAnimation(
                delay: const Duration(milliseconds: 200),
                child: Column(
                  children: [
                    Text(
                      transaction.title,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${isExpense ? '-' : '+'}Rp ${transaction.amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: TextStyle(
                        color: isExpense ? AppTheme.expense : AppTheme.income,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Outfit',
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Status Badge
              FadeInAnimation(
                delay: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.check_circle, color: AppTheme.primary, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Completed',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Info Card
              FadeInAnimation(
                delay: const Duration(milliseconds: 400),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0D1416) : colorScheme.surfaceVariant,
                    gradient: RadialGradient(
                      colors: [AppTheme.primary.withOpacity(0.08), Colors.transparent],
                      center: const Alignment(1.5, -1.5),
                      radius: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppTheme.primary.withOpacity(0.12)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(context, 'DATE', DateFormat('MMM dd, yyyy').format(transaction.date)),
                      const SizedBox(height: 24),
                      _buildInfoRow(context, 'TIME', DateFormat('HH:mm a').format(transaction.date) + ' EST'),
                      const SizedBox(height: 24),
                      _buildCategoryRow(context, 'CATEGORY', transaction.category?.name ?? 'Uncategorized', transaction.category?.icon ?? '📁'),
                      if (transaction.note != null && transaction.note!.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Divider(color: colorScheme.onSurface.withOpacity(0.05)),
                        const SizedBox(height: 24),
                        Text(
                          'NOTE',
                          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          transaction.note!,
                          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.8), fontSize: 14, height: 1.5),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Action Buttons
              FadeInAnimation(
                delay: const Duration(milliseconds: 500),
                child: ElevatedButton(
                  onPressed: () => ReceiptHelper.generateAndShareReceipt(transaction),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppTheme.primary.withOpacity(0.8) : AppTheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.download_rounded, size: 20),
                      SizedBox(width: 12),
                      Text('Download Receipt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              FadeInAnimation(
                delay: const Duration(milliseconds: 600),
                child: OutlinedButton(
                  onPressed: () => Get.toNamed('/transactions/edit/${transaction.id}'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    side: BorderSide(color: colorScheme.onSurface.withOpacity(0.1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit_note_rounded, color: colorScheme.onSurface, size: 22),
                      const SizedBox(width: 12),
                      Text('Edit Transaction', style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(color: colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Outfit'),
        ),
      ],
    );
  }

  Widget _buildCategoryRow(BuildContext context, String label, String name, String icon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(icon, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(width: 12),
            Text(
              name,
              style: TextStyle(color: colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
