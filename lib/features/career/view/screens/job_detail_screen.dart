import 'package:flutter/material.dart';
import 'application_details_screen.dart';


class InternshipDetailsScreen extends StatefulWidget {
  final String title;
  final String company;
  final String location;
  final String stipend;
  final String type;
  final List<String> tags;
  final String? about;
  final List<String>? requirements;

  const InternshipDetailsScreen({
    super.key,
    this.title = 'Frontend Developer Intern',
    this.company = 'Google',
    this.location = 'Mountain View, CA',
    this.stipend = '₹500+',
    this.type = 'Full-time • 3 Months',
    this.tags = const ['Frontend', 'React', 'Tailwind', 'JavaScript'],
    this.about,
    this.requirements,
  });

  @override
  State<InternshipDetailsScreen> createState() => _InternshipDetailsScreenState();
}

typedef JobDetailScreen = InternshipDetailsScreen;

class _InternshipDetailsScreenState extends State<InternshipDetailsScreen> {
  int _selectedTab = 0; // 0 = ABOUT, 1 = REQUIREMENTS, 2 = PERKS, 3 = SIMILAR

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBannerWithHeaderCard(context),
                    const SizedBox(height: 16),
                    _buildTags(),
                    const SizedBox(height: 16),
                    _buildStatsRow(),
                    const SizedBox(height: 20),
                    _buildTabsHeader(),
                    const SizedBox(height: 20),
                    if (_selectedTab == 0) ...[
                      _buildAboutSection(),
                      const SizedBox(height: 24),
                      _buildPerksSection(),
                      const SizedBox(height: 24),
                      _buildRequirementsSection(),
                    ] else if (_selectedTab == 1) ...[
                      _buildRequirementsSection(),
                      const SizedBox(height: 24),
                      _buildAboutSection(),
                      const SizedBox(height: 24),
                      _buildPerksSection(),
                    ] else if (_selectedTab == 2) ...[
                      _buildPerksSection(),
                      const SizedBox(height: 24),
                      _buildAboutSection(),
                      const SizedBox(height: 24),
                      _buildRequirementsSection(),
                    ] else ...[
                      _buildAboutSection(),
                      const SizedBox(height: 24),
                      _buildRequirementsSection(),
                      const SizedBox(height: 24),
                      _buildPerksSection(),
                    ],
                    const SizedBox(height: 24),
                    _buildSimilarInternshipsSection(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            _buildBottomActionBar(),
          ],
        ),
      ),
    );
  }

  // 1. Top Banner + Header Card overlapping
  Widget _buildTopBannerWithHeaderCard(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Office Banner Image
        Container(
          height: 220,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=800&q=80',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Gradient overlay on banner for readability of top controls
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.4),
                Colors.transparent,
              ],
            ),
          ),
        ),
        // Top Navigation Controls (Back button, Share, Notification)
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          right: 16,
          child: Row(
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF0088CC),
                    size: 20,
                  ),
                ),
              ),
              const Spacer(),
              // Share Button
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.share_outlined,
                  color: Color(0xFF0088CC),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              // Bookmark Button
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bookmark_border_rounded,
                  color: Color(0xFF0088CC),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        // Floating Card
        Padding(
          padding: const EdgeInsets.only(top: 140, left: 20, right: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF0F9FF), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                              letterSpacing: -0.3,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.company,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0088CC),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4FB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.bookmark_border_rounded,
                        color: Color(0xFF0088CC),
                        size: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.location,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      widget.title.contains('UI/UX')
                          ? Icons.calendar_today_outlined
                          : Icons.work_outline_rounded,
                      size: 16,
                      color: const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.type,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 2. Tags Row
  Widget _buildTags() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.tags.map((tag) {
            Color bg;
            Color fg;
            final t = tag.toLowerCase();
            if (t.contains('figma') || t.contains('front') || t == 'sql') {
              bg = const Color(0xFFE8F4FB);
              fg = const Color(0xFF0088CC);
            } else if (t.contains('design system') || t.contains('react') || t == 'excel') {
              bg = const Color(0xFFE8F4FB);
              fg = const Color(0xFF0088CC);
            } else if (t.contains('research') || t.contains('tail') || t == 'python') {
              bg = const Color(0xFFDCFCE7);
              fg = const Color(0xFF15803D);
            } else if (t.contains('power bi') || t.contains('power')) {
              bg = const Color(0xFFFEF9C3);
              fg = const Color(0xFFA16207);
            } else {
              bg = const Color(0xFFF3F4F6);
              fg = const Color(0xFF4B5563);
            }
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildTagPill(tag, bg, fg),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTagPill(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }

  // 3. Stats Row
  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _buildStatCard('Applicants', '120+')),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard('Stipend', widget.stipend)),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard('Views', '1.2k')),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0088CC),
            ),
          ),
        ],
      ),
    );
  }

  // 4. Tabs Header
  Widget _buildTabsHeader() {
    final tabs = ['ABOUT', 'REQUIREMENTS', 'PERKS', 'SIMILAR'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(tabs.length, (i) {
                final isSelected = _selectedTab == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTab = i),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: Column(
                      children: [
                        Text(
                          tabs[i],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? const Color(0xFF0088CC) : const Color(0xFF6B7280),
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 2.5,
                          width: 40,
                          color: isSelected ? const Color(0xFF0088CC) : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          Container(
            height: 1,
            color: const Color(0xFFE5E7EB),
          ),
        ],
      ),
    );
  }

  // 5. About Section
  Widget _buildAboutSection() {
    final aboutText = widget.about ??
        (widget.title.contains('UI/UX')
            ? 'Join our design team and create delightful, accessible, and meaningful experiences for millions of users. You’ll collaborate with cross-functional teams to tackle real-world problems through user-centered design.'
            : (widget.title.contains('Data') || widget.title.contains('Analyst')
                ? 'Work with our data team to collect, clean, analyze, and visualize data that drives business decisions. You’ll build dashboards, uncover insights, and help solve real-world problems using data.'
                : 'Join our world-class engineering team and build fast, accessible, and beautiful user experiences. You\'ll work on real-world projects, collaborate with designers and engineers, and make an impact used by millions of people around the world.'));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About this Internship',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            aboutText,
            style: const TextStyle(
              fontSize: 14,
              height: 1.55,
              color: Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }

  // 6. Perks Section
  Widget _buildPerksSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Perks & Benefits',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _buildPerkTile(Icons.medical_services_outlined, 'Health Benefits')),
              const SizedBox(width: 12),
              Expanded(child: _buildPerkTile(Icons.restaurant_outlined, 'Free Gourmet Meals')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildPerkTile(Icons.school_outlined, 'Mentorship')),
              const SizedBox(width: 12),
              Expanded(child: _buildPerkTile(Icons.fitness_center_outlined, 'Gym Membership')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerkTile(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4FB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF0088CC), size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 7. Requirements Section
  Widget _buildRequirementsSection() {
    final reqs = widget.requirements ??
        (widget.title.contains('UI/UX')
            ? [
                'Proficiency in Figma, Adobe XD, or Sketch.',
                'Strong understanding of UI/UX principles and design systems.',
                'Experience with user research and usability testing.',
                'A strong portfolio showcasing end-to-end design projects.',
              ]
            : (widget.title.contains('Data') || widget.title.contains('Analyst')
                ? [
                    'Proficiency in SQL and Excel.',
                    'Knowledge of Python, Power BI, or Tableau is a plus.',
                    'Strong analytical and problem-solving skills.',
                    'Good understanding of statistics and data visualization.',
                  ]
                : [
                    'Strong portfolio demonstrating frontend projects and user empathy',
                    'Proficiency in React, JavaScript, and modern CSS frameworks',
                    'Experience with state management libraries (e.g., Redux, Zustand, Context API)',
                    'Understanding of responsive design and cross-browser compatibility',
                  ]));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Requirements',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
            ),
            child: Column(
              children: reqs.map((req) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0088CC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        req,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // 8. Similar Internships Section
  Widget _buildSimilarInternshipsSection() {
    final isUiUx = widget.title.contains('UI/UX');
    final isData = widget.title.contains('Data') || widget.title.contains('Analyst');

    final title1 = isUiUx ? 'Product Design Intern' : (isData ? 'Business Analyst Intern' : 'UI Engineer Intern');
    final company1 = isUiUx ? 'Microsoft' : (isData ? 'Deloitte' : 'Meta • Full-time');
    final salary1 = isData ? '₹45k/mo' : (isUiUx ? '₹45k/mo' : '₹45k/mo');
    final badge1 = isUiUx ? 'HOT' : (isData ? 'HOT' : '95%');
    final accent1 = isUiUx ? const Color(0xFF0088CC) : (isData ? const Color(0xFF16A34A) : const Color(0xFF0088CC));
    final icon1 = isUiUx ? Icons.grid_view_rounded : (isData ? Icons.insert_chart_outlined : Icons.all_inclusive_rounded);

    final title2 = isUiUx ? 'UX Research Intern' : (isData ? 'Data Science Intern' : 'Frontend Intern');
    final company2 = isUiUx ? 'Amazon' : (isData ? 'Amazon' : 'Notion • Part-time');
    final salary2 = isData ? '₹50k/mo' : (isUiUx ? '₹40k/mo' : '₹40k/mo');
    final badge2 = isUiUx ? '95% Match' : (isData ? '95% Match' : '93%');
    final accent2 = isData ? const Color(0xFFCA8A04) : const Color(0xFF0088CC);
    final icon2 = isUiUx ? Icons.cloud_outlined : (isData ? Icons.hexagon_outlined : Icons.note_alt_outlined);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Similar Internships',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                'View all',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0088CC),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildSimilarCard(
                  icon: icon1,
                  title: title1,
                  company: company1,
                  salary: salary1,
                  badge: badge1,
                  accent: accent1,
                  isHot: badge1 == 'HOT',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSimilarCard(
                  icon: icon2,
                  title: title2,
                  company: company2,
                  salary: salary2,
                  badge: badge2,
                  accent: accent2,
                  isHot: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarCard({
    required IconData icon,
    required String title,
    required String company,
    required String salary,
    required String badge,
    required Color accent,
    bool isHot = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: accent, size: 18),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: isHot ? const Color(0xFFFEE2E2) : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isHot ? const Color(0xFFEF4444) : const Color(0xFF15803D),
                  ),
                ),
              ),
            ],
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
          const SizedBox(height: 2),
          Text(
            company,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            salary,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }

  // 9. Bottom Action Bar
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: Color(0xFF64748B),
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApplicationDetailsScreen(
                        jobType: 'Internship',
                        jobTitle: widget.title,
                        companyName: widget.company,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0088CC),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Apply Now',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class JobDetailsScreen extends StatefulWidget {
  final String title;
  final String company;
  final String location;
  final String salary;
  final List<String> tags;
  final String? about;
  final List<String>? requirements;
  final String applied;
  final String size;
  final String views;

  const JobDetailsScreen({
    super.key,
    this.title = 'Frontend Developer',
    this.company = 'Google',
    this.location = 'Remote (Worldwide)',
    this.salary = '\$80k – \$110k USD',
    this.tags = const ['React', 'Tailwind'],
    this.about,
    this.requirements,
    this.applied = '450+',
    this.size = '2 – 5 yrs',
    this.views = '2 hours ago',
  });

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  int _selectedTab = 0; // 0 = About, 1 = Requirements, 2 = Perks, 3 = Similar Jobs

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBannerWithHeaderCard(context),
                    const SizedBox(height: 16),
                    _buildStatsRow(),
                    const SizedBox(height: 20),
                    _buildTabsHeader(),
                    const SizedBox(height: 20),
                    if (_selectedTab == 0) ...[
                      _buildAboutSection(),
                      const SizedBox(height: 20),
                      if (widget.title.contains('Frontend') || widget.company == 'Google') ...[
                        _buildWhatYouWillDoSection(),
                        const SizedBox(height: 20),
                        _buildTechnologiesUsedSection(),
                        const SizedBox(height: 24),
                      ] else ...[
                        _buildPerksSection(),
                        const SizedBox(height: 24),
                        _buildRequirementsSection(),
                        const SizedBox(height: 24),
                      ],
                    ] else if (_selectedTab == 1) ...[
                      _buildRequirementsSection(),
                      const SizedBox(height: 24),
                      _buildAboutSection(),
                    ] else if (_selectedTab == 2) ...[
                      _buildPerksSection(),
                      const SizedBox(height: 24),
                      _buildAboutSection(),
                      const SizedBox(height: 24),
                    ] else ...[
                      const SizedBox.shrink(),
                    ],
                    _buildSimilarJobsSection(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            _buildBottomActionBar(),
          ],
        ),
      ),
    );
  }

  // 1. Top Banner + Header Card overlapping
  Widget _buildTopBannerWithHeaderCard(BuildContext context) {
    final isStripe = widget.company == 'Stripe';
    final isMicrosoft = widget.company == 'Microsoft' || widget.title.contains('Data Analyst');
    final isFrontend = widget.title.contains('Frontend') || widget.company == 'Google';

    final primaryThemeColor = isFrontend
        ? const Color(0xFF0088CC)
        : (isStripe ? const Color(0xFF0088CC) : const Color(0xFF229ED9));

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Office Banner Image
        Container(
          height: 220,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=800&q=80',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Gradient overlay
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.4),
                Colors.transparent,
              ],
            ),
          ),
        ),
        // Navigation controls
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          right: 16,
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: primaryThemeColor,
                    size: 20,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.share_outlined,
                  color: primaryThemeColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.bookmark_border_rounded,
                  color: primaryThemeColor,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        // Floating Card
        Padding(
          padding: const EdgeInsets.only(top: 135, left: 20, right: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
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
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isFrontend ? const Color(0xFFE8F4FB) : const Color(0xFFE8F4FB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: isFrontend
                            ? const Icon(
                                Icons.code_rounded,
                                color: Color(0xFF0088CC),
                                size: 24,
                              )
                            : (isStripe
                                ? const Text(
                                    'S',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0088CC),
                                    ),
                                  )
                                : (isMicrosoft
                                    ? const Icon(
                                        Icons.window_rounded,
                                        color: Color(0xFF229ED9),
                                        size: 22,
                                      )
                                    : const Icon(
                                        Icons.bookmark_border_rounded,
                                        color: Color(0xFF0088CC),
                                        size: 22,
                                      ))),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                              letterSpacing: -0.4,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.company,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: primaryThemeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isFrontend)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4FB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Active',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0088CC),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.location.contains('Full-time')
                          ? widget.location
                          : '${widget.location}  •  ',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    if (!widget.location.contains('Full-time')) ...[
                      const Icon(
                        Icons.work_outline_rounded,
                        size: 15,
                        color: Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Full-time',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 15,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.salary,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                if (isFrontend) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: widget.tags.map((t) => Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4FB),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        t,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0088CC),
                        ),
                      ),
                    )).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 2. Stats Row
  Widget _buildStatsRow() {
    final isFrontend = widget.title.contains('Frontend') || widget.company == 'Google';

    final label1 = isFrontend ? 'Applicants' : 'Applied';
    final val1 = isFrontend ? '450+' : widget.applied;

    final label2 = isFrontend ? 'Experience' : 'Size';
    final val2 = isFrontend ? '2 – 5 yrs' : widget.size;

    final label3 = isFrontend ? 'Posted' : 'Views';
    final val3 = isFrontend ? '2 hours ago' : widget.views;

    final isStripe = widget.company == 'Stripe';
    final primaryColor = isFrontend
        ? const Color(0xFF0088CC)
        : (isStripe ? const Color(0xFF0088CC) : const Color(0xFF229ED9));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
        ),
        child: Row(
          children: [
            Expanded(child: _buildStatItem(label1, val1, primaryColor)),
            Container(width: 1, height: 32, color: const Color(0xFFE2E8F0)),
            Expanded(child: _buildStatItem(label2, val2, primaryColor)),
            Container(width: 1, height: 32, color: const Color(0xFFE2E8F0)),
            Expanded(child: _buildStatItem(label3, val3, primaryColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color primaryColor) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: value.contains('hours') || value.contains('ago')
                ? const Color(0xFF4B5563)
                : primaryColor,
          ),
        ),
      ],
    );
  }

  // 3. Tabs Header
  Widget _buildTabsHeader() {
    final isFrontend = widget.title.contains('Frontend') || widget.company == 'Google';
    final tabs = isFrontend
        ? ['About', 'Requirements', 'Perks', 'Similar Jobs']
        : ['About', 'Requirements', 'Perks'];

    final isStripe = widget.company == 'Stripe';
    final activeTabColor = isFrontend
        ? const Color(0xFF0088CC)
        : (isStripe ? const Color(0xFF0088CC) : const Color(0xFF229ED9));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(tabs.length, (i) {
              final isSelected = _selectedTab == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedTab = i),
                child: Column(
                  children: [
                    Text(
                      tabs[i],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? activeTabColor : const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 2.5,
                      width: 44,
                      color: isSelected ? activeTabColor : Colors.transparent,
                    ),
                  ],
                ),
              );
            }),
          ),
          Container(
            height: 1,
            color: const Color(0xFFE5E7EB),
          ),
        ],
      ),
    );
  }

  // 4. About Section
  Widget _buildAboutSection() {
    final aboutText = widget.about ??
        (widget.title.contains('Frontend') || widget.company == 'Google'
            ? 'As a Frontend Developer at Google, you will build beautiful, responsive, and accessible user interfaces that power millions of users worldwide. You\'ll work with cross-functional teams to deliver high-quality products using modern web technologies.'
            : (widget.title.contains('Product Designer') || widget.company == 'Stripe'
                ? 'We’re looking for a Product Designer to join our design team and help create intuitive, beautiful experiences for millions of businesses worldwide. You’ll own the end-to-end design process from user research to high-fidelity designs and work closely with product managers and engineers to ship impactful products.'
                : 'Join our data team to collect, clean, analyze, and visualize data that helps drive business decisions. You’ll work on real-world datasets, build insightful dashboards, and collaborate with cross-functional teams to solve meaningful problems.'));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About this role',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            aboutText,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.5,
              color: Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }

  // What you'll do Section for Frontend Developer
  Widget _buildWhatYouWillDoSection() {
    const items = [
      'Build responsive and accessible web interfaces.',
      'Collaborate with designers and backend engineers.',
      'Write clean, maintainable, and testable code.',
      'Optimize applications for maximum speed and scalability.',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What you’ll do',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0088CC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 11,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // Technologies you'll use Section
  Widget _buildTechnologiesUsedSection() {
    const tech = ['React', 'Tailwind CSS', 'TypeScript', 'HTML', 'CSS', 'Git'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Technologies you’ll use',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tech.map((t) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F4FB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    t,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0088CC),
                    ),
                  ),
                )).toList(),
          ),
        ],
      ),
    );
  }

  // 5. Perks Section
  Widget _buildPerksSection() {
    final isStripe = widget.title.contains('Product Designer') || widget.company == 'Stripe';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Perks & Benefits',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _buildPerkTile(Icons.medical_services_outlined, 'Health Benefits')),
              const SizedBox(width: 12),
              Expanded(child: _buildPerkTile(Icons.restaurant_outlined, 'Free Gourmet Food')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildPerkTile(Icons.savings_outlined, '401k Matching')),
              const SizedBox(width: 12),
              Expanded(child: _buildPerkTile(isStripe ? Icons.home_outlined : Icons.fitness_center_outlined, isStripe ? 'Home Office Setup' : 'On-site Gym')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerkTile(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4FB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF0088CC), size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 6. Requirements Section
  Widget _buildRequirementsSection() {
    final reqs = widget.requirements ??
        [
          'Mastery in React, Node.js, and TypeScript with 3+ years of production experience.',
          'Proven track record of building responsive, high-performance web applications.',
          'Strong understanding of web accessibility standards and UI design systems.',
        ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Requirements',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
            ),
            child: Column(
              children: reqs.map((req) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0088CC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        req,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // 7. Similar Jobs Section
  Widget _buildSimilarJobsSection() {
    final isStripe = widget.title.contains('Product Designer') || widget.company == 'Stripe';
    final isData = widget.title.contains('Data') || widget.company == 'Microsoft';

    final icon1 = isStripe ? Icons.cloud_outlined : (isData ? Icons.insert_chart_outlined : Icons.cloud_outlined);
    final title1 = isStripe ? 'UI/UX Designer' : (isData ? 'Business Analyst Intern' : 'UI/UX Designer');
    final company1 = isStripe ? 'Airbnb' : (isData ? 'Deloitte' : 'Airbnb');
    final salary1 = isStripe ? '\$70k/mo' : (isData ? '₹45k/mo' : '\$70k/mo');
    final badge1 = 'REMOTE';
    final badgeColor1 = const Color(0xFF0088CC);

    final icon2 = isStripe ? Icons.compare_arrows_rounded : (isData ? Icons.hexagon_outlined : Icons.code_rounded);
    final title2 = isStripe ? 'Product Design Intern' : (isData ? 'Data Science Intern' : 'Product Design Intern');
    final company2 = isStripe ? 'Canva' : (isData ? 'Amazon' : 'Canva');
    final salary2 = isStripe ? '\$30k/mo' : (isData ? '₹50k/mo' : '\$30k/mo');
    final badge2 = 'NEW';
    final badgeColor2 = const Color(0xFF006699);

    final primaryThemeColor = (widget.title.contains('Frontend') || widget.company == 'Google')
        ? const Color(0xFF0088CC)
        : (isStripe ? const Color(0xFF0088CC) : const Color(0xFF229ED9));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Similar Jobs',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                'View all',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: primaryThemeColor,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildSimilarCard(
                  icon: icon1,
                  title: title1,
                  company: company1,
                  salary: salary1,
                  badge: badge1,
                  badgeColor: badgeColor1,
                  themeColor: primaryThemeColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSimilarCard(
                  icon: icon2,
                  title: title2,
                  company: company2,
                  salary: salary2,
                  badge: badge2,
                  badgeColor: badgeColor2,
                  themeColor: primaryThemeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarCard({
    required IconData icon,
    required String title,
    required String company,
    required String salary,
    required String badge,
    required Color badgeColor,
    required Color themeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: themeColor, size: 18),
              ),
              const Spacer(),
            ],
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
          const SizedBox(height: 2),
          Text(
            company,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                salary,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: themeColor,
                ),
              ),
              const Spacer(),
              if (badge.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeColor == const Color(0xFF0088CC)
                        ? const Color(0xFFE8F4FB)
                        : const Color(0xFFE8F4FB),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: badgeColor,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // 8. Bottom Action Bar
  Widget _buildBottomActionBar() {
    final isFrontend = widget.title.contains('Frontend') || widget.company == 'Google';
    final isStripe = widget.company == 'Stripe';

    final primaryThemeColor = isFrontend
        ? const Color(0xFF0088CC)
        : (isStripe ? const Color(0xFF0088CC) : const Color(0xFF229ED9));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: Color(0xFF64748B),
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApplicationDetailsScreen(
                        jobType: 'Job',
                        jobTitle: widget.title,
                        companyName: widget.company,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryThemeColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Apply Now',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

