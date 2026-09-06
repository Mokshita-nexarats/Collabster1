import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import '../../model/chat_model.dart';
import '../../model/community_model.dart';
import '../../model/post_model.dart';
import 'chat_screen.dart';
import 'create_room_screen.dart';
import 'post_detail_screen.dart';
import 'posts_list_screen.dart';
import 'rooms_list_screen.dart';

class CommunityDetailScreen extends ConsumerStatefulWidget {
  final String title;
  final String memberCount;
  final String tag;
  final IconData icon;
  final List<Color> gradientColors;
  final String? communityId;
  final bool? isJoined;
  final VoidCallback? onToggleJoin;

  const CommunityDetailScreen({
    super.key,
    required this.title,
    this.memberCount = '',
    this.tag = '',
    this.icon = Icons.people_rounded,
    this.gradientColors = const [Color(0xFF2563EB), Color(0xFF3B82F6)],
    this.communityId,
    this.isJoined,
    this.onToggleJoin,
  });

  @override
  ConsumerState<CommunityDetailScreen> createState() =>
      _CommunityDetailScreenState();
}

class _Member {
  final String name;
  final String role;
  final bool online;
  final Color color;
  const _Member(this.name, this.role, this.online, this.color);
}

class _CommunityDetailScreenState
    extends ConsumerState<CommunityDetailScreen> {
  bool _muted = false;

  // ── Derived live join state ─────────────────────────────────────────────
  bool? _resolvedJoined() {
    final communityState = ref.watch(communityViewModelProvider);
    if (widget.communityId != null) {
      final id = widget.communityId;
      for (final c in communityState.myCommunities) {
        if (c.id == id) return c.isJoined;
      }
      for (final c in communityState.recommendedCommunities) {
        if (c.id == id) return c.isJoined;
      }
    }
    return widget.isJoined;
  }

  VoidCallback? _liveToggle() {
    final id = widget.communityId;
    if (id != null) {
      final communityState = ref.read(communityViewModelProvider);
      if (communityState.myCommunities.any((c) => c.id == id)) {
        return () => ref
            .read(communityViewModelProvider.notifier)
            .toggleJoinMyCommunity(id);
      }
      if (communityState.recommendedCommunities.any((c) => c.id == id)) {
        return () => ref
            .read(communityViewModelProvider.notifier)
            .toggleJoinRecommended(id);
      }
    }
    return widget.onToggleJoin;
  }

  List<CommunityRoom> _rooms() {
    final rooms = ref.watch(communityViewModelProvider).rooms;
    return rooms.where((room) {
      return widget.communityId != null
          ? room.communityId == widget.communityId
          : room.communityTitle == widget.title;
    }).toList();
  }

  // Deterministic member roster so every group feels alive.
  List<_Member> _members() {
    const pool = [
      _Member('Sarah Chen', 'Admin', true, Color(0xFF0088CC)),
      _Member('Rahul Verma', 'Moderator', true, Color(0xFF7C3AED)),
      _Member('Ananya Rao', 'Moderator', false, Color(0xFF059669)),
      _Member('Mike Johnson', 'Member', true, Color(0xFF229ED9)),
      _Member('Sarah Lee', 'Member', true, Color(0xFFDB2777)),
      _Member('Arjun Mehta', 'Member', false, Color(0xFF2563EB)),
      _Member('Priya Nair', 'Member', true, Color(0xFF0D9488)),
      _Member('Karthik S', 'Member', false, Color(0xFFB45309)),
    ];
    final hash = widget.title.hashCode.abs();
    return List.generate(
        8, (i) => pool[(hash + i) % pool.length]);
  }

  String get _inviteLink {
    final slug = widget.title
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
    return 'collabster.app/g/$slug';
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  void _openRoom(CommunityRoom room) {
    final conversations = ref.read(messageViewModelProvider).conversations;
    Conversation? match;
    for (final c in conversations) {
      if (c.name.toLowerCase().contains(room.name.toLowerCase()) ||
          room.name.toLowerCase().contains(c.name.toLowerCase().split('·').first.trim())) {
        match = c;
        break;
      }
    }
    if (match != null) {
      ref.read(messageViewModelProvider.notifier).markRead(match.id);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ChatScreen(conversationId: match!.id)),
      );
    } else if (!room.isJoined) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Join "${room.name}" to start chatting'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Join',
            onPressed: () => ref
                .read(communityViewModelProvider.notifier)
                .toggleJoinRoom(room.id),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${room.name}" chat opens from the Chats tab'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _openMember(_Member m) {
    final conversations = ref.read(messageViewModelProvider).conversations;
    Conversation? dm;
    for (final c in conversations) {
      if (!c.isRoom &&
          (c.name.toLowerCase().contains(m.name.split(' ').first.toLowerCase()) ||
              m.name.toLowerCase().contains(c.name.toLowerCase().split(' ').first))) {
        dm = c;
        break;
      }
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3E6EA),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 14),
              CircleAvatar(
                radius: 30,
                backgroundColor: m.color.withValues(alpha: 0.12),
                child: Text(
                  m.name[0].toUpperCase(),
                  style: TextStyle(
                      color: m.color,
                      fontSize: 26,
                      fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 10),
              Text(m.name,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w800)),
              Text(m.role,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: m.online
                          ? const Color(0xFF16A34A)
                          : const Color(0xFFCBD5E1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(m.online ? 'Online' : 'Offline',
                      style: const TextStyle(
                          fontSize: 12.5, color: Color(0xFF64748B))),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${m.name} is in "${widget.title}"'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF334155),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('View activity'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        if (dm != null) {
                          ref
                              .read(messageViewModelProvider.notifier)
                              .markRead(dm.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    ChatScreen(conversationId: dm!.id)),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Start a chat with ${m.name} from the Chats tab'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0088CC),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Message'),
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

  void _showAllMembers(List<_Member> members) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (_, controller) => Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE3E6EA),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Row(
                children: [
                  Text('Members · ${members.length * 312}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w800)),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            Expanded(
              child: ListView.separated(
                controller: controller,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: members.length,
                separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    color: Color(0xFFF1F5F9),
                    indent: 72),
                itemBuilder: (_, i) {
                  final m = members[i];
                  return ListTile(
                    leading: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor:
                              m.color.withValues(alpha: 0.12),
                          child: Text(m.name[0].toUpperCase(),
                              style: TextStyle(
                                  color: m.color,
                                  fontWeight: FontWeight.w800)),
                        ),
                        if (m.online)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: const Color(0xFF16A34A),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text(m.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                    subtitle: Text(m.role,
                        style: const TextStyle(
                            fontSize: 12.5, color: Color(0xFF64748B))),
                    trailing: Text(
                        m.online ? 'online' : 'offline',
                        style: TextStyle(
                            fontSize: 12,
                            color: m.online
                                ? const Color(0xFF16A34A)
                                : const Color(0xFF94A3B8))),
                    onTap: () {
                      Navigator.pop(ctx);
                      _openMember(m);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rooms = _rooms();
    final joined = _resolvedJoined();
    final toggle = _liveToggle();
    final canJoin = joined != null && toggle != null;
    final joinedValue = joined ?? false;
    final members = _members();
    final admins = members.take(3).toList();
    final onlineCount = members.where((m) => m.online).length;
    final posts = ref.watch(postViewModelProvider).posts;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.gradientColors.length >= 2
                      ? [
                          widget.gradientColors.first,
                          widget.gradientColors.last
                        ]
                      : [
                          widget.gradientColors.first,
                          widget.gradientColors.first
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => _shareInvite(),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(19),
                              ),
                              child: const Icon(
                                Icons.share_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _showMoreSheet(
                                context, ref, joined, toggle),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(19),
                              ),
                              child: const Icon(
                                Icons.more_horiz_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.6),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.icon,
                          color: widget.gradientColors.first,
                          size: 38,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        [
                          if (widget.memberCount.isNotEmpty)
                            widget.memberCount,
                          if (widget.tag.isNotEmpty) widget.tag,
                        ].join(' • '),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF4ADE80),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$onlineCount admins online now',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color:
                                  Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (canJoin)
                        GestureDetector(
                          onTap: toggle,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 34,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: joinedValue
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              border: joinedValue
                                  ? Border.all(
                                      color: Colors.white
                                          .withValues(alpha: 0.6),
                                      width: 1.4)
                                  : null,
                            ),
                            child: Text(
                              joinedValue ? 'Joined ✓' : 'Join Channel',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _headerAction(
                              Icons.chat_bubble_outline_rounded,
                              'Chat', () {
                            final conversations = ref
                                .read(messageViewModelProvider)
                                .conversations;
                            final match = conversations.firstWhere(
                              (c) => c.name
                                  .toLowerCase()
                                  .contains(widget.title
                                      .split(' ')
                                      .first
                                      .toLowerCase()),
                              orElse: () => conversations.first,
                            );
                            ref
                                .read(messageViewModelProvider.notifier)
                                .markRead(match.id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ChatScreen(
                                      conversationId: match.id)),
                            );
                          }),
                          const SizedBox(width: 12),
                          _headerAction(
                              _muted
                                  ? Icons.notifications_off_rounded
                                  : Icons.notifications_none_rounded,
                              _muted ? 'Muted' : 'Mute', () {
                            setState(() => _muted = !_muted);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(_muted
                                    ? 'Notifications muted for "${widget.title}"'
                                    : 'Notifications unmuted'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }),
                          const SizedBox(width: 12),
                          _headerAction(Icons.person_add_outlined,
                              'Invite', _shareInvite),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildStatsRow(rooms.length, posts.length),
                const SizedBox(height: 20),
                _buildSectionTitle('About', null),
                const SizedBox(height: 12),
                _buildAboutCard(members.length),
                const SizedBox(height: 20),
                _buildSectionTitle('Admins & moderators', null),
                const SizedBox(height: 12),
                _buildAdminsCard(admins),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: _buildSectionTitle(
                            'Members · ${_extractNumber(widget.memberCount).isEmpty ? '${members.length * 312}' : _extractNumber(widget.memberCount)}',
                            null)),
                    GestureDetector(
                      onTap: () => _showAllMembers(members),
                      child: const Row(
                        children: [
                          Text('See all',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0088CC))),
                          Icon(Icons.chevron_right_rounded,
                              size: 18, color: Color(0xFF0088CC)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildMembersStrip(members),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(
                        child: Text('Rooms',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E293B),
                                letterSpacing: -0.3))),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RoomsListScreen()),
                      ),
                      child: const Row(
                        children: [
                          Text('See all',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0088CC))),
                          Icon(Icons.chevron_right_rounded,
                              size: 18, color: Color(0xFF0088CC)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (rooms.isEmpty)
                  _buildNoRooms(context)
                else
                  _buildRoomsCard(rooms, ref),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(
                        child: Text('Pinned discussions',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E293B),
                                letterSpacing: -0.3))),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PostsListScreen()),
                      ),
                      child: const Row(
                        children: [
                          Text('See all',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0088CC))),
                          Icon(Icons.chevron_right_rounded,
                              size: 18, color: Color(0xFF0088CC)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (posts.isEmpty)
                  _buildEmptyMini('No discussions yet — be the first to post.')
                else
                  ...posts
                      .take(2)
                      .map((p) => Padding(
                            padding:
                                const EdgeInsets.only(bottom: 10),
                            child: _buildPostCard(p),
                          )),
                const SizedBox(height: 10),
                _buildSectionTitle('Invite', null),
                const SizedBox(height: 12),
                _buildInviteCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(int roomCount, int postCount) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _stat(
            Icons.people_outline_rounded,
            widget.memberCount.isNotEmpty
                ? _extractNumber(widget.memberCount)
                : '—',
            'Members',
            widget.gradientColors.first,
          ),
          _divider(),
          _stat(
            Icons.forum_outlined,
            '$roomCount',
            'Rooms',
            widget.gradientColors.first,
          ),
          _divider(),
          _stat(Icons.article_outlined, '$postCount', 'Posts',
              widget.gradientColors.first),
        ],
      ),
    );
  }

  String _extractNumber(String input) {
    final match = RegExp(r'(\d+(?:\.\d+)?[Kk]?)').firstMatch(input);
    return match?.group(1) ?? input;
  }

  Widget _stat(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 34, color: const Color(0xFFE2E8F0));
  }

  Widget _buildSectionTitle(String title, VoidCallback? onSeeAll) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
              letterSpacing: -0.3,
            ),
          ),
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: const Row(
              children: [
                Text('See all',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0088CC))),
                Icon(Icons.chevron_right_rounded,
                    size: 18, color: Color(0xFF0088CC)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _card(Widget child) {
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
      child: child,
    );
  }

  // ── About (expanded) ────────────────────────────────────────────────────
  Widget _buildAboutCard(int memberSeed) {
    final info = [
      _infoRow(Icons.tag_rounded, 'Category',
          widget.tag.isNotEmpty ? widget.tag : 'General'),
      _infoRow(Icons.lock_open_rounded, 'Type', 'Public group · anyone can join'),
      _infoRow(Icons.calendar_month_outlined, 'Created', 'January 2024'),
      _infoRow(Icons.language_rounded, 'Language', 'English'),
    ];
    const rules = [
      'Be kind and stay on topic.',
      'No spam, promotions or job posts outside rooms.',
      'Share knowledge — help others grow.',
    ];
    return _card(
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'A community for people passionate about ${widget.title}. Join discussions, share updates, connect with like-minded members.',
              style: const TextStyle(
                fontSize: 13.5,
                color: Color(0xFF475569),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 8),
            ...info,
            const SizedBox(height: 8),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 10),
            const Text('Group rules',
                style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B))),
            const SizedBox(height: 8),
            for (int i = 0; i < rules.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: widget.gradientColors.first
                            .withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text('${i + 1}',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: widget.gradientColors.first)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(rules[i],
                          style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF475569),
                              height: 1.45)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: const Color(0xFF475569)),
          ),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(
                  fontSize: 12.5, color: Color(0xFF94A3B8))),
          const Spacer(),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B))),
          ),
        ],
      ),
    );
  }

  // ── Admins ──────────────────────────────────────────────────────────────
  Widget _buildAdminsCard(List<_Member> admins) {
    return _card(
      Column(
        children: [
          for (int i = 0; i < admins.length; i++) ...[
            ListTile(
              leading: CircleAvatar(
                radius: 21,
                backgroundColor:
                    admins[i].color.withValues(alpha: 0.12),
                child: Text(admins[i].name[0].toUpperCase(),
                    style: TextStyle(
                        color: admins[i].color,
                        fontWeight: FontWeight.w800)),
              ),
              title: Text(admins[i].name,
                  style: const TextStyle(
                      fontSize: 14.5, fontWeight: FontWeight.w700)),
              subtitle: Text(admins[i].role,
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF64748B))),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (admins[i].online)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text('online',
                          style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF16A34A))),
                    )
                  else
                    const Text('offline',
                        style: TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF94A3B8))),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right_rounded,
                      color: Color(0xFFCBD5E1)),
                ],
              ),
              onTap: () => _openMember(admins[i]),
            ),
            if (i != admins.length - 1)
              const Divider(
                  height: 1,
                  color: Color(0xFFF1F5F9),
                  indent: 70,
                  endIndent: 16),
          ],
        ],
      ),
    );
  }

  // ── Members strip ───────────────────────────────────────────────────────
  Widget _buildMembersStrip(List<_Member> members) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: members.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) {
          final m = members[i];
          return GestureDetector(
            onTap: () => _openMember(m),
            child: SizedBox(
              width: 62,
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor:
                            m.color.withValues(alpha: 0.12),
                        child: Text(m.name[0].toUpperCase(),
                            style: TextStyle(
                                color: m.color,
                                fontSize: 20,
                                fontWeight: FontWeight.w800)),
                      ),
                      if (m.online)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: const Color(0xFF16A34A),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white, width: 2.5),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(m.name.split(' ').first,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155))),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Rooms ───────────────────────────────────────────────────────────────
  Widget _buildRoomsCard(List<CommunityRoom> rooms, WidgetRef ref) {
    return _card(
      Column(
        children: rooms.asMap().entries.map((entry) {
          final idx = entry.key;
          final room = entry.value;
          final isLast = idx == rooms.length - 1;

          return Column(
            children: [
              InkWell(
                onTap: () => _openRoom(room),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.forum_outlined,
                          color: Color(0xFF7C3AED),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              room.name,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${room.memberCount} · tap to open chat',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => ref
                            .read(communityViewModelProvider.notifier)
                            .toggleJoinRoom(room.id),
                        child: AnimatedContainer(
                          duration:
                              const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: room.isJoined
                                ? const Color(0xFF7C3AED)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF7C3AED),
                              width: 1.4,
                            ),
                          ),
                          child: Text(
                            room.isJoined ? 'Joined' : 'Join',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: room.isJoined
                                  ? Colors.white
                                  : const Color(0xFF7C3AED),
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

  Widget _buildNoRooms(BuildContext context) {
    return _card(
      Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.forum_outlined,
                color: Color(0xFF7C3AED),
                size: 26,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'No rooms yet',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Create the first topic room for "${widget.title}"',
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const CreateRoomScreen()),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 9),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0088CC), Color(0xFF229ED9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Create Room',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Discussions ─────────────────────────────────────────────────────────
  Widget _buildPostCard(CareerPost post) {
    return _card(
      InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => PostDetailScreen(post: post)),
        ),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: widget.gradientColors.first
                        .withValues(alpha: 0.12),
                    child: Text(
                      post.authorName.isNotEmpty
                          ? post.authorName[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                          color: widget.gradientColors.first,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(post.authorName,
                            style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700)),
                        Text(
                            '${post.authorRole} · ${_timeAgo(post.createdAt)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F4FB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('Pinned',
                        style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF229ED9))),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(post.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B))),
              const SizedBox(height: 4),
              Text(post.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF475569),
                      height: 1.5)),
              const SizedBox(height: 10),
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
                            size: 17,
                            color: post.isLiked
                                ? const Color(0xFF0088CC)
                                : const Color(0xFF94A3B8)),
                        const SizedBox(width: 4),
                        Text('${post.likes}',
                            style: const TextStyle(
                                fontSize: 12.5,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              PostDetailScreen(post: post)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 17,
                            color: Color(0xFF94A3B8)),
                        const SizedBox(width: 4),
                        Text('${post.comments}',
                            style: const TextStyle(
                                fontSize: 12.5,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 13, color: Color(0xFFCBD5E1)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyMini(String text) {
    return _card(
      Padding(
        padding: const EdgeInsets.all(18),
        child: Center(
          child: Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF64748B))),
        ),
      ),
    );
  }

  // ── Invite ──────────────────────────────────────────────────────────────
  Widget _buildInviteCard() {
    return _card(
      Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color:
                    const Color(0xFF0088CC).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.link_rounded,
                  color: Color(0xFF0088CC)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Invite link',
                      style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(_inviteLink,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF0088CC))),
                ],
              ),
            ),
            GestureDetector(
              onTap: _shareInvite,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFF0088CC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text('Copy',
                    style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareInvite() {
    Clipboard.setData(ClipboardData(
        text: 'Join "${widget.title}" on Collabster! $_inviteLink'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invite link copied to clipboard'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showMoreSheet(BuildContext context, WidgetRef ref, bool? joined,
      VoidCallback? onToggle) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE3E6EA),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.share_outlined,
                  color: Color(0xFF0088CC)),
              title: const Text('Share invite link'),
              onTap: () {
                Navigator.pop(ctx);
                _shareInvite();
              },
            ),
            ListTile(
              leading: Icon(
                  _muted
                      ? Icons.notifications_off_outlined
                      : Icons.notifications_none_rounded,
                  color: const Color(0xFF0088CC)),
              title: Text(_muted ? 'Unmute notifications' : 'Mute notifications'),
              onTap: () {
                Navigator.pop(ctx);
                setState(() => _muted = !_muted);
              },
            ),
            if (onToggle != null)
              ListTile(
                leading: Icon(
                    joined == true
                        ? Icons.logout_rounded
                        : Icons.group_add_outlined,
                    color: joined == true
                        ? Colors.redAccent
                        : const Color(0xFF0088CC)),
                title: Text(
                  joined == true ? 'Leave channel' : 'Join channel',
                  style: TextStyle(
                      color: joined == true
                          ? Colors.redAccent
                          : const Color(0xFF111111)),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  onToggle();
                },
              ),
            ListTile(
              leading:
                  const Icon(Icons.flag_outlined, color: Colors.grey),
              title: const Text('Report'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Thanks — our team will review this.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
