import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/di/providers.dart';
import '../widgets/career_search_bar.dart';
import 'job_detail_screen.dart';

// ═══════════════════════════════════════════════════════════════════════════
// InternshipsScreen — opened when user taps "Internships" chip on Dashboard.
// Shows career board listings + internships published by startups.
// ═══════════════════════════════════════════════════════════════════════════
class InternshipsScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBack;
  const InternshipsScreen({super.key, this.onBack});

  @override
  ConsumerState<InternshipsScreen> createState() => _InternshipsScreenState();
}

class _InternshipsScreenState extends ConsumerState<InternshipsScreen> {
  int _selectedFilter = 0; // 0=All Roles, 1=Remote, 2=Paid, 3=Hybrid
  final List<String> _filters = ['All Roles', 'Remote', 'Paid', 'Hybrid'];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(hiringViewModelProvider.notifier).loadInitialData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Startup internships bridged from the Startup hiring board ──────────
  List<_Internship> get _startupInternships {
    final roles = ref.watch(hiringViewModelProvider).roles
        .where((r) => r.roleType == 'internship' && r.status == 'HIRING')
        .toList();
    if (roles.isEmpty) return const [];

    final session = ref.watch(authViewModelProvider).session;
    final startupName = (session?.startupName?.isNotEmpty == true)
        ? session!.startupName!
        : session?.joinedStartupName;

    return roles
        .map(
          (r) => _Internship(
            logo: Icons.rocket_launch_rounded,
            title: r.title,
            salary: r.salaryLpa ?? 'Stipend on apply',
            company: startupName ?? 'Startup',
            location: r.location ?? 'On-site',
            tags: (r.skills ?? '')
                .split(',')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .take(3)
                .toList(),
            badge: 'Startup',
            badgeFg: const Color(0xFF0088CC),
            badgeBg: const Color(0xFFE8F4FB),
          ),
        )
        .toList();
  }

  // ── Career internships from Career board ──────────────────────────────────
  List<_Internship> get _careerInternships {
    final careerState = ref.watch(careerViewModelProvider);
    final internships = careerState.jobs.where((j) => j.roleType == 'internship').toList();
    if (internships.isEmpty) return const [];

    return internships.map((j) => _Internship(
      logo: Icons.code_rounded,
      title: j.title,
      salary: j.salaryTag,
      company: j.company,
      location: j.location,
      tags: j.tags,
      badge: j.showNew ? 'NEW' : 'Career',
      badgeFg: const Color(0xFF0088CC),
      badgeBg: const Color(0xFFE8F4FB),
    )).toList();
  }

