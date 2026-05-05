// lib/features/profile/presentation/profile_screen.dart
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
    if (user == null) return const SizedBox();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ACCOUNT SETTINGS'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Profile Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05)),
            ),
            child: Row(children: [
              CircleAvatar(
                radius:          32,
                backgroundColor: AppTheme.primary,
                backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                child: user.photoUrl == null
                    ? Text(user.name[0].toUpperCase(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white))
                    : null,
              ),
              const SizedBox(width: 20),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'Outfit')),
                  const SizedBox(height: 4),
                  Text(user.email, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              )),
            ]),
          ),
          const SizedBox(height: 40),

          Text('PREFERENCES', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
          const SizedBox(height: 16),
          _MenuSection(items: [
            _MenuItem(icon: Icons.person_outline_rounded, label: 'Personal Information', onTap: () => Get.toNamed('/profile/edit')),
            _MenuItem(icon: Icons.shield_outlined, label: 'Security & Password', onTap: () {}),
          ]),
          const SizedBox(height: 24),

          Text('APP SETTINGS', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
          const SizedBox(height: 16),
          _MenuSection(items: [
            _MenuItem(icon: Icons.notifications_none_rounded, label: 'Notification Settings', onTap: () {}),
            _MenuItem(icon: Icons.color_lens_outlined, label: 'Appearance (Dark Mode)', onTap: () {}),
          ]),
          const SizedBox(height: 24),

          _MenuSection(items: [
            _MenuItem(icon: Icons.logout_rounded, label: 'Sign Out Account', color: AppTheme.expense, 
              onTap: () => _confirmLogout(context, ref)),
          ]),
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
        title: const Text('SIGN OUT?', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w900)),
        content: Text('Are you sure you want to log out from MoneyTrack?', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('CANCEL', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold))),
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

class _MenuSection extends StatelessWidget {
  final List<_MenuItem> items;
  const _MenuSection({required this.items});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color:        Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(24),
      border:       Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05)),
    ),
    child: Column(
      children: items.asMap().entries.map((e) {
        final item = e.value;
        final last = e.key == items.length - 1;
        return Column(children: [
          ListTile(
            onTap: item.onTap,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            leading: Icon(item.icon, color: item.color ?? AppTheme.primary, size: 22),
            title: Text(item.label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: item.color ?? Theme.of(context).colorScheme.onSurface)),
            trailing: Icon(Icons.chevron_right_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
          ),
          if (!last) Divider(height: 1, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05), indent: 16, endIndent: 16),
        ]);
      }).toList(),
    ),
  );
}

class _MenuItem {
  final IconData icon; final String label; final Color? color; final VoidCallback onTap;
  const _MenuItem({required this.icon, required this.label, required this.onTap, this.color});
}
