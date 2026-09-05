import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/career_search_bar.dart';

class SavedJobsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const SavedJobsScreen({super.key, this.onBack});

  @override
  State<SavedJobsScreen> createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends State<SavedJobsScreen> {
  int _selectedFilter = 0; // 0 = All, 1 = Remote, 2 = Hybrid, 3 = On-site
  final TextEditingController _searchController = TextEditingController();

  static final List<Map<String, dynamic>> _allSavedItems = [
    {
      'logoUrl': 'https://img.icons8.com/color/48/adobe-illustrator.png',
      'isBookmarked': true,
      'badgeText': 'ACTIVE',
      'badgeColor': const Color(0xFFE8F4FB),
      'badgeTextColor': const Color(0xFF006699),
      'title': 'Senior Product Designer',
      'company': 'Nexus Systems',
      'salaryInfo': '\$120k - \$150k • San Francisco, CA (Hybrid)',
      'tags': ['Figma', 'Design Systems', 'Prototyping'],
      'isActive': true,
      'type': 'hybrid',
    },
    {
      'logoUrl': 'https://img.icons8.com/color/48/figma--v1.png',
      'isBookmarked': true,
      'badgeText': 'CLOSING SOON',
      'badgeColor': const Color(0xFFE8F4FB),
      'badgeTextColor': const Color(0xFF0088CC),
      'title': 'Frontend Web Revamp',
      'company': 'Vortex AI',
      'salaryInfo': '\$1,500 - \$2,500 (Project based) • Remote',
      'tags': ['React', 'Tailwind'],
      'isActive': true,
      'type': 'remote',
    },
    {
      'logoUrl': 'https://img.icons8.com/color/48/microsoft.png',
      'isBookmarked': false,
      'badgeText': 'EXPIRED',
      'badgeColor': const Color(0xFFF1F5F9),
      'badgeTextColor': const Color(0xFF64748B),
      'title': 'Lead UX Researcher',
      'company': 'Aether Analytics',
      'salaryInfo': '\$110k - \$130k • Austin, TX (On-site)',
      'tags': ['User Testing', 'Data Analysis'],
      'isActive': false,
      'type': 'on-site',
    },
    {
      'logoUrl': 'https://img.icons8.com/color/48/google-logo.png',
      'isBookmarked': true,
      'badgeText': 'ACTIVE',
      'badgeColor': const Color(0xFFE8F4FB),
      'badgeTextColor': const Color(0xFF006699),
      'title': 'Machine Learning Engineer',
      'company': 'Vortex AI',
      'salaryInfo': '\$160k - \$210k • Palo Alto, CA (Hybrid)',
      'tags': ['Python', 'PyTorch', 'NLP'],
      'isActive': true,
      'type': 'hybrid',
    },
  ];

  List<Map<String, dynamic>> get _filteredSavedItems {
    final query = _searchController.text.trim().toLowerCase();

    return _allSavedItems.where((item) {
      if (_selectedFilter == 1 && item['type'] != 'remote') return false;
      if (_selectedFilter == 2 && item['type'] != 'hybrid') return false;
      if (_selectedFilter == 3 && item['type'] != 'on-site') return false;

      if (query.isEmpty) return true;
      final titleMatch = (item['title'] as String).toLowerCase().contains(query);
      final companyMatch = (item['company'] as String).toLowerCase().contains(query);
      final salaryMatch = (item['salaryInfo'] as String).toLowerCase().contains(query);
      final tagsMatch = (item['tags'] as List<String>).any((t) => t.toLowerCase().contains(query));

      return titleMatch || companyMatch || salaryMatch || tagsMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredSavedItems;

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
                    onTap: widget.onBack,
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Saved',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CareerSearchBar(
                controller: _searchController,
                hintText: 'Search saved jobs & opportunities...',
                hasActiveFilter: _selectedFilter != 0,
                onChanged: (value) => setState(() {}),
                onFilterTap: () {
                  setState(() {
                    _selectedFilter = (_selectedFilter + 1) % 4;
                  });
                },
              ),
            ),
            const SizedBox(height: 14),

            // Filter chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildFilterChip(0, 'All'),
                  const SizedBox(width: 8),
                  _buildFilterChip(1, 'Remote'),
                  const SizedBox(width: 8),
                  _buildFilterChip(2, 'Hybrid'),
                  const SizedBox(width: 8),
                  _buildFilterChip(3, 'On-site'),
                ],
              ),
            ),
            const SizedBox(height: 16),


            // Scrollable Saved Items list
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      if (filtered.isNotEmpty)
                        ...filtered.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildSavedItemCard(
                                logoUrl: item['logoUrl'] as String,
                                isBookmarked: item['isBookmarked'] as bool,
                                badgeText: item['badgeText'] as String,
                                badgeColor: item['badgeColor'] as Color,
                                badgeTextColor: item['badgeTextColor'] as Color,
                                title: item['title'] as String,
                                company: item['company'] as String,
                                salaryInfo: item['salaryInfo'] as String,
                                tags: List<String>.from(item['tags']),
                                isActive: item['isActive'] as bool,
                              ),
                            ))
                      else
                        _buildEmptyState(),
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
            'No saved jobs match your search',
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


  Widget _buildFilterChip(int index, String label) {
    final selected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF0088CC) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildSavedItemCard({
    required String logoUrl,
    required bool isBookmarked,
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
    required String title,
    required String company,
    required String salaryInfo,
    required List<String> tags,
    required bool isActive,
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
          // Logo & Bookmark & Badge Row
          Row(
            children: [
              Image.network(logoUrl, width: 36, height: 36),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: badgeTextColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                color: isBookmarked ? const Color(0xFF0088CC) : Colors.grey.shade400,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title & Company
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isActive ? const Color(0xFF1E293B) : Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            company,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 8),

          // Details Row
          Row(
            children: [
              Icon(Icons.business_center_outlined, color: Colors.grey.shade400, size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  salaryInfo,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Tags row
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: tags.map((t) => _buildTagChip(t, isActive)).toList(),
          ),
          const SizedBox(height: 14),

          // Apply button
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: isActive ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isActive ? const Color(0xFF0088CC) : const Color(0xFFE2E8F0),
                disabledBackgroundColor: const Color(0xFFE2E8F0),
                elevation: 0,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                isActive ? 'Apply Now' : 'Application Closed',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.white : Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isActive ? const Color(0xFF475569) : Colors.grey.shade400,
        ),
      ),
    );
  }
}
