import 'package:flutter/material.dart';
import 'resume_screen.dart';
import 'resume_upgrade_screen.dart';

class ProfessionalTemplatesScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const ProfessionalTemplatesScreen({super.key, this.onBack});

  @override
  State<ProfessionalTemplatesScreen> createState() => _ProfessionalTemplatesScreenState();
}

class _ProfessionalTemplatesScreenState extends State<ProfessionalTemplatesScreen> {
  int _selectedFilterIndex = 0;
  final List<Map<String, dynamic>> _filters = [
    {'label': 'All', 'icon': Icons.grid_view_rounded},
    {'label': 'Modern', 'icon': Icons.bolt_rounded},
    {'label': 'Minimal', 'icon': Icons.description_outlined},
    {'label': 'Creative', 'icon': Icons.palette_outlined},
    {'label': 'ATS Friendly', 'icon': Icons.verified_user_outlined},
  ];

  final List<Map<String, dynamic>> _templates = [
    {
      'title': 'Modern Professional',
      'subtitle': 'Clean two-column layout perfect for tech professionals.',
      'tag': 'Recommended',
      'category': 'Modern',
      'isSelected': true,
      'isFilledButton': true,
      'name': 'ALEXANDER JOHN',
      'role': 'Software Engineer',
      'hasSidebar': true,
      'sidebarColor': const Color(0xFF006699),
    },
    {
      'title': 'Minimal Elegance',
      'subtitle': 'Minimal design with emphasis on readability.',
      'tag': null,
      'category': 'Minimal',
      'isSelected': false,
      'isFilledButton': false,
      'name': 'OLIVIA SMITH',
      'role': 'Product Designer',
      'hasSidebar': false,
      'sidebarColor': Colors.white,
    },
    {
      'title': 'Classic Sidebar',
      'subtitle': 'Professional sidebar layout to highlight your key skills.',
      'tag': null,
      'category': 'Modern',
      'isSelected': false,
      'isFilledButton': false,
      'name': 'JAMES WILSON',
      'role': 'Data Analyst',
      'hasSidebar': true,
      'sidebarColor': const Color(0xFF0F172A),
    },
    {
      'title': 'Creative Gradient',
      'subtitle': 'Modern & creative design to showcase your personality.',
      'tag': null,
      'category': 'Creative',
      'isSelected': false,
      'isFilledButton': false,
      'name': 'ISHA PATEL',
      'role': 'Marketing Specialist',
      'hasSidebar': false,
      'isGradientHeader': true,
      'sidebarColor': Colors.white,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredTemplates = _selectedFilterIndex == 0
        ? _templates
        : _templates.where((t) => t['category'] == _filters[_selectedFilterIndex]['label'] || (_filters[_selectedFilterIndex]['label'] == 'ATS Friendly' && t['title'].contains('Minimal'))).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Bar Navigation Row (Back & Help Buttons)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (widget.onBack != null) {
                        widget.onBack!();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0088CC), size: 20),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.help_outline_rounded, color: Color(0xFF0088CC), size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 2. Header Banner with Title & Folder Graphic
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Professional Templates',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Choose a template that best represents you and make your resume stand out.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 3D Folder Graphic Illustration
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F4FB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: const [
                        Icon(Icons.folder_open_rounded, color: Color(0xFF0088CC), size: 42),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Icon(Icons.auto_awesome_rounded, color: Color(0xFF229ED9), size: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 3. Filter Chips Row with Icons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_filters.length, (i) {
                    final isSelected = _selectedFilterIndex == i;
                    final f = _filters[i];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedFilterIndex = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF0088CC) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF0088CC) : const Color(0xFFE2E8F0),
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              f['icon'] as IconData,
                              size: 14,
                              color: isSelected ? Colors.white : const Color(0xFF475569),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              f['label'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : const Color(0xFF334155),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),

              // 4. 2x2 Templates Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredTemplates.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.49,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 18,
                ),
                itemBuilder: (ctx, index) {
                  final t = filteredTemplates[index];
                  return _buildTemplateCard(context, t);
                },
              ),
              const SizedBox(height: 24),

