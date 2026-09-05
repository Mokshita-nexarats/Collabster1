import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data model for period-based analytics
// ─────────────────────────────────────────────────────────────────────────────

const _periods = ['Day', 'Week', 'Month', 'Year'];

const _profileViewsData = {
  'Day': (value: '82', change: '+2.1%', positive: true, label: 'vs yesterday'),
  'Week': (value: '574', change: '+8.3%', positive: true, label: 'vs last week'),
  'Month': (value: '2,438', change: '+10.4%', positive: true, label: 'vs last 30 days'),
  'Year': (value: '28,900', change: '+42.1%', positive: true, label: 'vs last year'),
};

const _chartPoints = {
  'Day': [30.0, 42.0, 38.0, 55.0, 48.0, 62.0, 58.0, 72.0, 65.0, 82.0],
  'Week': [180.0, 220.0, 195.0, 260.0, 240.0, 310.0, 280.0, 350.0, 320.0, 574.0],
  'Month': [40.0, 55.0, 45.0, 65.0, 50.0, 75.0, 60.0, 80.0, 70.0, 90.0],
  'Year': [60.0, 72.0, 68.0, 80.0, 74.0, 88.0, 82.0, 92.0, 88.0, 100.0],
};

const _metricsData = {
  'Day': [
    (label: 'Visitors', value: '82', change: '+2.1%', positive: true, icon: Icons.people_outline),
    (label: 'Followers', value: '14', change: '+1.2%', positive: true, icon: Icons.person_add_outlined),
    (label: 'Applications', value: '2', change: '+0.0%', positive: true, icon: Icons.work_outline),
    (label: 'Pitch Deck Views', value: '95', change: '-5.3%', positive: false, icon: Icons.slideshow_outlined),
  ],
  'Week': [
    (label: 'Visitors', value: '574', change: '+8.3%', positive: true, icon: Icons.people_outline),
    (label: 'Followers', value: '98', change: '+6.9%', positive: true, icon: Icons.person_add_outlined),
    (label: 'Applications', value: '12', change: '+20.0%', positive: true, icon: Icons.work_outline),
    (label: 'Pitch Deck Views', value: '642', change: '-12.4%', positive: false, icon: Icons.slideshow_outlined),
  ],
  'Month': [
    (label: 'Visitors', value: '2,438', change: '+13.2%', positive: true, icon: Icons.people_outline),
    (label: 'Followers', value: '1,209', change: '+12.9%', positive: true, icon: Icons.person_add_outlined),
    (label: 'Applications', value: '42', change: '+30.2%', positive: true, icon: Icons.work_outline),
    (label: 'Pitch Deck Views', value: '2,543', change: '-25.3%', positive: false, icon: Icons.slideshow_outlined),
  ],
  'Year': [
    (label: 'Visitors', value: '28,900', change: '+42.1%', positive: true, icon: Icons.people_outline),
    (label: 'Followers', value: '14,200', change: '+38.7%', positive: true, icon: Icons.person_add_outlined),
    (label: 'Applications', value: '486', change: '+61.0%', positive: true, icon: Icons.work_outline),
    (label: 'Pitch Deck Views', value: '29,800', change: '-8.2%', positive: false, icon: Icons.slideshow_outlined),
  ],
};

const _trafficData = {
  'Day': [
    (label: 'Direct Search', fraction: 0.52, color: Color(0xFF0088CC)),
    (label: 'Social Media', fraction: 0.28, color: Color(0xFF2563EB)),
    (label: 'Investor Referrals', fraction: 0.20, color: Color(0xFF059669)),
  ],
  'Week': [
    (label: 'Direct Search', fraction: 0.48, color: Color(0xFF0088CC)),
    (label: 'Social Media', fraction: 0.35, color: Color(0xFF2563EB)),
    (label: 'Investor Referrals', fraction: 0.17, color: Color(0xFF059669)),
  ],
  'Month': [
    (label: 'Direct Search', fraction: 0.45, color: Color(0xFF0088CC)),
    (label: 'Social Media', fraction: 0.32, color: Color(0xFF2563EB)),
    (label: 'Investor Referrals', fraction: 0.23, color: Color(0xFF059669)),
  ],
  'Year': [
    (label: 'Direct Search', fraction: 0.41, color: Color(0xFF0088CC)),
    (label: 'Social Media', fraction: 0.38, color: Color(0xFF2563EB)),
    (label: 'Investor Referrals', fraction: 0.21, color: Color(0xFF059669)),
  ],
};

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

