import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/di/providers.dart';
import '../../../model/event_model.dart';
import '../event_home_screen.dart';
import 'event_detail_screen.dart';
import 'my_events_screen.dart';

class WebinarsScreen extends ConsumerStatefulWidget {
  const WebinarsScreen({super.key});

  @override
  ConsumerState<WebinarsScreen> createState() => _WebinarsScreenState();
}

class _WebinarsScreenState extends ConsumerState<WebinarsScreen> {
  int _selectedFilterIndex = 0;
  int _bottomNavIndex = 0;

  final List<String> _filters = ['All', 'Live', 'Upcoming', 'On-Demand'];

  Event _webinarToEvent(Map<String, dynamic> w) {
    return Event(
      id: w['title'] as String,
      title: w['title'] as String,
      description: '${w['tags'].join(', ')} — join the webinar from anywhere.',
      location: 'Online',
      startDate: DateTime.now().add(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 1)),
      organizerName: w['organizer'] as String,
      category: 'Webinar',
      attendeeCount: 430,
      isOnline: true,
    );
  }

  void _openDetail(Map<String, dynamic> w) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EventDetailScreen(event: _webinarToEvent(w))),
    );
  }

  final List<Map<String, dynamic>> _webinars = [
    {
      'status': 'LIVE',
      'statusColor': Color(0xFFEF4444), // red
      'statusBg': Color(0xFFFEE2E2),
      'imageUrl': 'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=500&auto=format&fit=crop&q=60',
      'watching': '4.2k watching',
      'avatarColor': Color(0xFFDBEAFE),
      'iconColor': Color(0xFF2563EB),
      'avatarIcon': Icons.laptop_mac_rounded,
      'title': 'Cracking the Google PM Interview',
      'organizer': 'Career Path • Zoom',
      'tags': ['Online Only', 'Q&A Session', 'Industry Experts'],
      'ctaText': 'Join Link',
      'isPrimaryCta': true,
    },
    {
      'status': 'STARTING IN 2H',
      'statusColor': Color(0xFF3B82F6), // blue
      'statusBg': Color(0xFFDBEAFE),
      'imageUrl': 'https://images.unsplash.com/photo-1507668077129-56e32842fceb?w=500&auto=format&fit=crop&q=60',
      'watching': null,
      'avatarColor': Color(0xFFFCE7F3),
      'iconColor': Color(0xFFDB2777),
      'avatarIcon': Icons.psychology_alt_rounded,
      'title': 'AI Ethics in Modern Research',
      'organizer': 'Global Scholars • Teams',
      'tags': ['Recorded Link', 'Q&A Session'],
      'ctaText': 'Notify Me',
      'isPrimaryCta': false,
    },
    {
      'status': 'ON-DEMAND',
      'statusColor': Color(0xFFEF4444), // red
      'statusBg': Color(0xFFFEE2E2),
      'imageUrl': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=500&auto=format&fit=crop&q=60',
      'watching': null,
      'avatarColor': Color(0xFFE0F2FE),
      'iconColor': Color(0xFF0284C7),
      'avatarIcon': Icons.groups_rounded,
      'title': 'Women in Fintech Panel',
      'organizer': 'Fintech Club • Recorded',
      'tags': ['Industry Experts', 'Recorded Link'],
      'ctaText': 'Watch Now',
      'isPrimaryCta': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A), size: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Webinars',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      color: Color(0xFF64748B),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        style: TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
                        decoration: InputDecoration(
                          hintText: 'Search webinars...',
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                          ),
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
              ),
            ),

            // Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  itemCount: _filters.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedFilterIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedFilterIndex = index),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF0088CC) : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _filters[index],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            color: isSelected ? Colors.white : const Color(0xFF4B5563),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Recommended for You / View All Section Header
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Recommended for You',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EventsListScreen()),
                      );
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0088CC),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Webinars Scrollable List
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: _webinars.length,
                itemBuilder: (context, index) {
                  final webinar = _webinars[index];
                  final isPrimary = webinar['isPrimaryCta'] as bool;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Stack
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                              child: Image.network(
                                webinar['imageUrl'] as String,
                                height: 160,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 160,
                                  color: const Color(0xFFE5E7EB),
                                  child: const Center(
                                    child: Icon(
                                      Icons.ondemand_video_rounded,
                                      color: Color(0xFF9CA3AF),
                                      size: 36,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Status Badge
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: webinar['status'] == 'LIVE'
                                      ? const Color(0xFFEF4444)
                                      : webinar['status'] == 'ON-DEMAND'
                                          ? const Color(0xFFBE123C)
                                          : const Color(0xFF3B82F6),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (webinar['status'] == 'LIVE') ...[
                                      const CircleAvatar(
                                        radius: 3,
                                        backgroundColor: Colors.white,
                                      ),
                                      const SizedBox(width: 6),
                                    ],
                                    Text(
                                      webinar['status'] as String,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Watching Count
                            if (webinar['watching'] != null)
                              Positioned(
                                bottom: 10,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.85),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    webinar['watching'] as String,
                                    style: const TextStyle(
                                      color: Color(0xFF111827),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),

                        // Title, details, tags and CTA buttons
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: webinar['avatarColor'] as Color,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      webinar['avatarIcon'] as IconData,
                                      color: webinar['iconColor'] as Color,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          webinar['title'] as String,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF111827),
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          webinar['organizer'] as String,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF6B7280),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Tags Row
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: (webinar['tags'] as List<String>).map((tag) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF3F4F6),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      tag,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF4B5563),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 14),

                              // Actions: Bookmark + CTA button
                              Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF3F4F6),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.bookmark_border_rounded,
                                      color: Color(0xFF4B5563),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: SizedBox(
                                      height: 42,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          ref.read(eventViewModelProvider.notifier)
                                              .rsvpEvent(webinar['title'] as String);
                                          _openDetail(webinar);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isPrimary
                                              ? const Color(0xFF0088CC)
                                              : const Color(0xFFEFF6FF),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          webinar['ctaText'] as String,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: isPrimary
                                                ? Colors.white
                                                : const Color(0xFF0088CC),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation
            Container(
              height: 64,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                ),
              ),
              child: Row(
                children: [
                  _buildBottomNavItem(0, Icons.home_rounded, 'Home'),
                  _buildBottomNavItem(1, Icons.explore_outlined, 'Explore'),
                  _buildBottomNavItem(2, Icons.work_outline_rounded, 'Applied'),
                  _buildBottomNavItem(3, Icons.bookmark_border_rounded, 'Saved'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(int index, IconData icon, String label) {
    final isSelected = _bottomNavIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _bottomNavIndex = index);
          if (index == 0) Navigator.pop(context);
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EventsListScreen()),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyEventsScreen()),
            );
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyEventsScreen()),
            );
          }
        },
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFEFF6FF) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? const Color(0xFF0088CC) : const Color(0xFF9CA3AF),
                  size: 20,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? const Color(0xFF0088CC) : const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
