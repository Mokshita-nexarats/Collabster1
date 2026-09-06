import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';
import 'activity_screen.dart';
import 'comments_sheet.dart';
import 'share_sheet.dart';
import 'main_drawer.dart';
import '../../home/view/user_profile_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Feed Screen – main social feed matching the "Hey Lobster!" design
// ─────────────────────────────────────────────────────────────────────────────

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _postController = TextEditingController();
  File? _selectedImageFile;

  // Scaffold key to open drawer programmatically
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Ticker scroll
  late final ScrollController _tickerController;
  Timer? _tickerTimer;

  static const _kPurple = Color(0xFF4338CA);
  static const _kPurpleDark = Color(0xFF3730A3);
  static const _kPurpleLight = Color(0xFFEEF2FF);
  static const _kPurpleSoft = Color(0xFFE0E7FF);
  static const _kTextDark = Color(0xFF111827);
  static const _kTextMid = Color(0xFF6B7280);
  static const _kBorder = Color(0xFFE5E7EB);
  static const _kBg = Color(0xFFF8F9FC);

  final List<_FeedPost> _posts = [
    _FeedPost(
      authorName: 'Alpha Tech Team',
      authorSub: 'Product Development • 2h',
      authorInitials: 'A',
      authorColor: Color(0xFF4F46E5),
      title: 'Project Alpha: Beta Launch Today! 🚀',
      body:
          "We are thrilled to announce that the beta version of Project Alpha is finally live! Huge thanks to the incredible team for their dedication over the past 6 months. We're looking for early adopters to provide feedback.",
      hasImage: true,
      likes: 248,
      comments: 42,
      likedByMe: false,
    ),
    _FeedPost(
      authorName: 'Emma Williams',
      authorSub: 'Senior Marketing Strategist • 5h',
      authorInitials: 'E',
      authorColor: Color(0xFF7C3AED),
      title: '',
      body:
          "I'm excited to share that I've joined the incredible team at DesignBridge as their new Head of Marketing! Looking forward to this new chapter and building amazing campaigns with a talented crew. #CareerUpdate #MarketingLife",
      hasImage: false,
      likes: 892,
      comments: 156,
      likedByMe: true,
    ),
    _FeedPost(
      authorName: 'Rahul Sharma',
      authorSub: 'Startup Founder • 8h',
      authorInitials: 'R',
      authorColor: Color(0xFF059669),
      title: 'We just crossed 10,000 users! 🎉',
      body:
          "Six months ago we launched with zero users. Today, we hit 10K. This wouldn't have happened without our amazing community. Thank you for believing in us. #Milestone #Startup #Growth",
      hasImage: false,
      likes: 1204,
      comments: 89,
      likedByMe: false,
    ),
    _FeedPost(
      authorName: 'FinTech Lab',
      authorSub: 'Community Page • 12h',
      authorInitials: 'F',
      authorColor: Color(0xFFDC2626),
      title: '🌱 Seed Funding Round Closed!',
      body:
          'FinTech Lab has successfully closed its seed funding round of \$2.4M. We will be using the capital to expand our engineering team and scale our AI-powered credit scoring model. Applications open now!',
      hasImage: false,
      likes: 563,
      comments: 74,
      likedByMe: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tickerController = ScrollController();
    // Auto-scroll ticker right→left every 16ms (~60fps), loops seamlessly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tickerTimer = Timer.periodic(const Duration(milliseconds: 30), (_) {
        if (!_tickerController.hasClients) return;
        final max = _tickerController.position.maxScrollExtent;
        final current = _tickerController.offset;
        if (max <= 0) return;
        if (current >= max) {
          _tickerController.jumpTo(0);
        } else {
          _tickerController.jumpTo(current + 1.5);
        }
      });
    });
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    _tabController.dispose();
    _searchController.dispose();
    _postController.dispose();
    _tickerController.dispose();
    super.dispose();
  }

  // ── helpers ────────────────────────────────────────────────────────────────

  String _firstName(String full) => full.split(RegExp(r'\s+')).first;

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final session = authState.session;
    final userName = session?.fullName ?? 'Lobster';
    final firstName = _firstName(userName);
    final photoPath = session?.profilePhotoPath ?? '';
    final hasPhoto = photoPath.isNotEmpty && File(photoPath).existsSync();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _kBg,
      drawer: const MainDrawer(activeRoute: 'feed'),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Top bar ──────────────────────────────────────────────────
            _buildTopBar(firstName),

            // ── Ticker ─────────────────────────────────────────────────────
            _buildTicker(),

            // ── Scrollable body ──────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 100),
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 12),
                  // Search bar
                  _buildSearchBar(),
                  const SizedBox(height: 14),
                  // Post composer
                  _buildPostComposer(hasPhoto, photoPath, userName),
                  const SizedBox(height: 14),
                  // Tabs + feed
                  _buildTabSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Top bar ────────────────────────────────────────────────────────────────

  Widget _buildTopBar(String firstName) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Hamburger
          GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: const Icon(Icons.menu_rounded, size: 26, color: _kTextDark),
          ),
          const SizedBox(width: 12),
          // Greeting
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Hey ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: _kTextDark,
                    ),
                  ),
                  TextSpan(
                    text: '$firstName!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: _kPurple,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Notification with badge
          GestureDetector(
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (_) => const ActivityScreen()),
              );
            },
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    size: 26,
                    color: _kTextDark,
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
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
    );
  }

  // ── Scrolling ticker ───────────────────────────────────────────────────────

  Widget _buildTicker() {
    const items = [
      '🚀 FINTECH LAB CLOSED SEED MILESTONE',
      '🎓 NEW ALUMNI FUND LAUNCHED',
      '💡 COLLABSTER BETA NOW LIVE',
      '📢 PRODUCT DESIGN SUMMIT — REGISTER NOW',
    ];
    final text = items.join('   •   ');

    return Container(
      height: 30,
      color: _kPurpleDark,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _tickerController,
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 48),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }

  // ── Search bar ─────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _kBorder),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            const Icon(
              Icons.search_rounded,
              size: 18,
              color: Color(0xFF9CA3AF),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: const TextStyle(fontSize: 13.5, color: _kTextDark),
                decoration: const InputDecoration(
                  hintText: 'Search navigation...',
                  hintStyle: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 13.5,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Post composer ──────────────────────────────────────────────────────────

  Widget _buildPostComposer(bool hasPhoto, String photoPath, String userName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _kBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Selected image preview
            if (_selectedImageFile != null) ...[
              Container(
                width: double.infinity,
                height: 180,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.file(
                  _selectedImageFile!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ] else if (hasPhoto) ...[
              Container(
                width: double.infinity,
                height: 180,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(0),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _kPurpleLight,
                      _kPurpleSoft,
                      _kPurple.withValues(alpha: 0.15),
                    ],
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Decorative phone mockup illustration
                    Positioned(right: 24, child: _PhoneMockup(color: _kPurple)),
                    Positioned(
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _mockCard('collabster', _kPurple),
                          const SizedBox(height: 6),
                          _mockCard('a Feed', const Color(0xFF7C3AED)),
                          const SizedBox(height: 6),
                          _mockCard('launch!', const Color(0xFF4F46E5)),
                        ],
                      ),
                    ),
                    // Floating stats
                    Positioned(
                      top: 18,
                      right: 18,
                      child: _mockStat(Icons.bar_chart_rounded, _kPurple),
                    ),
                    Positioned(
                      bottom: 18,
                      left: 18,
                      child: _mockStat(
                        Icons.pie_chart_rounded,
                        const Color(0xFF7C3AED),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 10),
            // Action row
            Row(
              children: [
                _composerAction(Icons.image_outlined, () {}),
                const SizedBox(width: 8),
                _composerAction(Icons.link_rounded, () {}),
                const Spacer(),
                // Post button
                GestureDetector(
                  onTap: () =>
                      _showComposerSheet(hasPhoto, photoPath, userName),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _kPurple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Post',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _composerAction(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: _kPurpleLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: _kPurple),
      ),
    );
  }

  // ── Tabs + feed ────────────────────────────────────────────────────────────

  Widget _buildTabSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab bar
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            isScrollable: false,
            labelColor: _kPurple,
            unselectedLabelColor: _kTextMid,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            indicatorColor: _kPurple,
            indicatorWeight: 2.5,
            dividerColor: _kBorder,
            tabs: const [
              Tab(text: 'For You'),
              Tab(text: 'Following'),
              Tab(text: 'Trending'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Feed list – static, non-scrolling inside the outer ListView
        ..._posts.map((post) => _buildPostCard(post)),
        const SizedBox(height: 20),
      ],
    );
  }

  // ── Post card ──────────────────────────────────────────────────────────────

  Widget _buildPostCard(_FeedPost post) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Author row ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 10, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    // Derive a clean role label from the sub-header ("Role • Xh ago")
                    final rolePart = post.authorSub.contains('•')
                        ? post.authorSub.split('•').first.trim()
                        : post.authorSub;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UserProfileScreen(
                          name: post.authorName,
                          handle:
                              '@${post.authorName.toLowerCase().replaceAll(' ', '_')}',
                          role: rolePart,
                          avatarColor: post.authorColor,
                          initials: post.authorInitials,
                        ),
                      ),
                    );
                  },
                  child: _buildAvatar(
                    hasPhoto: false,
                    photoPath: '',
                    initials: post.authorInitials,
                    radius: 20,
                    color: post.authorColor,
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
                          color: _kTextDark,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        post.authorSub,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: _kTextMid,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _showPostOptions(post),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.more_horiz_rounded,
                      size: 20,
                      color: _kTextMid,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Content ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.title.isNotEmpty) ...[
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: _kTextDark,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
                Text(
                  post.body,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF374151),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // ── Post image ─────────────────────────────────────────────────
          if (post.hasImage) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(0),
              ),
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _kPurpleLight,
                      _kPurpleSoft,
                      _kPurple.withValues(alpha: 0.15),
                    ],
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Decorative phone mockup illustration
                    Positioned(right: 24, child: _PhoneMockup(color: _kPurple)),
                    Positioned(
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _mockCard('collabster', _kPurple),
                          const SizedBox(height: 6),
                          _mockCard('a Feed', const Color(0xFF7C3AED)),
                          const SizedBox(height: 6),
                          _mockCard('launch!', const Color(0xFF4F46E5)),
                        ],
                      ),
                    ),
                    // Floating stats
                    Positioned(
                      top: 18,
                      right: 18,
                      child: _mockStat(Icons.bar_chart_rounded, _kPurple),
                    ),
                    Positioned(
                      bottom: 18,
                      left: 18,
                      child: _mockStat(
                        Icons.pie_chart_rounded,
                        const Color(0xFF7C3AED),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // ── Actions ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                _postAction(
                  icon: post.likedByMe
                      ? Icons.thumb_up_rounded
                      : Icons.thumb_up_outlined,
                  label: _formatCount(post.likes),
                  color: post.likedByMe ? _kPurple : _kTextMid,
                  onTap: () => setState(() {
                    final idx = _posts.indexOf(post);
                    _posts[idx] = post.copyWith(
                      likes: post.likedByMe ? post.likes - 1 : post.likes + 1,
                      likedByMe: !post.likedByMe,
                    );
                  }),
                ),
                const SizedBox(width: 20),
                _postAction(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: _formatCount(post.comments),
                  color: _kTextMid,
                  onTap: () =>
                      CommentsSheet.show(context, commentCount: post.comments),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => ShareSheet.show(context),
                  child: const Icon(
                    Icons.share_outlined,
                    size: 20,
                    color: _kTextMid,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _postAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }

  // ── Avatar ─────────────────────────────────────────────────────────────────

  Widget _buildAvatar({
    required bool hasPhoto,
    required String photoPath,
    required String initials,
    required double radius,
    required Color color,
  }) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: color.withValues(alpha: 0.15),
      backgroundImage: hasPhoto ? FileImage(File(photoPath)) : null,
      child: hasPhoto
          ? null
          : Text(
              initials,
              style: TextStyle(
                color: color,
                fontSize: radius * 0.9,
                fontWeight: FontWeight.w800,
              ),
            ),
    );
  }

  // ── Mock decorations for post image ───────────────────────────────────────

  Widget _mockCard(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _mockStat(IconData icon, Color color) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }

  // ── Bottom sheet: composer ─────────────────────────────────────────────────

  void _showComposerSheet(bool hasPhoto, String photoPath, String userName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                    _buildAvatar(
                      hasPhoto: hasPhoto,
                      photoPath: photoPath,
                      initials: userName.isNotEmpty
                          ? userName[0].toUpperCase()
                          : '?',
                      radius: 20,
                      color: _kPurple,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _postController,
                        autofocus: true,
                        maxLines: 5,
                        minLines: 3,
                        style: const TextStyle(fontSize: 14, color: _kTextDark),
                        decoration: const InputDecoration(
                          hintText: "What's on your mind?",
                          hintStyle: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _composerAction(Icons.image_outlined, () {}),
                    const SizedBox(width: 8),
                    _composerAction(Icons.link_rounded, () {}),
                    const SizedBox(width: 8),
                    _composerAction(Icons.tag_rounded, () {}),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx);
                        _postController.clear();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: _kPurple,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Post',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Post options sheet ────────────────────────────────────────────────────

  void _showPostOptions(_FeedPost post) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              _optionTile(
                Icons.bookmark_outline_rounded,
                'Save post',
                () => Navigator.pop(ctx),
              ),
              _optionTile(
                Icons.person_remove_outlined,
                'Unfollow ${post.authorName}',
                () => Navigator.pop(ctx),
              ),
              _optionTile(
                Icons.flag_outlined,
                'Report post',
                () => Navigator.pop(ctx),
                danger: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _optionTile(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool danger = false,
  }) {
    final color = danger ? const Color(0xFFEF4444) : _kTextDark;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color, size: 22),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      onTap: onTap,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────

class _FeedPost {
  final String authorName;
  final String authorSub;
  final String authorInitials;
  final Color authorColor;
  final String title;
  final String body;
  final bool hasImage;
  final int likes;
  final int comments;
  final bool likedByMe;

  const _FeedPost({
    required this.authorName,
    required this.authorSub,
    required this.authorInitials,
    required this.authorColor,
    required this.title,
    required this.body,
    required this.hasImage,
    required this.likes,
    required this.comments,
    required this.likedByMe,
  });

  _FeedPost copyWith({int? likes, bool? likedByMe}) {
    return _FeedPost(
      authorName: authorName,
      authorSub: authorSub,
      authorInitials: authorInitials,
      authorColor: authorColor,
      title: title,
      body: body,
      hasImage: hasImage,
      likes: likes ?? this.likes,
      comments: comments,
      likedByMe: likedByMe ?? this.likedByMe,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Phone mockup widget (decorative)
// ─────────────────────────────────────────────────────────────────────────────

class _PhoneMockup extends StatelessWidget {
  final Color color;
  const _PhoneMockup({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(4, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 24,
            height: 4,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: List.generate(
                  5,
                  (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.2 + i * 0.06),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