class StartupAnalyticsScreen extends StatefulWidget {
  const StartupAnalyticsScreen({super.key});

  @override
  State<StartupAnalyticsScreen> createState() => _StartupAnalyticsScreenState();
}

class _StartupAnalyticsScreenState extends State<StartupAnalyticsScreen> {
  String _profilePeriod = 'Month';
  String _metricsPeriod = 'Month';
  String _trafficPeriod = 'Month';

  @override
  Widget build(BuildContext context) {
    final profile = _profileViewsData[_profilePeriod]!;
    final chartPts = _chartPoints[_profilePeriod]!;
    final metrics = _metricsData[_metricsPeriod]!;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      body: CustomScrollView(
        slivers: [
          // ── Profile Views Header Card ──────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0088CC), Color(0xFF229ED9), Color(0xFF0088CC)],
                ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                left: 20, right: 20, bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back + title
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('Analytics',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Profile Views Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Label + calendar filter button on same row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('PROFILE VIEWS',
                                style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1)),
                            const Spacer(),
                            // Period label pill
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _profilePeriod,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(width: 6),
                            // Calendar icon button
                            GestureDetector(
                              onTap: () => _showPeriodPicker(
                                title: 'Profile Views Period',
                                currentPeriod: _profilePeriod,
                                onSelected: (p) =>
                                    setState(() => _profilePeriod = p),
                              ),
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.calendar_month_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Value + change badge
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, anim) =>
                                  FadeTransition(opacity: anim, child: child),
                              child: Text(
                                profile.value,
                                key: ValueKey(profile.value),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                            const SizedBox(width: 10),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Container(
                                key: ValueKey(profile.change),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: (profile.positive
                                          ? const Color(0xFF34D399)
                                          : const Color(0xFFF87171))
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  profile.change,
                                  style: TextStyle(
                                      color: profile.positive
                                          ? const Color(0xFF34D399)
                                          : const Color(0xFFF87171),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            profile.label,
                            key: ValueKey(profile.label),
                            style: const TextStyle(
                                color: Colors.white60, fontSize: 12),
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: _ChartWidget(
                              key: ValueKey(_profilePeriod), points: chartPts),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Top Metrics ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section header + calendar filter
                  Row(
                    children: [
                      const Text('Top Metrics',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF12233D))),
                      const Spacer(),
                      // Period label pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4FB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _metricsPeriod,
                          style: const TextStyle(
                              color: Color(0xFF0088CC),
                              fontSize: 11,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Calendar icon button
                      GestureDetector(
                        onTap: () => _showPeriodPicker(
                          title: 'Top Metrics Period',
                          currentPeriod: _metricsPeriod,
                          onSelected: (p) =>
                              setState(() => _metricsPeriod = p),
                        ),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F4FB),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.calendar_month_rounded,
                            color: Color(0xFF0088CC),
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Metric rows (animated switch on period change)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: SlideTransition(
                          position: Tween<Offset>(
                                  begin: const Offset(0, 0.06),
                                  end: Offset.zero)
                              .animate(anim),
                          child: child,
                        )),
                    child: Column(
                      key: ValueKey(_metricsPeriod),
                      children: metrics
                          .map((m) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _MetricRow(
                                  icon: m.icon,
                                  label: m.label,
                                  value: m.value,
                                  change: m.change,
                                  positive: m.positive,
                                ),
                              ))
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Traffic Sources header + calendar picker
                  Row(
                    children: [
                      const Text('Traffic Sources',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF12233D))),
                      const Spacer(),
                      // Period label pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4FB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _trafficPeriod,
                          style: const TextStyle(
                              color: Color(0xFF0088CC),
                              fontSize: 11,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Calendar icon button
                      GestureDetector(
                        onTap: () => _showPeriodPicker(
                          title: 'Traffic Sources Period',
                          currentPeriod: _trafficPeriod,
                          onSelected: (p) =>
                              setState(() => _trafficPeriod = p),
                        ),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F4FB),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.calendar_month_rounded,
                            color: Color(0xFF0088CC),
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Animated traffic bars
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: SlideTransition(
                          position: Tween<Offset>(
                                  begin: const Offset(0, 0.06),
                                  end: Offset.zero)
                              .animate(anim),
                          child: child,
                        )),
                    child: Column(
                      key: ValueKey(_trafficPeriod),
                      children: _trafficData[_trafficPeriod]!
                          .map((s) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _sourceBar(
                                    s.label, s.fraction, s.color),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPeriodPicker({
    required String title,
    required String currentPeriod,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F4FB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.calendar_month_rounded,
                      color: Color(0xFF0088CC), size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF12233D))),
                    const Text('Select a time range',
                        style: TextStyle(
                            fontSize: 12, color: Color(0xFF6B7280))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ..._periods.map((p) {
              final isSelected = currentPeriod == p;
              final icons = {
                'Day': Icons.today_rounded,
                'Week': Icons.view_week_rounded,
                'Month': Icons.calendar_view_month_rounded,
                'Year': Icons.calendar_today_rounded,
              };
              final subtitles = {
                'Day': 'Data from today',
                'Week': 'Data from last 7 days',
                'Month': 'Data from last 30 days',
                'Year': 'Data from last 12 months',
              };
              return GestureDetector(
                onTap: () {
                  onSelected(p);
                  Navigator.pop(ctx);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF0088CC)
                        : const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF0088CC)
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        icons[p]!,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF0088CC),
                        size: 22,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p,
                              style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF12233D),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14),
                            ),
                            Text(
                              subtitles[p]!,
                              style: TextStyle(
                                  color: isSelected
                                      ? Colors.white70
                                      : const Color(0xFF6B7280),
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle_rounded,
                            color: Colors.white, size: 20),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _sourceBar(String label, double fraction, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151))),
            Text('${(fraction * 100).round()}%',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF12233D))),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 8,
            backgroundColor: const Color(0xFFE5E7EB),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}



// ─────────────────────────────────────────────────────────────────────────────
// Metric Row
// ─────────────────────────────────────────────────────────────────────────────

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.change,
    required this.positive,
  });
  final IconData icon;
  final String label, value, change;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
                color: const Color(0xFFE8F4FB),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: const Color(0xFF0088CC), size: 22),
          ),
          const SizedBox(width: 14),
          Text(label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151))),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF12233D))),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: (positive
                      ? const Color(0xFF059669)
                      : const Color(0xFFDC2626))
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              change,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: positive
                      ? const Color(0xFF059669)
                      : const Color(0xFFDC2626)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Chart
// ─────────────────────────────────────────────────────────────────────────────

class _ChartWidget extends StatelessWidget {
  const _ChartWidget({super.key, required this.points});
  final List<double> points;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: CustomPaint(
        painter: _LineChartPainter(points: points),
        size: const Size(double.infinity, 60),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  const _LineChartPainter({required this.points});
  final List<double> points;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.3),
          Colors.white.withValues(alpha: 0)
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();
    final min = points.reduce((a, b) => a < b ? a : b);
    final max = points.reduce((a, b) => a > b ? a : b);

    for (int i = 0; i < points.length; i++) {
      final x = i * size.width / (points.length - 1);
      final y = size.height -
          ((points[i] - min) / (max - min)) * size.height * 0.8 -
          size.height * 0.1;
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_LineChartPainter oldDelegate) =>
      oldDelegate.points != points;
}
