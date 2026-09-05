import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/role_switcher_sheet.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/bridge/view/connect_screen.dart';
import '../../../auth/view/screens/profile_screen.dart';
import '../../../auth/view/sign_in_screen.dart';
import '../../../inbox/view/inbox_screen.dart';
import '../../../career/view/screens/notifications_screen.dart';
import 'my_courses_screen.dart';
import 'certificates_screen.dart';
import 'discussion_forums_screen.dart';
import 'leaderboard_screen.dart';
import 'find_mentors_screen.dart';
import 'explore_courses_screen.dart';
import 'learning_progress_screen.dart';
import 'course_detail_screen.dart';
import 'scheduled_sessions_screen.dart';

class LearnDashboardScreen extends ConsumerStatefulWidget {
  const LearnDashboardScreen({super.key});

  @override
  ConsumerState<LearnDashboardScreen> createState() => _LearnDashboardScreenState();
}

class _LearnDashboardScreenState extends ConsumerState<LearnDashboardScreen> {
  int _selectedIndex = 0;

  String get _timeBasedGreeting {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good Morning';
    if (hour >= 12 && hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

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
                  _buildCreateAction(ctx, icon: Icons.play_circle_outline_rounded, label: 'Start\nCourse', color: const Color(0xFF8B5CF6), onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ExploreCoursesScreen()));
                  }),
                  _buildCreateAction(ctx, icon: Icons.calendar_today_rounded, label: 'Scheduled\nSessions', color: const Color(0xFF0D9488), onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ScheduledSessionsScreen()));
                  }),
                  _buildCreateAction(ctx, icon: Icons.school_rounded, label: 'Find\nMentor', color: const Color(0xFF6D28D9), onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const FindMentorsScreen()));
                  }),
                  _buildCreateAction(ctx, icon: Icons.emoji_events_rounded, label: 'View\nCerts', color: const Color(0xFF5B21B6), onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CertificatesScreen()));
                  }),
                  _buildCreateAction(ctx, icon: Icons.forum_rounded, label: 'Join\nForum', color: const Color(0xFF8B5CF6), onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const DiscussionForumsScreen()));
                  }),
                  _buildCreateAction(ctx, icon: Icons.leaderboard_rounded, label: 'Leader\nboard', color: const Color(0xFF7C3AED), onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardScreen()));
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateAction(BuildContext ctx, {required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withValues(alpha: 0.12),
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
      _buildHomeContent(),
      _buildExplorePage(),
      const SizedBox.shrink(),
      _buildProgressPage(),
      const SizedBox.shrink(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: pages[_selectedIndex],
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildHomeContent() {
    final authState = ref.watch(authViewModelProvider);
    final session = authState.session;
    final userName = session?.fullName ?? 'Learner';
    final greetingName = userName.split(RegExp(r'\s+')).first;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF7C3AED),
                  Color(0xFF8B5CF6),
                  Color(0xFF7C3AED),
                ],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Learn Hub',
                                style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
                              ),
                              Text(
                                'Upskill and grow continuously',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12.5),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const InboxScreen()),
                          ),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(Icons.forum_outlined, color: Colors.white, size: 22),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                          ),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              children: [
                                const Center(
                                  child: Icon(Icons.notifications_outlined, color: Colors.white, size: 22),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(color: Color(0xFFF87171), shape: BoxShape.circle),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '$_timeBasedGreeting, $greetingName',
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Ready to learn something new today?",
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildSectionHeader('Your Progress', null),
              const SizedBox(height: 12),
              _buildProgressCard(),
              const SizedBox(height: 24),

              _buildSectionHeader('Recommended for You', 'View all', onCtaTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ExploreCoursesScreen()));
              }),
              const SizedBox(height: 14),
              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _CourseCard(
                      title: 'Flutter Masterclass',
                      instructor: 'Dr. Angela Yu',
                      lessons: '42 lessons',
                      rating: '4.9',
                      colorA: const Color(0xFF7C3AED),
                      colorB: const Color(0xFF8B5CF6),
                    ),
                    const SizedBox(width: 12),
                    _CourseCard(
                      title: 'AI & Machine Learning',
                      instructor: 'Andrew Ng',
                      lessons: '38 lessons',
                      rating: '4.8',
                      colorA: const Color(0xFF6D28D9),
                      colorB: const Color(0xFF7C3AED),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),

              _buildSectionHeader('Continue Learning', 'View all', onCtaTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const MyCoursesScreen()));
              }),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CourseDetailScreen(title: 'Advanced React Patterns', instructor: 'Maximilian Schwarzmuller', lessons: 36, completed: 23, color: Color(0xFF6D28D9), icon: Icons.code_rounded))),
                child: _buildContinueCard(
                  title: 'Advanced React Patterns',
                  progress: 0.65,
                  lastAccessed: '2 hours ago',
                  icon: Icons.code_rounded,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CourseDetailScreen(title: 'System Design Fundamentals', instructor: 'Alex Xu', lessons: 30, completed: 10, color: Color(0xFF5B21B6), icon: Icons.architecture_rounded))),
                child: _buildContinueCard(
                  title: 'System Design Fundamentals',
                  progress: 0.32,
                  lastAccessed: 'Yesterday',
                  icon: Icons.architecture_rounded,
                ),
              ),
              const SizedBox(height: 26),

              _buildSectionHeader('Quick Actions', null),
              const SizedBox(height: 12),
              _buildQuickActionsGrid(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ProgressStat(value: '12', label: 'Courses\nEnrolled', color: const Color(0xFF8B5CF6)),
          Container(width: 1, height: 40, color: const Color(0xFFE5E7EB)),
          _ProgressStat(value: '5', label: 'Completed', color: const Color(0xFF10B981)),
          Container(width: 1, height: 40, color: const Color(0xFFE5E7EB)),
          _ProgressStat(value: '3', label: 'Certificates', color: const Color(0xFFF59E0B)),
        ],
      ),
    );
  }

  Widget _buildContinueCard({
    required String title,
    required double progress,
    required String lastAccessed,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDE9FE), width: 1.2),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF8B5CF6), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                const SizedBox(height: 4),
                Text('Last accessed: $lastAccessed', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: const Color(0xFFEDE9FE),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${(progress * 100).toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    final actions = [
      _QuickAction(Icons.play_circle_outline_rounded, 'My Courses', const Color(0xFF8B5CF6), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MyCoursesScreen()));
      }),
      _QuickAction(Icons.emoji_events_rounded, 'Certificates', const Color(0xFF7C3AED), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CertificatesScreen()));
      }),
      _QuickAction(Icons.forum_rounded, 'Discussion\nForums', const Color(0xFF6D28D9), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const DiscussionForumsScreen()));
      }),
      _QuickAction(Icons.leaderboard_rounded, 'Leaderboard', const Color(0xFF5B21B6), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardScreen()));
      }),
      _QuickAction(Icons.school_rounded, 'Find Mentors', const Color(0xFF8B5CF6), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const FindMentorsScreen()));
      }),
      _QuickAction(Icons.calendar_today_rounded, 'Scheduled\nSessions', const Color(0xFF0D9488), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ScheduledSessionsScreen()));
      }),
      _QuickAction(Icons.alt_route_rounded, 'Connect', const Color(0xFF7C3AED), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ConnectScreen(modeTheme: 'learn')));
      }),
      _QuickAction(Icons.chat_bubble_outline_rounded, 'Messages', const Color(0xFF0EA5E9), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const InboxScreen()));
      }),
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildQuickActionItem(actions[0]),
              const SizedBox(width: 10),
              _buildQuickActionItem(actions[1]),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildQuickActionItem(actions[2]),
              const SizedBox(width: 10),
              _buildQuickActionItem(actions[3]),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildQuickActionItem(actions[4]),
              const SizedBox(width: 10),
              _buildQuickActionItem(actions[5]),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildQuickActionItem(actions[6]),
              const SizedBox(width: 10),
              _buildQuickActionItem(actions[7]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(_QuickAction action) {
    return Expanded(
      child: GestureDetector(
        onTap: action.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            color: action.color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: action.color.withValues(alpha: 0.12)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: action.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(action.icon, color: action.color, size: 19),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  action.label,
                  maxLines: 2,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade900,
                    height: 1.15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? cta, {VoidCallback? onCtaTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF111827), letterSpacing: -0.2)),
        if (cta != null)
          GestureDetector(
            onTap: onCtaTap ?? () {},
            child: Text(cta, style: const TextStyle(fontSize: 13, color: Color(0xFF8B5CF6), fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }

  Widget _buildExplorePage() {
    return ExploreCoursesScreen(
      onBack: () => setState(() => _selectedIndex = 0),
    );
  }

  Widget _buildProgressPage() {
    return LearningProgressScreen(
      onBack: () => setState(() => _selectedIndex = 0),
    );
  }

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
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.85),
          child: Container(
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(999))),
                  const SizedBox(height: 14),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFFEDE9FE),
                    backgroundImage: hasPhoto ? FileImage(File(photoPath)) : null,
                    child: hasPhoto ? null : Text(getInitials(userName), style: const TextStyle(color: Color(0xFF8B5CF6), fontSize: 24, fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(height: 10),
                  Text(userName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                  if (email.isNotEmpty) ...[const SizedBox(height: 2), Text(email, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280), fontWeight: FontWeight.w500))],
                  const SizedBox(height: 2),
                  Text(roleLabel, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                  const SizedBox(height: 14),
                  _sheetAction(Icons.person_outline_rounded, 'View Profile', const Color(0xFF8B5CF6), () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                  }),
                  const SizedBox(height: 8),
                  _sheetAction(Icons.swap_horiz_rounded, 'Switch Tab', const Color(0xFF8B5CF6), () {
                    Navigator.pop(ctx);
                    RoleSwitcherSheet.show(context);
                  }),
                  const SizedBox(height: 8),
                  _sheetAction(Icons.logout_rounded, 'Logout', const Color(0xFFEF4444), () async {
                    Navigator.pop(ctx);
                    await ref.read(authViewModelProvider.notifier).logout();
                    if (!mounted) return;
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignInScreen()));
                  }),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
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
                painter: _SeamlessNavPainter(
                  fillColor: Colors.white,
                  borderColor: const Color(0xFFE2E4EA),
                  shadowColor: Colors.black.withValues(alpha: 0.08),
                ),
                size: Size.infinite,
                child: SizedBox(
                  height: _navBarHeight,
                  child: Row(
                    children: [
                      _navItem(0, Icons.home_outlined, Icons.home_rounded, 'Home'),
                      _navItem(1, Icons.explore_outlined, Icons.explore_rounded, 'Explore'),
                      SizedBox(width: _fabSize + 12),
                      _navItem(3, Icons.trending_up, Icons.trending_up_rounded, 'Progress'),
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
    const selectedColor = Color(0xFF8B5CF6);
    const unselectedColor = Color(0xFF9CA3AF);

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? activeIcon : icon,
              color: selected ? selectedColor : unselectedColor,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? selectedColor : unselectedColor,
              ),
            ),
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
            colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}

