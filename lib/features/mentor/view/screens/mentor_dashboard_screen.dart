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
import 'my_mentees_screen.dart';
import 'mentor_sessions_screen.dart';
import 'mentor_earnings_screen.dart';
import 'mentor_reviews_screen.dart';
import 'mentor_schedule_screen.dart';
import 'mentee_detail_screen.dart';
import 'session_detail_screen.dart';
import 'live_session_screen.dart';

class MentorDashboardScreen extends ConsumerStatefulWidget {
  const MentorDashboardScreen({super.key});

  @override
  ConsumerState<MentorDashboardScreen> createState() => _MentorDashboardScreenState();
}

class _MentorDashboardScreenState extends ConsumerState<MentorDashboardScreen> {
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
                  _buildCreateAction(ctx, icon: Icons.person_add_rounded, label: 'Add\nMentee', color: const Color(0xFF14B8A6), onTap: () {
                    Navigator.pop(ctx);
                  }),
                  _buildCreateAction(ctx, icon: Icons.event_rounded, label: 'Schedule\nSession', color: const Color(0xFF0D9488), onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const MentorScheduleScreen()));
                  }),
                  _buildCreateAction(ctx, icon: Icons.videocam_rounded, label: 'Start\nLive', color: const Color(0xFF0F766E), onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveSessionScreen(mentee: 'Next Mentee', topic: 'Quick Session')));
                  }),
                  _buildCreateAction(ctx, icon: Icons.chat_rounded, label: 'Messages', color: const Color(0xFF14B8A6), onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const InboxScreen()));
                  }),
                  _buildCreateAction(ctx, icon: Icons.leaderboard_rounded, label: 'My\nReviews', color: const Color(0xFF0D9488), onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const MentorReviewsScreen()));
                  }),
                  _buildCreateAction(ctx, icon: Icons.account_balance_wallet_rounded, label: 'Earnings', color: const Color(0xFF0F766E), onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const MentorEarningsScreen()));
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
      _buildMenteesPage(),
      const SizedBox.shrink(),
      _buildSessionsPage(),
      const SizedBox.shrink(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF0FDFA),
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
    final userName = session?.fullName ?? 'Mentor';
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
                colors: [Color(0xFF0D9488), Color(0xFF14B8A6), Color(0xFF0D9488)],
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
                            gradient: const LinearGradient(colors: [Color(0xFF14B8A6), Color(0xFF0D9488)]),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                          ),
                          child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Mentor Hub', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
                              Text('Guide, teach, and inspire', style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12.5)),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InboxScreen())),
                          child: Container(
                            width: 42, height: 42,
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                            child: const Center(child: Icon(Icons.forum_outlined, color: Colors.white, size: 22)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
                          child: Container(
                            width: 42, height: 42,
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                            child: Stack(children: [
                              const Center(child: Icon(Icons.notifications_outlined, color: Colors.white, size: 22)),
                              Positioned(top: 8, right: 8, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFF87171), shape: BoxShape.circle))),
                            ]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('$_timeBasedGreeting, $greetingName', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text("Let's make an impact today.", style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13.5)),
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
              _buildStatsRow(),
              const SizedBox(height: 24),
              _buildSectionHeader('Upcoming Sessions', 'View all', onCtaTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const MentorSessionsScreen()));
              }),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SessionDetailScreen(mentee: 'Priya Sharma', topic: 'Flutter State Management', date: 'Today, 3:00 PM', duration: '60 min', type: 'Video Call', status: 'Upcoming'))),
                child: _buildUpcomingSessionCard(name: 'Priya Sharma', topic: 'Flutter State Management', time: 'Today, 3:00 PM', avatar: 1),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SessionDetailScreen(mentee: 'Alex Chen', topic: 'System Design Review', date: 'Tomorrow, 10:00 AM', duration: '45 min', type: 'Video Call', status: 'Upcoming'))),
                child: _buildUpcomingSessionCard(name: 'Alex Chen', topic: 'System Design Review', time: 'Tomorrow, 10:00 AM', avatar: 2),
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('Recent Mentees', 'View all', onCtaTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const MyMenteesScreen()));
              }),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MenteeDetailScreen(name: 'Priya Sharma', goal: 'Flutter Developer', progress: 0.75, sessions: 8, totalSessions: 12))),
                child: _buildMenteeRow(name: 'Priya Sharma', progress: 0.75, sessions: 8, avatar: 1),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MenteeDetailScreen(name: 'Alex Chen', goal: 'System Architect', progress: 0.45, sessions: 4, totalSessions: 10))),
                child: _buildMenteeRow(name: 'Alex Chen', progress: 0.45, sessions: 4, avatar: 2),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MenteeDetailScreen(name: 'Marcus Lee', goal: 'Full-Stack Engineer', progress: 0.90, sessions: 12, totalSessions: 12))),
                child: _buildMenteeRow(name: 'Marcus Lee', progress: 0.90, sessions: 12, avatar: 3),
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('Quick Actions', null),
              const SizedBox(height: 12),
              _buildQuickActionsGrid(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
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
          _statItem('24', 'Total\nMentees', const Color(0xFF14B8A6)),
          Container(width: 1, height: 40, color: const Color(0xFFE5E7EB)),
          _statItem('156', 'Sessions\nCompleted', const Color(0xFF0D9488)),
          Container(width: 1, height: 40, color: const Color(0xFFE5E7EB)),
          _statItem('4.9', 'Average\nRating', const Color(0xFFF59E0B)),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 4),
        Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey.shade500, height: 1.2)),
      ],
    );
  }

  Widget _buildUpcomingSessionCard({required String name, required String topic, required String time, required int avatar}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCCFBF1), width: 1.2),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFCCFBF1),
            child: Text(name[0], style: const TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                Text(topic, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: const Color(0xFFCCFBF1), borderRadius: BorderRadius.circular(20)),
            child: Text(time, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0D9488))),
          ),
        ],
      ),
    );
  }

  Widget _buildMenteeRow({required String name, required double progress, required int sessions, required int avatar}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFCCFBF1),
            child: Text(name[0], style: const TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                Text('$sessions sessions completed', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              ],
            ),
          ),
          SizedBox(
            width: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${(progress * 100).toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF14B8A6))),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(value: progress, backgroundColor: const Color(0xFFCCFBF1), valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF14B8A6)), minHeight: 4),
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
      _QuickAction(Icons.people_rounded, 'My Mentees', const Color(0xFF14B8A6), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MyMenteesScreen()));
      }),
      _QuickAction(Icons.event_rounded, 'Schedule', const Color(0xFF0D9488), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MentorScheduleScreen()));
      }),
      _QuickAction(Icons.account_balance_wallet_rounded, 'Earnings', const Color(0xFF0F766E), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MentorEarningsScreen()));
      }),
      _QuickAction(Icons.star_rounded, 'Reviews', const Color(0xFF14B8A6), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MentorReviewsScreen()));
      }),
      _QuickAction(Icons.videocam_rounded, 'Live Sessions', const Color(0xFF0D9488), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MentorSessionsScreen()));
      }),
      _QuickAction(Icons.alt_route_rounded, 'Connect', const Color(0xFF0F766E), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ConnectScreen(modeTheme: 'mentor')));
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
          Row(children: [_buildQuickActionItem(actions[0]), const SizedBox(width: 10), _buildQuickActionItem(actions[1])]),
          const SizedBox(height: 10),
          Row(children: [_buildQuickActionItem(actions[2]), const SizedBox(width: 10), _buildQuickActionItem(actions[3])]),
          const SizedBox(height: 10),
          Row(children: [_buildQuickActionItem(actions[4]), const SizedBox(width: 10), _buildQuickActionItem(actions[5])]),
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
                width: 36, height: 36,
                decoration: BoxDecoration(color: action.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                child: Icon(action.icon, color: action.color, size: 19),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(action.label, maxLines: 2, softWrap: true, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey.shade900, height: 1.15)),
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
            child: Text(cta, style: const TextStyle(fontSize: 13, color: Color(0xFF14B8A6), fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }

  Widget _buildMenteesPage() {
    return MyMenteesScreen(onBack: () => setState(() => _selectedIndex = 0));
  }

  Widget _buildSessionsPage() {
    return MentorSessionsScreen(onBack: () => setState(() => _selectedIndex = 0));
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
                    backgroundColor: const Color(0xFFCCFBF1),
                    backgroundImage: hasPhoto ? FileImage(File(photoPath)) : null,
                    child: hasPhoto ? null : Text(getInitials(userName), style: const TextStyle(color: Color(0xFF0D9488), fontSize: 24, fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(height: 10),
                  Text(userName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                  if (email.isNotEmpty) ...[const SizedBox(height: 2), Text(email, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280), fontWeight: FontWeight.w500))],
                  const SizedBox(height: 2),
                  Text(roleLabel, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                  const SizedBox(height: 14),
                  _sheetAction(Icons.person_outline_rounded, 'View Profile', const Color(0xFF14B8A6), () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                  }),
                  const SizedBox(height: 8),
                  _sheetAction(Icons.swap_horiz_rounded, 'Switch Tab', const Color(0xFF14B8A6), () {
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
  final int selectedIndex;
  final ValueChanged<int> onTap;
  const _BottomNavBar({required this.selectedIndex, required this.onTap});

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
            top: _navBarTop, left: 12, right: 12, bottom: 0,
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
                      _navItem(1, Icons.people_outlined, Icons.people_rounded, 'Mentees'),
                      SizedBox(width: _fabSize + 12),
                      _navItem(3, Icons.event_outlined, Icons.event_rounded, 'Sessions'),
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
    const selectedColor = Color(0xFF14B8A6);
    const unselectedColor = Color(0xFF9CA3AF);

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(selected ? activeIcon : icon, color: selected ? selectedColor : unselectedColor, size: 24),
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
        width: _fabSize, height: _fabSize,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF14B8A6), Color(0xFF0D9488)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: const Color(0xFF14B8A6).withValues(alpha: 0.35), blurRadius: 14, offset: const Offset(0, 6))],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}

class _SeamlessNavPainter extends CustomPainter {
  const _SeamlessNavPainter({required this.fillColor, required this.borderColor, required this.shadowColor});
  final Color fillColor, borderColor, shadowColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final h = size.height, w = size.width, centerX = w / 2;
    const cornerRadius = 28.0, fabRadius = 28.0, clearance = 5.0;
    const notchR = fabRadius + clearance, notchW = notchR + 14, bottomArc = 2.5;

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

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction(this.icon, this.label, this.color, this.onTap);
}
