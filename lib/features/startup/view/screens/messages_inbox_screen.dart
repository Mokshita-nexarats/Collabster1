import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import '../../model/startup_models.dart';
import '../../model/team_chat_message.dart';
import '../../viewmodel/team_state.dart';
import 'team_chat_screen.dart';
import '../widgets/startup_color_helper.dart';

class MessagesInboxScreen extends ConsumerStatefulWidget {
  const MessagesInboxScreen({
    super.key,
    required this.startupName,
  });

  final String startupName;

  @override
  ConsumerState<MessagesInboxScreen> createState() => _MessagesInboxScreenState();
}

class _MessagesInboxScreenState extends ConsumerState<MessagesInboxScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchCtrl = TextEditingController();
  late AnimationController _fadeCtrl;
  String _query = '';

  // Online status simulation
  static const Set<String> _onlineMembers = {
    'Rahul Verma',
    'Sneha Iyer',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _searchCtrl.addListener(() {
      setState(() => _query = _searchCtrl.text.toLowerCase());
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(teamViewModelProvider.notifier).loadInitialData();
      ref.read(requestsViewModelProvider.notifier).loadInitialData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  List<TeamMember> _filtered(TeamState teamState) {
    if (_query.isEmpty) return teamState.members;
    return teamState.members
        .where((m) =>
            m.name.toLowerCase().contains(_query) ||
            m.role.toLowerCase().contains(_query))
        .toList();
  }

  void _openChat(TeamMember member) {
    ref.read(teamViewModelProvider.notifier).markAsRead(member.name);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, a1, a2) => TeamChatScreen(
          member: member,
          startupName: widget.startupName,
        ),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 320),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teamState = ref.watch(teamViewModelProvider);
    final requestsState = ref.watch(requestsViewModelProvider);
    final pendingRequests = requestsState.pending;
    final members = _filtered(teamState);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF0088CC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          if (teamState.totalUnread > 0)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${teamState.totalUnread} unread',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF229ED9), Color(0xFF006699)],
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          tabs: [
            const Tab(text: 'Chats'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Requests'),
                  if (pendingRequests.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${pendingRequests.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChatsTab(teamState, members),
          _buildRequestsTab(pendingRequests),
        ],
      ),
    );
  }

  // ── Chats Tab View ───────────────────────────────────────────────────
  Widget _buildChatsTab(TeamState teamState, List<TeamMember> members) {
    return CustomScrollView(
      slivers: [
        // ── Search bar ──────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchCtrl,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF12233D),
                ),
                decoration: InputDecoration(
                  hintText: 'Search conversations...',
                  hintStyle: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF9CA3AF),
                    size: 20,
                  ),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Color(0xFF9CA3AF),
                            size: 18,
                          ),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _query = '');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
        ),

        // ── Online Now horizontal strip ──────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 0, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'ONLINE NOW',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF6B7280),
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                SizedBox(
                  height: 82,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: teamState.members
                        .where((m) => _onlineMembers.contains(m.name))
                        .map((m) => _onlineAvatar(m))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Section header ───────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                const Text(
                  'ALL CONVERSATIONS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF6B7280),
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                Text(
                  '${members.length} chats',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Conversation list ─────────────────────────────────────────
        members.isEmpty
            ? SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 52,
                        color: Colors.grey.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'No results found',
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    return FadeTransition(
                      opacity: _fadeCtrl,
                      child: _conversationTile(members[i], teamState),
                    );
                  },
                  childCount: members.length,
                ),
              ),

        const SliverToBoxAdapter(child: SizedBox(height: 30)),
      ],
    );
  }

  // ── Requests Tab View ─────────────────────────────────────────────────
  Widget _buildRequestsTab(List<ConnectionRequest> requests) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        if (requests.isEmpty)
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: 44,
                  color: Color(0xFF10B981),
                ),
                SizedBox(height: 12),
                Text(
                  'All caught up!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'No pending connection requests right now.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
              ],
            ),
          )
        else
          ...requests.map(
            (r) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFFE8F4FB),
                    child: Text(
                      r.initials,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF229ED9),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                r.name,
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            Text(
                              r.time,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          r.role,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        if (r.note.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            r.note,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF475569),
                              height: 1.4,
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => ref
                                    .read(requestsViewModelProvider.notifier)
                                    .ignore(r.name),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFFE2E8F0),
                                  ),
                                  foregroundColor: const Color(0xFF64748B),
                                  minimumSize: const Size(0, 36),
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Ignore'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => ref
                                    .read(requestsViewModelProvider.notifier)
                                    .accept(r.name),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF229ED9),
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(0, 36),
                                  padding: EdgeInsets.zero,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Accept'),
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
      ],
    );
  }

  // ── Online Avatar pill ─────────────────────────────────────────────────────
  Widget _onlineAvatar(TeamMember member) {
    return GestureDetector(
      onTap: () => _openChat(member),
      child: Container(
        margin: const EdgeInsets.only(right: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor:
                      StartupColorHelper.fromKey(member.badgeColorKey)
                          .withValues(alpha: 0.15),
                  child: Text(
                    member.initials,
                    style: TextStyle(
                      color: StartupColorHelper.fromKey(member.badgeColorKey),
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                ),
                Positioned(
                  right: 1,
                  bottom: 1,
                  child: Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              member.name.split(' ').first,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Conversation tile ──────────────────────────────────────────────────────
  Widget _conversationTile(TeamMember member, TeamState teamState) {
    final msgs = teamState.chatMessages[member.name];
    final lastMsg = (msgs != null && msgs.isNotEmpty) ? msgs.last : null;
    final unread = teamState.unreadCountFor(member.name);
    final isOnline = _onlineMembers.contains(member.name);
    final isTyping = teamState.isTypingFor(member.name);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _openChat(member),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Avatar with online dot
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor:
                          StartupColorHelper.fromKey(member.badgeColorKey)
                              .withValues(alpha: 0.15),
                      child: Text(
                        member.initials,
                        style: TextStyle(
                          color:
                              StartupColorHelper.fromKey(member.badgeColorKey),
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (isOnline)
                      Positioned(
                        right: 1,
                        bottom: 1,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),

                // Name + last message
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              member.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: unread > 0
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: const Color(0xFF12233D),
                              ),
                            ),
                          ),
                          Text(
                            lastMsg?.time ?? '',
                            style: TextStyle(
                              fontSize: 11,
                              color: unread > 0
                                  ? const Color(0xFF0088CC)
                                  : const Color(0xFF9CA3AF),
                              fontWeight: unread > 0
                                  ? FontWeight.w700
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: isTyping
                                ? Row(
                                    children: [
                                      const Text(
                                        'typing',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF0088CC),
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      _TypingDots(),
                                    ],
                                  )
                                : Text(
                                    lastMsg != null
                                        ? '${lastMsg.isMe ? "You: " : ""}${lastMsg.text}'
                                        : 'Start a conversation',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: unread > 0
                                          ? const Color(0xFF374151)
                                          : const Color(0xFF9CA3AF),
                                      fontWeight: unread > 0
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                          ),
                          if (unread > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0088CC),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$unread',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          if (lastMsg != null && lastMsg.isMe && unread == 0)
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Icon(
                                lastMsg.status == MessageStatus.seen
                                    ? Icons.done_all_rounded
                                    : Icons.done_rounded,
                                size: 14,
                                color: lastMsg.status == MessageStatus.seen
                                    ? const Color(0xFF0088CC)
                                    : const Color(0xFF9CA3AF),
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
      ),
    );
  }
}

// ── Animated typing dots ────────────────────────────────────────────────────
class _TypingDots extends StatefulWidget {
  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i * 0.3;
            final opacity = ((_ctrl.value - delay) % 1.0).clamp(0.0, 1.0);
            final bounce = opacity < 0.5 ? opacity : 1.0 - opacity;
            return Transform.translate(
              offset: Offset(0, -3 * bounce),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: Color(0xFF0088CC),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
