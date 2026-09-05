import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/theme/app_colors.dart';
import 'manual_recommendations_screen.dart';


class AIOptimizationScreen extends StatelessWidget {
  const AIOptimizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar & Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
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
                      const SizedBox(height: 20),

                      // Title
                      const Text(
                        'AI optimization',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Gauge in center
                      Center(
                        child: SizedBox(
                          width: 130,
                          height: 130,
                          child: CustomPaint(
                            painter: _DonutGaugePainter(percentage: 0.98),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    '98%',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF006699),
                                    ),
                                  ),
                                  Text(
                                    'EXCELLENT',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade500,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // AI Resume Optimization card text description
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              'AI Resume Optimization',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Your profile is highly competitive for Cloud Architecture roles.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // OPTIMIZED CHANGES section
                      const Text(
                        'OPTIMIZED CHANGES',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0088CC),
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Optimized changes card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: const Color(0xFFE8F4FB), width: 1.2),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle_outline_rounded,
                                    color: Color(0xFF0088CC), size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: RichText(
                                    text: const TextSpan(
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF4B5563),
                                        height: 1.4,
                                      ),
                                      children: [
                                        TextSpan(text: 'Quantified impact added to '),
                                        TextSpan(
                                          text: '4 experience bullet points',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0088CC),
                                          ),
                                        ),
                                        TextSpan(text: '.'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle_outline_rounded,
                                    color: Color(0xFF0088CC), size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: RichText(
                                    text: const TextSpan(
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF4B5563),
                                        height: 1.4,
                                      ),
                                      children: [
                                        TextSpan(text: 'Successfully integrated '),
                                        TextSpan(
                                          text: '"Cloud Architecture"',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF006699),
                                          ),
                                        ),
                                        TextSpan(text: ' and '),
                                        TextSpan(
                                          text: '"DevOps"',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF006699),
                                          ),
                                        ),
                                        TextSpan(text: ' keywords.'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // REMAINING DRAWBACKS section
                      const Text(
                        'REMAINING DRAWBACKS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B7280),
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Remaining drawbacks card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: const Color(0xFFE8F4FB), width: 1.2),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.info_outline_rounded,
                                    color: Color(0xFF0088CC), size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: RichText(
                                    text: const TextSpan(
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF4B5563),
                                        height: 1.4,
                                      ),
                                      children: [
                                        TextSpan(text: 'Work history gap: Consider adding a brief explanation for '),
                                        TextSpan(
                                          text: '2023',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF111827),
                                          ),
                                        ),
                                        TextSpan(text: '.'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.warning_amber_rounded,
                                    color: Color(0xFF0088CC), size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: RichText(
                                    text: const TextSpan(
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF4B5563),
                                        height: 1.4,
                                      ),
                                      children: [
                                        TextSpan(text: 'Formatting: Resume length exceeds '),
                                        TextSpan(
                                          text: '2 pages',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF111827),
                                          ),
                                        ),
                                        TextSpan(text: '; trim secondary details.'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Two action buttons
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Downloading optimized resume PDF...')),
                            );
                          },
                          icon: const Icon(Icons.file_download_outlined,
                              color: Colors.white, size: 18),
                          label: const Text(
                            'Download Optimized PDF',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0088CC),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                       SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ManualRecommendationsScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit_outlined,
                              color: Colors.white, size: 18),
                          label: const Text(
                            'Edit manually',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0088CC),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Navigation Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: Colors.grey.shade200, width: 1)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(true, Icons.home_rounded, 'Home'),
                      _buildNavItem(false, Icons.explore_outlined, 'Explore'),
                      _buildCenterAddButton(context),
                      _buildNavItem(false, Icons.work_outline, 'Applied'),
                      _buildNavItem(false, Icons.bookmark_border, 'Saved'),
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

  Widget _buildNavItem(bool isSelected, IconData icon, String label) {
    return GestureDetector(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 14, vertical: 6)
            : const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFFE8F4FB),
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : Colors.grey.shade500,
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCenterAddButton(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x400284C7),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(Icons.add, color: Colors.white, size: 26),
    );
  }
}

class _DonutGaugePainter extends CustomPainter {
  final double percentage;
  const _DonutGaugePainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 9.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background track
    final bgPaint = Paint()
      ..color = const Color(0xFFE8F4FB)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress track
    final fgPaint = Paint()
      ..color = const Color(0xFF0088CC)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * percentage,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
