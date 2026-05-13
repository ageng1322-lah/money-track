import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/widgets/animations.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  double _progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        if (_progress < 0.9) {
          _progress += 0.02; // Slightly faster
        } else if (_progress < 1.0) {
          _progress += 0.01;
        } else {
          _timer?.cancel();
          _navigateToNext();
        }
      });
    });
  }

  Future<void> _navigateToNext() async {
    // Wait until auth state is not loading
    final authState = ref.read(authProvider);
    
    if (authState.isLoading) {
      // If still loading, wait a bit and try again or listen to state
      Future.delayed(const Duration(milliseconds: 500), _navigateToNext);
      return;
    }

    getx.Get.offNamed('/dashboard');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF00FFA3);
    const darkBg = Color(0xFF0B1214);

    return Scaffold(
      backgroundColor: darkBg,
      body: Stack(
        children: [
          // Background Glow
          Center(
            child: Container(
              width: 250, height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [neonGreen.withOpacity(0.1), Colors.transparent],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                // Logo Section
                FadeInAnimation(
                  delay: const Duration(milliseconds: 200),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 140, height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: neonGreen.withOpacity(0.2), width: 1),
                          ),
                        ),
                        // Small orbiting dot (static for now)
                        Positioned(
                          right: 15, top: 15,
                          child: Container(
                            width: 12, height: 12,
                            decoration: const BoxDecoration(color: neonGreen, shape: BoxShape.circle),
                          ),
                        ),
                        const Icon(Icons.account_balance_wallet_rounded, color: neonGreen, size: 60),
                        // Glow effect for icon
                        Icon(Icons.account_balance_wallet_rounded, color: neonGreen.withOpacity(0.3), size: 70),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                
                // App Name
                FadeInAnimation(
                  delay: const Duration(milliseconds: 400),
                  child: Text(
                    'MoneyTrack',
                    style: GoogleFonts.spaceGrotesk(
                      color: neonGreen,
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                      shadows: [
                        Shadow(color: neonGreen.withOpacity(0.6), blurRadius: 30),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeInAnimation(
                  delay: const Duration(milliseconds: 600),
                  child: Text(
                    'PRECISION WEALTH INTELLIGENCE',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                
                const Spacer(flex: 2),
                
                // Progress Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: _progress,
                          backgroundColor: Colors.white.withOpacity(0.05),
                          valueColor: const AlwaysStoppedAnimation<Color>(neonGreen),
                          minHeight: 3,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Syncing secure protocols...',
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                
                // Bottom Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline, color: Colors.white.withOpacity(0.2), size: 18),
                    const SizedBox(width: 20),
                    Icon(Icons.storage_rounded, color: Colors.white.withOpacity(0.2), size: 18),
                    const SizedBox(width: 20),
                    Icon(Icons.qr_code_2_rounded, color: Colors.white.withOpacity(0.2), size: 18),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
