import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/auth_service.dart';
import '../utils/app_theme.dart';
import '../utils/ui_helpers.dart';
import '../widgets/common_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  String? _selectedGender;
  bool _isLoading = false;
  bool _agreeToTerms = false;

  final List<String> _genderOptions = ['Male', 'Female', 'Non-binary'];

  late AnimationController _anim;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fadeAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeIn));
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    _usernameCtrl.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      showAppSnackBar(context, 'Please agree to Terms & Conditions',
          isError: true);
      return;
    }
    setState(() => _isLoading = true);
    try {
      await AuthService.registerWithEmail(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
        displayName:
            '${_firstNameCtrl.text.trim()} ${_lastNameCtrl.text.trim()}',
      );
      await AuthService.signOut();
      if (mounted) {
        showAppSnackBar(context, 'Account created! Please sign in.',
            isError: false);
        await Future.delayed(const Duration(milliseconds: 700));
        Navigator.pop(context);
      }
    } catch (e) {
      final msg = e.toString();
      if (msg == 'ACCOUNT_EXISTS') {
        showAppSnackBar(context, 'Account already exists, try Logging in',
            isError: true);
      } else {
        showAppSnackBar(context, msg, isError: true);
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

      if (!result.isNewUser) {
        await AuthService.signOut();
        if (mounted) {
          showAppSnackBar(
            context,
            'Account already exists, try Logging in',
            isError: true,
          );
        }
        return;
      }

      await AuthService.signOut();
      if (mounted) {
        showAppSnackBar(
          context,
          'Google account registered! Please sign in.',
          isError: false,
        );
        await Future.delayed(const Duration(milliseconds: 700));
        Navigator.pop(context);
      }
    } catch (e) {
      final msg = e.toString();
      if (msg == 'ACCOUNT_EXISTS') {
        showAppSnackBar(context, 'Account already exists, try Logging in',
            isError: true);
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

      if (!result.isNewUser) {
        await AuthService.signOut();
        if (mounted) {
          showAppSnackBar(
            context,
            'Account already exists, try Logging in',
            isError: true,
          );
        }
        return;
      }

      await AuthService.signOut();
      if (mounted) {
        showAppSnackBar(
          context,
          'Facebook account registered! Please sign in.',
          isError: false,
        );
        await Future.delayed(const Duration(milliseconds: 700));
        Navigator.pop(context);
      }
    } catch (e) {
      final msg = e.toString();
      if (msg == 'ACCOUNT_EXISTS') {
        showAppSnackBar(context, 'Account already exists, try Logging in',
            isError: true);
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

      if (!result.isNewUser) {
        await AuthService.signOut();
        if (mounted) {
          showAppSnackBar(
            context,
            'Account already exists, try Logging in',
            isError: true,
          );
        }
        return;
      }

      await AuthService.signOut();
      if (mounted) {
        showAppSnackBar(
          context,
          'Twitter account registered! Please sign in.',
          isError: false,
        );
        await Future.delayed(const Duration(milliseconds: 700));
        Navigator.pop(context);
      }
    } catch (e) {
      final msg = e.toString();
      if (msg == 'ACCOUNT_EXISTS') {
        showAppSnackBar(context, 'Account already exists, try Logging in',
            isError: true);
      } else {
        if (mounted) showAppSnackBar(context, msg, isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                top: -80,
                left: -60,
                child: _glow(250, AppColors.gold.withOpacity(0.06)),
              ),
              Positioned(
                bottom: 80,
                right: -50,
                child: _glow(200, AppColors.green.withOpacity(0.06)),
              ),
              SafeArea(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                                    border: Border.all(color: AppColors.cardBorder),
                                  ),
                                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                                      color: AppColors.gold, size: 18),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Logo & App Name
                            const AppLogoWidget(size: 80),
                            const SizedBox(height: 12),
                            const AppNameWidget(fontSize: 24),
                            const SizedBox(height: 4),
                            Text(
                              'Create your account today',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 28),

                            // Card
                            _buildCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _sectionTitle('Create Account'),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Fill in the details below',
                                    style: TextStyle(color: AppColors.textHint, fontSize: 12),
                                  ),
                                  const SizedBox(height: 20),

                                  // Username
                                  CustomTextField(
                                    controller: _usernameCtrl,
                                    hint: 'Username',
                                    prefixIcon: Icons.alternate_email_rounded,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return 'Username is required';
                                      if (v.length < 3) return 'Minimum 3 characters';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 14),

                                  // First & Last name in a row
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomTextField(
                                          controller: _firstNameCtrl,
                                          hint: 'First Name',
                                          prefixIcon: Icons.person_outline_rounded,
                                          validator: (v) => v == null || v.isEmpty
                                              ? 'Required'
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: CustomTextField(
                                          controller: _lastNameCtrl,
                                          hint: 'Last Name',
                                          prefixIcon: Icons.person_outline_rounded,
                                          validator: (v) => v == null || v.isEmpty
                                              ? 'Required'
                                              : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),

                                  // Gender Dropdown
                                  _buildGenderDropdown(),
                                  const SizedBox(height: 14),

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

                                  // Confirm Password
                                  CustomTextField(
                                    controller: _confirmPasswordCtrl,
                                    hint: 'Confirm Password',
                                    prefixIcon: Icons.lock_person_outlined,
                                    isPassword: true,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return 'Please confirm your password';
                                      if (v != _passwordCtrl.text) return 'Passwords do not match';
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
                                  const SizedBox(height: 16),

                                  // Terms checkbox
                                  GestureDetector(
                                    onTap: () => setState(() => _agreeToTerms = !_agreeToTerms),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: Checkbox(
                                            value: _agreeToTerms,
                                            onChanged: (v) =>
                                                setState(() => _agreeToTerms = v ?? false),
                                            activeColor: AppColors.gold,
                                            checkColor: AppColors.background,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.shrinkWrap,
                                            visualDensity: VisualDensity.compact,
                                            side: const BorderSide(
                                                color: AppColors.cardBorder, width: 1.5),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              style: const TextStyle(
                                                color: AppColors.textSecondary,
                                                fontSize: 12,
                                                height: 1.4,
                                              ),
                                              children: [
                                                const TextSpan(text: 'I agree to the '),
                                                const TextSpan(
                                                  text: 'Terms & Conditions',
                                                  style: TextStyle(
                                                    color: AppColors.gold,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const TextSpan(text: ' and '),
                                                const TextSpan(
                                                  text: 'Privacy Policy',
                                                  style: TextStyle(
                                                    color: AppColors.gold,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Register Button
                                  _isLoading
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.gold,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : GradientButton(
                                          label: 'CREATE ACCOUNT',
                                          onPressed: _onRegister,
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

                            const SizedBox(height: 24),

                            // Already have account
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                      color: AppColors.gold,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
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

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      hint: const Text('Select Gender', style: TextStyle(color: AppColors.textHint, fontSize: 14)),
      dropdownColor: AppColors.cardDark,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.gold),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.cardDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        prefixIcon: const Icon(Icons.wc_outlined, color: AppColors.gold, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
      ),
      items: _genderOptions
          .map(
            (g) => DropdownMenuItem(
              value: g,
              child: Text(g, style: const TextStyle(color: AppColors.textPrimary)),
            ),
          )
          .toList(),
      onChanged: (v) => setState(() => _selectedGender = v),
      validator: (v) => v == null ? 'Please select gender' : null,
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
