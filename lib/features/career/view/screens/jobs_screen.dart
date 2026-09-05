import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/bridge/bridge_models.dart';
import '../../model/job_model.dart';
import '../widgets/career_search_bar.dart';
import 'internships_screen.dart';
import 'job_detail_screen.dart';


class JobsScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBack;
  const JobsScreen({super.key, this.onBack});

  @override
  ConsumerState<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends ConsumerState<JobsScreen> {
  final List<String> _filters = ['All Roles', 'Remote', 'Paid', 'Hybrid'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(careerViewModelProvider.notifier).loadInitialData();
      ref.read(hiringViewModelProvider.notifier).loadInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final careerState = ref.watch(careerViewModelProvider);
    final filtered = careerState.filteredJobs.where((j) => j.roleType == 'job').toList();

    final isSearching =
        careerState.searchQuery.isNotEmpty || careerState.selectedFilter != 0;
    final displayJobs = isSearching
        ? filtered
        : [
            ..._startupJobs().map(_toJobItem),
            ...filtered,
          ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, careerState),
              _buildBody(careerState, displayJobs),
            ],
          ),
        ),
      ),
    );
  }

  List<BridgeOpportunity> _startupJobs() {
    final roles = ref.watch(hiringViewModelProvider).roles;
    final session = ref.watch(authViewModelProvider).session;
    final startupName = (session?.startupName?.isNotEmpty == true)
        ? session!.startupName!
        : session?.joinedStartupName;
    return startupHiringOpportunities(
      roles.where((r) => r.roleType == 'job').toList(),
      startupName: startupName ?? 'Startup',
    );
  }

  JobItem _toJobItem(BridgeOpportunity o) {
    return JobItem(
      logo: o.fromStartup ? 'rocket_launch' : 'work_rounded',
      title: o.title,
      company: o.company,
      location: o.location,
      salaryTag: o.salary,
      tags: o.tags,
      timeAgo: o.fromStartup
          ? (o.experience.isEmpty ? 'Open Now' : o.experience)
          : o.experience,
      showNew: o.fromStartup,
    );
  }

  Widget _buildHeader(BuildContext context, dynamic careerState) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Navigation & Top Icons Row
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
                onPressed: () {
                  if (widget.onBack != null) {
                    widget.onBack!();
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 20),

          // Title
          const Text(
            'Discover Jobs',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Find opportunities tailored to your career  goals.',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 18),

          // Search bar
          CareerSearchBar(
            controller: TextEditingController(text: careerState.searchQuery),
            hintText: 'Search jobs, skills, or companies...',
            hasActiveFilter: careerState.selectedFilter != 0,
            onChanged: (value) => ref.read(careerViewModelProvider.notifier).setSearchQuery(value),
            onFilterTap: () {
              final next = (careerState.selectedFilter + 1) % _filters.length;
              ref.read(careerViewModelProvider.notifier).setFilter(next);
            },
          ),
          const SizedBox(height: 16),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_filters.length, (i) {
                final selected = careerState.selectedFilter == i;
                return GestureDetector(
                  onTap: () => ref.read(careerViewModelProvider.notifier).setFilter(i),
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
        ],
      ),
    );
  }

  Widget _buildBody(dynamic careerState, List<JobItem> filtered) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Popular Jobs Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                careerState.searchQuery.isNotEmpty || careerState.selectedFilter != 0
                    ? 'Search Results (${filtered.length})'
                    : 'Popular Jobs',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                  letterSpacing: -0.2,
                ),
              ),
              GestureDetector(
                onTap: () {
                  ref.read(careerViewModelProvider.notifier).setSearchQuery('');
                  ref.read(careerViewModelProvider.notifier).setFilter(0);
                },
                child: const Text(
                  'Reset',
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

          // Job Cards or Empty state
          if (filtered.isNotEmpty)
            ...filtered.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _buildJobCard(item),
                ))
          else
            _buildEmptyState(),


          const SizedBox(height: 16),

          // Popular Companies Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Popular Companies',
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
                    const SnackBar(content: Text('Showing all companies...')),
                  );
                },
                child: const Text(
                  'View all',
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

          // Company Cards Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCompanyCard(
                  name: 'Synthetix AI',
                  category: 'Artificial Intelligence',
                  openPositions: '42 Open Positions',
                  rating: '4.8',
                ),
                const SizedBox(width: 14),
                _buildCompanyCard(
                  name: 'Creative Design',
                  category: 'UI/UX Design',
                  openPositions: '18 Open Positions',
                  rating: '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _logoFromString(String logo) {
    switch (logo) {
      case 'code_rounded':
        return Icons.code_rounded;
      case 'design_services_outlined':
        return Icons.design_services_outlined;
      case 'analytics_outlined':
        return Icons.analytics_outlined;
      case 'rocket_launch':
        return Icons.rocket_launch_rounded;
      default:
        return Icons.work_rounded;
    }
  }

  Widget _buildJobCard(JobItem item) {
    return Container(
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
                child: Icon(_logoFromString(item.logo), color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        if (item.showNew) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F4FB),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'NEW',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF006699),
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
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
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4FB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.salaryTag,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006699),
                  ),
                ),
              ),
              ...item.tags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                  )),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.access_time_rounded, size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text(
                item.timeAgo,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
              const Spacer(),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE8F4FB)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.bookmark_border_rounded, size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  ref.read(careerViewModelProvider.notifier).applyToJob(item.title);
                  ref.read(hiringViewModelProvider.notifier).incrementApplicantsForRole(item.title);
                  
                  final isProductDesigner = item.title.contains('Product Designer') || item.company == 'Stripe';
                  final isDataAnalyst = item.title.contains('Data Analyst') || item.company == 'Microsoft';
                  final isFrontend = item.title.contains('Senior Software') || item.title.contains('Frontend') || item.company == 'Google';

                  String title = item.title;
                  String company = item.company;
                  String location = item.location;
                  String salary = item.salaryTag;
                  List<String> tags = item.tags;
                  String? about;
                  List<String>? requirements;
                  String applied = '320+';
                  String size = '1K+';
                  String views = '4.3k';

                  if (isFrontend) {
                    title = 'Frontend Developer';
                    company = 'Google';
                    location = 'Remote (Worldwide)';
                    salary = '\$80k – \$110k USD';
                    tags = const ['React', 'Tailwind'];
                    applied = '450+';
                    size = '2 – 5 yrs';
                    views = '2 hours ago';
                    about = 'As a Frontend Developer at Google, you will build beautiful, responsive, and accessible user interfaces that power millions of users worldwide. You\'ll work with cross-functional teams to deliver high-quality products using modern web technologies.';
                  } else if (isProductDesigner) {
                    title = 'Product Designer';
                    company = 'Stripe';
                    location = 'Remote (Worldwide)';
                    salary = '\$80k – \$110k USD';
                    tags = const ['Full-time', 'Remote', 'Mid Level'];
                    applied = '320+';
                    size = '1K+';
                    views = '4.3k';
                    about = 'We’re looking for a Product Designer to join our design team and help create intuitive, beautiful experiences for millions of businesses worldwide. You’ll own the end-to-end design process from user research to high-fidelity designs and work closely with product managers and engineers to ship impactful products.';
                    requirements = const [
                      'Proficiency in Figma and design tools.',
                      'Strong portfolio showcasing product design projects and design thinking.',
                      'Experience with user research, wireframing, prototyping, and design systems.',
                    ];
                  } else if (isDataAnalyst) {
                    title = 'Data Analyst Intern';
                    company = 'Microsoft';
                    location = 'Bangalore, KA (On-site)';
                    salary = '₹15 – ₹22 LPA';
                    tags = const ['Full-time', 'On-site', 'Entry Level'];
                    applied = '280+';
                    size = '1K+';
                    views = '3.8k';
                    about = 'Join our data team to collect, clean, analyze, and visualize data that helps drive business decisions. You’ll work on real-world datasets, build insightful dashboards, and collaborate with cross-functional teams to solve meaningful problems.';
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
                      builder: (context) => JobDetailsScreen(
                        title: title,
                        company: company,
                        location: location,
                        salary: salary,
                        tags: tags,
                        about: about,
                        requirements: requirements,
                        applied: applied,
                        size: size,
                        views: views,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(80, 38),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyCard({
    required String name,
    required String category,
    required String openPositions,
    required String rating,
  }) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8F4FB), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.business_rounded, color: AppColors.primary, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            category,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                openPositions,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              if (rating.isNotEmpty) ...[
                const SizedBox(width: 4),
                const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFBBF24)),
                Text(
                  rating,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Loading all available jobs...')),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary, width: 1.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              minimumSize: const Size(double.infinity, 36),
            ),
            child: const Text(
              'View Jobs',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
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
            'No matching jobs found',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Try adjusting your search query or clear filters.',
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}
