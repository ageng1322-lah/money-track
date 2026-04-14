// lib/features/auth/presentation/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart' as getx;
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
      ref.read(authProvider).when(
        data: (user) {
          if (user != null) {
            getx.Get.offAllNamed('/dashboard');
          }
        },
        error: (e, _) => setState(() => _error = e.toString()),
        loading: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authProvider).isLoading;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: -100, left: -100,
            child: Container(width: 300, height: 300, decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(150))),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                      onPressed: () => getx.Get.back(),
                    ),
                    const SizedBox(height: 32),
                    const Text('CREATE ACCOUNT', style: TextStyle(color: AppTheme.textDim, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    const SizedBox(height: 8),
                    const Text('Join the Tribe.', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, fontFamily: 'Outfit', fontStyle: FontStyle.italic)),
                    const SizedBox(height: 12),
                    const Text('Start your professional financial journey.', style: TextStyle(color: AppTheme.textDim, fontSize: 15, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 48),

                    if (_error != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.expense.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.expense.withOpacity(0.2)),
                        ),
                        child: Text(_error!, style: const TextStyle(color: AppTheme.expense, fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 24),
                    ],

                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: 'FULL NAME', hintText: 'M. Fauzi'),
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'EMAIL ADDRESS', hintText: 'name@domain.com'),
                      validator: (v) => (v == null || !v.contains('@')) ? 'Invalid email' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passCtrl,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        labelText: 'PASSWORD',
                        hintText: '••••••••',
                        suffixIcon: IconButton(
                          icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppTheme.textDim, size: 20),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: (v) => (v == null || v.length < 8) ? 'Min 8 characters' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _confCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'CONFIRM PASSWORD', hintText: 'Confirm your password'),
                      validator: (v) => v != _passCtrl.text ? 'Passwords do not match' : null,
                    ),
                    const SizedBox(height: 40),

                    ElevatedButton(
                      onPressed: loading ? null : _submit,
                      child: loading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3))
                          : const Text('CREATE ACCOUNT'),
                    ),
                    const SizedBox(height: 32),

                    Center(
                      child: GestureDetector(
                        onTap: () => getx.Get.back(),
                        child: RichText(text: const TextSpan(
                          text: "Already joined? ",
                          style: TextStyle(color: AppTheme.textDim, fontSize: 14, fontWeight: FontWeight.w600),
                          children: [TextSpan(
                            text: 'Sign in',
                            style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w900),
                          )],
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
