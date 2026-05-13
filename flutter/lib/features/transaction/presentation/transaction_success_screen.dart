import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/animations.dart';

class TransactionSuccessScreen extends StatelessWidget {
  final double amount;
  final String categoryName;
  final String categoryIcon;
  final String type;

  const TransactionSuccessScreen({
    super.key,
    required this.amount,
    required this.categoryName,
    required this.categoryIcon,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = type == 'expense';
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                
                // Success Icon Animation
                FadeInAnimation(
                  delay: const Duration(milliseconds: 200),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withOpacity(0.4),
                                blurRadius: 30,
                                spreadRadius: 2,
                              )
                            ],
                          ),
                          child: Icon(Icons.check_rounded, color: isDark ? Colors.black : Colors.white, size: 48),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Text Content
                FadeInAnimation(
                  delay: const Duration(milliseconds: 400),
                  child: Text(
                    'Transaction\nSuccessful',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Outfit',
                      height: 1.1,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                FadeInAnimation(
                  delay: const Duration(milliseconds: 500),
                  child: Text(
                    'Your payment has been processed\nand added to your ledger securely.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // Transaction Details Card
                FadeInAnimation(
                  delay: const Duration(milliseconds: 600),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: colorScheme.onSurface.withOpacity(0.05)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'AMOUNT PROCESSED',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Icon(Icons.payments_outlined, color: colorScheme.onSurface.withOpacity(0.2), size: 24),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${isExpense ? '-' : '+'}Rp ${amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        const SizedBox(height: 24),
                        Divider(color: colorScheme.onSurface.withOpacity(0.05)),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CATEGORY',
                                    style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(categoryIcon, style: const TextStyle(fontSize: 18)),
                                      const SizedBox(width: 8),
                                      Text(
                                        categoryName,
                                        style: TextStyle(color: colorScheme.onSurface, fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'STATUS',
                                    style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: AppTheme.primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Verified',
                                        style: TextStyle(color: colorScheme.onSurface, fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 60), 
                
                // Action Buttons
                FadeInAnimation(
                  delay: const Duration(milliseconds: 800),
                  child: ElevatedButton(
                    onPressed: () => Get.offAllNamed('/transactions'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppTheme.primary.withOpacity(0.8) : AppTheme.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('View History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(width: 12),
                        Icon(Icons.history_rounded, size: 20),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                FadeInAnimation(
                  delay: const Duration(milliseconds: 900),
                  child: OutlinedButton(
                    onPressed: () => Get.offAllNamed('/dashboard'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      side: BorderSide(color: AppTheme.primary.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Back to Dashboard', style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(width: 12),
                        Icon(Icons.grid_view_rounded, color: colorScheme.onSurface, size: 20),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                FadeInAnimation(
                  delay: const Duration(milliseconds: 1000),
                  child: Text(
                    'MONEYTRACK SECURE',
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
