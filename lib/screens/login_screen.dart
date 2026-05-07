import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/auth_service.dart';
import '../utils/app_theme.dart';
import '../utils/ui_helpers.dart';
import '../widgets/common_widgets.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _isLoading = false;
  late AnimationController _anim;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _anim, curve: Curves.easeIn));
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _onLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await AuthService.loginWithEmail(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
      if (mounted) {
        showAppSnackBar(context, 'Welcome back! 🎉', isError: false);
        await Future.delayed(const Duration(milliseconds: 400));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (_) => false,
        );
      }
    } catch (e) {
      final msg = e.toString();
      if (msg == 'ACCOUNT_NOT_FOUND') {
        _showAccountNotFoundBar();
      } else {
        if (mounted) showAppSnackBar(context, msg, isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final result = await AuthService.signInWithGoogle();
      if (result == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }
      if (result.isNewUser) {
        // 🚫 No registration found — DELETE the auto-created Firebase account
        // and sign out. Without delete(), the account persists and the SECOND
        // attempt would have isNewUser=false, silently logging them in.
        await result.credential.user?.delete();
        await AuthService.signOutGoogle();
        if (mounted) {
          _showAccountNotFoundBar();
        }
        return;
      }
      // ✅ Existing registered user — go to Home
      if (mounted) {
        showAppSnackBar(context, 'Welcome back! 🎉', isError: false);
        await Future.delayed(const Duration(milliseconds: 400));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (_) => false,
        );
      }
    } catch (e) {
      final msg = e.toString();
      if (msg == 'ACCOUNT_NOT_FOUND') {
        _showAccountNotFoundBar();
      } else {
        if (mounted) showAppSnackBar(context, msg, isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _signInWithFacebook() async {
    setState(() => _isLoading = true);
    try {
      final result = await AuthService.signInWithFacebook();
      if (result == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }
      if (result.isNewUser) {
        // 🚫 No registration found — DELETE the auto-created Firebase account
        await result.credential.user?.delete();
        await AuthService.signOutFacebook();
        if (mounted) {
          _showAccountNotFoundBar();
        }
        return;
      }
      // ✅ Existing registered user — go to Home
      if (mounted) {
        showAppSnackBar(context, 'Welcome back! 🎉', isError: false);
        await Future.delayed(const Duration(milliseconds: 400));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (_) => false,
        );
      }
    } catch (e) {
      final msg = e.toString();
      if (msg == 'ACCOUNT_NOT_FOUND') {
        _showAccountNotFoundBar();
      } else {
        if (mounted) showAppSnackBar(context, msg, isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _signInWithTwitter() async {
    setState(() => _isLoading = true);
    try {
      final result = await AuthService.signInWithTwitter();
      if (result == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }
      if (result.isNewUser) {
        // 🚫 No registration found — DELETE the auto-created Firebase account
        await result.credential.user?.delete();
        await AuthService.signOut();
        if (mounted) {
          _showAccountNotFoundBar();
        }
        return;
      }
      // ✅ Existing registered user — go to Home
      if (mounted) {
        showAppSnackBar(context, 'Welcome back! 🎉', isError: false);
        await Future.delayed(const Duration(milliseconds: 400));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (_) => false,
        );
      }
    } catch (e) {
      final msg = e.toString();
      if (msg == 'ACCOUNT_NOT_FOUND') {
        _showAccountNotFoundBar();
      } else {
        if (mounted) showAppSnackBar(context, msg, isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Special snackbar with a 'Register' action button
  void _showAccountNotFoundBar() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Account not found, create new Account!'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 2500),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          action: SnackBarAction(
            label: 'Register',
            textColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const RegisterScreen(),
                  transitionDuration: const Duration(milliseconds: 400),
                  transitionsBuilder: (_, anim, __, child) => SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                        parent: anim, curve: Curves.easeOut)),
                    child: child,
                  ),
                ),
              );
            },
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
              // Decorative glows
              Positioned(
                top: -60,
                right: -40,
                child: _glow(200, AppColors.gold.withOpacity(0.08)),
              ),
              Positioned(
                bottom: 60,
                left: -60,
                child: _glow(220, AppColors.green.withOpacity(0.06)),
              ),
              SafeArea(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),

                            // Logo & App Name
                            const AppLogoWidget(size: 90),
                            const SizedBox(height: 14),
                            const AppNameWidget(fontSize: 26),
                            const SizedBox(height: 6),
                            Text(
                              'Welcome back! Sign in to continue',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 36),

                            // Card
                            _buildCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _sectionTitle('Sign In'),
                                  const SizedBox(height: 20),

                                  // Email
                                  CustomTextField(
                                    controller: _emailCtrl,
                                    hint: 'Email Address',
                                    prefixIcon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return 'Email is required';
                                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                                        return 'Enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 14),

                                  // Password
                                  CustomTextField(
                                    controller: _passwordCtrl,
                                    hint: 'Password',
                                    prefixIcon: Icons.lock_outline,
                                    isPassword: true,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return 'Password is required';
                                      if (v.length < 6) return 'Minimum 6 characters';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 14),

                                  // Phone
                                  CustomTextField(
                                    controller: _phoneCtrl,
                                    hint: 'Phone Number',
                                    prefixIcon: Icons.phone_outlined,
                                    keyboardType: TextInputType.phone,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return 'Phone is required';
                                      if (v.length < 10) return 'Enter a valid phone number';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),

                                  // Forgot password
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (_, __, ___) =>
                                                const ForgotPasswordScreen(),
                                            transitionDuration:
                                                const Duration(milliseconds: 400),
                                            transitionsBuilder:
                                                (_, anim, __, child) =>
                                                    SlideTransition(
                                              position: Tween<Offset>(
                                                begin: const Offset(0, 1.0),
                                                end: Offset.zero,
                                              ).animate(CurvedAnimation(
                                                  parent: anim,
                                                  curve: Curves.easeOut)),
                                              child: child,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                          color: AppColors.gold,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  // Login Button
                                  _isLoading
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.gold,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : GradientButton(
                                          label: 'SIGN IN',
                                          onPressed: _onLogin,
                                        ),
                                  const SizedBox(height: 24),

                                  // Divider
                                  const OrDivider(),
                                  const SizedBox(height: 20),

                                  // Social Buttons — 3 equal columns
                                  Row(
                                    children: [
                                      SocialButton(
                                        faIcon: FontAwesomeIcons.google,
                                        color: AppColors.google,
                                        label: 'Google',
                                        onPressed: _signInWithGoogle,
                                      ),
                                      const SizedBox(width: 10),
                                      SocialButton(
                                        faIcon: FontAwesomeIcons.squareFacebook,
                                        color: AppColors.facebook,
                                        label: 'Facebook',
                                        onPressed: _signInWithFacebook,
                                      ),
                                      const SizedBox(width: 10),
                                      SocialButton(
                                        faIcon: FontAwesomeIcons.xTwitter,
                                        color: AppColors.textPrimary, // Changed color from AppColors.twitter since Twitter X is black/white
                                        label: 'Twitter',
                                        onPressed: _signInWithTwitter,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Register redirect
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (_, __, ___) => const RegisterScreen(),
                                        transitionDuration: const Duration(milliseconds: 400),
                                        transitionsBuilder: (_, anim, __, child) =>
                                            SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(1.0, 0),
                                            end: Offset.zero,
                                          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
                                          child: child,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                      color: AppColors.gold,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
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
            color: Colors.black.withOpacity(0.4),
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
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }

  Widget _glow(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
