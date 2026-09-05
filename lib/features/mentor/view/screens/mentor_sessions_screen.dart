import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'session_detail_screen.dart';

class MentorSessionsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const MentorSessionsScreen({super.key, this.onBack});

  @override
  State<MentorSessionsScreen> createState() => _MentorSessionsScreenState();
}

class _MentorSessionsScreenState extends State<MentorSessionsScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Upcoming', 'Completed', 'Cancelled'];

  final List<_Session> _allSessions = [
    _Session(mentee: 'Priya Sharma', topic: 'Flutter State Management', date: 'Today, 3:00 PM', duration: '60 min', status: 'Upcoming', type: 'Video Call'),
    _Session(mentee: 'Alex Chen', topic: 'System Design Review', date: 'Tomorrow, 10:00 AM', duration: '45 min', status: 'Upcoming', type: 'Video Call'),
    _Session(mentee: 'Marcus Lee', topic: 'Code Review Session', date: 'Aug 20, 2:00 PM', duration: '30 min', status: 'Completed', type: 'Screen Share'),
    _Session(mentee: 'David Kim', topic: 'Career Guidance', date: 'Aug 18, 11:00 AM', duration: '60 min', status: 'Completed', type: 'Video Call'),
    _Session(mentee: 'Sarah Johnson', topic: 'AI Project Planning', date: 'Aug 15, 4:00 PM', duration: '45 min', status: 'Cancelled', type: 'Video Call'),
  ];

  List<_Session> get _filteredSessions {
    if (_selectedFilter == 0) return _allSessions;
    return _allSessions.where((s) => s.status == _filters[_selectedFilter]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDFA),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onBack ?? () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF14B8A6), size: 22),
                  ),
                  const SizedBox(width: 14),
                  const Text('Sessions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: List.generate(_filters.length, (i) {
                  final selected = _selectedFilter == i;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() => _selectedFilter = i);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? const Color(0xFF14B8A6) : const Color(0xFFCCFBF1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(_filters[i], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: selected ? Colors.white : const Color(0xFF0D9488))),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredSessions.isEmpty
                  ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.event_outlined, size: 48, color: Colors.grey.shade300), const SizedBox(height: 12), Text('No sessions found', style: TextStyle(fontSize: 14, color: Colors.grey.shade500))]))
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: _filteredSessions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (ctx, i) {
                        final session = _filteredSessions[i];
                        return GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SessionDetailScreen(
                            mentee: session.mentee,
                            topic: session.topic,
                            date: session.date,
                            duration: session.duration,
                            type: session.type,
                            status: session.status,
                          ))),
                          child: _buildSessionCard(session),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionCard(_Session session) {
    final statusColor = session.status == 'Upcoming' ? const Color(0xFF14B8A6) : session.status == 'Completed' ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final statusBg = session.status == 'Upcoming' ? const Color(0xFFCCFBF1) : session.status == 'Completed' ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCCFBF1), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 20, backgroundColor: const Color(0xFFCCFBF1), child: Text(session.mentee[0], style: const TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold, fontSize: 14))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(session.mentee, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                  Text(session.topic, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(20)),
                child: Text(session.status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.access_time_rounded, size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text('${session.date}  •  ${session.duration}', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              const Spacer(),
              Icon(Icons.videocam_outlined, size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text(session.type, style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Session {
  final String mentee, topic, date, duration, status, type;
  const _Session({required this.mentee, required this.topic, required this.date, required this.duration, required this.status, required this.type});
}
