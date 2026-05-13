// lib/features/profile/presentation/setting_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/widgets/animations.dart';

class PreferencesScreen extends ConsumerWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeModeProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        children: [
          const SizedBox(height: 10),
          FadeInAnimation(
            delay: const Duration(milliseconds: 100),
            child: Text(
              'App Preferences',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'Outfit',
              ),
            ),
          ),
          const SizedBox(height: 8),
          FadeInAnimation(
            delay: const Duration(milliseconds: 200),
            child: Text(
              'Manage your digital command center settings and display options.',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 40),
          FadeInAnimation(
            delay: const Duration(milliseconds: 300),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.palette_outlined, color: AppTheme.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Appearance',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FadeInAnimation(
            delay: const Duration(milliseconds: 400),
            child: Row(
              children: [
                Expanded(
                  child: _ThemeCard(
                    label: 'DARK MODE',
                    icon: Icons.nightlight_round,
                    isActive: currentTheme == ThemeMode.dark,
                    onTap: () => ref.read(themeModeProvider.notifier).state = ThemeMode.dark,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ThemeCard(
                    label: 'LIGHT MODE',
                    icon: Icons.wb_sunny_rounded,
                    isActive: currentTheme == ThemeMode.light,
                    onTap: () => ref.read(themeModeProvider.notifier).state = ThemeMode.light,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isActive ? AppTheme.primary : colorScheme.onSurface.withOpacity(0.05),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: isActive ? AppTheme.primary : colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppTheme.primary : colorScheme.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
