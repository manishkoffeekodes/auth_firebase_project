import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;

  late AnimationController _anim;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeIn));
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _onSendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // Simulate API
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            OtpVerificationScreen(email: _emailCtrl.text.trim()),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
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
              // Glows
              Positioned(
                top: -80,
                right: -50,
                child: _glow(220, AppColors.gold.withValues(alpha: 0.07)),
              ),
              Positioned(
                bottom: 60,
                left: -60,
                child: _glow(200, AppColors.green.withValues(alpha: 0.05)),
              ),
              SafeArea(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Back button
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardDark,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppColors.cardBorder),
                                  ),
                                  child: const Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: AppColors.gold,
                                      size: 18),
                                ),
                              ),
                            ),
                            const SizedBox(height: 36),

                            // Animated icon
                            _buildIconBadge(),
                            const SizedBox(height: 28),

                            // Title
                            const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.4,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'No worries! Enter your registered email and\nwe\'ll send you a verification code.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 40),

                            // Card
                            _buildCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _sectionTitle('Enter Email'),
                                  const SizedBox(height: 20),

                                  CustomTextField(
                                    controller: _emailCtrl,
                                    hint: 'Email Address',
                                    prefixIcon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (v) {
                                      if (v == null || v.isEmpty)
                                        return 'Email is required';
                                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                          .hasMatch(v))
                                        return 'Enter a valid email';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 24),

                                  _isLoading
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.gold,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : GradientButton(
                                          label: 'SEND OTP',
                                          onPressed: _onSendOtp,
                                        ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 36),

                            // Step indicator
                            _buildStepIndicator(currentStep: 1),

                            const SizedBox(height: 40),

                            // Back to Login
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.arrow_back_rounded,
                                    color: AppColors.textSecondary, size: 16),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: const Text(
                                    'Back to Sign In',
                                    style: TextStyle(
                                      color: AppColors.gold,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconBadge() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.cardDark,
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.2),
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
      ),
      child: const Icon(
        Icons.lock_reset_rounded,
        color: AppColors.gold,
        size: 46,
      ),
    );
  }

  Widget _buildStepIndicator({required int currentStep}) {
    final steps = ['Email', 'OTP', 'Reset'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(steps.length, (i) {
        final stepNum = i + 1;
        final isActive = stepNum == currentStep;
        final isDone = stepNum < currentStep;
        return Row(
          children: [
            Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive || isDone
                        ? AppColors.gold
                        : AppColors.cardDark,
                    border: Border.all(
                      color: isActive || isDone
                          ? AppColors.gold
                          : AppColors.cardBorder,
                      width: 1.5,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: AppColors.gold.withValues(alpha: 0.35),
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ]
                        : [],
                  ),
                  child: Center(
                    child: isDone
                        ? const Icon(Icons.check_rounded,
                            color: AppColors.background, size: 16)
                        : Text(
                            '$stepNum',
                            style: TextStyle(
                              color: isActive
                                  ? AppColors.background
                                  : AppColors.textHint,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  steps[i],
                  style: TextStyle(
                    color: isActive ? AppColors.gold : AppColors.textHint,
                    fontSize: 11,
                    fontWeight:
                        isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
            if (i < steps.length - 1)
              Container(
                width: 48,
                height: 1.5,
                margin: const EdgeInsets.only(bottom: 22),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDone
                        ? AppColors.goldGradient
                        : [AppColors.cardBorder, AppColors.cardBorder],
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 22,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppColors.goldGradient,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _glow(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );
}
