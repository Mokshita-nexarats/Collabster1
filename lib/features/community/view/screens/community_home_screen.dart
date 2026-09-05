import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/bridge/bridge_models.dart';
import '../../../../core/bridge/view/connect_screen.dart';
import '../../../../shared/widgets/role_switcher_sheet.dart';
import '../../../auth/view/screens/profile_screen.dart';
import '../../../auth/view/sign_in_screen.dart';
import '../../../career/view/screens/notifications_screen.dart';
import '../../../career/view/screens/jobs_screen.dart';
import '../../../event/view/screens/event_home_screen.dart';
import '../../../startup/view/screens/startup_posts_feed_screen.dart';
import '../../model/community_model.dart';
import '../../model/post_model.dart';
import 'create_post_screen.dart';
import 'create_event_screen.dart';
import 'create_community_screen.dart';
import 'posts_list_screen.dart';
import 'communities_list_screen.dart';
import 'trending_posts_screen.dart';
import 'activity_list_screen.dart';
import 'post_detail_screen.dart';
import 'rooms_list_screen.dart';
import 'create_room_screen.dart';
import 'whats_happening_list_screen.dart';
import 'recommended_communities_screen.dart';
import 'community_detail_screen.dart';
import '../widgets/messages_tab.dart';
import '../widgets/activity_navigation.dart';

class CommunityHomeScreen extends ConsumerStatefulWidget {
  const CommunityHomeScreen({super.key});

  @override
  ConsumerState<CommunityHomeScreen> createState() =>
      _CommunityHomeScreenState();
}

class _CommunityHomeScreenState extends ConsumerState<CommunityHomeScreen> {
  int _selectedBottomNavIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (!mounted) return;
      ref.read(communityViewModelProvider.notifier).loadInitialData();
      ref.read(postViewModelProvider.notifier).loadPosts();
      ref.read(eventViewModelProvider.notifier).loadEvents();
      ref.read(hiringViewModelProvider.notifier).loadInitialData();
      ref.read(careerViewModelProvider.notifier).loadInitialData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onBottomNavTap(int index) {
    if (index == 2) {
      _showCreateOptionsSheet();
      return;
    }
    if (index == 4) {
      _showProfileSheet();
      return;
    }
    setState(() {
      _selectedBottomNavIndex = index;
    });
  }

