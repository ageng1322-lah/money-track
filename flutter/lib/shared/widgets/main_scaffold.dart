// lib/shared/widgets/main_scaffold.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import '../../core/theme/app_theme.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  int _getCurrentIndex() {
    final location = getx.Get.currentRoute;
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
        padding: const EdgeInsets.only(top: 12, bottom: 0),
        decoration: BoxDecoration(
          color:  AppTheme.background,
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05), width: 1)),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.grid_view_rounded, activeIcon: Icons.grid_view_rounded,
                label: 'HOME',    index: 0, current: currentIndex,
                onTap: () => getx.Get.offNamed('/dashboard')),
              _NavItem(icon: Icons.receipt_long_rounded, activeIcon: Icons.receipt_long_rounded,
                label: 'RECORDS', index: 1, current: currentIndex,
                onTap: () => getx.Get.offNamed('/transactions')),
              _NavItem(icon: Icons.person_rounded,     activeIcon: Icons.person_rounded,
                label: 'PROFILE',  index: 2, current: currentIndex,
                onTap: () => getx.Get.offNamed('/profile')),
            ],
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
    behavior: HitTestBehavior.opaque,
    child: AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity:  isActive ? 1.0 : 0.4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isActive ? activeIcon : icon, color: isActive ? AppTheme.primary : Colors.white, size: 24),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(
            fontSize:   9,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            color:      isActive ? AppTheme.primary : Colors.white,
          )),
          const SizedBox(height: 12),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isActive ? 4 : 0,
            height: 4,
            decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
          ),
        ],
      ),
    ),
  );
}
