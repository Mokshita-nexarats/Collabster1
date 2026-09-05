import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LearningSession {
  final String title;
  final String hostName;
  final String type;
  final String dateLabel;
  final String timeLabel;
  final String duration;
  final bool completed;
  final IconData icon;
  const LearningSession({
    required this.title,
    required this.hostName,
    required this.type,
    required this.dateLabel,
    required this.timeLabel,
    required this.duration,
    required this.icon,
    this.completed = false,
  });
}

class ScheduledSessionsScreen extends StatefulWidget {
  final List<LearningSession> bookedSessions;
  const ScheduledSessionsScreen({super.key, this.bookedSessions = const []});

  @override
  State<ScheduledSessionsScreen> createState() => _ScheduledSessionsScreenState();
}

class _ScheduledSessionsScreenState extends State<ScheduledSessionsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late List<LearningSession> _sessions;

  static const List<LearningSession> _defaultUpcoming = [
    LearningSession(title: 'Flutter State Management Deep Dive', hostName: 'Dr. Angela Yu', type: '1:1 Mentorship', dateLabel: 'Today', timeLabel: '04:00 PM', duration: '45 min', icon: Icons.school_rounded),
    LearningSession(title: 'System Design: Scaling to 10M Users', hostName: 'Alex Xu', type: 'Live Class', dateLabel: 'Tomorrow', timeLabel: '10:00 AM', duration: '60 min', icon: Icons.architecture_rounded),
    LearningSession(title: 'AI Model Fine-tuning Workshop', hostName: 'Andrew Ng', type: 'Workshop', dateLabel: 'Fri, Aug 28', timeLabel: '06:30 PM', duration: '90 min', icon: Icons.psychology_rounded),
  ];

  static const List<LearningSession> _defaultCompleted = [
    LearningSession(title: 'Advanced React Patterns Review', hostName: 'Maximilian Schwarzmuller', type: '1:1 Mentorship', dateLabel: 'Mon, Aug 17', timeLabel: '05:00 PM', duration: '45 min', icon: Icons.code_rounded, completed: true),
    LearningSession(title: 'Clean Architecture in Dart', hostName: 'Dr. Angela Yu', type: 'Live Class', dateLabel: 'Thu, Aug 13', timeLabel: '11:00 AM', duration: '60 min', icon: Icons.layers_rounded, completed: true),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _sessions = [...widget.bookedSessions, ..._defaultUpcoming, ..._defaultCompleted];
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<LearningSession> get _visibleSessions {
    final isCompletedTab = _tabController.index == 1;
    return _sessions.where((s) => s.completed == isCompletedTab).toList();
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
                  const Expanded(
                    child: Text('Scheduled Sessions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(20)),
                    child: Text('${_sessions.where((s) => !s.completed).length} Upcoming', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(14)),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: const Color(0xFF6D28D9),
                  unselectedLabelColor: const Color(0xFF8B7BB8),
                  labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  tabs: const [
                    Tab(text: 'Upcoming'),
                    Tab(text: 'Completed'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _visibleSessions.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      color: const Color(0xFF8B5CF6),
                      onRefresh: () async {},
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                        itemCount: _visibleSessions.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (ctx, i) => _buildSessionCard(_visibleSessions[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy_rounded, size: 56, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text('Nothing here yet', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey.shade500)),
          const SizedBox(height: 4),
          Text('Booked sessions will appear here', style: TextStyle(fontSize: 12.5, color: Colors.grey.shade400)),
        ],
      ),
    );
  }

  Widget _buildSessionCard(LearningSession session) {
    final isLive = !session.completed && session.dateLabel == 'Today';
    return GestureDetector(
      onTap: () => session.completed ? _showCompletedSheet(session) : _showSessionDetails(session),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isLive ? const Color(0xFF8B5CF6) : const Color(0xFFEDE9FE), width: isLive ? 1.4 : 1.2),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: session.completed ? const Color(0xFFF3F4F6) : const Color(0xFFEDE9FE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(session.icon, color: session.completed ? Colors.grey.shade500 : const Color(0xFF8B5CF6), size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(session.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                      const SizedBox(height: 3),
                      Text('with ${session.hostName}', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
                if (isLive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(20)),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 6, color: Color(0xFFDC2626)),
                        SizedBox(width: 4),
                        Text('TODAY', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFFDC2626), letterSpacing: 0.5)),
                      ],
                    ),
                  )
                else if (session.completed)
                  Icon(Icons.check_circle_rounded, size: 20, color: Colors.green.shade600),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _metaChip(Icons.category_outlined, session.type),
                const SizedBox(width: 8),
                _metaChip(Icons.calendar_today_rounded, session.dateLabel),
                const SizedBox(width: 8),
                _metaChip(Icons.access_time_rounded, session.timeLabel),
              ],
            ),
            if (!session.completed) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Joining "${session.title}"...'), backgroundColor: const Color(0xFF8B5CF6), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(color: const Color(0xFF8B5CF6), borderRadius: BorderRadius.circular(12)),
                        child: Text(isLive ? 'Join Now' : 'Join Session', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _showRescheduleSheet(session),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.edit_calendar_rounded, color: Color(0xFF8B5CF6), size: 18),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _metaChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
        ],
      ),
    );
  }

  void _showSessionDetails(LearningSession session) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(999)))),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(14)),
                    child: Icon(session.icon, color: const Color(0xFF8B5CF6), size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(session.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                        const SizedBox(height: 2),
                        Text('${session.type} · ${session.duration}', style: TextStyle(fontSize: 12.5, color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _detailRow(Icons.person_outline_rounded, 'Host', session.hostName),
              _detailRow(Icons.videocam_outlined, 'Format', 'Video call (link sent via email)'),
              _detailRow(Icons.schedule_rounded, 'When', '${session.dateLabel} · ${session.timeLabel} (${session.duration})'),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Joining "${session.title}"...'), backgroundColor: const Color(0xFF8B5CF6), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(color: const Color(0xFF8B5CF6), borderRadius: BorderRadius.circular(14)),
                        child: const Text('Join Session', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      _showRescheduleSheet(session);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(14)),
                      child: const Icon(Icons.edit_calendar_rounded, color: Color(0xFF4B5563), size: 22),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      _confirmCancel(session);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(14)),
                      child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFDC2626), size: 22),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE5E7EB))),
            child: Icon(icon, size: 16, color: const Color(0xFF6D28D9)),
          ),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
          const Spacer(),
          Flexible(
            child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF12233D))),
          ),
        ],
      ),
    );
  }

  void _showRescheduleSheet(LearningSession session) {
    final slots = ['09:00 AM', '11:00 AM', '01:00 PM', '04:00 PM', '06:30 PM'];
    final days = ['Today', 'Tomorrow', 'Wed, Aug 26', 'Thu, Aug 27', 'Fri, Aug 28'];
    var selectedDay = days.indexOf(session.dateLabel);
    if (selectedDay < 0) selectedDay = 0;
    var selectedSlot = slots.indexOf(session.timeLabel);
    if (selectedSlot < 0) selectedSlot = 0;

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
                const Text('Reschedule Session', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                const SizedBox(height: 4),
                Text(session.title, style: TextStyle(fontSize: 12.5, color: Colors.grey.shade500)),
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
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _sessions[_sessions.indexOf(session)] = LearningSession(
                        title: session.title,
                        hostName: session.hostName,
                        type: session.type,
                        dateLabel: days[selectedDay],
                        timeLabel: slots[selectedSlot],
                        duration: session.duration,
                        icon: session.icon,
                      );
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Session rescheduled! Invite updated.'), backgroundColor: Color(0xFF10B981), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)))));
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(color: const Color(0xFF8B5CF6), borderRadius: BorderRadius.circular(14)),
                    child: const Text('Confirm Reschedule', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmCancel(LearningSession session) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cancel session?', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        content: Text('Your ${session.type.toLowerCase()} with ${session.hostName} on ${session.dateLabel} will be cancelled.', style: const TextStyle(fontSize: 13.5, height: 1.4)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Keep it', style: TextStyle(fontWeight: FontWeight.w700))),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _sessions.remove(session));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Session cancelled'), backgroundColor: Color(0xFFEF4444), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)))));
            },
            child: const Text('Cancel session', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showCompletedSheet(LearningSession session) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(999)))),
              const SizedBox(height: 16),
              Text(session.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
              const SizedBox(height: 4),
              Text('Completed · ${session.dateLabel} · ${session.hostName}', style: TextStyle(fontSize: 12.5, color: Colors.grey.shade500)),
              const SizedBox(height: 18),
              _sheetOption(Icons.description_outlined, 'View Session Notes', const Color(0xFF8B5CF6), () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening session notes...'), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)))));
              }),
              const SizedBox(height: 8),
              _sheetOption(Icons.refresh_rounded, 'Book Again', const Color(0xFF10B981), () {
                Navigator.pop(ctx);
                setState(() {
                  _sessions.insert(0, LearningSession(title: session.title, hostName: session.hostName, type: session.type, dateLabel: 'Tomorrow', timeLabel: session.timeLabel, duration: session.duration, icon: session.icon));
                });
                _tabController.animateTo(0);
              }),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetOption(IconData icon, String label, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE5E7EB))),
          child: Row(
            children: [
              Icon(icon, color: color, size: 21),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: Color(0xFF12233D))),
              const Spacer(),
              Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade400, size: 15),
            ],
          ),
        ),
      ),
    );
  }
}
