import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _scaleAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.elasticOut)),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.9, curve: Curves.easeIn)),
    );
    _slideAnim = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.9, curve: Curves.easeOut)),
    );

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const LoginScreen(),
            transitionDuration: const Duration(milliseconds: 600),
            transitionsBuilder: (_, anim, __, child) {
              return FadeTransition(opacity: anim, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.bgGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Glowing background circles
            Positioned(
              top: -80,
              left: -60,
              child: _glowCircle(260, AppColors.gold.withOpacity(0.06)),
            ),
            Positioned(
              bottom: -100,
              right: -80,
              child: _glowCircle(300, AppColors.green.withOpacity(0.05)),
            ),
            // Grid pattern overlay
            Opacity(
              opacity: 0.04,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                ),
                itemBuilder: (_, __) => Container(
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white24, width: 0.3),
                  ),
                ),
              ),
            ),
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: const AppLogoWidget(size: 120),
                  ),
                  const SizedBox(height: 28),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) => Opacity(
                      opacity: _fadeAnim.value,
                      child: Transform.translate(
                        offset: Offset(0, _slideAnim.value),
                        child: Column(
                          children: [
                            const AppNameWidget(fontSize: 32),
                            const SizedBox(height: 8),
                            Text(
                              'Trade Smart. Win Big.',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 15,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold.withOpacity(0.8)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Initializing...',
                          style: TextStyle(
                            color: AppColors.textHint,
                            fontSize: 13,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Version tag at bottom
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Text(
                  'v1.0.0  •  MatkaTrading',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textHint, fontSize: 11, letterSpacing: 0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glowCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
