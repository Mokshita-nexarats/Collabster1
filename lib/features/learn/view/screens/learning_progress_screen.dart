import 'package:flutter/material.dart';

class LearningProgressScreen extends StatelessWidget {
  final VoidCallback? onBack;
  const LearningProgressScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  if (onBack != null)
                    GestureDetector(
                      onTap: onBack,
                      child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF8B5CF6), size: 22),
                    ),
                  const SizedBox(width: 14),
                  const Text('My Progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsGrid(),
                    const SizedBox(height: 24),
                    const Text('Weekly Activity', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                    const SizedBox(height: 12),
                    _buildWeeklyChart(),
                    const SizedBox(height: 24),
                    const Text('Skills Breakdown', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                    const SizedBox(height: 12),
                    _buildSkillBar('Flutter', 0.85, const Color(0xFF7C3AED)),
                    const SizedBox(height: 8),
                    _buildSkillBar('React', 0.65, const Color(0xFF6D28D9)),
                    const SizedBox(height: 8),
                    _buildSkillBar('AI/ML', 0.42, const Color(0xFF5B21B6)),
                    const SizedBox(height: 8),
                    _buildSkillBar('System Design', 0.38, const Color(0xFF8B5CF6)),
                    const SizedBox(height: 24),
                    const Text('Recent Achievements', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                    const SizedBox(height: 12),
                    _buildAchievement('Flutter Foundations', 'Completed 5 courses', Icons.flutter_dash_rounded, const Color(0xFF7C3AED)),
                    const SizedBox(height: 10),
                    _buildAchievement('21-Day Streak', 'Learning every day', Icons.local_fire_department_rounded, const Color(0xFFEF4444)),
                    const SizedBox(height: 10),
                    _buildAchievement('Quiz Master', 'Scored 90%+ on 3 quizzes', Icons.quiz_rounded, const Color(0xFFF59E0B)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _statCard('12', 'Courses\nEnrolled', const Color(0xFF8B5CF6), Icons.school_rounded),
        _statCard('5', 'Completed', const Color(0xFF10B981), Icons.check_circle_rounded),
        _statCard('21', 'Day Streak', const Color(0xFFEF4444), Icons.local_fire_department_rounded),
        _statCard('156', 'Hours\nLearned', const Color(0xFFF59E0B), Icons.access_time_rounded),
      ],
    );
  }

  Widget _statCard(String value, String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const Spacer(),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500, height: 1.2)),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final values = [0.6, 0.8, 0.45, 0.9, 0.7, 0.3, 0.5];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (i) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 100 * values[i],
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.15 + (values[i] * 0.35)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(days[i], style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillBar(String skill, double value, Color color) {
    return Row(
      children: [
        SizedBox(width: 100, child: Text(skill, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF111827)))),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(value: value, backgroundColor: color.withValues(alpha: 0.1), valueColor: AlwaysStoppedAnimation<Color>(color), minHeight: 10),
          ),
        ),
        const SizedBox(width: 10),
        Text('${(value * 100).toInt()}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildAchievement(String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.15), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Icon(Icons.emoji_events_rounded, color: color, size: 20),
        ],
      ),
    );
  }
}
