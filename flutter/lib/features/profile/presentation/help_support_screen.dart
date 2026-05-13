import 'package:fintrack/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:url_launcher/url_launcher.dart';
import '../../../shared/widgets/animations.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  Future<void> _launchWhatsApp() async {
    final phoneNumber = "6285545061475";
    final message = "Halo Admin MoneyTrack, saya butuh bantuan...";
    
    final httpsUrl = Uri.parse("https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");
    final whatsappUrl = Uri.parse("whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}");
    
    try {
      // First attempt with https
      if (await canLaunchUrl(httpsUrl)) {
        await launchUrl(httpsUrl, mode: LaunchMode.externalApplication);
      } 
      // Fallback to whatsapp:// scheme
      else if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      }
      else {
        throw 'Could not launch WhatsApp';
      }
    } catch (e) {
      getx.Get.snackbar(
        'WhatsApp Error',
        'Gagal membuka WhatsApp. Pastikan aplikasi sudah terinstall.',
        backgroundColor: getx.Get.theme.colorScheme.surface,
        colorText: Colors.redAccent,
        snackPosition: getx.SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => getx.Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            FadeInAnimation(
              delay: const Duration(milliseconds: 100),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0D1416) : colorScheme.surfaceVariant,
                  gradient: RadialGradient(
                    colors: [AppTheme.primary.withOpacity(0.12), Colors.transparent],
                    center: const Alignment(1.5, -1.5),
                    radius: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.primary.withOpacity(0.2), width: 1.5),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.support_agent, color: AppTheme.primary, size: 40),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'How can we help?',
                      style: TextStyle(color: colorScheme.onSurface, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We are here to support your financial journey with MoneyTrack.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6), fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // FAQs Section
            FadeInAnimation(
              delay: const Duration(milliseconds: 200),
              child: Text(
                'Frequently Asked Questions',
                style: TextStyle(color: colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            _buildFAQTile(
              context,
              'What is MoneyTrack?',
              'MoneyTrack is a premium personal finance manager designed to help you track expenses, manage budgets, and reach your financial goals with ease.',
              const Duration(milliseconds: 300),
            ),
            _buildFAQTile(
              context,
              'Is my data secure?',
              'Yes, all your data is stored securely and encrypted. We prioritize your privacy and ensure that only you can access your financial records.',
              const Duration(milliseconds: 400),
            ),
            _buildFAQTile(
              context,
              'How to add a transaction?',
              'Simply tap the "+" button in the center of the navigation bar, fill in the amount, category, and description, then save.',
              const Duration(milliseconds: 500),
            ),
            _buildFAQTile(
              context,
              'Can I export my data?',
              'Data export features are currently in development and will be available in future updates.',
              const Duration(milliseconds: 600),
            ),
            const SizedBox(height: 40),

            // Contact Admin Button
            FadeInAnimation(
              delay: const Duration(milliseconds: 700),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
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
                child: Column(
                  children: [
                    Text(
                      'Still need help?',
                      style: TextStyle(color: colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Our team is ready to assist you directly via WhatsApp.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _launchWhatsApp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: isDark ? Colors.black : Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.chat_bubble_outline, size: 20),
                          const SizedBox(width: 12),
                          Text('Talk to Admin', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQTile(BuildContext context, String question, String answer, Duration delay) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return FadeInAnimation(
      delay: delay,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0D1416) : colorScheme.surfaceVariant,
          gradient: RadialGradient(
            colors: [AppTheme.primary.withOpacity(0.08), Colors.transparent],
            center: const Alignment(1.5, -1.5),
            radius: 2.5,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primary.withOpacity(0.12)),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              question,
              style: TextStyle(color: colorScheme.onSurface, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            iconColor: AppTheme.primary,
            collapsedIconColor: colorScheme.onSurfaceVariant.withOpacity(0.3),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            expandedAlignment: Alignment.topLeft,
            children: [
              Text(
                answer,
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6), fontSize: 13, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
