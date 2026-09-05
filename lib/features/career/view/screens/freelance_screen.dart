import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/career_search_bar.dart';

class FreelanceScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const FreelanceScreen({super.key, this.onBack});

  @override
  State<FreelanceScreen> createState() => _FreelanceScreenState();
}

class _FreelanceScreenState extends State<FreelanceScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All Roles', 'Remote', 'Paid', 'Hybrid'];
  final TextEditingController _searchController = TextEditingController();

  static const _gigs = [
    _GigItem(
      logo: Icons.grid_view_rounded,
      title: 'Mobile App UI Kit',
      company: 'Nebula Fintech',
      timeAgo: '1 day ago',
      badge: 'REMOTE',
      badgeFg: Color(0xFF006699),
      badgeBg: Color(0xFFE8F4FB),
      budget: '\$45 - \$60 / hr',
      duration: '3 Months',
      tags: ['Figma', 'UI Design', 'Fintech'],
    ),
    _GigItem(
      logo: Icons.code_rounded,
      title: 'React Dashboard',
      company: 'CloudScale AI',
      timeAgo: '4 hours ago',
      badge: 'HYBRID',
      badgeFg: Color(0xFF006699),
      badgeBg: Color(0xFFE8F4FB),
      budget: '\$80 - \$110 / hr',
      duration: '6 Months',
      tags: ['React.js', 'Tailwind', 'GraphQL'],
    ),
    _GigItem(
      logo: Icons.edit_note_rounded,
      title: 'Technical Writer',
      company: 'SecureNet',
      timeAgo: '2 days ago',
      badge: 'REMOTE',
      badgeFg: Color(0xFF006699),
      badgeBg: Color(0xFFE8F4FB),
      budget: '\$50 - \$70 / hr',
      duration: 'Short-term',
      tags: ['API Docs', 'Cybersecurity'],
    ),
  ];

  List<_GigItem> get _filteredGigs {
    final query = _searchController.text.trim().toLowerCase();
    final filter = _filters[_selectedFilter].toLowerCase();

    return _gigs.where((gig) {
      if (filter == 'remote' && gig.badge != 'REMOTE') {
        return false;
      }
      if (filter == 'hybrid' && gig.badge != 'HYBRID') {
        return false;
      }
      if (filter == 'paid' && gig.budget.isEmpty) {
        return false;
      }

      if (query.isEmpty) return true;
      final titleMatch = gig.title.toLowerCase().contains(query);
      final companyMatch = gig.company.toLowerCase().contains(query);
      final durationMatch = gig.duration.toLowerCase().contains(query);
      final tagMatch = gig.tags.any((t) => t.toLowerCase().contains(query));

      return titleMatch || companyMatch || durationMatch || tagMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Navigation Controls Row
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
            'Freelancing',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Find freelance projects based on your skills.',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 18),

          // Search bar
          CareerSearchBar(
            controller: _searchController,
            hintText: 'Search freelance gigs, skills, clients...',
            hasActiveFilter: _selectedFilter != 0,
            onChanged: (value) => setState(() {}),
            onFilterTap: () {
              setState(() {
                _selectedFilter = (_selectedFilter + 1) % _filters.length;
              });
            },
          ),
          const SizedBox(height: 16),


          // Filter chips
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
        ],
      ),
    );
  }

  Widget _buildBody() {
    final filtered = _filteredGigs;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured Gigs Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _searchController.text.isNotEmpty || _selectedFilter != 0
                    ? 'Search Results (${filtered.length})'
                    : 'Featured Gigs',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                  letterSpacing: -0.2,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _searchController.clear();
                    _selectedFilter = 0;
                  });
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

          // Gig Cards or Empty State
          if (filtered.isNotEmpty)
            ...filtered.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildGigCard(item),
                ))
          else
            _buildEmptyState(),

          const SizedBox(height: 16),


          // Top Hiring Clients Header
          const Text(
            'Top Hiring Clients',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 14),

          // Clients Cards Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildClientCard(
                  name: 'Aura Dynamics',
                  category: 'TECHNOLOGY',
                  rating: '4.9',
                  activeCount: '12 Active',
                ),
                const SizedBox(width: 14),
                _buildClientCard(
                  name: 'Lumina Resources',
                  category: 'E-COMMERCE',
                  rating: '4.7',
                  activeCount: '8 Active',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGigCard(_GigItem item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.logo, color: AppColors.primary, size: 22),
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
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
                    Text(
                      '${item.company} • ${item.timeAgo}',
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
          const SizedBox(height: 16),

          // Budget & Duration
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BUDGET',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9CA3AF),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.budget,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DURATION',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9CA3AF),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.duration,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: item.tags.map((tag) => Container(
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
                )).toList(),
          ),
          const SizedBox(height: 16),

          // Action row
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening gig details...')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(0, 42),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'View Details',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE8F4FB)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.bookmark_border_rounded, size: 18, color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClientCard({
    required String name,
    required String category,
    required String rating,
    required String activeCount,
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
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFF0F9FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.business_rounded, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            category,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9CA3AF),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFBBF24)),
              const SizedBox(width: 4),
              Text(
                '$rating ($activeCount)',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Loading all projects...')),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary, width: 1.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              minimumSize: const Size(double.infinity, 36),
            ),
            child: const Text(
              'View Projects',
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
            'No matching freelance gigs found',
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
}

class _GigItem {
  final IconData logo;
  final String title, company, timeAgo, badge, budget, duration;
  final Color badgeFg, badgeBg;
  final List<String> tags;
  const _GigItem({
    required this.logo,
    required this.title,
    required this.company,
    required this.timeAgo,
    required this.badge,
    required this.badgeFg,
    required this.badgeBg,
    required this.budget,
    required this.duration,
    required this.tags,
  });
}
