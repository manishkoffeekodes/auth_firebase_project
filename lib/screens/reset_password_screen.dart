import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _isLoading = false;
  bool _isSuccess = false;

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
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _onReset() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _isSuccess = true;
    });
  }

  void _goToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: anim,
          child: child,
        ),
      ),
      (route) => false,
    );
  }

  // Password strength helper
  int _passwordStrength(String password) {
    int score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#\$%^&*]'))) score++;
    return score;
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
                      child: _isSuccess
                          ? _buildSuccessView()
                          : _buildFormView(),
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

  Widget _buildFormView() {
    final strength = _passwordStrength(_newPasswordCtrl.text);
    return Form(
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
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.gold, size: 18),
              ),
            ),
          ),
          const SizedBox(height: 36),

          _buildIconBadge(Icons.key_rounded),
          const SizedBox(height: 28),

          const Text(
            'Reset Password',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Create a strong new password\nfor your account.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 40),

          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('New Password'),
                const SizedBox(height: 20),

                // New Password
                CustomTextField(
                  controller: _newPasswordCtrl,
                  hint: 'New Password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  onChanged: (_) => setState(() {}),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 8) return 'Minimum 8 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Strength bar
                if (_newPasswordCtrl.text.isNotEmpty)
                  _buildStrengthBar(strength),

                const SizedBox(height: 14),

                // Confirm Password
                CustomTextField(
                  controller: _confirmPasswordCtrl,
                  hint: 'Confirm New Password',
                  prefixIcon: Icons.lock_person_outlined,
                  isPassword: true,
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return 'Please confirm your password';
                    if (v != _newPasswordCtrl.text)
                      return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password rules
                _buildPasswordRules(),
                const SizedBox(height: 24),

                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.gold,
                          strokeWidth: 2.5,
                        ),
                      )
                    : GradientButton(
                        label: 'RESET PASSWORD',
                        onPressed: _onReset,
                      ),
              ],
            ),
          ),

          const SizedBox(height: 36),
          _buildStepIndicator(currentStep: 3),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 80),

        // Animated success badge
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (_, v, child) => Transform.scale(scale: v, child: child),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.green.withValues(alpha: 0.12),
              border:
                  Border.all(color: AppColors.green.withValues(alpha: 0.5), width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.green.withValues(alpha: 0.25),
                  blurRadius: 30,
                  spreadRadius: 6,
                ),
              ],
            ),
            child: const Icon(Icons.check_circle_rounded,
                color: AppColors.green, size: 60),
          ),
        ),
        const SizedBox(height: 32),

        const Text(
          'Password Reset!',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Your password has been successfully\nreset. You can now sign in.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 48),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GradientButton(
            label: 'BACK TO SIGN IN',
            onPressed: _goToLogin,
          ),
        ),
        const SizedBox(height: 20),

        // Confetti-style dots decoration
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
            (i) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: i == 2 ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: i == 2
                    ? AppColors.gold
                    : AppColors.gold.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStrengthBar(int strength) {
    final labels = ['Weak', 'Fair', 'Good', 'Strong'];
    final colors = [Colors.red, Colors.orange, Colors.yellow, AppColors.green];
    final label = strength == 0 ? 'Too short' : labels[strength - 1];
    final color = strength == 0 ? Colors.red : colors[strength - 1];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 4),
                height: 4,
                decoration: BoxDecoration(
                  color: i < strength ? color : AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          'Strength: $label',
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildPasswordRules() {
    final rules = [
      ('At least 8 characters', _newPasswordCtrl.text.length >= 8),
      ('One uppercase letter', _newPasswordCtrl.text.contains(RegExp(r'[A-Z]'))),
      ('One number', _newPasswordCtrl.text.contains(RegExp(r'[0-9]'))),
      ('One special character (!@#\$)',
          _newPasswordCtrl.text.contains(RegExp(r'[!@#\$%^&*]'))),
    ];

    return Column(
      children: rules.map((r) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            children: [
              Icon(
                r.$2 ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                color: r.$2 ? AppColors.green : AppColors.textHint,
                size: 15,
              ),
              const SizedBox(width: 8),
              Text(
                r.$1,
                style: TextStyle(
                  color: r.$2 ? AppColors.green : AppColors.textHint,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildIconBadge(IconData icon) {
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
      child: Icon(icon, color: AppColors.gold, size: 46),
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
