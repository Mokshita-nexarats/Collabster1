import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/role_switcher_sheet.dart';
import '../../../core/di/providers.dart';
import '../../auth/view/screens/profile_screen.dart';
import '../../auth/view/sign_in_screen.dart';
import '../../career/view/screens/jobs_screen.dart';
import '../../career/view/screens/freelance_screen.dart';
import '../../career/view/screens/resume_screen.dart';
import '../../career/view/screens/notifications_screen.dart';
import '../../career/view/screens/saved_jobs_screen.dart';
import 'feed_screen.dart';
import 'saved_items_screen.dart';
import '../../learn/view/screens/learning_progress_screen.dart';

class HomeDashboardScreen extends ConsumerStatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  ConsumerState<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends ConsumerState<HomeDashboardScreen> {
  int _selectedIndex = 0;



  void _onNavTap(int index) {
    if (index == 2) {
      _showCreateSheet();
      return;
    }
    if (index == 4) {
      _showProfileSheet();
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12233D)),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(999)),
                      child: const Icon(Icons.close_rounded, color: Color(0xFF4B5563), size: 20),
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
                  _buildSheetAction(Icons.search_rounded, 'Explore', const Color(0xFF4338CA), () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const JobsScreen()));
                  }),
                  _buildSheetAction(Icons.work_outline_rounded, 'Jobs', const Color(0xFF0891B2), () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const JobsScreen()));
                  }),
                  _buildSheetAction(Icons.laptop_mac_outlined, 'Freelance', const Color(0xFF7C3AED), () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const FreelanceScreen()));
                  }),
                  _buildSheetAction(Icons.description_outlined, 'Resume', const Color(0xFF059669), () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ResumeScreen()));
                  }),
                  _buildSheetAction(Icons.bookmark_outline_rounded, 'Saved', const Color(0xFFDB2777), () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => SavedJobsScreen(onBack: () => Navigator.pop(context))));
                  }),
                  _buildSheetAction(Icons.notifications_outlined, 'Alerts', const Color(0xFFD97706), () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSheetAction(IconData icon, String label, Color color, VoidCallback onTap) {
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
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF374151), height: 1.25),
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
      SavedItemsScreen(onBack: () => setState(() => _selectedIndex = 0)),
      const SizedBox.shrink(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: pages[_selectedIndex],
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onNavTap,
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
        title: const Text('Explore', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildExploreNavCard(
            icon: Icons.work_outline_rounded,
            title: 'Jobs',
            subtitle: 'Browse opportunities from top companies',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JobsScreen())),
            color: const Color(0xFF4338CA),
          ),
          const SizedBox(height: 12),
          _buildExploreNavCard(
            icon: Icons.laptop_mac_outlined,
            title: 'Freelance',
            subtitle: 'Find freelance projects and gigs',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FreelanceScreen())),
            color: const Color(0xFF7C3AED),
          ),
          const SizedBox(height: 12),
          _buildExploreNavCard(
            icon: Icons.school_outlined,
            title: 'Learning',
            subtitle: 'Upskill with courses and tutorials',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LearningProgressScreen())),
            color: const Color(0xFF0891B2),
          ),
          const SizedBox(height: 12),
          _buildExploreNavCard(
            icon: Icons.people_outline_rounded,
            title: 'Network',
            subtitle: 'Connect with professionals and startups',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Network features coming soon')),
              );
            },
            color: const Color(0xFF059669),
          ),
        ],
      ),
    );
  }

  Widget _buildExploreNavCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.12), width: 1.0),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade400, size: 16),
          ],
        ),
      ),
    );
  }




  // ── Profile bottom sheet ──────────────────────────────────────────
  void _showProfileSheet() {
    final session = ref.read(authViewModelProvider).session;
    final userName = session?.fullName ?? 'Member';
    final email = session?.email ?? '';
    final roleLabel = session?.activeUserRole.label ?? 'Member';
    final photoPath = session?.profilePhotoPath ?? '';
    final hasPhoto = photoPath.isNotEmpty && File(photoPath).existsSync();

    String getInitials(String name) {
      final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
      if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      if (parts.isNotEmpty) return parts[0][0].toUpperCase();
      return '?';
    }


    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      // Square corners — fills all the way to the screen edge with no gap
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (ctx) => SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20, 16, 20,
          MediaQuery.of(ctx).viewPadding.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
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
            const SizedBox(height: 14),
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFFEEF2FF),
              backgroundImage: hasPhoto ? FileImage(File(photoPath)) : null,
              child: hasPhoto
                  ? null
                  : Text(
                      getInitials(userName),
                      style: const TextStyle(
                        color: Color(0xFF4338CA),
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),
            const SizedBox(height: 10),
            Text(
              userName,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF12233D),
              ),
            ),
            if (email.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                email,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            const SizedBox(height: 2),
            Text(roleLabel, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
            const SizedBox(height: 14),
            _sheetAction(Icons.person_outline_rounded, 'View Profile', const Color(0xFF4338CA), () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
            }),
            const SizedBox(height: 8),
            _sheetAction(Icons.swap_horiz_rounded, 'Switch Tab', const Color(0xFF4338CA), () {
              Navigator.pop(ctx);
              RoleSwitcherSheet.show(context);
            }),
            const SizedBox(height: 8),
            _sheetAction(Icons.logout_rounded, 'Logout', const Color(0xFFEF4444), () async {
              Navigator.pop(ctx);
              await ref.read(authViewModelProvider.notifier).logout();
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SignInScreen()),
              );
            }),
          ],
        ),
      ),
    );
  }


  Widget _sheetAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE5E7EB))),
          child: Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF12233D))),
              const Spacer(),
              Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade400, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}


