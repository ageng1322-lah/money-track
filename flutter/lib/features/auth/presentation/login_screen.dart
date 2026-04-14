// lib/features/auth/presentation/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart' as getx;
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
      state.when(
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
          // Background Decoration
          Positioned(
            top: -100, right: -100,
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
                    const SizedBox(height: 60),

                    // Logo
                    Container(
                      width: 64, height: 64,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                      ),
                      child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.black, size: 32),
                    ),
                    const SizedBox(height: 32),
                    const Text('WELCOME BACK', style: TextStyle(color: AppTheme.textDim, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    const SizedBox(height: 8),
                    const Text('MoneyTrack.', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, fontFamily: 'Outfit', fontStyle: FontStyle.italic)),
                    const SizedBox(height: 12),
                    const Text('Manage your future wealth today.', style: TextStyle(color: AppTheme.textDim, fontSize: 15, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 56),

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
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'EMAIL ADDRESS',
                        hintText: 'name@domain.com',
                      ),
                      validator: (v) => (v == null || !v.contains('@')) ? 'Invalid email' : null,
                    ),
                    const SizedBox(height: 20),

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
                    const SizedBox(height: 48),

                    ElevatedButton(
                      onPressed: loading ? null : _submit,
                      child: loading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3))
                          : const Text('SIGN IN NOW'),
                    ),
                    const SizedBox(height: 32),

                    Center(
                      child: GestureDetector(
                        onTap: () => getx.Get.toNamed('/register'),
                        child: RichText(text: const TextSpan(
                          text: "New here? ",
                          style: TextStyle(color: AppTheme.textDim, fontSize: 14, fontWeight: FontWeight.w600),
                          children: [TextSpan(
                            text: 'Create account',
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
