import 'package:flutter/material.dart';
import 'live_session_screen.dart';

class SessionDetailScreen extends StatelessWidget {
  final String mentee, topic, date, duration, type, status;

  const SessionDetailScreen({
    super.key,
    required this.mentee,
    required this.topic,
    required this.date,
    required this.duration,
    required this.type,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isUpcoming = status == 'Upcoming';
    final isCompleted = status == 'Completed';
    final Color statusColor = isUpcoming ? const Color(0xFF14B8A6) : isCompleted ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final Color statusBg = isUpcoming ? const Color(0xFFCCFBF1) : isCompleted ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2);

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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(20)),
                            child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        child: Text(mentee[0], style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 12),
                      Text(mentee, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(topic, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 14)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _infoChip(Icons.access_time_rounded, date),
                          const SizedBox(width: 10),
                          _infoChip(Icons.timer_outlined, duration),
                          const SizedBox(width: 10),
                          _infoChip(Icons.videocam_outlined, type),
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
                const Text('Session Details', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                const SizedBox(height: 12),
                _buildDetailRow('Topic', topic),
                const SizedBox(height: 8),
                _buildDetailRow('Mentee', mentee),
                const SizedBox(height: 8),
                _buildDetailRow('Date & Time', date),
                const SizedBox(height: 8),
                _buildDetailRow('Duration', duration),
                const SizedBox(height: 8),
                _buildDetailRow('Type', type),
                const SizedBox(height: 24),
                if (isCompleted) ...[
                  const Text('Session Notes', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFCCFBF1), width: 1),
                    ),
                    child: Text(
                      'Covered Flutter state management concepts including Provider, Riverpod, and BLoC patterns. Mentee showed good understanding and completed the practical exercise.',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                if (isUpcoming) ...[
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LiveSessionScreen(mentee: mentee, topic: topic))),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(color: const Color(0xFF14B8A6), borderRadius: BorderRadius.circular(14)),
                            child: const Text('Start Session', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(color: const Color(0xFFCCFBF1), borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.chat_rounded, color: Color(0xFF0D9488), size: 22),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFEF4444), width: 1)),
                    child: const Text('Cancel Session', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFFEF4444))),
                  ),
                ],
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 14),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCCFBF1), width: 1),
      ),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF111827))),
        ],
      ),
    );
  }
}
