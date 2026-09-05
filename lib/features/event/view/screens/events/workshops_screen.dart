import 'package:flutter/material.dart';
import '../event_home_screen.dart';
import 'my_events_screen.dart';
import 'workshop_registration_screen.dart';

// ─── Color Tokens ───────────────────────────────────────────────
const _bg = Color(0xFFF8FAFC);
const _surface = Colors.white;
const _card = Colors.white;
const _accent = Color(0xFF0088CC);
const _accentLight = Color(0xFF229ED9);
const _accentBg = Color(0xFFEFF6FF);
const _textPrimary = Color(0xFF0F172A);
const _textSecondary = Color(0xFF64748B);
const _borderColor = Color(0xFFE2E8F0);

class WorkshopsScreen extends StatefulWidget {
  const WorkshopsScreen({super.key});

  @override
  State<WorkshopsScreen> createState() => _WorkshopsScreenState();
}

class _WorkshopsScreenState extends State<WorkshopsScreen> {
  int _selectedFilterIndex = 0;
  int _bottomNavIndex = 0;

  final List<String> _filters = ['All', 'Hands-on', 'Bootcamps', 'Certified'];

  final List<Map<String, dynamic>> _workshops = [
    {
      'icon': Icons.edit_rounded,
      'iconBg': Color(0xFF2A1F4A),
      'iconColor': Color(0xFF9D5CFF),
      'title': 'Mastering Figma for Prototyping',
      'organizer': 'Design Studio',
      'mode': 'Online',
      'modeIcon': Icons.verified_rounded,
      'tags': ['Certificate Incl.', 'UI/UX Design', 'Figma'],
      'badge': 'LIMITED SLOTS',
      'badgeColor': Color(0xFFFF3C5C),
      'badgeBg': Color(0xFF3D1515),
    },
    {
      'icon': Icons.code_rounded,
      'iconBg': Color(0xFF1A2A3A),
      'iconColor': Color(0xFF38BDF8),
      'title': 'Advanced Webflow Workflows',
      'organizer': 'Web Academy',
      'mode': 'Virtual Lab',
      'modeIcon': Icons.cloud_outlined,
      'tags': ['No-Code', 'Frontend', 'Project Based'],
      'badge': 'STARTS IN 2 DAYS',
      'badgeColor': Color(0xFF22C55E),
      'badgeBg': Color(0xFF142A1C),
    },
    {
      'icon': Icons.psychology_rounded,
      'iconBg': Color(0xFF3D1A1A),
      'iconColor': Color(0xFFF87171),
      'title': 'Prompt Engineering Bootcamp',
      'organizer': 'AI Collective',
      'mode': 'Multi-Week',
      'modeIcon': Icons.repeat_rounded,
      'tags': ['AI/ML', 'Modern Tech', 'Portfolio'],
      'badge': '8 SLOTS LEFT',
      'badgeColor': Color(0xFFF59E0B),
      'badgeBg': Color(0xFF2E2010),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildSearchBar(),
                    const SizedBox(height: 14),
                    _buildFilterChips(),
                    const SizedBox(height: 18),
                    ..._workshops.map((w) => _buildWorkshopCard(context, w)),
                    const SizedBox(height: 20),
                    _buildViewAllButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  // ─── Top App Bar ─────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _surface,
                shape: BoxShape.circle,
                border: Border.all(color: _borderColor),
              ),
              child: const Icon(Icons.arrow_back_rounded, color: _textPrimary, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Workshops',
              style: TextStyle(color: _textPrimary, fontSize: 22, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Search Bar ──────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: const Row(
        children: [
          Icon(Icons.search_rounded, color: _textSecondary, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              style: TextStyle(color: _textPrimary, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Search workshops...',
                hintStyle: TextStyle(color: _textSecondary, fontSize: 13),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                filled: false,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Filter Chips ────────────────────────────────────────────
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_filters.length, (i) {
          final isSelected = _selectedFilterIndex == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilterIndex = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? _accent : _surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? _accent : _borderColor,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Text(
                _filters[i],
                style: TextStyle(
                  color: isSelected ? Colors.white : _textSecondary,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ─── Workshop Card ───────────────────────────────────────────
  Widget _buildWorkshopCard(BuildContext context, Map<String, dynamic> w) {
    final tags = w['tags'] as List<String>;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + Badge row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: w['iconBg'] as Color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(w['icon'] as IconData, color: w['iconColor'] as Color, size: 22),
              ),
              const Spacer(),
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (w['badgeBg'] as Color),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, color: w['badgeColor'] as Color, size: 6),
                    const SizedBox(width: 4),
                    Text(
                      w['badge'] as String,
                      style: TextStyle(
                        color: w['badgeColor'] as Color,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Title
          Text(w['title'] as String,
              style: const TextStyle(color: _textPrimary, fontWeight: FontWeight.bold, fontSize: 15, height: 1.3)),
          const SizedBox(height: 6),
          // Organizer + mode
          Row(
            children: [
              Icon(w['modeIcon'] as IconData, color: _textSecondary, size: 13),
              const SizedBox(width: 4),
              Expanded(
                child: Text('${w['organizer']} • ${w['mode']}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: _textSecondary, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Tags
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: tags.map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _accentBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(tag, style: const TextStyle(color: _accentLight, fontSize: 10, fontWeight: FontWeight.w500)),
            )).toList(),
          ),
          const SizedBox(height: 14),
          // Footer: bookmark + reserve
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _borderColor),
                ),
                child: const Icon(Icons.bookmark_border_rounded, color: _textSecondary, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WorkshopRegistrationScreen(
                          workshopTitle: w['title'] as String,
                          organizer: w['organizer'] as String,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Reserve Slot',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── View All Button ─────────────────────────────────────────
  Widget _buildViewAllButton() {
    return Center(
      child: OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EventsListScreen()),
          );
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: _accent, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('View All',
            style: TextStyle(color: _accentLight, fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    );
  }

  // ─── Bottom Navigation ───────────────────────────────────────
  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.explore_outlined, 'label': 'Explore'},
      {'icon': Icons.add_circle_outline_rounded, 'label': 'Applied'},
      {'icon': Icons.bookmark_border_rounded, 'label': 'Saved'},
    ];
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: _surface,
        border: Border(top: BorderSide(color: _borderColor)),
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          final isSelected = _bottomNavIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _bottomNavIndex = i);
                if (i == 0) Navigator.pop(context);
                if (i == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EventsListScreen()),
                  );
                }
                if (i == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyEventsScreen()),
                  );
                }
                if (i == 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyEventsScreen()),
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(items[i]['icon'] as IconData,
                      size: 22,
                      color: isSelected ? _accentLight : _textSecondary),
                  const SizedBox(height: 3),
                  Text(items[i]['label'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected ? _accentLight : _textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      )),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
