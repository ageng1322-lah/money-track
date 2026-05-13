// lib/features/auth/presentation/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart' as getx;
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/widgets/animations.dart';

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
  bool  _obscureConf = true;
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
            getx.Get.toNamed('/verify-otp');
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
    const neonGreen = Color(0xFF00FFA3);
    const darkBg = Color(0xFF000000);
    const cardBg = Color(0xFF0D1416);

    return Scaffold(
      backgroundColor: darkBg,
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100, right: -50,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [neonGreen.withOpacity(0.1), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100, left: -100,
            child: Container(
              width: 400, height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [neonGreen.withOpacity(0.05), Colors.transparent],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    // Header
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 100),
                      child: Text(
                        'Join the Future',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.spaceGrotesk(
                          color: neonGreen,
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          shadows: [
                            Shadow(color: neonGreen.withOpacity(0.5), blurRadius: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        'Secure your digital assets with\nnext-gen intelligence.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    if (_error != null) ...[
                      FadeInAnimation(
                        delay: Duration.zero,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.red.withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
                              const SizedBox(width: 12),
                              Expanded(child: Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Card Container
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 300),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: cardBg,
                          gradient: RadialGradient(
                            colors: [neonGreen.withOpacity(0.1), Colors.transparent],
                            center: const Alignment(1.5, -1.5),
                            radius: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: neonGreen.withOpacity(0.12)),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 40, offset: const Offset(0, 20)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Full Name'),
                            _buildTextField(
                              controller: _nameCtrl,
                              hint: 'John Doe',
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 20),

                            _buildFieldLabel('Digital Identity (Email)'),
                            _buildTextField(
                              controller: _emailCtrl,
                              hint: 'name@neotrack.io',
                              icon: Icons.alternate_email,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 20),

                            _buildFieldLabel('Access Key (Password)'),
                            _buildTextField(
                              controller: _passCtrl,
                              hint: '••••••••••••',
                              icon: Icons.lock_outline,
                              isPassword: true,
                              obscureText: _obscure,
                              onToggleObscure: () => setState(() => _obscure = !_obscure),
                            ),
                            const SizedBox(height: 20),

                            _buildFieldLabel('Confirm Access Key (Password)'),
                            _buildTextField(
                              controller: _confCtrl,
                              hint: '••••••••••••',
                              icon: Icons.lock_outline,
                              isPassword: true,
                              obscureText: _obscureConf,
                              onToggleObscure: () => setState(() => _obscureConf = !_obscureConf),
                            ),
                            const SizedBox(height: 32),

                            // Submit Button
                            Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(color: neonGreen.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: loading ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: neonGreen,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  elevation: 0,
                                ),
                                child: loading
                                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3))
                                    : Text('Create Account', style: GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.w900)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Footer
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 400),
                      child: Center(
                        child: GestureDetector(
                          onTap: () => getx.Get.back(),
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: GoogleFonts.spaceGrotesk(color: Colors.white.withOpacity(0.6), fontSize: 15, fontWeight: FontWeight.w500),
                              children: [
                                TextSpan(
                                  text: 'Login',
                                  style: GoogleFonts.spaceGrotesk(color: neonGreen, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: GoogleFonts.spaceGrotesk(color: Colors.white.withOpacity(0.8), fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleObscure,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.4), size: 20),
        suffixIcon: isPassword && onToggleObscure != null
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: Colors.white.withOpacity(0.4),
                  size: 20,
                ),
                onPressed: onToggleObscure,
              )
            : null,
        filled: true,
        fillColor: const Color(0xFF121B1E),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.05))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF00FFA3), width: 1)),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Required';
        if (keyboardType == TextInputType.emailAddress && !v.contains('@')) return 'Invalid email';
        if (isPassword && v.length < 8) return 'Min 8 characters';
        return null;
      },
    );
  }
}
