import 'package:flutter/material.dart';
import 'direct_message_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// UserProfileScreen – public-facing profile view opened from feed post avatars
// ─────────────────────────────────────────────────────────────────────────────

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({
    super.key,
    required this.name,
    required this.handle,
    required this.role,
    required this.avatarColor,
    required this.initials,
    this.location = 'San Francisco, CA',
    this.bio,
    this.followers = 1200,
    this.following = 430,
    this.posts = 86,
  });

  final String name;
  final String handle;
  final String role;
  final Color avatarColor;
  final String initials;
  final String location;
  final String? bio;
  final int followers;
  final int following;
  final int posts;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _isFollowing = false;

  static const _kPurple = Color(0xFF4338CA);
  static const _kPurpleLight = Color(0xFFEEF2FF);
  static const _kTextDark = Color(0xFF111827);
  static const _kTextMid = Color(0xFF6B7280);
  static const _kBorder = Color(0xFFE5E7EB);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatCount(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }

  @override
  Widget build(BuildContext context) {
    final bio = widget.bio ??
        'Building impactful products and collaborating with amazing people. '
            'Passionate about technology, design, and making a difference. #Innovation #Collab';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 18, color: _kTextDark),
              ),
            ),
            title: AnimatedOpacity(
              opacity: innerBoxIsScrolled ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                widget.handle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _kPurple,
                ),
              ),
            ),
            centerTitle: true,
            actions: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Help',
                  style: TextStyle(
                    color: _kTextMid,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(
                clipBehavior: Clip.none,
                children: [
                  // ── Cover gradient ───────────────────────────────────────
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.avatarColor.withValues(alpha: 0.85),
                          widget.avatarColor.withValues(alpha: 0.55),
                          Colors.white,
                        ],
                      ),
                    ),
                    child: CustomPaint(painter: _CoverPatternPainter(widget.avatarColor)),
                  ),

                  // ── Avatar circle ────────────────────────────────────────
                  Positioned(
                    bottom: 0,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: widget.avatarColor.withValues(alpha: 0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 38,
                        backgroundColor: widget.avatarColor.withValues(alpha: 0.15),
                        child: Text(
                          widget.initials,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: widget.avatarColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Profile info card ──────────────────────────────────────────
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle in purple
                    Text(
                      widget.handle,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _kPurple,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Name
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: _kTextDark,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Role
                    Text(
                      widget.role,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: _kTextMid,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Location
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 14, color: _kTextMid),
                        const SizedBox(width: 3),
                        Text(
                          widget.location,
                          style: const TextStyle(
                              fontSize: 12.5, color: _kTextMid),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Bio
                    Text(
                      bio,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF374151),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Stats row ──────────────────────────────────────────
                    Row(
                      children: [
                        _statItem(_formatCount(widget.followers), 'Followers'),
                        const SizedBox(width: 24),
                        _statItem('${widget.following}', 'Following'),
                        const SizedBox(width: 24),
                        _statItem('${widget.posts}', 'Posts'),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // ── Action buttons ────────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isFollowing = !_isFollowing),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 42,
                              decoration: BoxDecoration(
                                color: _isFollowing ? Colors.white : _kPurple,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _kPurple,
                                  width: 1.5,
                                ),
                                boxShadow: _isFollowing
                                    ? []
                                    : [
                                        BoxShadow(
                                          color: _kPurple.withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        )
                                      ],
                              ),
                              child: Center(
                                child: Text(
                                  _isFollowing ? 'Following ✓' : 'Follow',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: _isFollowing ? _kPurple : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DirectMessageScreen(
                                    name: widget.name,
                                    handle: widget.handle,
                                    avatarColor: widget.avatarColor,
                                    initials: widget.initials,
                                    isOnline: true,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: _kBorder, width: 1.5),
                              ),
                              child: const Center(
                                child: Text(
                                  'Message',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: _kPurple,
                                  ),
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

              const SizedBox(height: 8),

              // ── Tabs ──────────────────────────────────────────────────────
              Container(
                color: Colors.white,
                child: TabBar(
                  controller: _tabController,
                  labelColor: _kPurple,
                  unselectedLabelColor: _kTextMid,
                  indicatorColor: _kPurple,
                  indicatorWeight: 2.5,
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.grid_view_rounded, size: 18),
                      text: 'Posts',
                    ),
                    Tab(
                      icon: Icon(Icons.military_tech_rounded, size: 18),
                      text: 'Achievements',
                    ),
                    Tab(
                      icon: Icon(Icons.folder_outlined, size: 18),
                      text: 'Projects',
                    ),
                  ],
                ),
              ),

              // ── Tab content ───────────────────────────────────────────────
              _TabContent(
                tabController: _tabController,
                name: widget.name,
                avatarColor: widget.avatarColor,
                initials: widget.initials,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: _kTextDark,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: _kTextMid),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab content builder
// ─────────────────────────────────────────────────────────────────────────────

class _TabContent extends StatefulWidget {
  const _TabContent({
    required this.tabController,
    required this.name,
    required this.avatarColor,
    required this.initials,
  });

  final TabController tabController;
  final String name;
  final Color avatarColor;
  final String initials;

  @override
  State<_TabContent> createState() => _TabContentState();
}

class _TabContentState extends State<_TabContent> {
  static const _kPurple = Color(0xFF4338CA);
  static const _kPurpleLight = Color(0xFFEEF2FF);
  static const _kTextDark = Color(0xFF111827);
  static const _kTextMid = Color(0xFF6B7280);
  static const _kBorder = Color(0xFFE5E7EB);

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.tabController.index) {
      case 0:
        return _postsTab();
      case 1:
        return _achievementsTab();
      default:
        return _projectsTab();
    }
  }

  Widget _postsTab() {
    final posts = [
      ('Just wrapped up a deep-dive into AI-powered design workflows. The future is bright! 🚀 #AI #Design', '2h ago', 248, 42),
      ('Excited to share my latest project — a collaborative workspace tool that\'s changing how remote teams connect. #RemoteWork', '1d ago', 892, 156),
      ('Throwback to our team hackathon last weekend. So proud of what we built together 🏆 #Collab #Innovation', '3d ago', 563, 74),
    ];

    return Column(
      children: [
        ...posts.map(
          (p) => Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _kBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: widget.avatarColor.withValues(alpha: 0.15),
                      child: Text(
                        widget.initials,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: widget.avatarColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.name,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _kTextDark)),
                        Text(p.$2,
                            style: const TextStyle(
                                fontSize: 11, color: _kTextMid)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(p.$1,
                    style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF374151),
                        height: 1.5)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.thumb_up_outlined,
                        size: 15, color: _kTextMid),
                    const SizedBox(width: 4),
                    Text('${p.$3}',
                        style: const TextStyle(
                            fontSize: 12, color: _kTextMid)),
                    const SizedBox(width: 14),
                    const Icon(Icons.chat_bubble_outline_rounded,
                        size: 15, color: _kTextMid),
                    const SizedBox(width: 4),
                    Text('${p.$4}',
                        style: const TextStyle(
                            fontSize: 12, color: _kTextMid)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _achievementsTab() {
    final achievements = [
      (Icons.military_tech_rounded, 'Global Hackathon Winner 2026', 'Collobster Tech'),
      (Icons.star_rounded, 'Top AI Contributor Q3', 'Open Data Institute'),
      (Icons.school_rounded, 'Advanced Machine Learning Cert', 'Tech University'),
    ];

    return Column(
      children: [
        ...achievements.map(
          (a) => Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _kBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _kPurpleLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(a.$1, size: 24, color: _kPurple),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a.$2,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _kTextDark,
                          )),
                      const SizedBox(height: 2),
                      Text(a.$3,
                          style: const TextStyle(
                              fontSize: 12.5, color: _kTextMid)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _kPurpleLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.verified_rounded,
                                    size: 12, color: _kPurple),
                                SizedBox(width: 4),
                                Text('Verified',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: _kPurple,
                                    )),
                              ],
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
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _projectsTab() {
    final projects = [
      ('AI Collaboration Hub', 'A real-time workspace powered by AI for distributed teams.', 0.72),
      ('Smart Resume Builder', 'ML-driven resume tailoring tool for job seekers.', 0.45),
    ];

    return Column(
      children: [
        ...projects.map(
          (p) => Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _kBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _kPurpleLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.folder_rounded,
                          size: 20, color: _kPurple),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        p.$1,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: _kTextDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(p.$2,
                    style: const TextStyle(
                        fontSize: 13, color: Color(0xFF374151), height: 1.4)),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: p.$3,
                    backgroundColor: _kPurpleLight,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(_kPurple),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 4),
                Text('${(p.$3 * 100).toInt()}% complete',
                    style: const TextStyle(fontSize: 11.5, color: _kTextMid)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Custom painter for cover pattern
// ─────────────────────────────────────────────────────────────────────────────

class _CoverPatternPainter extends CustomPainter {
  final Color color;
  const _CoverPatternPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    // Decorative circles
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.3), 60, paint);
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.7), 40, paint);
    canvas.drawCircle(Offset(size.width * 0.95, size.height * 0.8), 30, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
