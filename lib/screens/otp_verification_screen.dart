import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'reset_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  // 4 OTP boxes
  final List<TextEditingController> _otpCtrl =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  bool _isResending = false;
  int _resendSeconds = 60;
  Timer? _timer;

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
    _startResendTimer();
  }

  void _startResendTimer() {
    _resendSeconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_resendSeconds <= 0) {
        t.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    _timer?.cancel();
    for (final c in _otpCtrl) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  String get _fullOtp => _otpCtrl.map((c) => c.text).join();

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  void _onVerify() async {
    if (_fullOtp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter the complete 6-digit OTP'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            ResetPasswordScreen(email: widget.email),
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

  void _onResend() async {
    if (_resendSeconds > 0) return;
    setState(() => _isResending = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isResending = false);
    for (final c in _otpCtrl) c.clear();
    _focusNodes[0].requestFocus();
    _startResendTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('OTP resent successfully!'),
        backgroundColor: AppColors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
              Positioned(
                top: -80,
                left: -50,
                child: _glow(220, AppColors.gold.withValues(alpha: 0.07)),
              ),
              Positioned(
                bottom: 80,
                right: -60,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Back
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.cardDark,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: AppColors.cardBorder),
                                ),
                                child: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: AppColors.gold,
                                    size: 18),
                              ),
                            ),
                          ),
                          const SizedBox(height: 36),

                          // Icon Badge
                          _buildIconBadge(),
                          const SizedBox(height: 28),

                          const Text(
                            'Verify OTP',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(height: 10),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                  height: 1.6),
                              children: [
                                const TextSpan(
                                    text: 'We\'ve sent a 6-digit code to\n'),
                                TextSpan(
                                  text: widget.email,
                                  style: const TextStyle(
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),

                          // OTP Card
                          _buildCard(
                            child: Column(
                              children: [
                                _sectionTitle('Enter OTP'),
                                const SizedBox(height: 24),

                                // OTP Boxes
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: List.generate(6, (i) => _otpBox(i)),
                                ),
                                const SizedBox(height: 28),

                                _isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.gold,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : GradientButton(
                                        label: 'VERIFY OTP',
                                        onPressed: _onVerify,
                                      ),
                                const SizedBox(height: 20),

                                // Resend
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Didn't receive OTP? ",
                                      style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 13),
                                    ),
                                    _resendSeconds > 0
                                        ? Text(
                                            'Resend in ${_resendSeconds}s',
                                            style: TextStyle(
                                              color: AppColors.textHint,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: _onResend,
                                            child: _isResending
                                                ? const SizedBox(
                                                    width: 16,
                                                    height: 16,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: AppColors.gold,
                                                    ),
                                                  )
                                                : const Text(
                                                    'Resend OTP',
                                                    style: TextStyle(
                                                      color: AppColors.gold,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 36),

                          // Step indicator
                          _buildStepIndicator(currentStep: 2),
                        ],
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

  Widget _otpBox(int index) {
    final isFilled = _otpCtrl[index].text.isNotEmpty;
    return SizedBox(
      width: 46,
      height: 54,
      child: TextField(
        controller: _otpCtrl[index],
        focusNode: _focusNodes[index],
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (v) => _onOtpChanged(v, index),
        style: TextStyle(
          color: isFilled ? AppColors.gold : AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: isFilled
              ? AppColors.gold.withValues(alpha: 0.08)
              : AppColors.surface,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isFilled ? AppColors.gold : AppColors.cardBorder,
              width: isFilled ? 1.5 : 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isFilled ? AppColors.gold : AppColors.cardBorder,
              width: isFilled ? 1.5 : 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.gold, width: 2),
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
      child: const Icon(Icons.mark_email_read_outlined,
          color: AppColors.gold, size: 46),
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