// ═══════════════════════════════════════════════════════════════════════════
// BOTTOM NAVIGATION BAR
// ═══════════════════════════════════════════════════════════════════════════
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.selectedIndex, required this.onTap});
  final int selectedIndex;
  final ValueChanged<int> onTap;

  static const double _navBarHeight = 64;
  static const double _fabSize = 56;
  static const double _navBarTop = 14;
  static const double _fabTop = -12;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final totalHeight = _navBarTop + _navBarHeight + bottomInset + 8;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: _navBarTop,
            left: 12,
            right: 12,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: CustomPaint(
                painter: _SeamlessNavPainter(fillColor: Colors.white, borderColor: const Color(0xFFE2E4EA), shadowColor: Colors.black.withValues(alpha: 0.08)),
                size: Size.infinite,
                child: SizedBox(
                  height: _navBarHeight,
                  child: Row(
                    children: [
                      _navItem(0, Icons.home_outlined, Icons.home_rounded, 'Home'),
                      _navItem(1, Icons.explore_outlined, Icons.explore_rounded, 'Explore'),
                      SizedBox(width: _fabSize + 12),
                      _navItem(3, Icons.bookmark_outline_rounded, Icons.bookmark_rounded, 'Saved'),
                      _navItem(4, Icons.person_outline, Icons.person, 'Profile'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(top: _fabTop, left: 0, right: 0, child: Center(child: _addButton())),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, IconData activeIcon, String label) {
    final selected = selectedIndex == index;
    const selectedColor = Color(0xFF4338CA);
    const unselectedColor = Color(0xFF9CA3AF);

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: selected ? const EdgeInsets.symmetric(horizontal: 10, vertical: 4) : EdgeInsets.zero,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFEEF2FF) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(selected ? activeIcon : icon, color: selected ? selectedColor : unselectedColor, size: 22),
            ),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: selected ? FontWeight.w700 : FontWeight.w500, color: selected ? selectedColor : unselectedColor)),
          ],
        ),
      ),
    );
  }

  Widget _addButton() {
    return GestureDetector(
      onTap: () => onTap(2),
      child: Container(
        width: _fabSize,
        height: _fabSize,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4338CA), Color(0xFF7C3AED)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4338CA).withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.edit_rounded, color: Colors.white, size: 24),
      ),
    );
  }
}

class _SeamlessNavPainter extends CustomPainter {
  const _SeamlessNavPainter({required this.fillColor, required this.borderColor, required this.shadowColor});
  final Color fillColor;
  final Color borderColor;
  final Color shadowColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final h = size.height;
    final w = size.width;
    final centerX = w / 2;
    const cornerRadius = 28.0;
    const fabRadius = 28.0;
    const clearance = 5.0;
    const notchR = fabRadius + clearance;
    const notchW = notchR + 14;
    const bottomArc = 2.5;

    final path = Path()
      ..moveTo(cornerRadius, 0)
      ..lineTo(centerX - notchW, 0)
      ..cubicTo(centerX - notchW + 10, 0, centerX - notchR * 1.1, notchR * 0.06, centerX - notchR, notchR * 0.35)
      ..cubicTo(centerX - notchR * 0.92, notchR * 0.6, centerX - notchR * 0.75, notchR * 0.85, centerX - notchR * 0.5, notchR * 0.98)
      ..cubicTo(centerX - notchR * 0.28, notchR * 1.05, centerX - 14, notchR * 1.06, centerX, notchR * 1.06)
      ..cubicTo(centerX + 14, notchR * 1.06, centerX + notchR * 0.28, notchR * 1.05, centerX + notchR * 0.5, notchR * 0.98)
      ..cubicTo(centerX + notchR * 0.75, notchR * 0.85, centerX + notchR * 0.92, notchR * 0.6, centerX + notchR, notchR * 0.35)
      ..cubicTo(centerX + notchR * 1.1, notchR * 0.06, centerX + notchW - 10, 0, centerX + notchW, 0)
      ..lineTo(w - cornerRadius, 0)
      ..arcToPoint(Offset(w, cornerRadius), radius: const Radius.circular(cornerRadius))
      ..lineTo(w, h - cornerRadius)
      ..arcToPoint(Offset(w - cornerRadius, h), radius: const Radius.circular(cornerRadius))
      ..quadraticBezierTo(centerX, h - bottomArc, cornerRadius, h)
      ..arcToPoint(Offset(0, h - cornerRadius), radius: const Radius.circular(cornerRadius))
      ..lineTo(0, cornerRadius)
      ..arcToPoint(Offset(cornerRadius, 0), radius: const Radius.circular(cornerRadius))
      ..close();

    canvas.drawShadow(path, shadowColor, 24, true);
    canvas.drawShadow(path, shadowColor.withValues(alpha: 0.5), 6, true);
    canvas.drawPath(path, Paint()..style = PaintingStyle.fill..color = fillColor);
    canvas.drawPath(path, Paint()..style = PaintingStyle.stroke..strokeWidth = 1.0..color = borderColor);
  }

  @override
  bool shouldRepaint(covariant _SeamlessNavPainter oldDelegate) => oldDelegate.fillColor != fillColor || oldDelegate.borderColor != borderColor || oldDelegate.shadowColor != shadowColor;
}
