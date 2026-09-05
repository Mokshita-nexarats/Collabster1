import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ActivityScreen – "Your activity" dashboard opened from the drawer footer
// ─────────────────────────────────────────────────────────────────────────────

class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;

  static const _kPurple     = Color(0xFF4338CA);
  static const _kPurpleLight = Color(0xFFEEF2FF);
  static const _kTextDark   = Color(0xFF111827);
  static const _kTextMid    = Color(0xFF6B7280);
  static const _kBorder     = Color(0xFFE5E7EB);
  static const _kBg         = Color(0xFFF8F9FC);

  // ── Seed data ───────────────────────────────────────────────────────────────

  final _notifications = const [
    _NotifItem(
      initials: 'SJ',
      color: Color(0xFF4338CA),
      body: 'Sarah Jenkins and 14 others liked your comment on ',
      link: 'Project Alpha',
      timeAgo: '45m ago',
      dotColor: Color(0xFFEF4444),
    ),
    _NotifItem(
      initials: 'MC',
      color: Color(0xFF059669),
      body: 'Marcus Cole replied to your thread in ',
      link: 'Design Sync Q3',
      timeAgo: '2h ago',
      dotColor: Color(0xFF4338CA),
    ),
    _NotifItem(
      initials: 'RK',
      color: Color(0xFF7C3AED),
      body: 'Riya Kumar mentioned you in ',
      link: 'Q4 Roadmap Discussion',
      timeAgo: '4h ago',
      dotColor: Color(0xFF7C3AED),
    ),
    _NotifItem(
      initials: 'AT',
      color: Color(0xFF0284C7),
      body: 'Alpha Tech Team posted a new update: ',
      link: 'Beta Launch Live!',
      timeAgo: '6h ago',
      dotColor: Color(0xFF22C55E),
    ),
  ];

  final _reactedActions = const [
    _NotifItem(
      initials: 'EW',
      color: Color(0xFF7C3AED),
      body: 'You liked Emma Williams\'s post about ',
      link: 'Head of Marketing role',
      timeAgo: '1h ago',
      dotColor: Color(0xFFEF4444),
    ),
    _NotifItem(
      initials: 'RS',
      color: Color(0xFF059669),
      body: 'You reacted 🎉 to Rahul Sharma\'s milestone: ',
      link: '10K Users Celebration',
      timeAgo: '3h ago',
      dotColor: Color(0xFFEF4444),
    ),
  ];

  final _commentHistory = const [
    _NotifItem(
      initials: 'FL',
      color: Color(0xFFDC2626),
      body: 'You commented on FinTech Lab\'s post: ',
      link: 'Seed Funding Round',
      timeAgo: '5h ago',
      dotColor: Color(0xFF4338CA),
    ),
    _NotifItem(
      initials: 'AT',
      color: Color(0xFF4F46E5),
      body: 'You replied to a thread in ',
      link: 'Project Alpha: Beta Launch',
      timeAgo: '7h ago',
      dotColor: Color(0xFF4338CA),
    ),
  ];

  final _people = const [
    _PersonItem(initials: 'DC', color: Color(0xFF0284C7), name: 'David Chen',    role: 'Senior Software...', mutual: 12),
    _PersonItem(initials: 'MP', color: Color(0xFF7C3AED), name: 'Maya Patel',    role: 'Product Designer',   mutual: 8),
    _PersonItem(initials: 'AL', color: Color(0xFF059669), name: 'Aisha Lee',     role: 'Data Scientist',     mutual: 5),
    _PersonItem(initials: 'JS', color: Color(0xFFDC2626), name: 'James Sullivan', role: 'UX Researcher',      mutual: 3),
  ];

  final _connected = <String>{};

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _tabCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final userName  = authState.session?.fullName ?? 'Member';

    return Scaffold(
      backgroundColor: _kBg,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title ───────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Text(
                'Your activity',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: _kPurple,
                  letterSpacing: -0.4,
                ),
              ),
            ),

            // ── Stats card ──────────────────────────────────────────────────
            _buildStatsCard(),

            const SizedBox(height: 20),

            // ── Tabs ─────────────────────────────────────────────────────────
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabCtrl,
                labelColor: _kPurple,
                unselectedLabelColor: _kTextMid,
                indicatorColor: _kPurple,
                indicatorWeight: 2.5,
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(text: 'Notifications'),
                  Tab(text: 'Reacted Actions'),
                  Tab(text: 'Comment History'),
                ],
              ),
            ),

            const SizedBox(height: 4),

            // ── Tab content ──────────────────────────────────────────────────
            _buildTabContent(),

            const SizedBox(height: 24),

            // ── People You May Know ──────────────────────────────────────────
            _buildPeopleSection(),
          ],
        ),
      ),
    );
  }

  // ── App bar ──────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
          color: _kPurple,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
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
    );
  }

  // ── Stats card ────────────────────────────────────────────────────────────

  Widget _buildStatsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _kPurpleLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '1,248',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: _kPurple,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Profile Views',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _kTextDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Text(
                        '(Past 7 days, ',
                        style: TextStyle(fontSize: 11.5, color: _kTextMid),
                      ),
                      const Text(
                        '+14%)',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF22C55E),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(width: 1, height: 60, color: _kBorder),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '5,320',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: _kTextDark,
                        letterSpacing: -1,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Post Impressions',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _kTextDark,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '(Past 7 days)',
                      style: TextStyle(fontSize: 11.5, color: _kTextMid),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Tab content ───────────────────────────────────────────────────────────

  Widget _buildTabContent() {
    final items = switch (_tabCtrl.index) {
      0 => _notifications,
      1 => _reactedActions,
      _ => _commentHistory,
    };

    return Column(
      children: items
          .map((n) => _NotifCard(item: n))
          .toList(),
    );
  }

  // ── People You May Know ───────────────────────────────────────────────────

  Widget _buildPeopleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Text(
            'People You May Know',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: _kTextDark,
              letterSpacing: -0.3,
            ),
          ),
        ),
        SizedBox(
          height: 185,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: _people
                .map(
                  (p) => _PersonCard(
                    person: p,
                    connected: _connected.contains(p.name),
                    onConnect: () => setState(
                      () => _connected.contains(p.name)
                          ? _connected.remove(p.name)
                          : _connected.add(p.name),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data classes
// ─────────────────────────────────────────────────────────────────────────────

class _NotifItem {
  final String initials;
  final Color color;
  final String body;
  final String link;
  final String timeAgo;
  final Color dotColor;
  const _NotifItem({
    required this.initials,
    required this.color,
    required this.body,
    required this.link,
    required this.timeAgo,
    required this.dotColor,
  });
}

class _PersonItem {
  final String initials;
  final Color color;
  final String name;
  final String role;
  final int mutual;
  const _PersonItem({
    required this.initials,
    required this.color,
    required this.name,
    required this.role,
    required this.mutual,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Notification card widget
// ─────────────────────────────────────────────────────────────────────────────

class _NotifCard extends StatelessWidget {
  const _NotifCard({required this.item});
  final _NotifItem item;

  static const _kPurple    = Color(0xFF4338CA);
  static const _kPurpleLight = Color(0xFFEEF2FF);
  static const _kTextDark  = Color(0xFF111827);
  static const _kTextMid   = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 6, 20, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _kPurpleLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 22,
            backgroundColor: item.color.withValues(alpha: 0.15),
            child: Text(
              item.initials,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: item.color,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Body
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: _kTextDark,
                      height: 1.45,
                    ),
                    children: [
                      TextSpan(
                        text: item.body,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text: item.link,
                        style: const TextStyle(
                          color: _kPurple,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: item.dotColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.timeAgo,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: _kTextMid,
                        fontWeight: FontWeight.w500,
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
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Person card widget
// ─────────────────────────────────────────────────────────────────────────────

class _PersonCard extends StatelessWidget {
  const _PersonCard({
    required this.person,
    required this.connected,
    required this.onConnect,
  });
  final _PersonItem person;
  final bool connected;
  final VoidCallback onConnect;

  static const _kPurple      = Color(0xFF4338CA);
  static const _kPurpleLight = Color(0xFFEEF2FF);
  static const _kTextDark    = Color(0xFF111827);
  static const _kTextMid     = Color(0xFF6B7280);
  static const _kBorder      = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 12),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: person.color.withValues(alpha: 0.15),
            child: Text(
              person.initials,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: person.color,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            person.name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _kTextDark,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            person.role,
            style: const TextStyle(fontSize: 11, color: _kTextMid),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${person.mutual} mutual',
            style: const TextStyle(
              fontSize: 10.5,
              color: _kTextMid,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onConnect,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 30,
              decoration: BoxDecoration(
                color: connected ? _kPurple : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _kPurple, width: 1.5),
              ),
              child: Center(
                child: Text(
                  connected ? 'Connected ✓' : 'Connect',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: connected ? Colors.white : _kPurple,
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
