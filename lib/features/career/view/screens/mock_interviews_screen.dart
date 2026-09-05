import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/theme/app_colors.dart';
import '../widgets/career_search_bar.dart';
import 'interview_details_screen.dart';
import 'match_peer_screen.dart';
import 'booked_sessions_screen.dart';
import 'peer_booking_screen.dart';

class MockInterviewsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const MockInterviewsScreen({super.key, this.onBack});

  @override
  State<MockInterviewsScreen> createState() => _MockInterviewsScreenState();
}

class _MockInterviewsScreenState extends State<MockInterviewsScreen> {
  int _selectedFilter = 0; // 0=All, 1=Technical, 2=HR, 3=Behavioral, 4=Case Study
  final List<String> _filters = ['All', 'Technical', 'HR', 'Behavioral', 'Case Study'];
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Mock Interviews',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              CareerSearchBar(
                controller: _searchController,
                hintText: 'Search interview templates, topics, or coaches...',
                hasActiveFilter: _selectedFilter != 0,
                onChanged: (value) => setState(() {}),
                onFilterTap: () {
                  setState(() {
                    _selectedFilter = (_selectedFilter + 1) % _filters.length;
                  });
                },
              ),
              const SizedBox(height: 16),


              // Filter Chips (scrollable)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: List.generate(_filters.length, (i) {
                    final selected = _selectedFilter == i;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedFilter = i),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary : const Color(0xFFE8F4FB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _filters[i],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: selected ? Colors.white : const Color(0xFF006699),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),

            // Prep Level Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F4FB),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PREP LEVEL',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0088CC),
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Prep Score: 85%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF006699),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '3 Mocks Completed this week',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 52,
                    height: 52,
                    child: CustomPaint(
                      painter: _MocksGaugePainter(percentage: 0.85),
                      child: const Center(
                        child: Text(
                          '85%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF006699),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Instant Matchmaking Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE8F4FB), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Live Now: 128 peers ready to mock',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Instant Matchmaking',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Jump into a random mock interview with a peer specializing in your role.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MatchPeerScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0088CC),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Find a Match',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Trending Mocks Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Trending Mocks',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                Text(
                  'View all',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Trending Cards (Horizontal scroll)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _TrendingMockCard(
                    icon: Icons.code_rounded,
                    title: 'Google SDE III',
                    desc: '45 min • Algorithm focus',
                    badgeCount: '+12',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InterviewDetailsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  const _TrendingMockCard(
                    icon: Icons.work_outline_rounded,
                    title: 'Stripe Product Manager',
                    desc: '60 min • Case focus',
                    badgeCount: '+8',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Explore Categories Section
            const Text(
              'Explore Categories',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 12),

            // Grid of categories
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: const [
                _CategoryGridCard(
                  icon: Icons.code_rounded,
                  title: 'Coding',
                  sessions: '42 Live Sessions',
                  bgColor: Color(0xFFF0F9FF),
                ),
                _CategoryGridCard(
                  icon: Icons.hub_outlined,
                  title: 'System Design',
                  sessions: '18 Live Sessions',
                  bgColor: Color(0xFFFFF2EB),
                ),
                _CategoryGridCard(
                  icon: Icons.people_outline_rounded,
                  title: 'Behavioral',
                  sessions: '24 Live Sessions',
                  bgColor: Color(0xFFE8F4FB),
                ),
                _CategoryGridCard(
                  icon: Icons.insert_chart_outlined_rounded,
                  title: 'Case Study',
                  sessions: '12 Live Sessions',
                  bgColor: Color(0xFFF3F4F6),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Expert Coaches Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Expert Coaches',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                Text(
                  'View all',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Coaches lists
            const _CoachRow(
              name: 'Sarah Jenkins',
              role: 'Ex-Google Senior Recruiter',
              rating: '4.9',
              reviews: '128',
              image: 'https://i.pravatar.cc/150?img=49',
            ),
            const SizedBox(height: 12),
            const _CoachRow(
              name: 'David Chen',
              role: 'Staff Engineer @ Meta',
              rating: '5.0',
              reviews: '84',
              image: 'https://i.pravatar.cc/150?img=33',
            ),
            const SizedBox(height: 24),

            // Bottom Booked Sessions Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookedSessionsScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0088CC),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Booked Sessions',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}

class _MocksGaugePainter extends CustomPainter {
  final double percentage;
  const _MocksGaugePainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 5.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background track
    final bgPaint = Paint()
      ..color = const Color(0xFFE8F4FB)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress track
    final fgPaint = Paint()
      ..color = const Color(0xFF0088CC)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * percentage,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TrendingMockCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final String badgeCount;
  final VoidCallback? onTap;

  const _TrendingMockCard({
    required this.icon,
    required this.title,
    required this.desc,
    required this.badgeCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 175,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8F4FB), width: 1.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFFF0F9FF),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 18),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              desc,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 12),
            // Avatars row
            Row(
              children: [
                const SizedBox(
                  width: 48,
                  height: 20,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=21'),
                        ),
                      ),
                      Positioned(
                        left: 24,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=43'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  badgeCount,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryGridCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String sessions;
  final Color bgColor;

  const _CategoryGridCard({
    required this.icon,
    required this.title,
    required this.sessions,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 16),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sessions,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CoachRow extends StatelessWidget {
  final String name;
  final String role;
  final String rating;
  final String reviews;
  final String image;

  const _CoachRow({
    required this.name,
    required this.role,
    required this.rating,
    required this.reviews,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
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
            radius: 22,
            backgroundImage: NetworkImage(image),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 14, color: Color(0xFFFBBF24)),
                    const SizedBox(width: 3),
                    Text(
                      '$rating ($reviews reviews)',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PeerBookingScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE8F4FB),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Book',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0088CC),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
