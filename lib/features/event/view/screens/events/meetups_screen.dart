import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/di/providers.dart';
import '../../../model/event_model.dart';
import '../event_home_screen.dart';
import 'event_detail_screen.dart';
import 'my_events_screen.dart';

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
const _liveRed = Color(0xFFFF3C5C);

class MeetupsScreen extends ConsumerStatefulWidget {
  const MeetupsScreen({super.key});

  @override
  ConsumerState<MeetupsScreen> createState() => _MeetupsScreenState();
}

class _MeetupsScreenState extends ConsumerState<MeetupsScreen> {
  int _selectedFilterIndex = 0;
  int _bottomNavIndex = 0;

  final List<String> _filters = ['All', 'Near Me', 'Informal', 'Startup Pitch'];

  Event _meetupToEvent(Map<String, dynamic> m) {
    return Event(
      id: m['title'] as String,
      title: m['title'] as String,
      description: '${(m['tags'] as List).join(', ')} — join the community and grow your network.',
      location: m['location'] as String,
      startDate: DateTime.now().add(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 2)),
      organizerName: 'Event Hub',
      category: 'Meetup',
      attendeeCount: 90,
    );
  }

  void _openDetail(Map<String, dynamic> m) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EventDetailScreen(event: _meetupToEvent(m))),
    );
  }

  final List<Map<String, dynamic>> _meetups = [
    {
      'title': 'Web3 Builders Mixer',
      'location': 'Hacker House • Bangalore',
      'locationIcon': Icons.location_on_outlined,
      'tags': ['Free Snacks', 'Networking', 'Co-Founders'],
      'isLive': true,
      'gradient': [Color(0xFF3B1F7A), Color(0xFF0F172A)],
      'icon': Icons.groups_rounded,
      'iconColor': Color(0xFFD8B4FE),
    },
    {
      'title': 'UI/UX Design Syncs',
      'location': 'Tomorrow, 5:30 PM • Koramangala',
      'locationIcon': Icons.calendar_today_rounded,
      'tags': ['Portfolio Review', 'Figma Workshop'],
      'isLive': false,
      'gradient': [Color(0xFF0F4C75), Color(0xFF1B262C)],
      'icon': Icons.design_services_rounded,
      'iconColor': Color(0xFF7DD3FC),
    },
    {
      'title': 'Coffee & Code',
      'location': 'Third Wave Coffee • Indiranagar',
      'locationIcon': Icons.location_on_outlined,
      'tags': ['Casual', 'Open Mic', 'Networking'],
      'isLive': false,
      'gradient': [Color(0xFF3D1A0A), Color(0xFF1C0A00)],
      'icon': Icons.coffee_rounded,
      'iconColor': Color(0xFFFBBF24),
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
                    ..._meetups.map((m) => _buildMeetupCard(context, m)),
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

  // ─── Top Bar ─────────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: _surface, shape: BoxShape.circle,
                border: Border.all(color: _borderColor),
              ),
              child: const Icon(Icons.arrow_back_rounded, color: _textPrimary, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Meetups',
                style: TextStyle(color: _textPrimary, fontSize: 22, fontWeight: FontWeight.w900)),
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
                hintText: 'Search Meetups...',
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
              child: Text(_filters[i],
                  style: TextStyle(
                    color: isSelected ? Colors.white : _textSecondary,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  )),
            ),
          );
        }),
      ),
    );
  }

  // ─── Meetup Card ─────────────────────────────────────────────
  Widget _buildMeetupCard(BuildContext context, Map<String, dynamic> m) {
    final tags = m['tags'] as List<String>;
    final gradients = m['gradient'] as List<Color>;
    final isLive = m['isLive'] as bool;

    return GestureDetector(
      onTap: () => _openDetail(m),
      child: Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image / gradient header
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradients,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Decorative circles
                  Positioned(
                    top: -20, right: -20,
                    child: Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -15, left: 30,
                    child: Container(
                      width: 60, height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Center icon
                  Center(
                    child: Icon(m['icon'] as IconData,
                        color: (m['iconColor'] as Color).withOpacity(0.9), size: 48),
                  ),
                  // LIVE badge
                  if (isLive)
                    Positioned(
                      top: 12, left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: _liveRed,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.circle, color: Colors.white, size: 6),
                            SizedBox(width: 5),
                            Text('LIVE NOW',
                                style: TextStyle(color: Colors.white,
                                    fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  // Bookmark top-right
                  Positioned(
                    top: 10, right: 10,
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.bookmark_border_rounded,
                          color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Card body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m['title'] as String,
                    style: const TextStyle(
                        color: _textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(m['locationIcon'] as IconData,
                        color: _textSecondary, size: 13),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(m['location'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: _textSecondary, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Tags
                Wrap(
                  spacing: 6, runSpacing: 6,
                  children: tags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _accentBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(tag,
                        style: const TextStyle(
                            color: _accentLight, fontSize: 10, fontWeight: FontWeight.w500)),
                  )).toList(),
                ),
                const SizedBox(height: 12),
                // Footer: bookmark + RSVP
                Row(
                  children: [
                    Container(
                      width: 34, height: 34,
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _borderColor),
                      ),
                      child: const Icon(Icons.bookmark_border_rounded,
                          color: _textSecondary, size: 16),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(eventViewModelProvider.notifier)
                              .rsvpEvent(m['title'] as String);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('RSVP confirmed! Added to My Events'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accent,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('RSVP',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
