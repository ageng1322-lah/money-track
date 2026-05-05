// lib/features/profile/presentation/setting_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/widgets/animations.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          FadeInAnimation(
            delay: const Duration(milliseconds: 100),
            child: Text('APPEARANCE', 
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1)),
          ),
          const SizedBox(height: 20),
          FadeInAnimation(
            delay: const Duration(milliseconds: 200),
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
          const SizedBox(height: 40),
          FadeInAnimation(
            delay: const Duration(milliseconds: 300),
            child: Text('ACCOUNT', 
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1)),
          ),
          const SizedBox(height: 20),
          FadeInAnimation(
            delay: const Duration(milliseconds: 400),
            child: _LogoutButton(
              onTap: () => _confirmLogout(context, ref),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('LOGOUT?', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w900)),
        content: Text('Are you sure you want to exit?', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('CANCEL', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authProvider.notifier).logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.expense, minimumSize: const Size(100, 45)),
            child: const Text('LOGOUT'),
          ),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isActive ? AppTheme.primary.withOpacity(0.5) : Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.yellow[600]),
            const SizedBox(height: 16),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.primary,
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

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            const Icon(Icons.logout_rounded, color: AppTheme.expense),
            const SizedBox(width: 14),
            const Text(
              'LOGOUT ACCOUNT',
              style: TextStyle(
                color: AppTheme.expense,
                fontWeight: FontWeight.w900,
                fontSize: 14,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
