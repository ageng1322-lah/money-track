// lib/features/profile/presentation/profile_screen.dart
import 'package:fintrack/shared/widgets/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).valueOrNull;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (user == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Header
            FadeInAnimation(
              delay: const Duration(milliseconds: 50),
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.primary, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: colorScheme.surfaceVariant,
                        backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                        child: user.photoUrl == null
                            ? Text(user.name[0].toUpperCase(), style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: colorScheme.onSurface))
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FadeInAnimation(
              delay: const Duration(milliseconds: 150),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: colorScheme.onSurface,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.checklist, color: AppTheme.primary, size: 14),
                        SizedBox(width: 6),
                        Text(
                          'VERIFIED',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Settings List
            FadeInAnimation(
              delay: const Duration(milliseconds: 250),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'SETTINGS',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SettingsTile(
                    icon: Icons.person_outline,
                    iconColor: AppTheme.primary,
                    title: 'Personal Info',
                    subtitle: 'Manage profile details',
                    onTap: () => Get.toNamed('/profile/edit'),
                  ),
                  const SizedBox(height: 12),
                  _SettingsTile(
                    icon: Icons.shield_outlined,
                    iconColor: Colors.blueAccent,
                    title: 'Security',
                    subtitle: '2FA, Keys & Passwords',
                    onTap: () => Get.toNamed('/profile/security'),
                  ),
                  const SizedBox(height: 12),
                  _SettingsTile(
                    icon: Icons.settings_outlined,
                    iconColor: Colors.purpleAccent,
                    title: 'Preferences',
                    subtitle: 'Notifications & Theme',
                    onTap: () => Get.toNamed('/preferences'),
                  ),
                  const SizedBox(height: 12),
                  _SettingsTile(
                    icon: Icons.help_outline,
                    iconColor: Colors.amber,
                    title: 'Help & Support',
                    subtitle: 'FAQs & Live Chat',
                    onTap: () => Get.toNamed('/profile/help'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Logout Button
            FadeInAnimation(
              delay: const Duration(milliseconds: 350),
              child: GestureDetector(
                onTap: () => _confirmLogout(context, ref),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: isDark 
                        ? colorScheme.error.withOpacity(0.1) 
                        : Colors.red.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.red.withOpacity(0.1)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
                      SizedBox(width: 12),
                      Text(
                        'Log Out',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: colorScheme.onSurface.withOpacity(0.05)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.withOpacity(0.2)),
                ),
                child: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 28),
              ),
              const SizedBox(height: 24),
              Text(
                'Confirm Logout',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to log out? You will need to sign back in to access your secure MoneyTrack portfolio.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  await ref.read(authProvider.notifier).logout();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: const Center(
                    child: Text(
                      'LOG OUT',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline_rounded, color: colorScheme.onSurfaceVariant.withOpacity(0.4), size: 14),
                  const SizedBox(width: 8),
                  Text(
                    'SECURE SESSION KEY',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0D1416) : colorScheme.surfaceVariant,
          gradient: RadialGradient(
            colors: [AppTheme.primary.withOpacity(0.08), Colors.transparent],
            center: const Alignment(1.5, -1.5),
            radius: 2.2,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.primary.withOpacity(0.12)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(isDark ? 0.05 : 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: colorScheme.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }
}
