// lib/features/profile/presentation/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).valueOrNull;
    if (user == null) return const SizedBox();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 8),
            const Text('Profil', style: TextStyle(fontSize: 22,
              fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
            const SizedBox(height: 24),

            // Avatar + info
            Center(child: Column(children: [
              Stack(children: [
                CircleAvatar(
                  radius:          44,
                  backgroundColor: AppTheme.primaryLight,
                  backgroundImage: user.photoUrl != null
                      ? NetworkImage(user.photoUrl!) : null,
                  child: user.photoUrl == null
                      ? Text(user.name[0].toUpperCase(),
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700,
                            color: AppTheme.primary))
                      : null,
                ),
                Positioned(bottom: 0, right: 0, child: Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color:        AppTheme.primary,
                    shape:        BoxShape.circle,
                    border:       Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                )),
              ]),
              const SizedBox(height: 12),
              Text(user.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary)),
              const SizedBox(height: 4),
              Text(user.email,
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
            ])),
            const SizedBox(height: 32),

            // Menu
            _MenuSection(items: [
              _MenuItem(icon: Icons.person_outline,  label: 'Edit profil',
                onTap: () {}),
              _MenuItem(icon: Icons.lock_outline,    label: 'Ubah password',
                onTap: () {}),
            ]),
            const SizedBox(height: 12),
            _MenuSection(items: [
              _MenuItem(icon: Icons.category_outlined, label: 'Kategori kustom',
                onTap: () {}),
              _MenuItem(icon: Icons.notifications_outlined, label: 'Notifikasi',
                onTap: () {}),
              _MenuItem(icon: Icons.dark_mode_outlined, label: 'Mode gelap',
                onTap: () {}),
            ]),
            const SizedBox(height: 12),
            _MenuSection(items: [
              _MenuItem(icon: Icons.logout, label: 'Keluar',
                color: AppTheme.expense,
                onTap: () => _confirmLogout(context, ref)),
            ]),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar dari akun?'),
        content: const Text('Anda akan keluar dari FinTrack.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authProvider.notifier).logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.expense),
            child: const Text('Keluar'),
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
      color:        AppTheme.surface,
      borderRadius: BorderRadius.circular(16),
      border:       Border.all(color: AppTheme.divider, width: 0.5),
    ),
    child: Column(
      children: items.asMap().entries.map((e) {
        final item = e.value;
        final last = e.key == items.length - 1;
        return Column(children: [
          InkWell(
            onTap:        item.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color:        (item.color ?? AppTheme.primary).withOpacity(.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.icon, color: item.color ?? AppTheme.primary, size: 18),
                ),
                const SizedBox(width: 14),
                Expanded(child: Text(item.label, style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w500,
                  color:    item.color ?? AppTheme.textPrimary))),
                Icon(Icons.chevron_right, color: AppTheme.textSecondary.withOpacity(.5), size: 20),
              ]),
            ),
          ),
          if (!last) Divider(height: 1, color: AppTheme.divider.withOpacity(.7),
            indent: 66, endIndent: 16),
        ]);
      }).toList(),
    ),
  );
}

class _MenuItem {
  final IconData icon;
  final String   label;
  final Color?   color;
  final VoidCallback onTap;
  const _MenuItem({required this.icon, required this.label,
    required this.onTap, this.color});
}