  void _openPostsScreen() {
    ref.read(postViewModelProvider.notifier).markPostsAsRead();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PostsListScreen()),
    );
  }

  void _openTrendingPostsScreen() {
    ref.read(postViewModelProvider.notifier).markPostsAsRead();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TrendingPostsScreen()),
    );
  }

  void _openActivityScreen() {
    ref.read(activityViewModelProvider.notifier).markActivitiesAsRead();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ActivityListScreen()),
    );
  }

  void _openRoomsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RoomsListScreen()),
    );
  }

  void _openWhatsHappeningScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const WhatsHappeningListScreen()),
    );
  }

  void _openRecommendedScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RecommendedCommunitiesScreen()),
    );
  }

  void _openEventsScreen() {
    ref.read(eventViewModelProvider.notifier).markEventsAsRead();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EventsListScreen()),
    );
  }

  void _openCreatePostScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreatePostScreen()),
    );
  }

  void _openCreateEventScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateEventScreen()),
    );
  }

  void _openCommunitiesScreen() {
    ref.read(communityViewModelProvider.notifier).markCommunitiesAsRead();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CommunitiesListScreen()),
    );
  }

  void _openCreateCommunityScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateCommunityScreen()),
    );
  }

  void _showCreateOptionsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
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
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Actions',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF12233D),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Select a community action to launch',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
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
              _buildCommunityActionTile(
                ctx,
                icon: Icons.post_add_rounded,
                title: 'Create Post',
                color: const Color(0xFFEA580C),
                onTap: () {
                  Navigator.pop(ctx);
                  _openCreatePostScreen();
                },
              ),
              const SizedBox(height: 10),
              _buildCommunityActionTile(
                ctx,
                icon: Icons.event_rounded,
                title: 'Create Event',
                color: const Color(0xFF059669),
                onTap: () {
                  Navigator.pop(ctx);
                  _openCreateEventScreen();
                },
              ),
              const SizedBox(height: 10),
              _buildCommunityActionTile(
                ctx,
                icon: Icons.groups_rounded,
                title: 'Create Community',
                color: const Color(0xFF2563EB),
                onTap: () {
                  Navigator.pop(ctx);
                  _openCreateCommunityScreen();
                },
              ),
              const SizedBox(height: 10),
              _buildCommunityActionTile(
                ctx,
                icon: Icons.forum_rounded,
                title: 'Create Room',
                color: const Color(0xFF7C3AED),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateRoomScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommunityActionTile(
    BuildContext ctx, {
    required IconData icon,
    required String title,
    String? subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.16)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.85)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.28),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 21),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF12233D),
                      ),
                    ),
                    if (subtitle != null && subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: color.withValues(alpha: 0.5),
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openNotificationsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
    );
  }

  void _openStartupFeed() {
    final session = ref.read(authViewModelProvider).session;
    final startupName = (session?.startupName?.isNotEmpty == true)
        ? session!.startupName!
        : session?.joinedStartupName;
    if (startupName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No startup linked yet — create one from Startup mode.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StartupPostsFeedScreen(startupName: startupName),
      ),
    );
  }

  void _openJobsBoard() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const JobsScreen()),
    );
  }

  List<BridgePost> _startupUpdates() {
    final session = ref.watch(authViewModelProvider).session;
    final posts = session?.posts ?? const [];
    if (posts.isEmpty) return const [];
    final label = (session?.startupName?.isNotEmpty == true)
        ? session!.startupName!
        : session?.joinedStartupName;
    return posts
        .map((p) => startupPostToBridge(p, startupName: label ?? 'Startup'))
        .toList();
  }

  List<BridgeOpportunity> _hiringNow() {
    final hiringRoles = ref.watch(hiringViewModelProvider).roles;
    final careerJobs = ref.watch(careerViewModelProvider).jobs;
    final session = ref.watch(authViewModelProvider).session;
    final label = (session?.startupName?.isNotEmpty == true)
        ? session!.startupName!
        : session?.joinedStartupName;
    return [
      ...startupHiringOpportunities(
        hiringRoles.where((r) => r.roleType == 'job').toList(),
        startupName: label ?? 'Startup',
      ),
      ...careerJobOpportunities(careerJobs),
    ].take(8).toList();
  }

  Widget _buildStartupUpdateCard(BridgePost post) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDE9FE), width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4A0E8F), Color(0xFF6D28D9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.rocket_launch_rounded,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${post.sourceLabel} • ${post.authorRole}',
                  style: TextStyle(fontSize: 11.5, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded,
              size: 14, color: Color(0xFF9CA3AF)),
        ],
      ),
    );
  }

  Widget _buildHiringNowCard(BridgeOpportunity opp) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: opp.fromStartup
              ? const Color(0xFFEDE9FE)
              : const Color(0xFFE0F2FE),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: opp.fromStartup
                      ? const Color(0xFFF3E8FF)
                      : const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  opp.fromStartup
                      ? Icons.rocket_launch_rounded
                      : Icons.work_rounded,
                  color: opp.fromStartup
                      ? const Color(0xFF6D28D9)
                      : const Color(0xFF0284C7),
                  size: 18,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: opp.fromStartup
                      ? const Color(0xFFEDE9FE)
                      : const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  opp.fromStartup ? 'STARTUP' : 'CAREER',
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            opp.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${opp.company} • ${opp.location}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11.5, color: Colors.grey.shade500),
          ),
          const Spacer(),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  opp.salary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF15803D),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      if (parts.isNotEmpty) return parts[0][0].toUpperCase();
      return '?';
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (ctx) => SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(ctx).viewPadding.bottom + 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 14),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFFFFF7ED),
                    backgroundImage: hasPhoto
                        ? FileImage(File(photoPath))
                        : null,
                    child: hasPhoto
                        ? null
                        : Text(
                            getInitials(userName),
                            style: const TextStyle(
                              color: Color(0xFFEA580C),
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
                  Text(
                    roleLabel,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _sheetAction(
                    Icons.person_outline_rounded,
                    'View Profile',
                    const Color(0xFFEA580C),
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
                  const SizedBox(height: 8),
                  _sheetAction(
                    Icons.swap_horiz_rounded,
                    'Switch Tab',
                    const Color(0xFFEA580C),
                    () {
                      Navigator.pop(ctx);
                      RoleSwitcherSheet.show(context);
                    },
                  ),
                  const SizedBox(height: 8),
                  _sheetAction(
                    Icons.logout_rounded,
                    'Logout',
                    const Color(0xFFEF4444),
                    () async {
                      Navigator.pop(ctx);
                      await ref.read(authViewModelProvider.notifier).logout();
                      if (!mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const SignInScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
    );
  }

  Widget _sheetAction(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF12233D),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final session = authState.session;
    final userName = session?.fullName ?? 'Member';

    final pages = [
      _buildHomeTab(userName),
      _buildCommunityTab(context, userName, session?.email ?? ''),
      _buildHomeTab(userName),
      _buildMessagesTab(),
      _buildHomeTab(userName),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: _buildDrawer(context, userName, session?.email ?? ''),
      body: pages[_selectedBottomNavIndex],
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedBottomNavIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════
  // HOME TAB - Dashboard
  // ══════════════════════════════════════════════════════════════════════
  Widget _buildHomeTab(String userName) {
    final greetingName = userName.split(RegExp(r'\s+')).first;
    final communityState = ref.watch(communityViewModelProvider);
    final postState = ref.watch(postViewModelProvider);

    String timeGreeting() {
      final hour = DateTime.now().hour;
      if (hour >= 5 && hour < 12) return 'Good Morning';
      if (hour >= 12 && hour < 17) return 'Good Afternoon';
      return 'Good Evening';
    }

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
                  Color(0xFFEA580C),
                  Color(0xFFF97316),
                  Color(0xFFEA580C),
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
                              colors: [Color(0xFFF97316), Color(0xFFEA580C)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.groups_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Community Hub',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'Connect, collaborate, grow',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.75),
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: _openNotificationsScreen,
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
                                  child: Icon(
                                    Icons.notifications_outlined,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF87171),
                                      shape: BoxShape.circle,
                                    ),
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
                      '${timeGreeting()}, $greetingName',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Here's what's happening in your communities today.",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Stats row
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _homeStat(
                            Icons.groups_rounded,
                            '${communityState.myCommunities.length}',
                            'Communities',
                          ),
                          _homeDivider(),
                          _homeStat(
                            Icons.article_outlined,
                            '${postState.posts.length}',
                            'Posts',
                          ),
                          _homeDivider(),
                          _homeStat(
                            Icons.forum_outlined,
                            '${communityState.rooms.length}',
                            'Rooms',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
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
              // Quick Actions
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 12),
              _buildHomeQuickActions(),
              const SizedBox(height: 24),

              // Startup Updates (bridged from Startup hub posts)
              if (_startupUpdates().isNotEmpty) ...[
                _buildSectionHeader(
                  title: 'Startup Updates',
                  onViewAll: _openStartupFeed,
                ),
                const SizedBox(height: 12),
                ..._startupUpdates().take(3).map(
                      (post) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildStartupUpdateCard(post),
                      ),
                    ),
                const SizedBox(height: 24),
              ],

              // Hiring Now (bridged from Startup hiring + Career board)
              _buildSectionHeader(
                title: 'Hiring Now',
                onViewAll: _openJobsBoard,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 168,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _hiringNow().length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) =>
                      _buildHiringNowCard(_hiringNow()[index]),
                ),
              ),
              const SizedBox(height: 24),

              // Trending Posts
              _buildSectionHeader(
                title: 'Trending Posts',
                onViewAll: _openTrendingPostsScreen,
              ),
              const SizedBox(height: 12),
              ..._trendingPosts().take(3).map((post) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildTrendingPostCard(
                    post: post,
                    tag: post.title.isNotEmpty
                        ? post.title.split(' ').first
                        : 'Post',
                    tagColor: const Color(0xFFEA580C),
                  ),
                );
              }),
              const SizedBox(height: 24),

              // Recent Activity
              _buildSectionHeader(
                title: 'Recent Activity',
                onViewAll: _openActivityScreen,
              ),
              const SizedBox(height: 12),
              ...ref.watch(activityViewModelProvider).activities.take(3).map((
                activity,
              ) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildActivityItem(
                    activity.icon,
                    activity.title,
                    activity.subtitle,
                    activity.timeAgo,
                    activity.color,
                    onTap: () => openActivityItem(
                      context,
                      ref,
                      activity,
                      onOpenMessages: () =>
                          setState(() => _selectedBottomNavIndex = 3),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _homeStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _homeDivider() {
    return Container(
      width: 1,
      height: 36,
      color: Colors.white.withValues(alpha: 0.2),
    );
  }

  Widget _buildHomeQuickActions() {
    final postState = ref.watch(postViewModelProvider);
    final eventState = ref.watch(eventViewModelProvider);
    final communityState = ref.watch(communityViewModelProvider);

    final actions = [
      _QuickAction(
        Icons.article_outlined,
        'Posts',
        const Color(0xFFEA580C),
        _openPostsScreen,
        count: postState.unreadCount,
      ),
      _QuickAction(
        Icons.event_outlined,
        'Events',
        const Color(0xFF059669),
        _openEventsScreen,
        count: eventState.unreadCount,
      ),
      _QuickAction(
        Icons.people_outline_rounded,
        'Communities',
        const Color(0xFF2563EB),
        _openCommunitiesScreen,
        count: communityState.unreadCount,
      ),
      _QuickAction(
        Icons.forum_outlined,
        'Rooms',
        const Color(0xFF7C3AED),
        _openRoomsScreen,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
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
          const SizedBox(height: 12),
          _buildConnectTile(),
        ],
      ),
    );
  }

  Widget _buildConnectTile() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ConnectScreen(modeTheme: 'community')),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4A0E8F), Color(0xFF6D28D9), Color(0xFF4F46E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          children: [
            Icon(Icons.alt_route_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Connect',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Startup hiring • Career jobs • Events • Investors — one feed',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(_QuickAction action) {
    return Expanded(
      child: GestureDetector(
        onTap: action.onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              decoration: BoxDecoration(
                color: action.color.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: action.color.withValues(alpha: 0.12)),
              ),
              child: Row(
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (action.count > 0)
              Positioned(
                top: -6,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: action.color,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${action.count}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<CareerPost> _trendingPosts() {
    final posts = ref.watch(postViewModelProvider).posts;
    return [...posts]..sort((a, b) => b.likes.compareTo(a.likes));
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  Widget _buildTrendingPostCard({
    required CareerPost post,
    required String tag,
    required Color tagColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PostDetailScreen(post: post)),
        ),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: tagColor.withValues(alpha: 0.12),
                    child: Text(
                      post.authorName.isNotEmpty
                          ? post.authorName[0].toUpperCase()
                          : 'A',
                      style: TextStyle(
                        color: tagColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.authorName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          _timeAgo(post.createdAt),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: tagColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: tagColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                post.content.isNotEmpty ? post.content : post.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF334155),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => ref
                        .read(postViewModelProvider.notifier)
                        .toggleLike(post.id),
                    child: Row(
                      children: [
                        Icon(
                          post.isLiked
                              ? Icons.thumb_up_rounded
                              : Icons.thumb_up_outlined,
                          size: 18,
                          color: post.isLiked
                              ? const Color(0xFFEA580C)
                              : Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${post.likes}',
                          style: TextStyle(
                            fontSize: 13,
                            color: post.isLiked
                                ? const Color(0xFFEA580C)
                                : Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PostDetailScreen(post: post),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 18,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${post.comments}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: post.title));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          content: const Row(
                            children: [
                              Icon(
                                Icons.link_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text('Post link copied to clipboard'),
                            ],
                          ),
                          backgroundColor: const Color(0xFF1E293B),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.share_outlined,
                          size: 18,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Share',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    IconData icon,
    String title,
    String subtitle,
    String time,
    Color iconColor, {
    VoidCallback? onTap,
  }) {
    final content = Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFFCBD5E1),
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(
            time,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return content;

    return GestureDetector(onTap: onTap, child: content);
  }

  // ══════════════════════════════════════════════════════════════════════
  // COMMUNITY TAB
  // ══════════════════════════════════════════════════════════════════════
  Widget _buildCommunityTab(
    BuildContext context,
    String userName,
    String email,
  ) {
    final communityState = ref.watch(communityViewModelProvider);
    final categories = communityState.categories;
    final selectedCategoryId = communityState.selectedCategoryId;
    final whatsHappening = communityState.whatsHappening;
    final filteredMyCommunities = communityState.filteredMyCommunities;
    final filteredRecommended = communityState.filteredRecommended;

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      'Community',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSearchBar(),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 96,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (ctx, index) {
                  final cat = categories[index];
                  final isSelected = cat.id == selectedCategoryId;
                  return _buildCategoryCard(cat, isSelected);
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionHeader(
                  title: "What's Happening",
                  onViewAll: _openWhatsHappeningScreen,
                ),
                const SizedBox(height: 12),
                _buildWhatsHappeningCard(whatsHappening),
                const SizedBox(height: 24),
                _buildSectionHeader(
                  title: 'My Communities',
                  onViewAll: _openCommunitiesScreen,
                ),
                const SizedBox(height: 12),
                _buildMyCommunitiesList(filteredMyCommunities),
                const SizedBox(height: 24),
                _buildSectionHeader(
                  title: 'Recommended for you',
                  onViewAll: _openRecommendedScreen,
                ),
                const SizedBox(height: 12),
                _buildRecommendedCard(filteredRecommended),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesTab() {
    return const MessagesTab();
  }

  // ── Search Input Bar ───────────────────────────────────────────────────
  Widget _buildSearchBar() {
    final hasText = _searchController.text.isNotEmpty;
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 21),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                ref
                    .read(communityViewModelProvider.notifier)
                    .setSearchQuery(val);
                setState(() {});
              },
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                hintText: 'Search communities, people, posts...',
                hintStyle: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          if (hasText)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                ref
                    .read(communityViewModelProvider.notifier)
                    .setSearchQuery('');
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.only(right: 6),
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Color(0xFF64748B),
                  size: 14,
                ),
              ),
            ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  // ── Category Filter Card ───────────────────────────────────────────────
  Widget _buildCategoryCard(CommunityCategory cat, bool isSelected) {
    const selectedBorderColor = Color(0xFFEA580C);
    const selectedBgColor = Color(0xFFFFF7ED);

    return GestureDetector(
      onTap: () {
        ref.read(communityViewModelProvider.notifier).selectCategory(cat.id);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 76,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? selectedBgColor : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? selectedBorderColor : const Color(0xFFE2E8F0),
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? selectedBorderColor.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFED7AA)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                cat.icon,
                color: isSelected
                    ? selectedBorderColor
                    : const Color(0xFF64748B),
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              cat.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected
                    ? selectedBorderColor
                    : const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Section Header ─────────────────────────────────────────────────────
  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onViewAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
            letterSpacing: -0.3,
          ),
        ),
        GestureDetector(
          onTap: onViewAll,
          child: const Row(
            children: [
              Text(
                'View all',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFEA580C),
                ),
              ),
              SizedBox(width: 2),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: Color(0xFFEA580C),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── What's Happening Card Container ────────────────────────────────────
  Widget _buildWhatsHappeningCard(List<WhatsHappeningItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          final isLast = idx == items.length - 1;

          return Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CommunityDetailScreen(
                        title: item.title,
                        memberCount: item.subtitle,
                        tag: item.status,
                        icon: item.icon,
                        gradientColors: [item.iconColor, item.iconColor],
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.vertical(
                  top: idx == 0 ? const Radius.circular(20) : Radius.zero,
                  bottom: isLast ? const Radius.circular(20) : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: item.iconBgColor,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(item.icon, color: item.iconColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.subtitle,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            item.status,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF10B981),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: Color(0xFF94A3B8),
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF1F5F9),
                  indent: 14,
                  endIndent: 14,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ── My Communities Horizontal Scroll ───────────────────────────────────
  Widget _buildMyCommunitiesList(List<MyCommunityItem> communities) {
    return SizedBox(
      height: 226,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: communities.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (ctx, index) {
          final community = communities[index];
          return _buildCommunityCardItem(community);
        },
      ),
    );
  }

  Widget _buildCommunityCardItem(MyCommunityItem community) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CommunityDetailScreen(
              title: community.title,
              memberCount: community.memberCount,
              tag: community.activeTodayCount,
              icon: community.logoIcon,
              gradientColors: community.gradientColors,
              communityId: community.id,
              isJoined: community.isJoined,
              onToggleJoin: () => ref
                  .read(communityViewModelProvider.notifier)
                  .toggleJoinMyCommunity(community.id),
            ),
          ),
        );
      },
      child: Container(
        width: 172,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Top Half with gradient and icon squircle
            Container(
              height: 94,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: community.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        community.logoIcon,
                        color: community.gradientColors.first,
                        size: 28,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.more_vert_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Half Details
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    community.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    community.memberCount,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Active Today Indicator
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        community.activeTodayCount,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Overlapping Avatar Stack
                  if (community.avatarUrls.length >= 3)
                    Row(
                      children: [
                        SizedBox(
                          width: 72,
                          height: 26,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                child: _avatarCircle(community.avatarUrls[0]),
                              ),
                              Positioned(
                                left: 16,
                                child: _avatarCircle(community.avatarUrls[1]),
                              ),
                              Positioned(
                                left: 32,
                                child: _avatarCircle(community.avatarUrls[2]),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '+${community.overflowCount}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFEA580C),
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
      ),
    );
  }

  Widget _avatarCircle(String url) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.8),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }

  // ── Recommended for you Section ────────────────────────────────────────
  Widget _buildRecommendedCard(List<RecommendedCommunityItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          final isLast = idx == items.length - 1;

          return Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CommunityDetailScreen(
                        title: item.title,
                        memberCount: item.memberCount,
                        tag: item.tag,
                        icon: item.icon,
                        gradientColors: const [
                          Color(0xFF2563EB),
                          Color(0xFF3B82F6),
                        ],
                        communityId: item.id,
                        isJoined: item.isJoined,
                        onToggleJoin: () => ref
                            .read(communityViewModelProvider.notifier)
                            .toggleJoinRecommended(item.id),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: item.iconBgColor,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(item.icon, color: item.iconColor, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${item.memberCount} • ${item.tag}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Join Button
                      GestureDetector(
                        onTap: () {
                          ref
                              .read(communityViewModelProvider.notifier)
                              .toggleJoinRecommended(item.id);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: item.isJoined
                                ? const Color(0xFFEA580C)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFEA580C),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            item.isJoined ? 'Joined' : 'Join',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: item.isJoined
                                  ? Colors.white
                                  : const Color(0xFFEA580C),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF1F5F9),
                  indent: 14,
                  endIndent: 14,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ── Navigation Drawer ─────────────────────────────────────────────────
  Widget _buildDrawer(BuildContext context, String userName, String email) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFEA580C), Color(0xFFF97316)],
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : 'C',
                style: const TextStyle(
                  color: Color(0xFFEA580C),
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            accountName: Text(
              userName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Text(email),
          ),
          ListTile(
            leading: const Icon(
              Icons.swap_horiz_rounded,
              color: Color(0xFFEA580C),
            ),
            title: const Text('Switch Tab'),
            onTap: () {
              Navigator.pop(context);
              RoleSwitcherSheet.show(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.person_outline_rounded,
              color: Color(0xFFEA580C),
            ),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFFEA580C),
            ),
            title: const Text('Notifications'),
            onTap: () {
              Navigator.pop(context);
              _openNotificationsScreen();
            },
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
            title: const Text(
              'Logout',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () async {
              Navigator.pop(context);
              await ref.read(authViewModelProvider.notifier).logout();
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SignInScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SEAMLESS FLOATING BOTTOM NAVIGATION BAR
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
                painter: _NavPainter(
                  fillColor: Colors.white,
                  borderColor: const Color(0xFFE2E8F0),
                  shadowColor: Colors.black.withValues(alpha: 0.08),
                ),
                child: SizedBox(
                  height: _navBarHeight,
                  child: Row(
                    children: [
                      _navItem(
                        0,
                        Icons.home_outlined,
                        Icons.home_rounded,
                        'Home',
                      ),
                      _navItem(
                        1,
                        Icons.people_outline_rounded,
                        Icons.people_rounded,
                        'Community',
                      ),
                      const SizedBox(width: _fabSize + 12),
                      _navItem(
                        3,
                        Icons.chat_bubble_outline_rounded,
                        Icons.chat_bubble_rounded,
                        'Messages',
                      ),
                      _navItem(
                        4,
                        Icons.person_outline_rounded,
                        Icons.person_rounded,
                        'Profile',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Floating Notch FAB Button
          Positioned(
            top: _fabTop,
            left: 0,
            right: 0,
            child: Center(child: _fabButton()),
          ),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, IconData activeIcon, String label) {
    final selected = selectedIndex == index;
    const selectedColor = Color(0xFFEA580C);
    const unselectedColor = Color(0xFF94A3B8);

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
              size: 23,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                color: selected ? selectedColor : unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fabButton() {
    return GestureDetector(
      onTap: () => onTap(2),
      child: Container(
        width: _fabSize,
        height: _fabSize,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFEA580C), Color(0xFFF97316)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFEA580C).withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
    );
  }
}

class _NavPainter extends CustomPainter {
  const _NavPainter({
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
      ..cubicTo(
        centerX - notchW + 10,
        0,
        centerX - notchR * 1.1,
        notchR * 0.06,
        centerX - notchR,
        notchR * 0.35,
      )
      ..cubicTo(
        centerX - notchR * 0.92,
        notchR * 0.6,
        centerX - notchR * 0.75,
        notchR * 0.85,
        centerX - notchR * 0.5,
        notchR * 0.98,
      )
      ..cubicTo(
        centerX - notchR * 0.28,
        notchR * 1.05,
        centerX - 14,
        notchR * 1.06,
        centerX,
        notchR * 1.06,
      )
      ..cubicTo(
        centerX + 14,
        notchR * 1.06,
        centerX + notchR * 0.28,
        notchR * 1.05,
        centerX + notchR * 0.5,
        notchR * 0.98,
      )
      ..cubicTo(
        centerX + notchR * 0.75,
        notchR * 0.85,
        centerX + notchR * 0.92,
        notchR * 0.6,
        centerX + notchR,
        notchR * 0.35,
      )
      ..cubicTo(
        centerX + notchR * 1.1,
        notchR * 0.06,
        centerX + notchW - 10,
        0,
        centerX + notchW,
        0,
      )
      ..lineTo(w - cornerRadius, 0)
      ..arcToPoint(
        Offset(w, cornerRadius),
        radius: const Radius.circular(cornerRadius),
      )
      ..lineTo(w, h - cornerRadius)
      ..arcToPoint(
        Offset(w - cornerRadius, h),
        radius: const Radius.circular(cornerRadius),
      )
      ..quadraticBezierTo(centerX, h - bottomArc, cornerRadius, h)
      ..arcToPoint(
        Offset(0, h - cornerRadius),
        radius: const Radius.circular(cornerRadius),
      )
      ..lineTo(0, cornerRadius)
      ..arcToPoint(
        Offset(cornerRadius, 0),
        radius: const Radius.circular(cornerRadius),
      )
      ..close();

    canvas.drawShadow(path, shadowColor, 20, true);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.fill
        ..color = fillColor,
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = borderColor,
    );
  }

  @override
  bool shouldRepaint(covariant _NavPainter oldDelegate) =>
      oldDelegate.fillColor != fillColor ||
      oldDelegate.borderColor != borderColor ||
      oldDelegate.shadowColor != shadowColor;
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final int count;
  const _QuickAction(
    this.icon,
    this.label,
    this.color,
    this.onTap, {
    this.count = 0,
  });
}
