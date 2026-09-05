import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'ai_optimization_screen.dart';

class ResumeUpgradeScreen extends StatelessWidget {
  const ResumeUpgradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative background dots/particles to match screenshot exactly
            ..._buildBackgroundParticles(),

            // Scrollable Content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              child: Column(
                children: [
                  // Top Bar
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const Spacer(flex: 2),

                  // Circle with checkmark
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F4FB),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Color(0xFF0088CC),
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  const Text(
                    'Upgrade Successful!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'You now have full access to Pro features.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Plan card details
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFFE8F4FB), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.01),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: const [
                        _DetailRow(label: 'Plan', value: 'Pro Annual'),
                        Divider(color: Color(0xFFF0F9FF), height: 24, thickness: 1),
                        _DetailRow(label: 'Price', value: '\$9.99/mo'),
                        Divider(color: Color(0xFFF0F9FF), height: 24, thickness: 1),
                        _DetailRow(label: 'Billing Cycle', value: 'Monthly'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Features tags
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: const [
                      _FeatureTag(label: 'Unlimited Mocks'),
                      _FeatureTag(label: 'Priority Support'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const _FeatureTag(label: 'AI Insights'),

                  const Spacer(flex: 3),

                  // Button Go to AI Optimization
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AIOptimizationScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0088CC),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Go to AI Optimization',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.bolt_rounded,
                              color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Small info text below button
                  Text(
                    'Receipt sent to your email.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBackgroundParticles() {
    return [
      Positioned(
        left: 80,
        bottom: 180,
        child: _buildDot(8, 0.08),
      ),
      Positioned(
        left: 140,
        bottom: 230,
        child: _buildDot(5, 0.05),
      ),
      Positioned(
        right: 100,
        bottom: 260,
        child: _buildDot(10, 0.06),
      ),
      Positioned(
        right: 60,
        bottom: 150,
        child: _buildDot(6, 0.07),
      ),
      Positioned(
        left: 50,
        bottom: 300,
        child: _buildDot(4, 0.05),
      ),
      Positioned(
        left: 110,
        bottom: 340,
        child: _buildDot(6, 0.06),
      ),
      Positioned(
        right: 150,
        bottom: 320,
        child: _buildDot(7, 0.04),
      ),
    ];
  }

  Widget _buildDot(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF0088CC).withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _FeatureTag extends StatelessWidget {
  final String label;

  const _FeatureTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8F4FB), width: 1.2),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0088CC),
        ),
      ),
    );
  }
}
