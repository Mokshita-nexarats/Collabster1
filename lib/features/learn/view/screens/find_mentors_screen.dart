import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'scheduled_sessions_screen.dart';

class FindMentorsScreen extends StatefulWidget {
  const FindMentorsScreen({super.key});

  @override
  State<FindMentorsScreen> createState() => _FindMentorsScreenState();
}

class _FindMentorsScreenState extends State<FindMentorsScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Flutter', 'React', 'AI/ML', 'System Design'];

  final List<_Mentor> _allMentors = [
    _Mentor(name: 'Dr. Angela Yu', specialty: 'Flutter & Dart Expert', rating: 4.9, sessions: 342, price: '\$45/session', avatar: 1, available: true, category: 'Flutter'),
    _Mentor(name: 'Maximilian Schwarzmuller', specialty: 'Full-Stack React/Node', rating: 4.8, sessions: 289, price: '\$55/session', avatar: 2, available: true, category: 'React'),
    _Mentor(name: 'Andrew Ng', specialty: 'AI & Machine Learning', rating: 5.0, sessions: 156, price: '\$75/session', avatar: 3, available: false, category: 'AI/ML'),
    _Mentor(name: 'Alex Xu', specialty: 'System Design & Architecture', rating: 4.7, sessions: 198, price: '\$60/session', avatar: 4, available: true, category: 'System Design'),
    _Mentor(name: 'Sarah Drasner', specialty: 'Vue.js & Frontend Leadership', rating: 4.9, sessions: 267, price: '\$50/session', avatar: 5, available: true, category: 'React'),
  ];

  List<_Mentor> get _filteredMentors {
    if (_selectedFilter == 0) return _allMentors;
    return _allMentors.where((m) => m.category == _filters[_selectedFilter]).toList();
  }

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
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF8B5CF6), size: 22),
                  ),
                  const SizedBox(width: 14),
                  const Text('Find Mentors', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
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
                        color: selected ? const Color(0xFF8B5CF6) : const Color(0xFFEDE9FE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(_filters[i], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: selected ? Colors.white : const Color(0xFF6D28D9))),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredMentors.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.school_outlined, size: 48, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          Text('No mentors found', style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: _filteredMentors.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (ctx, i) => _buildMentorCard(_filteredMentors[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMentorCard(_Mentor mentor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDE9FE), width: 1.2),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: const Color(0xFFEDE9FE),
                child: Text(mentor.name[0], style: const TextStyle(color: Color(0xFF8B5CF6), fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mentor.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                    Text(mentor.specialty, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  ],
                ),
              ),
              if (mentor.available)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(20)),
                  child: const Text('Available', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF047857))),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(20)),
                  child: const Text('Busy', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFDC2626))),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.star_rounded, color: const Color(0xFFFBBF24), size: 18),
              const SizedBox(width: 4),
              Text(mentor.rating.toString(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
              const SizedBox(width: 12),
              Icon(Icons.chat_bubble_outline_rounded, size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text('${mentor.sessions} sessions', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              const Spacer(),
              Text(mentor.price, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6))),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: mentor.available ? () => _showBookingSheet(mentor) : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(color: mentor.available ? const Color(0xFF8B5CF6) : Colors.grey.shade300, borderRadius: BorderRadius.circular(12)),
                    child: Text('Book Session', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: mentor.available ? Colors.white : Colors.grey.shade600)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.message_rounded, color: Color(0xFF8B5CF6), size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showBookingSheet(_Mentor mentor) {
    final days = ['Today', 'Tomorrow', 'Wed, Aug 26', 'Thu, Aug 27', 'Fri, Aug 28'];
    final slots = ['09:00 AM', '11:00 AM', '01:00 PM', '04:00 PM', '06:30 PM'];
    var selectedDay = -1;
    var selectedSlot = -1;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(999)))),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFFEDE9FE),
                      child: Text(mentor.name[0], style: const TextStyle(color: Color(0xFF8B5CF6), fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Book with ${mentor.name}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                          Text('${mentor.specialty} · ${mentor.price}', style: TextStyle(fontSize: 12.5, color: Colors.grey.shade500)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text('Pick a day', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF374151))),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(days.length, (i) {
                    final selected = selectedDay == i;
                    return GestureDetector(
                      onTap: () => setSheetState(() => selectedDay = i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected ? const Color(0xFF8B5CF6) : const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: selected ? const Color(0xFF8B5CF6) : const Color(0xFFE5E7EB)),
                        ),
                        child: Text(days[i], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? Colors.white : const Color(0xFF374151))),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 18),
                const Text('Pick a time slot', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF374151))),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(slots.length, (i) {
                    final selected = selectedSlot == i;
                    return GestureDetector(
                      onTap: () => setSheetState(() => selectedSlot = i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected ? const Color(0xFF8B5CF6) : const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: selected ? const Color(0xFF8B5CF6) : const Color(0xFFE5E7EB)),
                        ),
                        child: Text(slots[i], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? Colors.white : const Color(0xFF374151))),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 22),
                GestureDetector(
                  onTap: selectedDay >= 0 && selectedSlot >= 0
                      ? () {
                          Navigator.pop(ctx);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ScheduledSessionsScreen(
                                bookedSessions: [
                                  LearningSession(
                                    title: 'Mentorship Session',
                                    hostName: mentor.name,
                                    type: '1:1 Mentorship',
                                    dateLabel: days[selectedDay],
                                    timeLabel: slots[selectedSlot],
                                    duration: '45 min',
                                    icon: Icons.school_rounded,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      : null,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: selectedDay >= 0 && selectedSlot >= 0 ? const Color(0xFF8B5CF6) : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      selectedDay >= 0 && selectedSlot >= 0 ? 'Confirm Booking' : 'Select day & time',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: selectedDay >= 0 && selectedSlot >= 0 ? Colors.white : Colors.grey.shade600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Mentor {
  final String name, specialty, price, category;
  final double rating;
  final int sessions;
  final int avatar;
  final bool available;
  const _Mentor({required this.name, required this.specialty, required this.rating, required this.sessions, required this.price, required this.avatar, required this.available, required this.category});
}
