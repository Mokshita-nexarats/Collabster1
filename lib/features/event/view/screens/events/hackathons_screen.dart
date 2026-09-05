import 'package:flutter/material.dart';
import '../event_home_screen.dart';
import 'hackathon_registration_screen.dart';
import 'my_events_screen.dart';

// ─── Color Tokens (same as event theme) ────────────────────────
const _bg = Color(0xFFF8FAFC);
const _surface = Colors.white;
const _card = Colors.white;
const _accent = Color(0xFF0088CC);
const _accentLight = Color(0xFF229ED9);
const _accentBg = Color(0xFFEFF6FF);
const _textPrimary = Color(0xFF0F172A);
const _textSecondary = Color(0xFF64748B);
const _borderColor = Color(0xFFE2E8F0);
const _closingRed = Color(0xFFFF3C5C);

class HackathonsScreen extends StatefulWidget {
  const HackathonsScreen({super.key});

  @override
  State<HackathonsScreen> createState() => _HackathonsScreenState();
}

class _HackathonsScreenState extends State<HackathonsScreen> {
  int _selectedFilterIndex = 0;
  int _bottomNavIndex = 0;
  final _searchController = TextEditingController();
  final Set<String> _saved = {};

  final List<String> _filters = ['All', 'Online', 'Offline', '24-Hour'];

  final List<Map<String, dynamic>> _hackathons = [
    {
      'title': 'Global Fintech Hackathon',
      'organizer': 'Stripe',
      'location': 'Bangalore (Hybrid)',
      'prize': '₹5,00,000 Prize Pool',
      'postedAgo': '3 hours ago',
      'isClosingSoon': true,
    },
    {
      'title': 'Global Fintech Hackathon',
      'organizer': 'Stripe',
      'location': 'Bangalore (Hybrid)',
      'prize': '₹5,00,000 Prize Pool',
      'postedAgo': '3 hours ago',
      'isClosingSoon': true,
    },
    {
      'title': 'Global Fintech Hackathon',
      'organizer': 'Stripe',
      'location': 'Bangalore (Hybrid)',
      'prize': '₹5,00,000 Prize Pool',
      'postedAgo': '3 hours ago',
      'isClosingSoon': true,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _visibleHackathons {
    final query = _searchController.text.toLowerCase();
    return _hackathons.where((h) {
      if (query.isNotEmpty &&
          !(h['title'] as String).toLowerCase().contains(query) &&
          !(h['organizer'] as String).toLowerCase().contains(query)) {
        return false;
      }
      final online = (h['location'] as String).contains('Hybrid');
      if (_selectedFilterIndex == 1 && !online) return false;
      if (_selectedFilterIndex == 2 && online) return false;
      return true;
    }).toList();
  }

  void _openRegistration(Map<String, dynamic> h) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HackathonRegistrationScreen(hackathonTitle: h['title'] as String),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top App Bar
            _buildTopBar(context),
            // ── Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Search bar
                    _buildSearchBar(),
                    const SizedBox(height: 14),
                    // Filter chips
                    _buildFilterChips(),
                    const SizedBox(height: 16),
                    // Registration closing banner
                    _buildClosingBanner(),
                    const SizedBox(height: 16),
                    // Hackathon cards
                    ..._visibleHackathons.map((h) => _buildHackathonCard(context, h)),
                    const SizedBox(height: 20),
                    // View All button
                    _buildViewAllButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // ── Bottom Nav
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
          // Back button
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
              'Hackathons',
              style: TextStyle(color: _textPrimary, fontSize: 22, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Search Bar ─────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: _textSecondary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: _textPrimary, fontSize: 13),
              decoration: const InputDecoration(
                hintText: 'Search hackathons...',
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

  // ─── Registration Closing Banner ─────────────────────────────
  Widget _buildClosingBanner() {
    return GestureDetector(
      onTap: () => _openRegistration(_hackathons.first),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF3C5C), Color(0xFFFF7B5C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.info_outline_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Registration Closing Soon!',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  SizedBox(height: 3),
                  Text(
                    '3 top-tier hackathons are ending applications in less than 24 hours. Tap to view.',
                    style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.3),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  // ─── Hackathon Card ──────────────────────────────────────────
  Widget _buildHackathonCard(BuildContext context, Map<String, dynamic> h) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo placeholder
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _borderColor),
                ),
                child: const Icon(Icons.code_rounded, color: _accentLight, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      h['title'] as String,
                      style: const TextStyle(color: _textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${h['organizer']} • ${h['location']}',
                      style: const TextStyle(color: _textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              // Closing Soon badge
              if (h['isClosingSoon'] == true)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _closingRed.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _closingRed.withOpacity(0.4)),
                  ),
                  child: const Text(
                    'CLOSING\nSOON',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _closingRed, fontSize: 8, fontWeight: FontWeight.bold, height: 1.3),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          // Prize chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _accentBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🏆', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 5),
                Text(
                  h['prize'] as String,
                  style: const TextStyle(color: _accentLight, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Footer row
          Row(
            children: [
              const Icon(Icons.access_time_rounded, color: _textSecondary, size: 14),
              const SizedBox(width: 4),
              Text(h['postedAgo'] as String, style: const TextStyle(color: _textSecondary, fontSize: 11)),
              const Spacer(),
              // Bookmark icon
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_saved.contains(h['title'])) {
                      _saved.remove(h['title']);
                    } else {
                      _saved.add(h['title'] as String);
                    }
                  });
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _borderColor),
                  ),
                  child: Icon(
                    _saved.contains(h['title'])
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: _saved.contains(h['title']) ? _accent : _textSecondary,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Register button
              ElevatedButton(
                onPressed: () => _openRegistration(h),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Register', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
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
        child: const Text('View All', style: TextStyle(color: _accentLight, fontWeight: FontWeight.bold, fontSize: 14)),
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
