import 'package:flutter/material.dart';

import 'startup_dashboard_screen.dart';

class RegistrationSubmittedScreen extends StatelessWidget {
  const RegistrationSubmittedScreen({super.key});

  static const Color _skyBlue = Color(0xFF0284C7);
  static const Color _background = Color(0xFFF8FAFC);
  static const Color _text = Color(0xFF202124);
  static const Color _mutedText = Color(0xFF626A79);

  void _goToDashboard(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const StartupDashboardScreen(
          startupName: 'TechNova Solutions Pvt. Ltd.',
        ),
      ),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: _skyBlue, size: 25),
                padding: const EdgeInsets.only(left: 25, top: 8),
                constraints: const BoxConstraints(),
                splashRadius: 22,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(0, 11, 0, 32),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 710),
                  padding: const EdgeInsets.fromLTRB(38, 52, 38, 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                      bottom: Radius.circular(12),
                    ),
                    border: Border.all(color: const Color(0xFFE1E4EC)),
                  ),
                  child: Column(
                    children: [
                      const _LaunchIllustration(),
                      const SizedBox(height: 69),
                      const Text(
                        'Registration\nSubmitted!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          height: 1.3,
                          fontWeight: FontWeight.w700,
                          color: _text,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Your existing company registration is\nsuccessful.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: _mutedText,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5FBEA),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: const Color(0xFFB5F1C3)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: Color(0xFF087C39),
                            ),
                            SizedBox(width: 7),
                            Text(
                              'Application ID: TMV45872',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF087C39),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 34),
                      const Text(
                        'You will be notified once your company is\nverified.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: _mutedText,
                        ),
                      ),
                      const SizedBox(height: 26),
                      SizedBox(
                        width: double.infinity,
                        height: 49,
                        child: ElevatedButton(
                          onPressed: () => _goToDashboard(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _skyBlue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                          child: const Text(
                            'Go to Dashboard',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LaunchIllustration extends StatelessWidget {
  const _LaunchIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 185,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 214,
            height: 214,
            decoration: const BoxDecoration(
              color: Color(0xFFF7F3FF),
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            bottom: 17,
            child: Container(
              width: 284,
              height: 147,
              decoration: BoxDecoration(
                color: const Color(0xFFF7FBFE),
                border: Border.all(color: const Color(0xFFE9F0F5)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x140284C7),
                    blurRadius: 14,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final size in [34.0, 48.0, 58.0, 42.0, 30.0])
                        Container(
                          width: size,
                          height: size * .62,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x220284C7),
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  Positioned(
                    right: 76,
                    top: 28,
                    child: Transform.rotate(
                      angle: -.65,
                      child: const Icon(
                        Icons.rocket_launch,
                        size: 58,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 58,
                    top: 28,
                    child: const Icon(
                      Icons.auto_awesome,
                      size: 15,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                  const Positioned(
                    right: 34,
                    top: 37,
                    child: Icon(
                      Icons.auto_awesome,
                      size: 12,
                      color: Color(0xFF7DD3FC),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
