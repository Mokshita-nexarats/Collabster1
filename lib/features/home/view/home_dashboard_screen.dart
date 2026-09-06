import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/mode_menu_bar.dart';
import '../../auth/view/screens/profile_screen.dart';
import '../../inbox/view/inbox_screen.dart';
import 'activity_screen.dart';
import 'feed_screen.dart';
import 'saved_items_screen.dart';

class HomeDashboardScreen extends ConsumerStatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  ConsumerState<HomeDashboardScreen> createState() =>
      _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends ConsumerState<HomeDashboardScreen> {
  int _selectedIndex = 0;

  void _onNavTap(int index) {
    if (index == 2) {
      _showCreateSheet();
      return;
    }
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const InboxScreen()),
      );
      return;
    }
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
      return;
    }
    setState(() => _selectedIndex = index);
  }

  void _showCreateSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF12233D),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFF4B5563),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.0,
                children: [
                  _buildSheetAction(
                    Icons.search_rounded,
                    'Explore',
                    const Color(0xFF4338CA),
                    () {
                      Navigator.pop(ctx);
                      setState(() => _selectedIndex = 1);
                    },
                  ),
                  _buildSheetAction(
                    Icons.bookmark_outline_rounded,
                    'Saved',
                    const Color(0xFFDB2777),
                    () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SavedItemsScreen(
                            onBack: () => Navigator.pop(context),
                          ),
                        ),
                      );
                    },
                  ),
                  _buildSheetAction(
                    Icons.chat_bubble_outline_rounded,
                    'Messages',
                    const Color(0xFF0891B2),
                    () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const InboxScreen()),
                      );
                    },
                  ),
                  _buildSheetAction(
                    Icons.notifications_outlined,
                    'Activity',
                    const Color(0xFFD97706),
                    () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ActivityScreen(),
                        ),
                      );
                    },
                  ),
                  _buildSheetAction(
                    Icons.person_outline_rounded,
                    'Profile',
                    const Color(0xFF059669),
                    () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                  _buildSheetAction(
                    Icons.edit_outlined,
                    'New Post',
                    const Color(0xFF7C3AED),
                    () {
                      Navigator.pop(ctx);
                      setState(() => _selectedIndex = 0);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Use the composer at the top of your Feed to post.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSheetAction(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.12)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const FeedScreen(),
      _buildExplorePage(),
      const SizedBox.shrink(),
      const SizedBox.shrink(),
      const SizedBox.shrink(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: pages[_selectedIndex],
      bottomNavigationBar: ModeMenuBar(
        selectedIndex: _selectedIndex,
        onTap: _onNavTap,
        items: const [
          ModeMenuItem(
            index: 0,
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: 'Home',
          ),
          ModeMenuItem(
            index: 1,
            icon: Icons.explore_outlined,
            activeIcon: Icons.explore_rounded,
            label: 'Explore',
          ),
          ModeMenuItem(
            index: 3,
            icon: Icons.chat_bubble_outline_rounded,
            activeIcon: Icons.chat_bubble_rounded,
            label: 'Messages',
          ),
          ModeMenuItem(
            index: 4,
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            label: 'Profile',
          ),
        ],
        selectedColor: const Color(0xFF0088CC),
        fabGradient: const [Color(0xFF0088CC), Color(0xFF229ED9)],
        onFabTap: _showCreateSheet,
        borderColor: const Color(0xFFE2E4EA),
        unselectedColor: const Color(0xFF9CA3AF),
      ),
    );
  }

  Widget _buildExplorePage() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF111827)),
          onPressed: () => setState(() => _selectedIndex = 0),
        ),
        title: const Text(
          'Explore',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          TextField(
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search posts, people, or startups',
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: Color(0xFF6B7280),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFF4338CA),
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Browse categories',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildExploreCategoryChip(
                icon: Icons.dynamic_feed_rounded,
                label: 'Feed',
                color: const Color(0xFF4338CA),
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              _buildExploreCategoryChip(
                icon: Icons.bookmark_outline_rounded,
                label: 'Saved',
                color: const Color(0xFF7C3AED),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SavedItemsScreen(
                      onBack: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
              _buildExploreCategoryChip(
                icon: Icons.notifications_outlined,
                label: 'Activity',
                color: const Color(0xFF0891B2),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ActivityScreen(),
                  ),
                ),
              ),
              _buildExploreCategoryChip(
                icon: Icons.people_outline_rounded,
                label: 'Network',
                color: const Color(0xFF059669),
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Network features coming soon')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExploreCategoryChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return ActionChip(
      onPressed: onTap,
      avatar: Icon(icon, size: 18, color: color),
      label: Text(label),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w700),
      backgroundColor: color.withValues(alpha: 0.08),
      side: BorderSide(color: color.withValues(alpha: 0.22)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    );
  }
}