              // 5. ATS Friendly Templates Banner Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE8F4FB), width: 1.2),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4FB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.shield_outlined, color: Color(0xFF0088CC), size: 22),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              const Text(
                                'ATS Friendly Templates',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD1FAE5),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Optimized',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF059669),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            'All our templates are ATS-optimized to help you get noticed by recruiters.',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: Color(0xFF64748B),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ResumeUpgradeScreen()),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Learn more',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0088CC),
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded, size: 14, color: Color(0xFF0088CC)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateCard(BuildContext context, Map<String, dynamic> t) {
    final isSelected = t['isSelected'] == true;
    final isFilledButton = t['isFilledButton'] == true;
    final hasSidebar = t['hasSidebar'] == true;
    final isGradientHeader = t['isGradientHeader'] == true;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? const Color(0xFF0088CC) : const Color(0xFFE2E8F0),
          width: isSelected ? 1.8 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Document Graphic Preview Box
          Expanded(
            child: Container(
              width: double.infinity,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Stack(
                children: [
                  Row(
                    children: [
                      // Sidebar preview
                      if (hasSidebar)
                        Container(
                          width: 44,
                          height: double.infinity,
                          color: t['sidebarColor'] as Color,
                          padding: const EdgeInsets.all(6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(width: 14, height: 14, decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle)),
                              const SizedBox(height: 8),
                              Container(height: 3, width: 28, color: Colors.white54),
                              const SizedBox(height: 4),
                              Container(height: 3, width: 20, color: Colors.white38),
                              const SizedBox(height: 10),
                              Container(height: 2, width: 24, color: Colors.white54),
                              const SizedBox(height: 3),
                              Container(height: 2, width: 28, color: Colors.white38),
                            ],
                          ),
                        ),
                      // Main paper body
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isGradientHeader)
                              Container(
                                width: double.infinity,
                                height: 32,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF0088CC), Color(0xFFEC4899)],
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t['name'] as String,
                                    style: const TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    t['role'] as String,
                                    style: const TextStyle(fontSize: 6, color: Color(0xFF64748B)),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(height: 1.5, width: double.infinity, color: const Color(0xFFE2E8F0)),
                                  const SizedBox(height: 6),
                                  Container(height: 3, width: 34, color: const Color(0xFF0088CC)),
                                  const SizedBox(height: 4),
                                  Container(height: 2, width: double.infinity, color: const Color(0xFFF1F5F9)),
                                  const SizedBox(height: 3),
                                  Container(height: 2, width: 50, color: const Color(0xFFF1F5F9)),
                                  const SizedBox(height: 8),
                                  Container(height: 3, width: 40, color: const Color(0xFF0088CC)),
                                  const SizedBox(height: 4),
                                  Container(height: 2, width: double.infinity, color: const Color(0xFFF1F5F9)),
                                  const SizedBox(height: 3),
                                  Container(height: 2, width: 60, color: const Color(0xFFF1F5F9)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Selected Blue Checkmark Badge
                  if (isSelected)
                    const Positioned(
                      top: 6,
                      right: 6,
                      child: Icon(Icons.check_circle_rounded, color: Color(0xFF0088CC), size: 20),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Title + Tag row
          Row(
            children: [
              Expanded(
                child: Text(
                  t['title'] as String,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              if (t['tag'] != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F4FB),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    t['tag'] as String,
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0088CC),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            t['subtitle'] as String,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF64748B),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),

          // Action Buttons Row: Use Template + Bookmark
          Row(
            children: [
              Expanded(
                child: isFilledButton
                    ? ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Selected "${t['title']}" template! Opening builder...'),
                              backgroundColor: const Color(0xFF0088CC),
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ResumeScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0088CC),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text(
                          'Use Template',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Selected "${t['title']}" template! Opening builder...'),
                              backgroundColor: const Color(0xFF0088CC),
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ResumeScreen()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF0088CC), width: 1.2),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text(
                          'Use Template',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0088CC),
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Icon(Icons.bookmark_border_rounded, size: 16, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
