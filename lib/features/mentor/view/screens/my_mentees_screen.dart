import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'mentee_detail_screen.dart';

class MyMenteesScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const MyMenteesScreen({super.key, this.onBack});

  @override
  State<MyMenteesScreen> createState() => _MyMenteesScreenState();
}

class _MyMenteesScreenState extends State<MyMenteesScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Active', 'Completed', 'New'];

  final List<_Mentee> _allMentees = [
    _Mentee(name: 'Priya Sharma', goal: 'Flutter Developer', sessions: 8, totalSessions: 12, progress: 0.75, status: 'Active', lastSession: '2h ago'),
    _Mentee(name: 'Alex Chen', goal: 'System Architect', sessions: 4, totalSessions: 10, progress: 0.45, status: 'Active', lastSession: '1d ago'),
    _Mentee(name: 'Marcus Lee', goal: 'Full-Stack Engineer', sessions: 12, totalSessions: 12, progress: 1.0, status: 'Completed', lastSession: '3d ago'),
    _Mentee(name: 'Sarah Johnson', goal: 'AI/ML Engineer', sessions: 2, totalSessions: 8, progress: 0.25, status: 'New', lastSession: '5d ago'),
    _Mentee(name: 'David Kim', goal: 'DevOps Specialist', sessions: 6, totalSessions: 10, progress: 0.60, status: 'Active', lastSession: '12h ago'),
  ];

  List<_Mentee> get _filteredMentees {
    if (_selectedFilter == 0) return _allMentees;
    return _allMentees.where((m) => m.status == _filters[_selectedFilter]).toList();
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
                  const Text('My Mentees', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFF14B8A6).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                    child: Text('${_allMentees.length} total', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF14B8A6))),
                  ),
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
              child: _filteredMentees.isEmpty
                  ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.people_outline_rounded, size: 48, color: Colors.grey.shade300), const SizedBox(height: 12), Text('No mentees found', style: TextStyle(fontSize: 14, color: Colors.grey.shade500))]))
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: _filteredMentees.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (ctx, i) {
                        final mentee = _filteredMentees[i];
                        return GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MenteeDetailScreen(
                            name: mentee.name,
                            goal: mentee.goal,
                            progress: mentee.progress,
                            sessions: mentee.sessions,
                            totalSessions: mentee.totalSessions,
                          ))),
                          child: _buildMenteeCard(mentee),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenteeCard(_Mentee mentee) {
    final statusColor = mentee.status == 'Active' ? const Color(0xFF14B8A6) : mentee.status == 'Completed' ? const Color(0xFF10B981) : const Color(0xFFF59E0B);
    final statusBg = mentee.status == 'Active' ? const Color(0xFFCCFBF1) : mentee.status == 'Completed' ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCCFBF1), width: 1.2),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 24, backgroundColor: const Color(0xFFCCFBF1), child: Text(mentee.name[0], style: const TextStyle(color: Color(0xFF0D9488), fontSize: 18, fontWeight: FontWeight.bold))),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(mentee.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                  Text(mentee.goal, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(20)),
                child: Text(mentee.status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.access_time_rounded, size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text('${mentee.sessions}/${mentee.totalSessions} sessions', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              const Spacer(),
              Text('Last: ${mentee.lastSession}', style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: mentee.progress, backgroundColor: const Color(0xFFCCFBF1), valueColor: AlwaysStoppedAnimation<Color>(statusColor), minHeight: 6),
                ),
              ),
              const SizedBox(width: 8),
              Text('${(mentee.progress * 100).toInt()}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Mentee {
  final String name, goal, status, lastSession;
  final int sessions, totalSessions;
  final double progress;
  const _Mentee({required this.name, required this.goal, required this.sessions, required this.totalSessions, required this.progress, required this.status, required this.lastSession});
}
