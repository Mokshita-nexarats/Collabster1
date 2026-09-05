import 'package:flutter/material.dart';
import '../../../../core/theme/investor_colors.dart';

class ScheduledMeeting {
  ScheduledMeeting({
    required this.id,
    required this.subject,
    required this.startup,
    required this.type,
    required this.time,
    required this.founder,
    this.isLive = false,
  });

  final String id;
  final String subject;
  final String startup;
  final String type; // Pitch Call, Founder Sync, Diligence Call, Term Sheet
  final String time;
  final String founder;
  bool isLive;
}

/// Meetings Screen — view & manage scheduled founder pitch sync meetings
class InvestorMeetingsScreen extends StatefulWidget {
  const InvestorMeetingsScreen({super.key});

  @override
  State<InvestorMeetingsScreen> createState() => _InvestorMeetingsScreenState();
}

class _InvestorMeetingsScreenState extends State<InvestorMeetingsScreen> {
  final List<ScheduledMeeting> _meetings = [
    ScheduledMeeting(
      id: 'm1',
      subject: 'Series A Term Sheet Review & Technical Q&A',
      startup: 'Nova Robotics',
      type: 'Pitch Call',
      time: 'Today • 3:00 PM - 4:00 PM',
      founder: 'Dr. Aris Vance (CEO)',
      isLive: true,
    ),
    ScheduledMeeting(
      id: 'm2',
      subject: 'Seed Round Cap Table & Allocation Sync',
      startup: 'FinEdge Tech',
      type: 'Founder Sync',
      time: 'Tomorrow • 10:00 AM - 10:45 AM',
      founder: 'Elena Rostova (Co-founder)',
    ),
    ScheduledMeeting(
      id: 'm3',
      subject: 'Financial Audit & Customer Reference Call',
      startup: 'QuantumPay',
      type: 'Diligence Call',
      time: 'Aug 29 • 2:00 PM - 2:30 PM',
      founder: 'Marcus Sterling (CEO)',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: InvestorColors.goldBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(gradient: InvestorColors.headerGradient),
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
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 21),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Scheduled Meetings',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Sync calls with founders & diligence leads',
                                  style: TextStyle(color: Colors.white70, fontSize: 12.5),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '${_meetings.length} Scheduled',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ..._meetings.map((meet) => Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: InvestorColors.border),
                        boxShadow: const [
                          BoxShadow(color: Color(0x08000000), blurRadius: 10, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0088CC).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  meet.type,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0088CC),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                meet.startup,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: InvestorColors.textMuted,
                                ),
                              ),
                              const Spacer(),
                              if (meet.isLive)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.circle, color: Color(0xFFEF4444), size: 7),
                                      SizedBox(width: 4),
                                      Text(
                                        'LIVE NOW',
                                        style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900, color: Color(0xFFEF4444)),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            meet.subject,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: InvestorColors.ink,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.person_outline_rounded, size: 15, color: InvestorColors.textMuted),
                              const SizedBox(width: 4),
                              Text(
                                meet.founder,
                                style: const TextStyle(fontSize: 12.5, color: InvestorColors.inkSoft, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.schedule_rounded, size: 15, color: Color(0xFF0088CC)),
                              const SizedBox(width: 4),
                              Text(
                                meet.time,
                                style: const TextStyle(fontSize: 12.5, color: Color(0xFF0088CC), fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Joining ${meet.startup} meeting room...'),
                                    backgroundColor: const Color(0xFF0088CC),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: meet.isLive ? const Color(0xFF0088CC) : InvestorColors.goldDeep,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(vertical: 11),
                              ),
                              icon: Icon(meet.isLive ? Icons.videocam_rounded : Icons.calendar_month_rounded, color: Colors.white, size: 18),
                              label: Text(
                                meet.isLive ? 'Join Meeting Now' : 'View Calendar Invite',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