  List<_Internship> get _filteredInternships {
    final query = _searchController.text.trim().toLowerCase();
    final filter = _filters[_selectedFilter].toLowerCase();

    return [..._startupInternships, ..._careerInternships]
        .where((item) {
      if (filter == 'remote' && item.badge != 'REMOTE' && !item.location.toLowerCase().contains('remote')) {
        return false;
      }
      if (filter == 'hybrid' && item.badge != 'HYBRID' && !item.location.toLowerCase().contains('hybrid')) {
        return false;
      }
      if (filter == 'paid' && item.salary.isEmpty) {
        return false;
      }

      if (query.isEmpty) return true;
      final titleMatch = item.title.toLowerCase().contains(query);
      final companyMatch = item.company.toLowerCase().contains(query);
      final locationMatch = item.location.toLowerCase().contains(query);
      final tagMatch = item.tags.any((t) => t.toLowerCase().contains(query));

      return titleMatch || companyMatch || locationMatch || tagMatch;
    }).toList();
  }

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
          'Discover Internships',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBody(),
          ],
        ),
      ),
    );
  }

  // ── Body ────────────────────────────────────────────────────────────────
  Widget _buildBody() {
    final filtered = _filteredInternships;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Search bar ──────────────────────────────────────────────────
          CareerSearchBar(
            controller: _searchController,
            hintText: 'Search internships, roles, or companies...',
            hasActiveFilter: _selectedFilter != 0,
            onChanged: (value) => setState(() {}),
            onFilterTap: () {
              setState(() {
                _selectedFilter = (_selectedFilter + 1) % _filters.length;
              });
            },
          ),
          const SizedBox(height: 16),


          // ── Filter chips ────────────────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_filters.length, (i) {
                final selected = _selectedFilter == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: selected ? AppColors.primary : const Color(0xFFE8F4FB),
                        width: 1.3,
                      ),
                    ),
                    child: Text(
                      _filters[i],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : const Color(0xFF006699),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),

          // ── Featured Card (purple gradient) ─────────────────────────────
          _buildFeaturedCard(),
          const SizedBox(height: 26),

          // ── All Internships ──────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'All Internships',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                  letterSpacing: -0.2,
                ),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Showing all internships...')),
                  );
                },
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Internship cards or Empty state
          if (filtered.isNotEmpty)
            ...filtered.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _buildInternshipCard(item),
                ))
          else
            _buildEmptyState(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F4FB),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search_off_rounded, color: Color(0xFF0088CC), size: 28),
          ),
          const SizedBox(height: 12),
          const Text(
            'No matching internships found',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Try searching with a different term or clear filters.',
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }


  // ── Featured Card ────────────────────────────────────────────────────────
  Widget _buildFeaturedCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0088CC), Color(0xFF229ED9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + Match badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.rocket_launch_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '• 93.5% Match',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Company + Featured label
          Text(
            'STRIPE  •  FEATURED',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.65),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),

          // Job title
          const Text(
            'Product Design Intern',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 10),

          // Salary + Duration
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  color: Colors.white70, size: 16),
              const SizedBox(width: 5),
              Text(
                'San Francisco, CA',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 14),
              const Icon(Icons.group_outlined,
                  color: Colors.white70, size: 16),
              const SizedBox(width: 5),
              Text(
                '4 Members',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Apply Now button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  SmoothRightToLeftPageRoute(
                    builder: (context) => const InternshipDetailsScreen(
                      title: 'Product Design Intern',
                      company: 'Stripe',
                      location: 'San Francisco, CA',
                      stipend: '\$4,500/mo',
                      type: 'Full-time • 6 Months',
                      tags: ['Figma', 'UI/UX', 'Design Systems'],
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text(
                'Apply Now',
                style: TextStyle(
                  color: Color(0xFF0088CC),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Internship Card ───────────────────────────────────────────────────────
  Widget _buildInternshipCard(_Internship item) {
    void openDetails() {
      final isUiUx = item.title.contains('UI/UX') || (item.title.contains('Designer') && !item.title.contains('Frontend'));
      final isData = item.title.contains('Data') || item.title.contains('Analyst');

      String title = item.title.contains('Intern') ? item.title : '${item.title} Intern';
      String company = item.company;
      String location = item.company == 'Google' ? 'Mountain View, CA' : 'San Francisco, CA';
      String stipend = '₹500+';
      List<String> tags = item.company == 'Google'
          ? const ['Frontend', 'React', 'Tailwind', 'JavaScript']
          : const ['Design', 'Figma', 'UI/UX'];
      String? about;
      List<String>? requirements;

      if (isUiUx) {
        title = 'UI/UX Designer Intern';
        company = 'Google';
        location = 'Bangalore, KA';
        stipend = '₹500+';
        tags = const ['Figma', 'Design Systems', 'User Research', 'Prototyping'];
        about = 'Join our design team and create delightful, accessible, and meaningful experiences for millions of users. You’ll collaborate with cross-functional teams to tackle real-world problems through user-centered design.';
        requirements = const [
          'Proficiency in Figma, Adobe XD, or Sketch.',
          'Strong understanding of UI/UX principles and design systems.',
          'Experience with user research and usability testing.',
          'A strong portfolio showcasing end-to-end design projects.',
        ];
      } else if (isData) {
        title = 'Data Analyst Intern';
        company = 'Microsoft';
        location = 'Bangalore, KA';
        stipend = '₹400+';
        tags = const ['SQL', 'Excel', 'Python', 'Power BI', 'Statistics'];
        about = 'Work with our data team to collect, clean, analyze, and visualize data that drives business decisions. You’ll build dashboards, uncover insights, and help solve real-world problems using data.';
        requirements = const [
          'Proficiency in SQL and Excel.',
          'Knowledge of Python, Power BI, or Tableau is a plus.',
          'Strong analytical and problem-solving skills.',
          'Good understanding of statistics and data visualization.',
        ];
      }

      Navigator.push(
        context,
        SmoothRightToLeftPageRoute(
          builder: (context) => InternshipDetailsScreen(
            title: title,
            company: company,
            location: location,
            stipend: stipend,
            type: 'Full-time • 3 Months',
            tags: tags,
            about: about,
            requirements: requirements,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: openDetails,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8F4FB), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo + title + badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9FF),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(item.logo, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: item.badgeBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.badge,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: item.badgeFg,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      // Salary
                      Text(
                        item.salary,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Company · Location
                      Text(
                        '${item.company} • ${item.location}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Tags
            Row(
              children: item.tags.map((tag) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),

            // Apply + Bookmark
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: openDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0088CC),
                      minimumSize: const Size(0, 42),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE8F4FB)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.bookmark_border_rounded,
                      size: 18, color: AppColors.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data class ───────────────────────────────────────────────────────────────
class _Internship {
  final IconData logo;
  final String title, salary, company, location, badge;
  final List<String> tags;
  final Color badgeFg, badgeBg;
  const _Internship({
    required this.logo,
    required this.title,
    required this.salary,
    required this.company,
    required this.location,
    required this.tags,
    required this.badge,
    required this.badgeFg,
    required this.badgeBg,
  });
}

class SmoothRightToLeftPageRoute<T> extends MaterialPageRoute<T> {
  SmoothRightToLeftPageRoute({required super.builder, super.settings});

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
      ),
      child: child,
    );
  }
}