class _SeamlessNavPainter extends CustomPainter {
  const _SeamlessNavPainter({
    required this.fillColor,
    required this.borderColor,
    required this.shadowColor,
  });
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
  bool shouldRepaint(covariant _SeamlessNavPainter oldDelegate) =>
      oldDelegate.fillColor != fillColor ||
      oldDelegate.borderColor != borderColor ||
      oldDelegate.shadowColor != shadowColor;
}



class _ProgressStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _ProgressStat({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 4),
        Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey.shade500, height: 1.2)),
      ],
    );
  }
}

class _CourseCard extends StatelessWidget {
  final String title, instructor, lessons, rating;
  final Color colorA, colorB;

  const _CourseCard({required this.title, required this.instructor, required this.lessons, required this.rating, required this.colorA, required this.colorB});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => CourseDetailScreen(
          title: title,
          instructor: instructor,
          lessons: int.tryParse(RegExp(r'\d+').stringMatch(lessons) ?? '0') ?? 0,
          completed: 0,
          color: colorA,
          icon: Icons.play_circle_fill_rounded,
        )));
      },
      child: Container(
        width: 190,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(colors: [colorA, colorB], begin: Alignment.topLeft, end: Alignment.bottomRight),
          boxShadow: [BoxShadow(color: colorA.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.play_circle_fill_rounded, color: Colors.white.withValues(alpha: 0.9), size: 40),
              const Spacer(),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(instructor, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time_rounded, color: Colors.white.withValues(alpha: 0.7), size: 14),
                  const SizedBox(width: 4),
                  Text(lessons, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11)),
                  const Spacer(),
                  Icon(Icons.star_rounded, color: const Color(0xFFFBBF24), size: 14),
                  const SizedBox(width: 2),
                  Text(rating, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction(this.icon, this.label, this.color, this.onTap);
}
