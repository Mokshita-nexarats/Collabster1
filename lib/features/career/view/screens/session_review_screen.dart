import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/theme/app_colors.dart';

class SessionReviewScreen extends StatelessWidget {
  const SessionReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
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
                  const Icon(
                    Icons.share_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const Text(
                        'Session Review',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Circle Gauge in Center
                      Center(
                        child: SizedBox(
                          width: 140,
                          height: 140,
                          child: CustomPaint(
                            painter: _ReviewGaugePainter(percentage: 0.82),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    '82%',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF006699),
                                    ),
                                  ),
                                  Text(
                                    'Overall Score',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade500,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Completed Timestamp
                      Center(
                        child: Text(
                          'Completed on Oct 19 • 45 mins elapsed',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Progress scores
                      _buildMetricProgress('Technical Accuracy', 0.80, '80%'),
                      const SizedBox(height: 14),
                      _buildMetricProgress('Delivery & Pacing', 0.90, '90%'),
                      const SizedBox(height: 14),
                      _buildMetricProgress('Structure (STAR Method)', 0.60, '60%'),
                      const SizedBox(height: 24),

                      // What You Mastered (Green card)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.check_circle_outline_rounded,
                                    color: Color(0xFF0088CC), size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'What You Mastered',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0088CC),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildBulletItem(
                                'Excellent code syntax with proper variable naming.',
                                const Color(0xFF006699)),
                            const SizedBox(height: 8),
                            _buildBulletItem(
                                'Clear definition of the core problem situation.',
                                const Color(0xFF006699)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Areas to Improve (Sky Blue card)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F9FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.lightbulb_outline_rounded,
                                    color: Color(0xFF0088CC), size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Areas to Improve',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0088CC),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildBulletItem(
                                'Did not state the final outcome or metric in your STAR response.',
                                const Color(0xFF006699)),
                            const SizedBox(height: 8),
                            _buildBulletItem(
                                'Edge cases failed for negative integers during simulation.',
                                const Color(0xFF006699)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Behavioral Analytics
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE8F4FB), width: 1.2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Behavioral Analytics',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Pacing badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F4FB),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.speed_rounded,
                                      color: Color(0xFF0088CC), size: 14),
                                  SizedBox(width: 6),
                                  Text(
                                    '135 WPM (Perfect Pacing)',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0088CC),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Metric row boxes
                            Row(
                              children: const [
                                Expanded(child: _CountBox(count: '4', label: 'UM')),
                                SizedBox(width: 8),
                                Expanded(child: _CountBox(count: '2', label: 'LIKE')),
                                SizedBox(width: 8),
                                Expanded(child: _CountBox(count: '1', label: 'UH')),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Voice Visualizer Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'VOICE ENERGY CONFIDENCE',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                Icon(Icons.bar_chart_rounded,
                                    color: Color(0xFF0088CC), size: 14),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Vertical energy bars
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildEnergyBar(12),
                                _buildEnergyBar(24),
                                _buildEnergyBar(16),
                                _buildEnergyBar(34),
                                _buildEnergyBar(12),
                                _buildEnergyBar(20),
                                _buildEnergyBar(28),
                                _buildEnergyBar(14),
                                _buildEnergyBar(18),
                                _buildEnergyBar(32),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Code Execution
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE8F4FB), width: 1.2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Code Execution',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Test Case Matrix
                            Row(
                              children: [
                                const Text(
                                  'Test Case Matrix',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                _buildStatusDot('Sample 1', const Color(0xFF10B981)),
                                const SizedBox(width: 8),
                                _buildStatusDot('Sample 2', const Color(0xFF10B981)),
                                const SizedBox(width: 8),
                                _buildStatusDot('Edge Case 3', const Color(0xFFEF4444)),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Two small metrics cards
                            Row(
                              children: const [
                                Expanded(
                                  child: _ExecutionStatCard(
                                    label: 'Runtime',
                                    value: '12ms',
                                    sub: 'Faster than 85%',
                                    subColor: Color(0xFF10B981),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: _ExecutionStatCard(
                                    label: 'Memory',
                                    value: '14MB',
                                    sub: 'Optimized',
                                    subColor: Color(0xFF0088CC),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Buttons Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.refresh_rounded,
                            color: Color(0xFF0088CC), size: 18),
                        label: const Text(
                          'Retake Session',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0088CC)),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE8F4FB), width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          // pop until CareerHomeScreen shell (first route)
                          Navigator.popUntil(
                              context, (route) => route.isFirst);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0088CC),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Go to Home',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricProgress(String label, double val, String score) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            Text(
              score,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0088CC),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: val,
            minHeight: 6,
            backgroundColor: const Color(0xFFE8F4FB),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0088CC)),
          ),
        ),
      ],
    );
  }

  Widget _buildBulletItem(String text, Color textColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: textColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: textColor,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnergyBar(double height) {
    return Container(
      width: 4,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 2.5),
      decoration: BoxDecoration(
        color: const Color(0xFF0088CC).withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildStatusDot(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        const SizedBox(width: 4),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

class _ReviewGaugePainter extends CustomPainter {
  final double percentage;
  const _ReviewGaugePainter({required this.percentage});

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

class _CountBox extends StatelessWidget {
  final String count;
  final String label;

  const _CountBox({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006699),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExecutionStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final Color subColor;

  const _ExecutionStatCard({
    required this.label,
    required this.value,
    required this.sub,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006699),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: subColor,
            ),
          ),
        ],
      ),
    );
  }
}
