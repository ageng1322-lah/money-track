// lib/features/auth/presentation/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey    = GlobalKey<FormState>();
  final _emailCtrl  = TextEditingController();
  final _passCtrl   = TextEditingController();
  bool  _obscure    = true;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _error = null);

    await ref.read(authProvider.notifier).login(
      _emailCtrl.text.trim(),
      _passCtrl.text,
    );

    if (mounted) {
      final state = ref.read(authProvider);
      state.whenOrNull(
        error: (e, _) => setState(() => _error = e.toString()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authProvider).isLoading;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),

                // Logo & title
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    color:        AppTheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text('₿', style: TextStyle(fontSize: 28, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Selamat datang',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 8),
                const Text('Masuk ke akun FinTrack Anda',
                  style: TextStyle(fontSize: 15, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 40),

                // Error banner
                if (_error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:        const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(10),
                      border:       Border.all(color: AppTheme.expense.withOpacity(.3)),
                    ),
                    child: Row(children: [
                      const Icon(Icons.error_outline, color: AppTheme.expense, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_error!,
                        style: const TextStyle(color: AppTheme.expense, fontSize: 13))),
                    ]),
                  ),
                  const SizedBox(height: 16),
                ],

                // Email
                TextFormField(
                  controller:  _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText:   'Email',
                    prefixIcon:  Icon(Icons.email_outlined),
                  ),
                  validator: (v) => (v == null || !v.contains('@'))
                      ? 'Email tidak valid' : null,
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText:  'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) => (v == null || v.length < 8)
                      ? 'Minimal 8 karakter' : null,
                ),
                const SizedBox(height: 32),

                // Submit
                ElevatedButton(
                  onPressed: loading ? null : _submit,
                  child: loading
                      ? const SizedBox(width: 22, height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Masuk'),
                ),
                const SizedBox(height: 20),

                // Register link
                Center(
                  child: GestureDetector(
                    onTap: () => context.go('/register'),
                    child: RichText(text: const TextSpan(
                      text: 'Belum punya akun? ',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                      children: [TextSpan(
                        text:  'Daftar sekarang',
                        style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600),
                      )],
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
