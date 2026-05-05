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
    if (location.startsWith('/profile'))      return 3;
    if (location.startsWith('/setting'))      return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex();

    return Scaffold(
      body: child,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => getx.Get.toNamed('/transactions/add'),
        backgroundColor: AppTheme.primary,
        shape: const CircleBorder(),
        elevation: 4,
        child: Icon(Icons.add_rounded, color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white, size: 32),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05), width: 1)),
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
                icon: Icons.receipt_long_outlined, 
                activeIcon: Icons.receipt_long_rounded,
                label: 'TRANSAKSI', 
                index: 1, 
                current: currentIndex,
                onTap: () => getx.Get.offNamed('/transactions'),
              ),
              const SizedBox(width: 48), // Spacer for FAB
              _NavItem(
                icon: Icons.person_outline_rounded, 
                activeIcon: Icons.person_rounded,
                label: 'PROFILE', 
                index: 3, 
                current: currentIndex,
                onTap: () => getx.Get.offNamed('/profile'),
              ),
              _NavItem(
                icon: Icons.settings_outlined, 
                activeIcon: Icons.settings_rounded,
                label: 'SETTING', 
                index: 4, 
                current: currentIndex,
                onTap: () => getx.Get.offNamed('/setting'),
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
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity:  isActive ? 1.0 : 0.4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isActive ? activeIcon : icon, color: isActive ? AppTheme.primary : Theme.of(context).colorScheme.onSurface.withOpacity(0.4), size: 24),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(
            fontSize:   9,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            color:      isActive ? AppTheme.primary : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          )),
        ],
      ),
    ),
  );
}
