// lib/shared/widgets/main_scaffold.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  int _getCurrentIndex() {
    final location = Get.currentRoute;
    if (location.startsWith('/transactions')) return 1;
    if (location.startsWith('/profile'))      return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex();

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color:  AppTheme.surface,
          border: Border(top: BorderSide(color: AppTheme.divider, width: 0.5)),
          boxShadow: [BoxShadow(
            color:  Colors.black.withOpacity(.04),
            blurRadius: 20, offset: const Offset(0, -4),
          )],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.home_outlined,      activeIcon: Icons.home,
                  label: 'Home',    index: 0, current: currentIndex,
                  onTap: () => Get.offNamed('/dashboard')),
                _NavItem(icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long,
                  label: 'Catatan', index: 1, current: currentIndex,
                  onTap: () => Get.offNamed('/transactions')),
                _NavItem(icon: Icons.person_outline,     activeIcon: Icons.person,
                  label: 'Profil',  index: 2, current: currentIndex,
                  onTap: () => Get.offNamed('/profile')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon; final IconData activeIcon;
  final String label;  final int index; final int current;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.activeIcon, required this.label,
    required this.index, required this.current, required this.onTap});

  bool get isActive => index == current;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color:        isActive ? AppTheme.primaryLight : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(isActive ? activeIcon : icon,
          color: isActive ? AppTheme.primary : AppTheme.textSecondary, size: 22),
        const SizedBox(height: 3),
        Text(label, style: TextStyle(
          fontSize:   10,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          color:      isActive ? AppTheme.primary : AppTheme.textSecondary,
        )),
      ]),
    ),
  );
}
