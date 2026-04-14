// lib/features/auth/presentation/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _confCtrl  = TextEditingController();
  bool  _obscure   = true;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose();
    _passCtrl.dispose(); _confCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _error = null);

    await ref.read(authProvider.notifier).register(
      _nameCtrl.text.trim(),
      _emailCtrl.text.trim(),
      _passCtrl.text,
    );

    if (mounted) {
      ref.read(authProvider).whenOrNull(
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
                const SizedBox(height: 32),
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () => context.go('/login'),
                ),
                const SizedBox(height: 16),
                const Text('Buat akun baru',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 8),
                const Text('Mulai kelola keuangan Anda dengan FinTrack',
                  style: TextStyle(fontSize: 15, color: AppTheme.textSecondary)),
                const SizedBox(height: 32),

                if (_error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:  const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.expense.withOpacity(.3)),
                    ),
                    child: Text(_error!,
                      style: const TextStyle(color: AppTheme.expense, fontSize: 13)),
                  ),
                  const SizedBox(height: 16),
                ],

                TextFormField(
                  controller:  _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nama lengkap',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller:   _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText:  'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (v) => (v == null || !v.contains('@'))
                      ? 'Email tidak valid' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller:  _passCtrl,
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
                const SizedBox(height: 14),
                TextFormField(
                  controller:  _confCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText:  'Konfirmasi password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (v) => v != _passCtrl.text
                      ? 'Password tidak cocok' : null,
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: loading ? null : _submit,
                  child: loading
                      ? const SizedBox(width: 22, height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Daftar'),
                ),
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () => context.go('/login'),
                    child: RichText(text: const TextSpan(
                      text: 'Sudah punya akun? ',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                      children: [TextSpan(
                        text: 'Masuk',
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
