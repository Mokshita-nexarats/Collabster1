import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../shared/utils/dashboard_router.dart';
import '../../../core/di/providers.dart';
import '../../../shared/utils/app_snackbar.dart';
import 'forgot_password_screen.dart';
import 'sign_up_screen.dart';
import 'guest_explore_screen.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key, this.openSignUpTab = false});

  final bool openSignUpTab;

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  // Tab controller state
  late bool _isSignInTab;

  // Sign In Controllers
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();
  bool _obscureLoginPassword = true;
  bool _isSigningIn = false;

  // Sign Up Controllers
  final TextEditingController _signUpFullNameController = TextEditingController();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPhoneController = TextEditingController();
  final TextEditingController _signUpPasswordController = TextEditingController();
  final TextEditingController _signUpConfirmPasswordController = TextEditingController();
  bool _obscureSignUpPassword = true;
  bool _obscureSignUpConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _isSignInTab = !widget.openSignUpTab;
  }

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signUpFullNameController.dispose();
    _signUpEmailController.dispose();
    _signUpPhoneController.dispose();
    _signUpPasswordController.dispose();
    _signUpConfirmPasswordController.dispose();
    super.dispose();
  }

  // --- Sign In Handler ---
  Future<void> _handleSignIn() async {
    final navigator = Navigator.of(context);
    final email = _loginEmailController.text.trim();
    final password = _loginPasswordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showErrorMessage('Enter your email and password.');
      return;
    }

    setState(() => _isSigningIn = true);

    try {
      final authVM = ref.read(authViewModelProvider.notifier);
      final errorMsg = await authVM.signIn(
        email: email,
        password: password,
      );

      if (errorMsg != null) {
        if (!mounted) return;
        _showErrorMessage(errorMsg);
        return;
      }

      if (!mounted) return;
      final session = ref.read(authViewModelProvider).session;
      if (session == null) return;

      final destination = buildDashboardForRole(session);
      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => destination),
      );
    } finally {
      if (mounted) {
        setState(() => _isSigningIn = false);
      }
    }
  }

  // --- Sign Up Navigation Handler ---
  void _handleSignUpSubmit() {
    final fullName = _signUpFullNameController.text.trim();
    final email = _signUpEmailController.text.trim();
    final phone = _signUpPhoneController.text.trim();
    final password = _signUpPasswordController.text;
    final confirmPassword = _signUpConfirmPasswordController.text;

    if (fullName.isEmpty) {
      _showErrorMessage('Please enter your full name.');
      return;
    }
    if (email.isEmpty) {
      _showErrorMessage('Please enter your email address.');
      return;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      _showErrorMessage('Please enter a valid email address.');
      return;
    }
    if (phone.isEmpty) {
      _showErrorMessage('Please enter your phone number.');
      return;
    }
    if (password.isEmpty) {
      _showErrorMessage('Please enter a password.');
      return;
    }
    if (password.length < 6) {
      _showErrorMessage('Password must be at least 6 characters.');
      return;
    }
    if (confirmPassword.isEmpty) {
      _showErrorMessage('Please confirm your password.');
      return;
    }
    if (password != confirmPassword) {
      _showErrorMessage('Passwords do not match.');
      return;
    }

    // Move to multi-step SignUpScreen starting at Step 1 (Personal Details)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpScreen(
          initialPage: 1,
          prefilledFullName: fullName,
          prefilledEmail: email,
          prefilledPhone: phone,
          prefilledPassword: password,
        ),
      ),
    );
  }

  // Helpers
  void _showErrorMessage(String message) {
    AppSnackBar.showWithMessenger(
      ScaffoldMessenger.of(context),
      message,
      type: SnackBarType.error,
    );
  }

  void _showUnavailable(String feature) {
    AppSnackBar.showInfo(context, '$feature is not available yet.');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: Column(
            children: [
              // App Bar / Back arrow (only show if we can pop)
              Row(
                children: [
                  if (Navigator.of(context).canPop())
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFE2E8F0),
                          foregroundColor: const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                ],
              ),

                  // Scrollable Area
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 12),

                          // Logo and App Name
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CollabsterLogo(size: 38),
                              const SizedBox(width: 10),
                              const Text(
                                'CollobSter',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Tagline
                          const Text(
                            'Collaborate. Learn. Build. Grow Together.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Clean professional input card
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                    // Tabs
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => setState(() => _isSignInTab = true),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Sign In',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                    color: _isSignInTab ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Container(
                                                  height: 2,
                                                  width: 56,
                                                  decoration: BoxDecoration(
                                                    color: _isSignInTab ? const Color(0xFF0088CC) : Colors.transparent,
                                                    borderRadius: BorderRadius.circular(1),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => setState(() => _isSignInTab = false),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Sign Up',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                    color: !_isSignInTab ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Container(
                                                  height: 2,
                                                  width: 56,
                                                  decoration: BoxDecoration(
                                                    color: !_isSignInTab ? const Color(0xFF0088CC) : Colors.transparent,
                                                    borderRadius: BorderRadius.circular(1),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 28),

                                    // Animated Tab Forms
                                    _isSignInTab ? _buildSignInForm() : _buildSignUpForm(),
                                  ],
                                ),
                              ),

                          const SizedBox(height: 20),

                          // Guest Link
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const GuestExploreScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Continue as Guest',
                                style: TextStyle(
                                  color: Color(0xFF0088CC),
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  // --- Sign In Form Widget ---
  Widget _buildSignInForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Email/Username Input
        TextFormField(
          controller: _loginEmailController,
          style: const TextStyle(color: Color(0xFF0F172A), fontSize: 16),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: _buildInputDecoration(
            hintText: 'Email or Username',
            prefixIcon: const Icon(Icons.mail_outline_rounded, color: Color(0xFF0088CC)),
          ),
        ),

        const SizedBox(height: 18),

        // Password Input
        TextFormField(
          controller: _loginPasswordController,
          style: const TextStyle(color: Color(0xFF0F172A), fontSize: 16),
          obscureText: _obscureLoginPassword,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _handleSignIn(),
          decoration: _buildInputDecoration(
            hintText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF0088CC)),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureLoginPassword ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF94A3B8),
              ),
              onPressed: () => setState(() => _obscureLoginPassword = !_obscureLoginPassword),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Forgot Password? Link
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
              );
            },
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                color: Color(0xFF0088CC),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Sign In Button
        Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF0088CC), Color(0xFF229ED9)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0088CC).withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _isSigningIn ? null : _handleSignIn,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: _isSigningIn
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
          ),
        ),

        const SizedBox(height: 28),

        // Divider
        Row(
          children: [
            Expanded(child: Divider(color: const Color(0xFFE2E8F0), thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'or continue with',
                style: TextStyle(color: const Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(child: Divider(color: const Color(0xFFE2E8F0), thickness: 1)),
          ],
        ),

        const SizedBox(height: 24),

        // Social login buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSocialButton(
              logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1024px-Google_%22G%22_logo.svg.png',
              type: 'google',
              onTap: () => _showUnavailable('Google sign-in'),
            ),
            _buildSocialButton(
              logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Octicons-mark-github.svg/1024px-Octicons-mark-github.svg.png',
              type: 'github',
              onTap: () => _showUnavailable('GitHub sign-in'),
            ),
            _buildSocialButton(
              logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/LinkedIn_logo_initials.png/1024px-LinkedIn_logo_initials.png',
              type: 'linkedin',
              onTap: () => _showUnavailable('LinkedIn sign-in'),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // Bottom switch link
        Center(
          child: GestureDetector(
            onTap: () => setState(() => _isSignInTab = false),
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 14, color: Color(0xFF475569), letterSpacing: 0.2),
                children: [
                  TextSpan(text: "Don't have an account? "),
                  TextSpan(
                    text: 'Sign Up',
                    style: TextStyle(color: Color(0xFF0088CC), fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- Sign Up Form Widget ---
  Widget _buildSignUpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Full Name
        TextFormField(
          controller: _signUpFullNameController,
          style: const TextStyle(color: Color(0xFF0F172A), fontSize: 16),
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: _buildInputDecoration(
            hintText: 'Full Name',
            prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFF0088CC)),
          ),
        ),

        const SizedBox(height: 16),

        // Email Address
        TextFormField(
          controller: _signUpEmailController,
          style: const TextStyle(color: Color(0xFF0F172A), fontSize: 16),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: _buildInputDecoration(
            hintText: 'Email Address',
            prefixIcon: const Icon(Icons.mail_outline_rounded, color: Color(0xFF0088CC)),
          ),
        ),

        const SizedBox(height: 16),

        // Phone Number Input
        Row(
          children: [
            // Country flag code picker placeholder styled beautifully
            Container(
              width: 84,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF229ED9).withOpacity(0.25),
                  width: 1.2,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🇮🇳', style: TextStyle(fontSize: 18)),
                  SizedBox(width: 4),
                  Text('+91', style: TextStyle(color: Color(0xFF0F172A), fontSize: 14, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _signUpPhoneController,
                style: const TextStyle(color: Color(0xFF0F172A), fontSize: 16),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: _buildInputDecoration(
                  hintText: 'Phone Number',
                  prefixIcon: const Icon(Icons.phone_outlined, color: Color(0xFF0088CC)),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Password
        TextFormField(
          controller: _signUpPasswordController,
          style: const TextStyle(color: Color(0xFF0F172A), fontSize: 16),
          obscureText: _obscureSignUpPassword,
          textInputAction: TextInputAction.next,
          decoration: _buildInputDecoration(
            hintText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF0088CC)),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureSignUpPassword ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF94A3B8),
              ),
              onPressed: () => setState(() => _obscureSignUpPassword = !_obscureSignUpPassword),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Confirm Password
        TextFormField(
          controller: _signUpConfirmPasswordController,
          style: const TextStyle(color: Color(0xFF0F172A), fontSize: 16),
          obscureText: _obscureSignUpConfirmPassword,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _handleSignUpSubmit(),
          decoration: _buildInputDecoration(
            hintText: 'Confirm Password',
            prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF0088CC)),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureSignUpConfirmPassword ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF94A3B8),
              ),
              onPressed: () => setState(() => _obscureSignUpConfirmPassword = !_obscureSignUpConfirmPassword),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Sign Up / Continue Button
        Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF0088CC), Color(0xFF229ED9)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0088CC).withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _handleSignUpSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text(
              'Sign Up',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Bottom switch link
        Center(
          child: GestureDetector(
            onTap: () => setState(() => _isSignInTab = true),
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 14, color: Color(0xFF475569), letterSpacing: 0.2),
                children: [
                  TextSpan(text: 'Already have an account? '),
                  TextSpan(
                    text: 'Sign In',
                    style: TextStyle(color: Color(0xFF0088CC), fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Input styling generator
  InputDecoration _buildInputDecoration({
    required String hintText,
    required Widget prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 15, fontWeight: FontWeight.w500),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF1F5F9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: const Color(0xFF229ED9).withOpacity(0.25),
          width: 1.2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFF0088CC),
          width: 1.8,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.5,
        ),
      ),
    );
  }

  // Custom Social Button
  Widget _buildSocialButton({
    required String logoUrl,
    required String type,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF229ED9).withOpacity(0.20),
            width: 1.2,
          ),
        ),
        child: Center(
          child: Image.network(
            logoUrl,
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => _buildSocialFallback(type),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialFallback(String type) {
    if (type == 'google') {
      return Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Text(
            'G',
            style: TextStyle(
              color: Color(0xFF4285F4),
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ),
      );
    } else if (type == 'github') {
      return Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: Color(0xFF24292F),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Text(
            'Git',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
      );
    } else {
      // linkedin
      return Container(
        width: 26,
        height: 26,
        decoration: const BoxDecoration(
          color: Color(0xFF0A66C2),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: const Center(
          child: Text(
            'in',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: 'sans-serif',
            ),
          ),
        ),
      );
    }
  }
}

// ── Collabster Logo Painter & Widget ──────────────────────────────────────────

class CollabsterLogo extends StatelessWidget {
  const CollabsterLogo({super.key, this.size = 48});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: const CollabsterLogoPainter(),
    );
  }
}

class CollabsterLogoPainter extends CustomPainter {
  const CollabsterLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = math.min(size.width, size.height) * 0.4;

    // Paints
    final orbitPaint = Paint()
      ..color = const Color(0xFF229ED9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final bodyPaint = Paint()
      ..color = const Color(0xFF0088CC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.35
      ..strokeCap = StrokeCap.round;

    final spherePaint = Paint()
      ..color = const Color(0xFF229ED9)
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = const Color(0xFF229ED9).withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: radius * 2.4,
      height: radius * 0.65,
    );

    // 1. Draw back half of the orbit ellipse
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(-math.pi / 6); // -30 degrees tilt
    canvas.drawArc(rect, math.pi, math.pi, false, orbitPaint);
    canvas.restore();

    // 2. Draw white planet body ('C')
    final bodyRect = Rect.fromCircle(center: Offset(cx, cy), radius: radius * 0.8);
    canvas.drawArc(bodyRect, 0.25 * math.pi, 1.5 * math.pi, false, bodyPaint);

    // 3. Draw the satellite planet
    final sphereCenter = Offset(cx + radius * 0.8, cy - radius * 0.05);
    final sphereRadius = radius * 0.26;
    canvas.drawCircle(sphereCenter, sphereRadius + 2, glowPaint);
    canvas.drawCircle(sphereCenter, sphereRadius, spherePaint);

    // 4. Draw front half of the orbit ellipse
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(-math.pi / 6);
    canvas.drawArc(rect, 0, math.pi, false, orbitPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
