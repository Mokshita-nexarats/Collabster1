import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import 'applied_applications_screen.dart';
import 'check_resume_score_screen.dart';
import 'job_detail_screen.dart';
import 'jobs_screen.dart';
import 'mock_interviews_screen.dart';
import 'resume_screen.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBack;
  const ExploreScreen({super.key, this.onBack});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _savedJobTitles = {};
  String _selectedSkill = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSave(String title) {
    setState(() {
      if (_savedJobTitles.contains(title)) {
        _savedJobTitles.remove(title);
      } else {
        _savedJobTitles.add(title);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final session = authState.session;
    final userName = session?.fullName ?? 'Alex';
    final firstName = userName.split(RegExp(r'\s+')).first;

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Bar
              _buildTopBar(context),
              const SizedBox(height: 16),

              // 2. Greeting Header & Search
              Text(
                'Explore Now',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Where would you like to grow today, $firstName?',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF334155),
                  height: 1.3,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar Input
              _buildSearchBar(),
              const SizedBox(height: 24),

              // 3. Feature Hero Cards
              _buildFeatureHeroCard(
                icon: Icons.work_outline_rounded,
                title: 'Find Your Role',
                subtitle: 'Explore AI-curated job feeds tailored to your unique expertise and career goals.',
                ctaText: 'Explore Jobs >',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => JobsScreen(onBack: () => Navigator.pop(context)),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              _buildFeatureHeroCard(
                icon: Icons.verified_outlined,
                title: 'Practice & Interview',
                subtitle: 'Sharpen your skills with AI-powered mock interviews and real-time coding challenges.',
                ctaText: 'Start Session >',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MockInterviewsScreen(onBack: () => Navigator.pop(context)),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              _buildFeatureHeroCard(
                icon: Icons.show_chart_rounded,
                title: 'Track Progress',
                subtitle: 'Monitor your application pipeline and see exactly where you stand in the process.',
                ctaText: 'View Pipeline >',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AppliedApplicationsScreen(onBack: () => Navigator.pop(context)),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // 4. Jobs Picked For You Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Jobs Picked For You',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.3,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JobsScreen(onBack: () => Navigator.pop(context)),
                        ),
                      );
                    },
                    child: Row(
                      children: const [
                        Text(
                          'View all',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0088CC),
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.open_in_new_rounded, size: 14, color: Color(0xFF0088CC)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Job Cards
              _buildJobCard(
                context: context,
                icon: Icons.design_services_outlined,
                title: 'Senior Product Designer',
                company: 'FlowState',
                location: 'Remote, US',
                salary: '\$150k - \$210k',
                tags: ['Figma', 'UI/UX', 'Design Systems'],
              ),
              const SizedBox(height: 16),

              _buildJobCard(
                context: context,
                icon: Icons.memory_rounded,
                title: 'Staff ML Engineer',
                company: 'NexusAI',
                location: 'Palo Alto, CA',
                salary: '\$220k - \$280k',
                tags: ['Python', 'PyTorch', 'LLMs'],
              ),
              const SizedBox(height: 28),

              // 5. Trending Skills Card
              _buildTrendingSkillsCard(),
              const SizedBox(height: 20),

              // 6. Salary Analytics Card
              _buildSalaryAnalyticsCard(context),
              const SizedBox(height: 20),

              // 7. Premium AI Boost Banner
              _buildPremiumBanner(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        if (widget.onBack != null)
          GestureDetector(
            onTap: widget.onBack,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0088CC), size: 20),
            ),
          )
        else
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4FB),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.explore_rounded, color: Color(0xFF0088CC), size: 22),
          ),
        const Spacer(),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: const Icon(Icons.notifications_outlined, color: Color(0xFF0088CC), size: 20),
        ),
        const SizedBox(width: 10),
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFF0088CC),
          child: const Text(
            'A',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFE8F4FB), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0088CC).withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A), fontWeight: FontWeight.w500),
              decoration: const InputDecoration(
                hintText: 'Search roles, skills, or companies...',
                hintStyle: TextStyle(fontSize: 14, color: Color(0xFF94A3B8), fontWeight: FontWeight.w400),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            GestureDetector(
              onTap: () => setState(() => _searchController.clear()),
              child: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8), size: 18),
            ),
        ],
      ),
    );
  }

  Widget _buildFeatureHeroCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String ctaText,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8F4FB), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0088CC).withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4FB),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF0088CC), size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onTap,
            child: Text(
              ctaText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0088CC),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String company,
    required String location,
    required String salary,
    required List<String> tags,
  }) {
    final isSaved = _savedJobTitles.contains(title);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8F4FB), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0088CC).withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: const Color(0xFF0088CC), size: 24),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircleAvatar(radius: 3, backgroundColor: Color(0xFF166534)),
                    SizedBox(width: 5),
                    Text(
                      'ACTIVELY HIRING',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF166534),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.business_rounded, size: 14, color: Color(0xFF64748B)),
              const SizedBox(width: 4),
              Text(
                company,
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF64748B)),
              const SizedBox(width: 4),
              Text(
                location,
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            salary,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _toggleSave(title),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isSaved ? const Color(0xFF0088CC) : const Color(0xFFCBD5E1),
                      width: 1.3,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    isSaved ? 'Saved ✓' : 'Save',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isSaved ? const Color(0xFF0088CC) : const Color(0xFF475569),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JobDetailsScreen(
                          title: title,
                          company: company,
                          location: location,
                          salary: salary,
                          tags: tags,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0088CC),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Apply Now',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingSkillsCard() {
    final skills = ['System Design', 'LLM Engineering', 'Next.js', 'Rust', 'AWS Lambda', 'Tailwind CSS'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8F4FB), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trending Skills',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: skills.map((skill) {
              final selected = _selectedSkill == skill;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSkill = selected ? '' : skill;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFF0088CC) : const Color(0xFFE8F4FB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    skill,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : const Color(0xFF0088CC),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryAnalyticsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8F4FB), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0088CC).withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Salary Analytics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Market value benchmarks for Senior Design roles in your area.',
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 20),

          // Custom Salary Curve Chart Visual
          SizedBox(
            height: 75,
            width: double.infinity,
            child: CustomPaint(
              painter: _SalaryChartPainter(),
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CheckResumeScoreScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                'Check Market Value',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF0088CC).withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF0088CC), width: 1),
            ),
            child: const Text(
              'PREMIUM',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Color(0xFF229ED9),
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Unlock AI Resume Boost',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Get 50% more matches with our deep-learning profile optimizer.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF94A3B8),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ResumeScreen()),
              );
            },
            child: Row(
              children: const [
                Text(
                  'Go Pro Now',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.bolt_rounded, color: Color(0xFF229ED9), size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SalaryChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path()
      ..moveTo(0, h * 0.7)
      ..cubicTo(w * 0.25, h * 0.85, w * 0.5, h * 0.6, w * 0.75, h * 0.25)
      ..cubicTo(w * 0.85, h * 0.1, w * 0.95, h * 0.4, w, h * 0.3);

    final linePaint = Paint()
      ..color = const Color(0xFF0088CC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    // Draw marker dot
    final markerOffset = Offset(w * 0.75, h * 0.25);
    final dotPaint = Paint()..color = const Color(0xFF0088CC);
    final bgDotPaint = Paint()..color = Colors.white;

    canvas.drawCircle(markerOffset, 6, bgDotPaint);
    canvas.drawCircle(markerOffset, 4, dotPaint);

    // Draw Tooltip Badge
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '75th %',
        style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final tooltipRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w * 0.75, h * 0.25 - 18), width: 44, height: 18),
      const Radius.circular(6),
    );

    canvas.drawRRect(tooltipRRect, Paint()..color = const Color(0xFF0088CC));
    textPainter.paint(
      canvas,
      Offset(w * 0.75 - textPainter.width / 2, h * 0.25 - 18 - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
