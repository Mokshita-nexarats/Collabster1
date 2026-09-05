import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/career_providers.dart';
import 'interview_details_screen.dart';
import 'peer_booking_screen.dart';

class BookedSessionsScreen extends ConsumerStatefulWidget {
  const BookedSessionsScreen({super.key});

  @override
  ConsumerState<BookedSessionsScreen> createState() => _BookedSessionsScreenState();
}

class _BookedSessionsScreenState extends ConsumerState<BookedSessionsScreen> {
  @override
  Widget build(BuildContext context) {
    final careerState = ref.watch(careerStateProvider);
    final completedList = careerState.completedInterviews;

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
                    'Booked Sessions',
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
                      // Section 1: Active & Upcoming
                      const Text(
                        'Active & Upcoming',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Card 1: Sarah Jenkins (Live soon)
                      _buildUpcomingCard(
                        avatarUrl: 'https://i.pravatar.cc/150?img=32',
                        name: 'Sarah Jenkins',
                        role: 'System Design Expert',
                        badgeText: 'Live in 15mins',
                        badgeColor: const Color(0xFFD1FAE5),
                        badgeTextColor: const Color(0xFF047857),
                        hasDot: true,
                        dateTime: 'Today, 10:00 AM',
                        isLobbyActive: true,
                      ),
                      const SizedBox(height: 16),

                      // Card 2: Alex Rivera (Starts in 2 days)
                      _buildUpcomingCard(
                        avatarUrl: 'https://i.pravatar.cc/150?img=59',
                        name: 'Alex Rivera',
                        role: 'Behavioral Interviewing',
                        badgeText: 'Starts in 2 days',
                        badgeColor: const Color(0xFFE8F4FB),
                        badgeTextColor: const Color(0xFF0088CC),
                        hasDot: false,
                        dateTime: 'July 26, 2:30 PM',
                        isLobbyActive: false,
                      ),
                      const SizedBox(height: 24),

                      // Section 2: History Header (Completed Mock Interviews)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Completed Mock Interviews',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'View All',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0088CC),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Dynamic Completed Interviews List
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: completedList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = completedList[index];
                          return _buildHistoryRow(
                            avatarUrl: 'https://i.pravatar.cc/150?img=${30 + index}',
                            name: '${item.interviewer} • ${item.company}',
                            status: '${item.status} (${item.score})',
                            statusColor: const Color(0xFF047857),
                            statusBg: const Color(0xFFD1FAE5),
                            date: item.date,
                            hasPlayIcon: true,
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Section 3: Recommended for You
                      const Text(
                        'Recommended for You',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Recommendation grid/cards row
                      Row(
                        children: [
                          Expanded(
                            child: _buildRecommendedCoachCard(
                              avatarUrl: 'https://i.pravatar.cc/150?img=67',
                              rating: '4.9',
                              name: 'David Kim',
                              specialty: 'Frontend Expert',
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildRecommendedCoachCard(
                              avatarUrl: 'https://i.pravatar.cc/150?img=43',
                              rating: '5.0',
                              name: 'Priya Shah',
                              specialty: 'Product Lead',
                            ),
                          ),
                        ],
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

  Widget _buildUpcomingCard({
    required String avatarUrl,
    required String name,
    required String role,
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
    required bool hasDot,
    required String dateTime,
    required bool isLobbyActive,
  }) {
    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
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
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      role,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasDot) ...[
                      CircleAvatar(radius: 3, backgroundColor: badgeTextColor),
                      const SizedBox(width: 5),
                    ],
                    Text(
                      badgeText,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: badgeTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Date detail row
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, color: Colors.grey.shade400, size: 14),
              const SizedBox(width: 6),
              Text(
                dateTime,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: ElevatedButton(
                    onPressed: isLobbyActive ? () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const InterviewDetailsScreen()));
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0088CC),
                      disabledBackgroundColor: const Color(0xFFE2E8F0),
                      elevation: 0,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Enter Lobby',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isLobbyActive ? Colors.white : Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening reschedule options...')),
                      );
                    },
                    child: const Text(
                      'Reschedule',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0088CC),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryRow({
    required String avatarUrl,
    required String name,
    required String status,
    required Color statusColor,
    required Color statusBg,
    required String date,
    required bool hasPlayIcon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8F4FB), width: 1.2),
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
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      date,
                      style: TextStyle(fontSize: 9, color: Colors.grey.shade400),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (hasPlayIcon) ...[
            const Icon(Icons.play_circle_outline_rounded, color: Color(0xFF0088CC), size: 22),
            const SizedBox(width: 12),
          ],
          SizedBox(
            height: 28,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PeerBookingScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF0F9FF),
                elevation: 0,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Rebook',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0088CC),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedCoachCard({
    required String avatarUrl,
    required String rating,
    required String name,
    required String specialty,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8F4FB), width: 1.2),
      ),
      child: Column(
        children: [
          // Avatar with floating rating badge
          Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 34,
                backgroundImage: NetworkImage(avatarUrl),
              ),
              Positioned(
                bottom: -8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFFBBF24), size: 10),
                      const SizedBox(width: 2),
                      Text(
                        rating,
                        style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Name & Specialty
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              specialty,
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0088CC),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Book button
          SizedBox(
            width: double.infinity,
            height: 32,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PeerBookingScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0088CC),
                elevation: 0,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Book',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
