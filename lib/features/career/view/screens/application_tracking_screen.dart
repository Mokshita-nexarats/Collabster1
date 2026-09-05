import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ApplicationTrackingScreen extends StatelessWidget {
  const ApplicationTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Application Status',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card 1: Process Tracking timeline
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE8F4FB), width: 1.2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Process Tracking',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Timeline Custom Widgets
                            _buildTimelineStep(
                              isCompleted: true,
                              isActive: false,
                              showLine: true,
                              title: 'Application Submitted',
                              sub: 'Oct 12, 2026',
                            ),
                            _buildTimelineStep(
                              isCompleted: true,
                              isActive: false,
                              showLine: true,
                              title: 'Resume Screened',
                              sub: 'Oct 15, 2026',
                            ),
                            _buildTimelineStep(
                              isCompleted: false,
                              isActive: true,
                              showLine: true,
                              title: 'Interview Scheduled',
                              sub: 'Status: Ready for Interview',
                              subColor: const Color(0xFF0088CC),
                            ),
                            _buildTimelineStep(
                              isCompleted: false,
                              isActive: false,
                              showLine: true,
                              title: 'Hiring Manager Review',
                              sub: 'Estimated: TBD',
                            ),
                            _buildTimelineStep(
                              isCompleted: false,
                              isActive: false,
                              showLine: false,
                              title: 'Final Decision',
                              sub: 'Estimated: TBD',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Card 2: Upcoming Interview box
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0088CC),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.calendar_today_rounded, color: Colors.white70, size: 14),
                                SizedBox(width: 6),
                                Text(
                                  'UPCOMING INTERVIEW',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Monday, Oct 19, 2026',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '10:00 AM – 10:45 AM',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '(GMT+5:30)',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Meet & Link Action rows
                            Row(
                              children: [
                                _buildUpcomingActionBtn(Icons.video_call_outlined, 'Google Meet'),
                                const SizedBox(width: 8),
                                _buildUpcomingActionBtn(Icons.link_rounded, 'Link Shared'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Card 3: Your Interviewers
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE8F4FB), width: 1.2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.people_outline_rounded, color: Color(0xFF0088CC), size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Your Interviewers',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Interviewer boxes
                            _buildInterviewerRow(
                              name: 'Sarah Jenkins',
                              role: 'Senior Recruiter',
                              avatarUrl: 'https://i.pravatar.cc/150?img=32',
                            ),
                            const SizedBox(height: 10),
                            _buildInterviewerRow(
                              name: 'David Chen',
                              role: 'Staff Engineer',
                              avatarUrl: 'https://i.pravatar.cc/150?img=44',
                            ),
                            const SizedBox(height: 16),

                            // Preparation Tip Box
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F9FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.lightbulb_outline_rounded, color: Color(0xFF0088CC), size: 18),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Preparation Tip',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0088CC),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'David often focuses on architectural scalability. Review your recent system design sessions in PrepAI.',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF4B5563),
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep({
    required bool isCompleted,
    required bool isActive,
    required bool showLine,
    required String title,
    required String sub,
    Color? subColor,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Indicator circle & line
          Column(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? const Color(0xFF0088CC)
                      : isActive
                          ? Colors.white
                          : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCompleted
                        ? Colors.transparent
                        : isActive
                            ? const Color(0xFF0088CC)
                            : Colors.grey.shade300,
                    width: isActive ? 5.5 : 1.5,
                  ),
                ),
                child: isCompleted
                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 13)
                    : null,
              ),
              if (showLine)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted ? const Color(0xFF0088CC) : Colors.grey.shade300,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isCompleted || isActive ? const Color(0xFF1E293B) : Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sub,
                    style: TextStyle(
                      fontSize: 11,
                      color: subColor ?? Colors.grey.shade400,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingActionBtn(IconData icon, String text) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterviewerRow({
    required String name,
    required String role,
    required String avatarUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
