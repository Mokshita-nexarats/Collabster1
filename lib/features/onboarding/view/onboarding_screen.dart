import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/theme/app_assets.dart';
import '../../auth/view/sign_in_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LANDING / ONBOARDING SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  // Animation controllers
  late final AnimationController _fadeCtrl;
  late final AnimationController _slideCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _shimmerCtrl;

  // Animations
  late final Animation<double> _logoFade;
  late final Animation<Offset> _logoSlide;
  late final Animation<double> _taglineFade;
  late final Animation<double> _featureFade;
  late final Animation<Offset> _featureSlide;
  late final Animation<double> _btnFade;
  late final Animation<Offset> _btnSlide;
  late final Animation<double> _pulse;
  late final Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _logoFade = CurvedAnimation(
      parent: _fadeCtrl,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );
    _taglineFade = CurvedAnimation(
      parent: _fadeCtrl,
      curve: const Interval(0.3, 0.65, curve: Curves.easeOut),
    );
    _featureFade = CurvedAnimation(
      parent: _fadeCtrl,
      curve: const Interval(0.5, 0.80, curve: Curves.easeOut),
    );
    _btnFade = CurvedAnimation(
      parent: _fadeCtrl,
      curve: const Interval(0.70, 1.0, curve: Curves.easeOut),
    );

    _logoSlide = Tween<Offset>(begin: const Offset(0, -0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _slideCtrl,
            curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
          ),
        );
    _featureSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _slideCtrl,
            curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic),
          ),
        );
    _btnSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _slideCtrl,
            curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _pulse = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _shimmer = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _shimmerCtrl, curve: Curves.linear));

    // Kick off entrance
    _fadeCtrl.forward();
    _slideCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _slideCtrl.dispose();
    _pulseCtrl.dispose();
    _shimmerCtrl.dispose();
    super.dispose();
  }

  // ── Navigation helpers ─────────────────────────────────────────────────────

  Future<void> _getStarted() async {
    final status = await Permission.notification.request();
    if (!mounted) return;
    if (status.isPermanentlyDenied) {
      _showPermissionDialog();
      return;
    }
    _navigateToSignIn();
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Enable Notifications'),
        content: const Text(
          'Notifications help you stay updated on startup activities, messages, and events. Please enable them in Settings.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _navigateToSignIn();
            },
            child: const Text('Skip'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C3AED),
              foregroundColor: Colors.white,
            ),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _navigateToSignIn() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) =>
            FadeTransition(opacity: animation, child: const SignInScreen()),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ── Background image ─────────────────────────────────────────
          Positioned.fill(
            child: Image.asset(AppAssets.landingBg, fit: BoxFit.cover),
          ),

          // ── Deep gradient overlay ────────────────────────────────────
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xCC0A0520), // very dark top
                    Color(0x440A0520), // semi-transparent middle
                    Color(0xDD0A0520), // dark at bottom
                  ],
                  stops: [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),

          // ── Ambient purple glow ──────────────────────────────────────
          Positioned(
            top: size.height * 0.12,
            left: -80,
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (_, __) => Transform.scale(
                scale: _pulse.value,
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF7C3AED).withOpacity(0.25),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: size.height * 0.22,
            right: -60,
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (_, __) => Transform.scale(
                scale: 2.0 - _pulse.value,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF4F46E5).withOpacity(0.20),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Floating sparkle dots ────────────────────────────────────
          ...List.generate(8, (i) => _SparkleParticle(index: i, size: size)),

          // ── Main content ─────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // ── Logo + Brand ──────────────────────────────────────
                  FadeTransition(
                    opacity: _logoFade,
                    child: SlideTransition(
                      position: _logoSlide,
                      child: _buildLogoSection(),
                    ),
                  ),

                  const Spacer(flex: 2),

                  // ── Hero tagline ──────────────────────────────────────
                  FadeTransition(opacity: _taglineFade, child: _buildTagline()),

                  const SizedBox(height: 28),

                  // ── Feature pills ─────────────────────────────────────
                  FadeTransition(
                    opacity: _featureFade,
                    child: SlideTransition(
                      position: _featureSlide,
                      child: _buildFeaturePills(),
                    ),
                  ),

                  const Spacer(flex: 2),

                  const SizedBox(height: 36),

                  // ── CTA button ────────────────────────────────────────
                  FadeTransition(
                    opacity: _btnFade,
                    child: SlideTransition(
                      position: _btnSlide,
                      child: _buildGetStartedButton(),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ── Sign in link ──────────────────────────────────────
                  FadeTransition(opacity: _btnFade, child: _buildSignInLink()),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Logo section ───────────────────────────────────────────────────────────

  Widget _buildLogoSection() {
    return Column(
      children: [
        // Logo image with glow ring
        AnimatedBuilder(
          animation: _pulse,
          builder: (_, __) => Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFF7C3AED,
                  ).withOpacity(0.35 * _pulse.value),
                  blurRadius: 32 * _pulse.value,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Image.asset(AppAssets.appLogo, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        // Brand name with shimmer
        AnimatedBuilder(
          animation: _shimmer,
          builder: (_, child) {
            return ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment(_shimmer.value - 1, 0),
                end: Alignment(_shimmer.value + 1, 0),
                colors: const [
                  Colors.white,
                  Color(0xFFD8B4FE),
                  Colors.white,
                  Color(0xFF818CF8),
                  Colors.white,
                ],
                stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
              ).createShader(bounds),
              child: child,
            );
          },
          child: const Text(
            'Collabster',
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -1.0,
              height: 1.0,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF7C3AED).withOpacity(0.25),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF7C3AED).withOpacity(0.4)),
          ),
          child: const Text(
            'Connecting Builders & Dreamers',
            style: TextStyle(
              fontSize: 11.5,
              color: Color(0xFFD8B4FE),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ],
    );
  }

  // ── Hero tagline ───────────────────────────────────────────────────────────

  Widget _buildTagline() {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Where ',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.25,
                  letterSpacing: -0.5,
                ),
              ),
              TextSpan(
                text: 'Ideas\n',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFA78BFA),
                  height: 1.25,
                  letterSpacing: -0.5,
                ),
              ),
              TextSpan(
                text: 'meet ',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.25,
                  letterSpacing: -0.5,
                ),
              ),
              TextSpan(
                text: 'Opportunity',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF818CF8),
                  height: 1.25,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Join a thriving ecosystem of startups,\ninvestors & creators.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.5,
            height: 1.5,
            color: Colors.white.withOpacity(0.72),
            fontWeight: FontWeight.w400,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }

  // ── Feature pills ──────────────────────────────────────────────────────────

  Widget _buildFeaturePills() {
    final features = [
      _Feature(
        Icons.rocket_launch_rounded,
        'Startups',
        const Color(0xFF818CF8),
      ),
      _Feature(Icons.trending_up_rounded, 'Investors', const Color(0xFF34D399)),
      _Feature(
        Icons.people_outline_rounded,
        'Network',
        const Color(0xFFF472B6),
      ),
      _Feature(Icons.groups_rounded, 'Community', const Color(0xFF60A5FA)),
      _Feature(Icons.dynamic_feed_rounded, 'Feed', const Color(0xFFA78BFA)),
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: features.map((f) => _FeaturePill(feature: f)).toList(),
    );
  }

  // ── CTA button ─────────────────────────────────────────────────────────────

  Widget _buildGetStartedButton() {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, child) => Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(
                0xFF7C3AED,
              ).withOpacity(0.30 + 0.15 * (_pulse.value - 0.95) / 0.1),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: child,
      ),
      child: ElevatedButton(
        onPressed: _getStarted,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Get Started',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Sign-in link ───────────────────────────────────────────────────────────

  Widget _buildSignInLink() {
    return GestureDetector(
      onTap: _navigateToSignIn,
      behavior: HitTestBehavior.opaque,
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.65),
            letterSpacing: 0.2,
          ),
          children: const [
            TextSpan(text: 'Already have an account?  '),
            TextSpan(
              text: 'Sign In',
              style: TextStyle(
                color: Color(0xFFA78BFA),
                fontWeight: FontWeight.w800,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Feature data model
// ─────────────────────────────────────────────────────────────────────────────

class _Feature {
  final IconData icon;
  final String label;
  final Color color;
  const _Feature(this.icon, this.label, this.color);
}

// ─────────────────────────────────────────────────────────────────────────────
// Feature Pill widget
// ─────────────────────────────────────────────────────────────────────────────

class _FeaturePill extends StatelessWidget {
  const _FeaturePill({required this.feature});
  final _Feature feature;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: feature.color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: feature.color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(feature.icon, size: 14, color: feature.color),
              const SizedBox(width: 6),
              Text(
                feature.label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withOpacity(0.92),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Floating sparkle particle
// ─────────────────────────────────────────────────────────────────────────────

class _SparkleParticle extends StatefulWidget {
  const _SparkleParticle({required this.index, required this.size});
  final int index;
  final Size size;

  @override
  State<_SparkleParticle> createState() => _SparkleParticleState();
}

class _SparkleParticleState extends State<_SparkleParticle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final double _left;
  late final double _top;
  late final double _dotSize;

  static final _rng = math.Random();

  @override
  void initState() {
    super.initState();
    // Stagger durations to prevent sync
    final duration = Duration(milliseconds: 1800 + widget.index * 340);
    _ctrl = AnimationController(vsync: this, duration: duration)
      ..repeat(reverse: true);

    _left = _rng.nextDouble() * widget.size.width;
    _top = _rng.nextDouble() * widget.size.height * 0.6;
    _dotSize = 2.0 + _rng.nextDouble() * 3.0;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _left,
      top: _top,
      child: FadeTransition(
        opacity: CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
        child: Container(
          width: _dotSize,
          height: _dotSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.85),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFA78BFA).withOpacity(0.6),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Collabster logo (kept for backward compat if used elsewhere)
// ─────────────────────────────────────────────────────────────────────────────

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

    final orbitPaint = Paint()
      ..color = const Color(0xFF8B6FFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final bodyPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.35
      ..strokeCap = StrokeCap.round;

    final spherePaint = Paint()
      ..color = const Color(0xFF8B6FFF)
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = const Color(0xFF8B6FFF).withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: radius * 2.4,
      height: radius * 0.65,
    );

    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(-math.pi / 6);
    canvas.drawArc(rect, math.pi, math.pi, false, orbitPaint);
    canvas.restore();

    final bodyRect = Rect.fromCircle(
      center: Offset(cx, cy),
      radius: radius * 0.8,
    );
    canvas.drawArc(bodyRect, 0.25 * math.pi, 1.5 * math.pi, false, bodyPaint);

    final sphereCenter = Offset(cx + radius * 0.8, cy - radius * 0.05);
    final sphereRadius = radius * 0.26;
    canvas.drawCircle(sphereCenter, sphereRadius + 2, glowPaint);
    canvas.drawCircle(sphereCenter, sphereRadius, spherePaint);

    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(-math.pi / 6);
    canvas.drawArc(rect, 0, math.pi, false, orbitPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
