// lib/features/auth/presentation/otp_verification_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart' as getx;
import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/widgets/animations.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  
  int _secondsRemaining = 60;
  Timer? _timer;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  String _formatTime(int seconds) {
    final mins = (seconds / 60).floor();
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _verify() async {
    final otp = _controllers.map((c) => c.text.trim()).join();
    if (otp.length != 4) {
      setState(() => _error = 'Kode OTP harus 4 digit');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await ref.read(authProvider.notifier).verifyOtp(otp);
      
      // Wait a tiny bit for the provider state to propagate if needed
      final updatedState = ref.read(authProvider);
      
      if (updatedState.hasError) {
        final errorMsg = updatedState.error.toString();
        setState(() {
          _error = errorMsg.contains('422') ? 'Invalid OTP code. Please try again.' : errorMsg;
        });
      } else if (updatedState.hasValue && updatedState.value != null) {
        if (updatedState.value!.isVerified) {
          getx.Get.offAllNamed('/dashboard');
        } else {
          setState(() => _error = 'Verification failed. Please try again.');
        }
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resend() async {
    if (_secondsRemaining > 0) return;
    
    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).resendOtp();
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP code resent successfully')),
      );
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF00FFA3);
    const darkBg = Color(0xFF000000);
    const cardBg = Color(0xFF0D1416);

    return Scaffold(
      backgroundColor: darkBg,
      body: Stack(
        children: [
          // Glows
          Positioned(
            top: 100, left: -50,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [neonGreen.withOpacity(0.05), Colors.transparent],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 100),
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: cardBg,
                          gradient: RadialGradient(
                            colors: [neonGreen.withOpacity(0.1), Colors.transparent],
                            center: const Alignment(1.5, -1.5),
                            radius: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: neonGreen.withOpacity(0.12)),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 40, offset: const Offset(0, 20)),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Icon Box
                            Container(
                              width: 64, height: 64,
                              decoration: BoxDecoration(
                                color: neonGreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: neonGreen.withOpacity(0.2)),
                              ),
                              child: const Icon(Icons.lock_outline_rounded, color: neonGreen, size: 32),
                            ),
                            const SizedBox(height: 32),
                            
                            Text(
                              'Verify Identity',
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Enter the 4-digit code sent to your\nemail.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 48),

                            // OTP Fields
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(4, (index) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: _buildOtpBox(index),
                              )),
                            ),
                            const SizedBox(height: 48),

                            if (_error != null) ...[
                              Text(
                                _error!,
                                style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Verify Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _verify,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: neonGreen,
                                  foregroundColor: Colors.black,
                                  disabledBackgroundColor: neonGreen.withOpacity(0.3),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: _isLoading ? 0 : 8,
                                  shadowColor: neonGreen.withOpacity(0.5),
                                ),
                                child: _isLoading
                                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3))
                                    : Text(
                                        'VERIFY ACCOUNT',
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Resend
                            Text(
                              "Didn't receive the code?",
                              style: GoogleFonts.spaceGrotesk(color: Colors.white.withOpacity(0.5), fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: _resend,
                              child: RichText(
                                text: TextSpan(
                                  text: 'Resend Code',
                                  style: GoogleFonts.spaceGrotesk(
                                    color: _secondsRemaining == 0 ? neonGreen : Colors.white.withOpacity(0.3),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    if (_secondsRemaining > 0)
                                      TextSpan(
                                        text: ' (${_formatTime(_secondsRemaining)})',
                                        style: TextStyle(color: Colors.white.withOpacity(0.3), fontWeight: FontWeight.normal),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 300),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.verified_user_outlined, color: Colors.white.withOpacity(0.3), size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'SECURE ENCRYPTION',
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.white.withOpacity(0.3),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
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

  Widget _buildOtpBox(int index) {
    const neonGreen = Color(0xFF00FFA3);
    final isFocused = _focusNodes[index].hasFocus;
    final hasValue = _controllers[index].text.isNotEmpty;

    return Container(
      width: 56, height: 68,
      decoration: BoxDecoration(
        color: const Color(0xFF121B1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFocused ? neonGreen : Colors.white.withOpacity(0.05),
          width: 2,
        ),
        boxShadow: isFocused ? [
          BoxShadow(color: neonGreen.withOpacity(0.15), blurRadius: 15, spreadRadius: 1)
        ] : null,
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
            style: GoogleFonts.spaceGrotesk(
              color: hasValue ? neonGreen : Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
              hintText: '0',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.05), fontSize: 28),
              contentPadding: EdgeInsets.zero,
            ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              if (index < 3) {
                _focusNodes[index + 1].requestFocus();
              } else {
                _focusNodes[index].unfocus();
              }
            } else {
              if (index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
            }
            setState(() {});
          },
        ),
      ),
    );
  }
}
