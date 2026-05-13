// lib/features/profile/presentation/security_screen.dart
import 'package:fintrack/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/widgets/animations.dart';

class SecurityScreen extends ConsumerStatefulWidget {
  const SecurityScreen({super.key});

  @override
  ConsumerState<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends ConsumerState<SecurityScreen> {
  final _currentController = TextEditingController();
  final _newController     = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading          = false;
  bool _obscureCurrent     = true;
  bool _obscureNew         = true;
  bool _obscureConfirm     = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (_currentController.text.isEmpty || _newController.text.isEmpty || _confirmController.text.isEmpty) {
      Get.snackbar('Error', 'Semua field harus diisi', 
        backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (_newController.text != _confirmController.text) {
      Get.snackbar('Error', 'Konfirmasi password tidak cocok', 
        backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(profileProvider.notifier).updatePassword(
        currentPassword: _currentController.text,
        newPassword:     _newController.text,
      );
      
      Get.snackbar('Berhasil', 'Password Anda telah diperbarui', 
        backgroundColor: AppTheme.primary, colorText: Colors.white);
      
      _currentController.clear();
      _newController.clear();
      _confirmController.clear();
    } catch (e) {
      Get.snackbar('Gagal', 'Terjadi kesalahan: ${e.toString()}', 
        backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      setState(() => _isLoading = false);
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
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            FadeInAnimation(
              delay: const Duration(milliseconds: 100),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Security\nSettings',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Outfit',
                        height: 1.1,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                    ),
                    child: const Text(
                      'SYSTEM PROTECTED',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            FadeInAnimation(
              delay: const Duration(milliseconds: 200),
              child: Text(
                'Manage your account protection and data privacy protocols.',
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
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0D1416) : colorScheme.surfaceVariant,
                  gradient: RadialGradient(
                    colors: [AppTheme.primary.withOpacity(0.1), Colors.transparent],
                    center: const Alignment(1.5, -1.5),
                    radius: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: AppTheme.primary.withOpacity(0.15), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.key_outlined, color: AppTheme.primary, size: 20),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Change Password',
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildFieldLabel(context, 'CURRENT PASSWORD'),
                    const SizedBox(height: 12),
                    _buildPasswordField(
                      controller: _currentController,
                      hint:       '••••••••••••',
                      obscure:    _obscureCurrent,
                      onToggle:   () => setState(() => _obscureCurrent = !_obscureCurrent),
                    ),
                    const SizedBox(height: 24),
                    _buildFieldLabel(context, 'NEW PASSWORD'),
                    const SizedBox(height: 12),
                    _buildPasswordField(
                      controller: _newController,
                      hint:       'Enter new password',
                      obscure:    _obscureNew,
                      onToggle:   () => setState(() => _obscureNew = !_obscureNew),
                    ),
                    const SizedBox(height: 24),
                    _buildFieldLabel(context, 'CONFIRM PASSWORD'),
                    const SizedBox(height: 12),
                    _buildPasswordField(
                      controller: _confirmController,
                      hint:       'Repeat new password',
                      obscure:    _obscureConfirm,
                      onToggle:   () => setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                    const SizedBox(height: 32),
                    
                    // Update Button
                    GestureDetector(
                      onTap: _isLoading ? null : _updatePassword,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isLoading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text(
                                'UPDATE PASSWORD',
                                style: TextStyle(
                                  color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              ),
                        ),
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

  Widget _buildFieldLabel(BuildContext context, String label) {
    return Text(
      label,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.onSurface.withOpacity(0.05)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: TextStyle(color: colorScheme.onSurface, fontSize: 14, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.4)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: colorScheme.onSurfaceVariant, size: 20),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }
}
