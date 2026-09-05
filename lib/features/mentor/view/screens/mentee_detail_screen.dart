import 'package:flutter/material.dart';
import '../../../inbox/view/inbox_screen.dart';
import 'mentor_schedule_screen.dart';

class MenteeDetailScreen extends StatelessWidget {
  final String name, goal;
  final double progress;
  final int sessions, totalSessions;

  const MenteeDetailScreen({
    super.key,
    required this.name,
    required this.goal,
    required this.progress,
    required this.sessions,
    required this.totalSessions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDFA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF0D9488), Color(0xFF14B8A6)]),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.more_vert_rounded, color: Colors.white, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        child: Text(name[0], style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 12),
                      Text(name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(goal, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 14)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _headerStat('$sessions/$totalSessions', 'Sessions'),
                          _headerStat('${(progress * 100).toInt()}%', 'Progress'),
                          _headerStat('4.8', 'Rating'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildProgressSection(),
                const SizedBox(height: 20),
                const Text('Session History', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                const SizedBox(height: 12),
                _buildSessionHistory('Flutter State Management', 'Aug 20, 3:00 PM', '60 min', true),
                const SizedBox(height: 10),
                _buildSessionHistory('Code Review Best Practices', 'Aug 18, 10:00 AM', '45 min', true),
                const SizedBox(height: 10),
                _buildSessionHistory('Career Planning Discussion', 'Aug 15, 2:00 PM', '30 min', true),
                const SizedBox(height: 20),
                const Text('Goals & Notes', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                const SizedBox(height: 12),
                _buildGoalCard('Master Flutter state management', 'In Progress', const Color(0xFF14B8A6)),
                const SizedBox(height: 8),
                _buildGoalCard('Build 3 portfolio projects', 'In Progress', const Color(0xFF0D9488)),
                const SizedBox(height: 8),
                _buildGoalCard('Land a junior developer role', 'Upcoming', const Color(0xFFF59E0B)),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MentorScheduleScreen())),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(color: const Color(0xFF14B8A6), borderRadius: BorderRadius.circular(14)),
                          child: const Text('Schedule Session', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InboxScreen())),
                      child: Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(color: const Color(0xFFCCFBF1), borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.chat_rounded, color: Color(0xFF0D9488), size: 22),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11)),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Overall Progress', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(value: progress, backgroundColor: const Color(0xFFCCFBF1), valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF14B8A6)), minHeight: 10),
          ),
          const SizedBox(height: 8),
          Text('${(progress * 100).toInt()}% complete  •  $sessions of $totalSessions sessions done', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildSessionHistory(String topic, String date, String duration, bool completed) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCCFBF1), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: completed ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(10)),
            child: Icon(completed ? Icons.check_rounded : Icons.access_time_rounded, color: completed ? const Color(0xFF047857) : const Color(0xFFD97706), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(topic, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
              Text('$date  •  $duration', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(String goal, String status, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.flag_rounded, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(goal, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF111827)))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
            child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
          ),
        ],
      ),
    );
  }
}
