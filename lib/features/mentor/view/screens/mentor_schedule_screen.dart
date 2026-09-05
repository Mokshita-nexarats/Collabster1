import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MentorScheduleScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const MentorScheduleScreen({super.key, this.onBack});

  @override
  State<MentorScheduleScreen> createState() => _MentorScheduleScreenState();
}

class _MentorScheduleScreenState extends State<MentorScheduleScreen> {
  int _selectedDay = 3;
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<String> _dates = ['18', '19', '20', '21', '22', '23', '24'];

  final List<_TimeSlot> _slots = [
    _TimeSlot(time: '9:00 AM', available: true),
    _TimeSlot(time: '10:00 AM', available: false),
    _TimeSlot(time: '11:00 AM', available: true),
    _TimeSlot(time: '12:00 PM', available: true),
    _TimeSlot(time: '1:00 PM', available: false),
    _TimeSlot(time: '2:00 PM', available: true),
    _TimeSlot(time: '3:00 PM', available: false),
    _TimeSlot(time: '4:00 PM', available: true),
    _TimeSlot(time: '5:00 PM', available: true),
  ];

  void _bookSlot(_TimeSlot slot) {
    if (!slot.available) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Book Slot', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${_days[_selectedDay]}, ${_dates[_selectedDay]} Aug', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            const SizedBox(height: 4),
            Text('Time: ${slot.time}', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            const SizedBox(height: 4),
            Text('Duration: 60 min', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Slot booked for ${slot.time}'), backgroundColor: const Color(0xFF14B8A6)),
              );
            },
            child: const Text('Confirm', style: TextStyle(color: Color(0xFF14B8A6), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
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
                  const Text('Schedule', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: 7,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  final selected = _selectedDay == i;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() => _selectedDay = i);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 56,
                      decoration: BoxDecoration(
                        color: selected ? const Color(0xFF14B8A6) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: selected ? const Color(0xFF14B8A6) : const Color(0xFFE5E7EB), width: selected ? 2 : 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_days[i], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: selected ? Colors.white70 : Colors.grey.shade500)),
                          const SizedBox(height: 4),
                          Text(_dates[i], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: selected ? Colors.white : const Color(0xFF111827))),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: _slots.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (ctx, i) => GestureDetector(
                  onTap: () => _bookSlot(_slots[i]),
                  child: _buildTimeSlot(_slots[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlot(_TimeSlot slot) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: slot.available ? const Color(0xFFCCFBF1) : const Color(0xFFFEE2E2), width: 1.2),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time_rounded, size: 18, color: slot.available ? const Color(0xFF14B8A6) : Colors.grey.shade400),
          const SizedBox(width: 12),
          Text(slot.time, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: slot.available ? const Color(0xFF111827) : Colors.grey.shade400)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: slot.available ? const Color(0xFF14B8A6) : const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              slot.available ? 'Available' : 'Booked',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: slot.available ? Colors.white : const Color(0xFFEF4444)),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeSlot {
  final String time;
  final bool available;
  const _TimeSlot({required this.time, required this.available});
}
