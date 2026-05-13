// lib/shared/widgets/main_scaffold.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import '../../core/theme/app_theme.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  int _getCurrentIndex() {
    final location = getx.Get.currentRoute;
    if (location.startsWith('/summary'))      return 1;
    if (location.startsWith('/transactions')) return 3;
    if (location.startsWith('/profile') || location.startsWith('/preferences')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex();
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: child,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => getx.Get.toNamed('/transactions/add'),
        backgroundColor: AppTheme.primary,
        shape: const CircleBorder(),
        elevation: 10,
        child: Icon(Icons.add_rounded, color: isDark ? Colors.black : Colors.white, size: 32),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        color: colorScheme.surface,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: colorScheme.onSurface.withOpacity(0.05), width: 1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined, 
                activeIcon: Icons.home_rounded,
                label: 'HOME', 
                index: 0, 
                current: currentIndex,
                onTap: () => getx.Get.offNamed('/dashboard'),
              ),
              _NavItem(
                icon: Icons.analytics_outlined, 
                activeIcon: Icons.analytics_rounded,
                label: 'SUMMARY', 
                index: 1, 
                current: currentIndex,
                onTap: () => getx.Get.offNamed('/summary'),
              ),
              const SizedBox(width: 48), // Spacer for FAB
              _NavItem(
                icon: Icons.receipt_long_outlined, 
                activeIcon: Icons.receipt_long_rounded,
                label: 'HISTORY', 
                index: 3, 
                current: currentIndex,
                onTap: () => getx.Get.offNamed('/transactions'),
              ),
              _NavItem(
                icon: Icons.person_outline_rounded, 
                activeIcon: Icons.person_rounded,
                label: 'PROFILE', 
                index: 4, 
                current: currentIndex,
                onTap: () => getx.Get.offNamed('/profile'),
              ),
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
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity:  isActive ? 1.0 : 0.4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isActive ? activeIcon : icon, color: isActive ? AppTheme.primary : colorScheme.onSurface, size: 24),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(
              fontSize:   9,
              fontFamily: 'Space Grotesk',
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
              color:      isActive ? AppTheme.primary : colorScheme.onSurface,
            )),
          ],
        ),
      ),
    );
  }
}
