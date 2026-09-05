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
import '../../model/chat_model.dart';
import '../../model/community_model.dart';
import '../../model/post_model.dart';
import 'chat_screen.dart';
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
import '../widgets/activity_navigation.dart';
import '../widgets/community_search_bar.dart';

// ── Telegram palette ──────────────────────────────────────────────────────
const _tgBlue = Color(0xFF229ED9);
const _tgDarkBlue = Color(0xFF0088CC);
const _tgLightBlue = Color(0xFFE8F4FB);
const _tgBg = Color(0xFFFFFFFF);
const _tgSearchBg = Color(0xFFF1F3F5);
const _tgDivider = Color(0xFFEEF1F4);
const _tgText = Color(0xFF111111);
const _tgSub = Color(0xFF707579);
const _tgOnline = Color(0xFF4CCD5E);
const _tgMuted = Color(0xFFA8ADB3);

class CommunityHomeScreen extends ConsumerStatefulWidget {
  const CommunityHomeScreen({super.key});

  @override
  ConsumerState<CommunityHomeScreen> createState() =>
      _CommunityHomeScreenState();
}

class _CommunityHomeScreenState extends ConsumerState<CommunityHomeScreen> {
  // _activeTab: 0 = Home (updates feed), 1 = Groups, 2 = Chats (dialogs)
  int _activeTab = 0;
  // bottom highlight index: 0,1,(2 fab),3,4
  int _bottomIndex = 0;
  final TextEditingController _chatSearchController = TextEditingController();
  final TextEditingController _groupSearchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _chatFolder = 'All';
  String _chatQuery = '';
  final Set<String> _pinnedIds = {};
  final Set<String> _mutedIds = {};

  static const _folders = ['All', 'Unread', 'Groups', 'Rooms', 'Contacts'];

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
    _chatSearchController.dispose();
    _groupSearchController.dispose();
    super.dispose();
  }

  // ── Bottom nav ──────────────────────────────────────────────────────────
  void _onBottomNavTap(int index) {
    if (index == 2) {
      _showCreateOptionsSheet();
      return;
    }
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
      return;
    }
    setState(() {
      _bottomIndex = index;
      if (index == 0) _activeTab = 0;
      if (index == 1) _activeTab = 1;
      if (index == 3) _activeTab = 2;
    });
  }

  void _goToChats() => setState(() {
        _activeTab = 2;
        _bottomIndex = 3;
      });

  // ── Navigation helpers (every tile wired) ───────────────────────────────
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

  void _openCreateRoomScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateRoomScreen()),
    );
  }

  void _openNotificationsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
    );
  }

  void _openJobsBoard() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const JobsScreen()),
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

  void _openChat(Conversation c) {
    ref.read(messageViewModelProvider.notifier).markRead(c.id);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChatScreen(conversationId: c.id)),
    );
  }

  void _openCommunityDetail(MyCommunityItem c) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CommunityDetailScreen(
          title: c.title,
          memberCount: c.memberCount,
          tag: c.activeTodayCount,
          icon: c.logoIcon,
          gradientColors: c.gradientColors,
          communityId: c.id,
          isJoined: c.isJoined,
          onToggleJoin: () => ref
              .read(communityViewModelProvider.notifier)
              .toggleJoinMyCommunity(c.id),
        ),
      ),
    );
  }

  // ── Create sheet (Telegram "New ..." style) ─────────────────────────────
  void _showCreateOptionsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 24),
        child: SafeArea(
          top: false,
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
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'New',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: _tgText,
                    ),
                  ),
                ),
              ),
              _createTile(ctx, Icons.edit_outlined, 'New Post',
                  'Share an update with your communities', _tgBlue, () {
                Navigator.pop(ctx);
                _openCreatePostScreen();
              }),
              _createTile(ctx, Icons.event_outlined, 'New Event',
                  'Host a meetup, workshop or webinar', const Color(0xFF4CCD5E),
                  () {
                Navigator.pop(ctx);
                _openCreateEventScreen();
              }),
              _createTile(ctx, Icons.group_add_outlined, 'New Community',
                  'Start a public channel or group', _tgDarkBlue, () {
                Navigator.pop(ctx);
                _openCreateCommunityScreen();
              }),
              _createTile(ctx, Icons.forum_outlined, 'New Room',
                  'Open a topic room inside a community',
                  const Color(0xFF7C3AED), () {
                Navigator.pop(ctx);
                _openCreateRoomScreen();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createTile(BuildContext ctx, IconData icon, String title,
      String subtitle, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(title,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w600, color: _tgText)),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 13, color: _tgSub)),
      trailing: const Icon(Icons.chevron_right_rounded, color: _tgMuted),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  // ── Compose (Telegram pencil) ───────────────────────────────────────────
  void _showComposeSheet() {
    final conversations = ref.read(messageViewModelProvider).conversations;
    final contacts = conversations.where((c) => !c.isRoom).toList();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3E6EA),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text('New message',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: _tgText)),
              const SizedBox(height: 4),
              const Text('Choose a member to start chatting',
                  style: TextStyle(fontSize: 13, color: _tgSub)),
              const SizedBox(height: 12),
              for (final c in contacts)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: _avatar(c.name, _tgDarkBlue, 44, online: c.isOnline),
                  title: Text(c.name,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  subtitle: Text(
                      c.lastMessage?.text ?? 'Start a conversation',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 13, color: _tgSub)),
                  trailing: const Icon(Icons.chevron_right_rounded,
                      color: _tgMuted),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _openChat(c);
                  },
                ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    _showCreateOptionsSheet();
                  },
                  icon: const Icon(Icons.group_add_outlined, size: 18),
                  label: const Text('Or create a community / room'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _tgDarkBlue,
                    side: const BorderSide(color: _tgBlue),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Dialog long-press actions ───────────────────────────────────────────
  void _showDialogActions(_DialogData d) {
    final pinned = _pinnedIds.contains(d.id);
    final muted = _mutedIds.contains(d.id);
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
              leading: _avatar(d.title, d.color, 44),
              title: Text(d.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(d.preview,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _tgSub, fontSize: 13)),
            ),
            const Divider(height: 1, color: _tgDivider),
            _actionRow(ctx, pinned ? Icons.push_pin_outlined : Icons.push_pin,
                pinned ? 'Unpin' : 'Pin', () {
              Navigator.pop(ctx);
              setState(() {
                if (pinned) {
                  _pinnedIds.remove(d.id);
                } else {
                  _pinnedIds.add(d.id);
                }
              });
            }),
            _actionRow(
                ctx,
                muted
                    ? Icons.notifications_outlined
                    : Icons.notifications_off_outlined,
                muted ? 'Unmute' : 'Mute', () {
              Navigator.pop(ctx);
              setState(() {
                if (muted) {
                  _mutedIds.remove(d.id);
                } else {
                  _mutedIds.add(d.id);
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(muted ? 'Unmuted ${d.title}' : 'Muted ${d.title}'),
                behavior: SnackBarBehavior.floating,
              ));
            }),
            _actionRow(ctx, Icons.mark_chat_read_outlined, 'Mark as read', () {
              Navigator.pop(ctx);
              if (d.conversation != null) {
                ref
                    .read(messageViewModelProvider.notifier)
                    .markRead(d.conversation!.id);
              }
              if (d.isCommunityChannel) {
                ref
                    .read(communityViewModelProvider.notifier)
                    .markCommunitiesAsRead();
              }
              setState(() {});
            }),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _actionRow(
      BuildContext ctx, IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: _tgDarkBlue),
      title: Text(label, style: const TextStyle(fontSize: 15)),
      onTap: onTap,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authViewModelProvider).session;
    final userName = session?.fullName ?? 'Member';
    final email = session?.email ?? '';

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _tgBg,
      drawer: _buildTelegramDrawer(userName, email),
      body: IndexedStack(
        index: _activeTab,
        children: [
          _buildUpdatesTab(userName),
          _buildGroupsTab(),
          _buildChatsTab(),
        ],
      ),
      floatingActionButton: _activeTab == 2
          ? FloatingActionButton(
              heroTag: 'tg_compose',
              backgroundColor: _tgBlue,
              elevation: 3,
              onPressed: _showComposeSheet,
              child: const Icon(Icons.edit_rounded,
                  color: Colors.white, size: 24),
            )
          : null,
      bottomNavigationBar: _TelegramBottomNav(
        selectedIndex: _bottomIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // TAB 2 — CHATS (Telegram dialogs)
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildChatsTab() {
    final messageState = ref.watch(messageViewModelProvider);
    final communityState = ref.watch(communityViewModelProvider);
    final onlineCount =
        messageState.conversations.where((c) => c.isOnline).length +
            communityState.myCommunities.length;

    final dialogs = _buildDialogs(
      conversations: messageState.conversations,
      whatsHappening: communityState.whatsHappening,
    );

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // Telegram header
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  icon: const Icon(Icons.menu_rounded,
                      color: _tgText, size: 24),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Community',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: _tgText)),
                      Text('$onlineCount members online',
                          style: const TextStyle(
                              fontSize: 12.5, color: _tgSub)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _openNotificationsScreen,
                  icon: Stack(
                    children: [
                      const Icon(Icons.notifications_none_rounded,
                          color: _tgText, size: 24),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _showComposeSheet,
                  icon: const Icon(Icons.edit_outlined,
                      color: _tgText, size: 22),
                ),
              ],
            ),
          ),
          // Telegram search (shared plain bar — no fixed height, can't overflow)
          CommunitySearchBar(
            controller: _chatSearchController,
            hintText: 'Search',
            showClear: _chatQuery.isNotEmpty,
            onChanged: (v) => setState(() => _chatQuery = v),
            onClear: () {
              _chatSearchController.clear();
              setState(() => _chatQuery = '');
            },
          ),
          // Stories / active communities
          _buildStoriesRow(),
          // Folder tabs (intrinsic height — never overflows)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                for (int i = 0; i < _folders.length; i++)
                  Padding(
                    padding: EdgeInsets.only(
                        right: i == _folders.length - 1 ? 0 : 8),
                    child: _folderChip(_folders[i], dialogs),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: dialogs.isEmpty
                ? _emptyChats()
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 90),
                    itemCount: dialogs.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      color: _tgDivider,
                      indent: 84,
                      endIndent: 0,
                    ),
                    itemBuilder: (_, i) => _dialogRow(dialogs[i]),
                  ),
          ),
        ],
      ),
    );
  }

  List<_DialogData> _buildDialogs({
    required List<Conversation> conversations,
    required List<WhatsHappeningItem> whatsHappening,
  }) {
    final q = _chatQuery.trim().toLowerCase();
    List<_DialogData> list = [];

    for (final c in conversations) {
      if (q.isNotEmpty &&
          !c.name.toLowerCase().contains(q) &&
          !(c.lastMessage?.text.toLowerCase().contains(q) ?? false)) {
        continue;
      }
      if (_chatFolder == 'Unread' && c.unreadCount == 0) continue;
      if (_chatFolder == 'Groups' && c.isRoom) continue;
      if (_chatFolder == 'Rooms' && !c.isRoom) continue;
      if (_chatFolder == 'Contacts' && c.isRoom) continue;
      if (_chatFolder == 'Groups' && !c.isRoom) {
        // Groups folder shows only group-type DMs? keep DMs out — skip
        continue;
      }
      list.add(_DialogData(
        id: c.id,
        title: c.name,
        preview: c.lastMessage?.text ?? c.subtitle,
        time: c.timeLabel,
        unread: c.unreadCount,
        isOnline: c.isOnline,
        isRoom: c.isRoom,
        isMine: c.lastMessage?.isMine ?? false,
        color: c.isRoom ? const Color(0xFF7C3AED) : _tgDarkBlue,
        icon: c.isRoom ? Icons.forum_rounded : Icons.person_rounded,
        conversation: c,
      ));
    }

    // Channels from What's Happening (Telegram channels section)
    if (_chatFolder == 'All' || _chatFolder == 'Groups') {
      for (final w in whatsHappening) {
        if (q.isNotEmpty &&
            !w.title.toLowerCase().contains(q) &&
            !w.subtitle.toLowerCase().contains(q)) {
          continue;
        }
        list.add(_DialogData(
          id: 'channel_${w.id}',
          title: w.title,
          preview: w.subtitle,
          time: 'now',
          unread: 0,
          isOnline: true,
          isRoom: false,
          isChannel: true,
          color: w.iconColor,
          icon: w.icon,
          whatsHappening: w,
        ));
      }
    }

    // Pinned first, then unread, then rest
    list.sort((a, b) {
      final ap = _pinnedIds.contains(a.id) ? 0 : 1;
      final bp = _pinnedIds.contains(b.id) ? 0 : 1;
      if (ap != bp) return ap.compareTo(bp);
      return b.unread.compareTo(a.unread);
    });
    return list;
  }

  Widget _folderChip(String f, List<_DialogData> dialogs) {
    final selected = f == _chatFolder;
    int count = 0;
    if (f == 'Unread') {
      count = dialogs.where((d) => d.unread > 0).length;
    }
    return GestureDetector(
      onTap: () => setState(() => _chatFolder = f),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? _tgBlue : _tgSearchBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(f,
                style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : _tgSub)),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : _tgBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('$count',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color:
                            selected ? _tgBlue : Colors.white)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStoriesRow() {
    final my = ref.watch(communityViewModelProvider).myCommunities;
    if (my.isEmpty) return const SizedBox.shrink();
    // Intrinsic height (no tight ListView constraint) — never overflows.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _showCreateOptionsSheet,
            child: const Column(
              children: [
                _StoryAddButton(),
                SizedBox(height: 4),
                Text('New',
                    style: TextStyle(fontSize: 11, color: _tgSub)),
              ],
            ),
          ),
          for (final c in my) ...[
            const SizedBox(width: 14),
            GestureDetector(
              onTap: () => _openCommunityDetail(c),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: _tgBlue, width: 2),
                    ),
                    child: _avatar(c.title, c.gradientColors.first, 54),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 60,
                    child: Text(c.title.split(' ').first,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 11, color: _tgText)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _emptyChats() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: const BoxDecoration(
                color: _tgLightBlue, shape: BoxShape.circle),
            child: const Icon(Icons.chat_bubble_outline_rounded,
                color: _tgBlue, size: 40),
          ),
          const SizedBox(height: 14),
          const Text('No chats found',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: _tgText)),
          const SizedBox(height: 4),
          const Text('Try another search or start a new chat',
              style: TextStyle(fontSize: 13.5, color: _tgSub)),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: _showComposeSheet,
            style: ElevatedButton.styleFrom(
              backgroundColor: _tgBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Start chatting'),
          ),
        ],
      ),
    );
  }

  Widget _dialogRow(_DialogData d) {
    final pinned = _pinnedIds.contains(d.id);
    final muted = _mutedIds.contains(d.id);
    return InkWell(
      onTap: () {
        if (d.conversation != null) {
          _openChat(d.conversation!);
        } else if (d.whatsHappening != null) {
          final w = d.whatsHappening!;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CommunityDetailScreen(
                title: w.title,
                memberCount: w.subtitle,
                tag: w.status,
                icon: w.icon,
                gradientColors: [w.iconColor, w.iconColor],
              ),
            ),
          );
        }
      },
      onLongPress: () => _showDialogActions(d),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _avatar(d.title, d.color, 56,
                    icon: d.isChannel ? d.icon : null,
                    online: false),
                if (d.isOnline && !d.isChannel)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: _tgOnline,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white, width: 2.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(d.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: _tgText)),
                            ),
                            if (muted) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                  Icons
                                      .notifications_off_outlined,
                                  size: 14,
                                  color: _tgMuted),
                            ],
                            if (pinned) ...[
                              const SizedBox(width: 4),
                              const Icon(Icons.push_pin,
                                  size: 14, color: _tgMuted),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(d.time,
                          style: TextStyle(
                              fontSize: 12,
                              color: d.unread > 0
                                  ? _tgBlue
                                  : _tgMuted)),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      if (d.isMine)
                        const Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Icon(Icons.done_all_rounded,
                              size: 16, color: _tgBlue),
                        ),
                      if (d.isRoom)
                        Container(
                          margin:
                              const EdgeInsets.only(right: 6),
                          padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDE9FE),
                            borderRadius:
                                BorderRadius.circular(5),
                          ),
                          child: const Text('GROUP',
                              style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF7C3AED))),
                        ),
                      if (d.isChannel)
                        Container(
                          margin:
                              const EdgeInsets.only(right: 6),
                          padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: _tgLightBlue,
                            borderRadius:
                                BorderRadius.circular(5),
                          ),
                          child: const Text('CHANNEL',
                              style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: _tgDarkBlue)),
                        ),
                      Expanded(
                        child: Text(d.preview,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                                color: d.unread > 0
                                    ? _tgText
                                    : _tgSub,
                                fontWeight: d.unread > 0
                                    ? FontWeight.w500
                                    : FontWeight.w400)),
                      ),
                      if (d.unread > 0)
                        Container(
                          margin:
                              const EdgeInsets.only(left: 8),
                          padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: muted
                                ? _tgMuted
                                : _tgBlue,
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                          child: Text('${d.unread}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700)),
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

  // ═══════════════════════════════════════════════════════════════════════
  // TAB 1 — GROUPS (Telegram channels list)
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildGroupsTab() {
    final communityState = ref.watch(communityViewModelProvider);
    final my = communityState.filteredMyCommunities;
    final rec = communityState.filteredRecommended;
    final happening = communityState.filteredWhatsHappening;
    final cats = communityState.categories;

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () =>
                        _scaffoldKey.currentState?.openDrawer(),
                    icon: const Icon(Icons.menu_rounded,
                        color: _tgText, size: 24),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Groups & Channels',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: _tgText)),
                        Text(
                            '${communityState.myCommunities.length} groups · ${communityState.recommendedCommunities.length} to explore',
                            style: const TextStyle(
                                fontSize: 12.5, color: _tgSub)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _openCreateCommunityScreen,
                    icon: const Icon(Icons.group_add_outlined,
                        color: _tgText, size: 22),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: CommunitySearchBar(
              controller: _groupSearchController,
              hintText: 'Search groups, channels...',
              showClear: _groupSearchController.text.isNotEmpty,
              onChanged: (v) {
                ref
                    .read(communityViewModelProvider.notifier)
                    .setSearchQuery(v);
                setState(() {});
              },
              onClear: () {
                _groupSearchController.clear();
                ref
                    .read(communityViewModelProvider.notifier)
                    .setSearchQuery('');
                setState(() {});
              },
            ),
          ),
          SliverToBoxAdapter(
            // Intrinsic height — never overflows at any font scale.
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  for (int i = 0; i < cats.length; i++)
                    Padding(
                      padding: EdgeInsets.only(
                          right: i == cats.length - 1 ? 0 : 8),
                      child: _categoryChip(cats[i],
                          cats[i].id == communityState.selectedCategoryId),
                    ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _tgSectionHeader('My groups', _openCommunitiesScreen,
                    count: my.length),
                const SizedBox(height: 8),
                if (my.isEmpty)
                  _tgEmptyBox('No groups match your search')
                else
                  _tgCard(children: [
                    for (int i = 0; i < my.length; i++) ...[
                      _groupChannelRow(
                        title: my[i].title,
                        subtitle:
                            '${my[i].memberCount} · ${my[i].activeTodayCount}',
                        color: my[i].gradientColors.first,
                        icon: my[i].logoIcon,
                        badge: 'GROUP',
                        isJoined: my[i].isJoined,
                        onTap: () => _openCommunityDetail(my[i]),
                        onJoin: () => ref
                            .read(communityViewModelProvider
                                .notifier)
                            .toggleJoinMyCommunity(my[i].id),
                      ),
                      if (i != my.length - 1)
                        const Divider(
                            height: 1,
                            color: _tgDivider,
                            indent: 68),
                    ],
                  ]),
                const SizedBox(height: 20),
                _tgSectionHeader(
                    'Recommended channels', _openRecommendedScreen,
                    count: rec.length),
                const SizedBox(height: 8),
                if (rec.isEmpty)
                  _tgEmptyBox('Nothing recommended right now')
                else
                  _tgCard(children: [
                    for (int i = 0; i < rec.length; i++) ...[
                      _groupChannelRow(
                        title: rec[i].title,
                        subtitle:
                            '${rec[i].memberCount} · ${rec[i].tag}',
                        color: rec[i].iconBgColor,
                        icon: rec[i].icon,
                        iconColor: rec[i].iconColor,
                        badge: 'CHANNEL',
                        isJoined: rec[i].isJoined,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CommunityDetailScreen(
                              title: rec[i].title,
                              memberCount: rec[i].memberCount,
                              tag: rec[i].tag,
                              icon: rec[i].icon,
                              gradientColors: const [
                                _tgDarkBlue,
                                _tgBlue
                              ],
                              communityId: rec[i].id,
                              isJoined: rec[i].isJoined,
                              onToggleJoin: () => ref
                                  .read(communityViewModelProvider
                                      .notifier)
                                  .toggleJoinRecommended(rec[i].id),
                            ),
                          ),
                        ),
                        onJoin: () => ref
                            .read(communityViewModelProvider
                                .notifier)
                            .toggleJoinRecommended(rec[i].id),
                      ),
                      if (i != rec.length - 1)
                        const Divider(
                            height: 1,
                            color: _tgDivider,
                            indent: 68),
                    ],
                  ]),
                const SizedBox(height: 20),
                _tgSectionHeader(
                    "What's happening", _openWhatsHappeningScreen),
                const SizedBox(height: 8),
                _tgCard(children: [
                  for (int i = 0; i < happening.length; i++) ...[
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 2),
                      leading: _avatar(happening[i].title,
                          happening[i].iconColor, 48,
                          icon: happening[i].icon),
                      title: Text(happening[i].title,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                      subtitle: Text(happening[i].subtitle,
                          style: const TextStyle(
                              fontSize: 13, color: _tgSub)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                                color: _tgOnline,
                                shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                              Icons.chevron_right_rounded,
                              color: _tgMuted),
                        ],
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CommunityDetailScreen(
                            title: happening[i].title,
                            memberCount: happening[i].subtitle,
                            tag: happening[i].status,
                            icon: happening[i].icon,
                            gradientColors: [
                              happening[i].iconColor,
                              happening[i].iconColor
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (i != happening.length - 1)
                      const Divider(
                          height: 1,
                          color: _tgDivider,
                          indent: 68),
                  ],
                ]),
                const SizedBox(height: 20),
                _tgSectionHeader('Quick access', null),
                const SizedBox(height: 8),
                _tgCard(children: [
                  _quickLink(Icons.article_outlined, 'Posts',
                      '${ref.watch(postViewModelProvider).posts.length} posts',
                      _openPostsScreen),
                  const Divider(
                      height: 1, color: _tgDivider, indent: 68),
                  _quickLink(Icons.event_outlined, 'Events',
                      'Upcoming meetups & workshops', _openEventsScreen),
                  const Divider(
                      height: 1, color: _tgDivider, indent: 68),
                  _quickLink(Icons.forum_outlined, 'Rooms',
                      '${ref.watch(communityViewModelProvider).rooms.length} topic rooms',
                      _openRoomsScreen),
                  const Divider(
                      height: 1, color: _tgDivider, indent: 68),
                  _quickLink(Icons.alt_route_rounded, 'Connect',
                      'Cross-mode feed — startup, career, events',
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ConnectScreen(
                              modeTheme: 'community')),
                    );
                  }),
                ]),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryChip(CommunityCategory cat, bool sel) {
    return GestureDetector(
      onTap: () => ref
          .read(communityViewModelProvider.notifier)
          .selectCategory(cat.id),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: sel ? _tgBlue : const Color(0xFFF1F3F5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(cat.icon,
                size: 15, color: sel ? Colors.white : _tgSub),
            const SizedBox(width: 6),
            Text(cat.label,
                style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: sel ? Colors.white : _tgText)),
          ],
        ),
      ),
    );
  }

  Widget _tgSectionHeader(String title, VoidCallback? onViewAll,
      {int? count}) {
    return Row(
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _tgDarkBlue)),
        if (count != null)
          Container(
            margin: const EdgeInsets.only(left: 8),
            padding: const EdgeInsets.symmetric(
                horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
                color: _tgLightBlue,
                borderRadius: BorderRadius.circular(10)),
            child: Text('$count',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _tgDarkBlue)),
          ),
        const Spacer(),
        if (onViewAll != null)
          GestureDetector(
            onTap: onViewAll,
            child: const Row(
              children: [
                Text('See all',
                    style: TextStyle(
                        fontSize: 13.5,
                        color: _tgSub,
                        fontWeight: FontWeight.w500)),
                Icon(Icons.chevron_right_rounded,
                    color: _tgMuted, size: 18),
              ],
            ),
          ),
      ],
    );
  }

  Widget _tgCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _tgDivider),
      ),
      child: Column(children: children),
    );
  }

  Widget _tgEmptyBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _tgDivider),
      ),
      child: Text(text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13.5, color: _tgSub)),
    );
  }

  Widget _groupChannelRow({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    Color iconColor = Colors.white,
    required String badge,
    required bool isJoined,
    required VoidCallback onTap,
    required VoidCallback onJoin,
  }) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: _avatar(title, color, 48, icon: icon),
      title: Row(
        children: [
          Flexible(
            child: Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: badge == 'GROUP'
                  ? const Color(0xFFEDE9FE)
                  : _tgLightBlue,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(badge,
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: badge == 'GROUP'
                        ? const Color(0xFF7C3AED)
                        : _tgDarkBlue)),
          ),
        ],
      ),
      subtitle: Text(subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13, color: _tgSub)),
      trailing: GestureDetector(
        onTap: onJoin,
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isJoined ? _tgBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _tgBlue, width: 1.2),
          ),
          child: Text(isJoined ? 'Joined' : 'Join',
              style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: isJoined ? Colors.white : _tgBlue)),
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _quickLink(
      IconData icon, String title, String sub, VoidCallback onTap) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      leading: Container(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(
            color: _tgLightBlue, shape: BoxShape.circle),
        child: Icon(icon, color: _tgDarkBlue, size: 20),
      ),
      title: Text(title,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w600)),
      subtitle:
          Text(sub, style: const TextStyle(fontSize: 13, color: _tgSub)),
      trailing: const Icon(Icons.chevron_right_rounded, color: _tgMuted),
      onTap: onTap,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // TAB 0 — HOME (updates feed)
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildUpdatesTab(String userName) {
    final first = userName.split(RegExp(r'\s+')).first;
    final activities = ref.watch(activityViewModelProvider).activities;

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () =>
                        _scaffoldKey.currentState?.openDrawer(),
                    icon: const Icon(Icons.menu_rounded,
                        color: _tgText, size: 24),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hi, $first',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: _tgText)),
                        const Text('Updates from your communities',
                            style: TextStyle(
                                fontSize: 12.5, color: _tgSub)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _openNotificationsScreen,
                    icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: _tgText,
                        size: 24),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _updatesStatsStrip(),
                const SizedBox(height: 16),
                _tgSectionHeader('Quick actions', null),
                const SizedBox(height: 8),
                _updatesQuickActions(),
                const SizedBox(height: 18),
                if (_startupUpdates().isNotEmpty) ...[
                  _tgSectionHeader(
                      'Startup updates', _openStartupFeed),
                  const SizedBox(height: 8),
                  for (final p in _startupUpdates().take(3))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _startupRow(p),
                    ),
                  const SizedBox(height: 10),
                ],
                _tgSectionHeader('Hiring now', _openJobsBoard),
                const SizedBox(height: 8),
                SizedBox(
                  height: 148,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _hiringNow().length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: 10),
                    itemBuilder: (_, i) =>
                        _hiringCard(_hiringNow()[i]),
                  ),
                ),
                const SizedBox(height: 18),
                _tgSectionHeader(
                    'Trending posts', _openTrendingPostsScreen),
                const SizedBox(height: 8),
                for (final post in _trendingPosts().take(3))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _postCard(post),
                  ),
                const SizedBox(height: 10),
                _tgSectionHeader(
                    'Recent activity', _openActivityScreen),
                const SizedBox(height: 8),
                for (final a in activities.take(4))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _activityRow(a),
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _updatesStatsStrip() {
    final c = ref.watch(communityViewModelProvider);
    final p = ref.watch(postViewModelProvider);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_tgDarkBlue, _tgBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem('${c.myCommunities.length}', 'Groups'),
          _vDiv(),
          _statItem('${p.posts.length}', 'Posts'),
          _vDiv(),
          _statItem('${c.rooms.length}', 'Rooms'),
          _vDiv(),
          _statItem(
              '${ref.watch(messageViewModelProvider).conversations.length}',
              'Chats'),
        ],
      ),
    );
  }

  Widget _statItem(String v, String l) {
    return Column(
      children: [
        Text(v,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800)),
        Text(l,
            style: const TextStyle(
                color: Colors.white70, fontSize: 11.5)),
      ],
    );
  }

  Widget _vDiv() =>
      Container(width: 1, height: 30, color: Colors.white24);

  Widget _updatesQuickActions() {
    final postState = ref.watch(postViewModelProvider);
    final eventState = ref.watch(eventViewModelProvider);
    final communityState = ref.watch(communityViewModelProvider);
    final items = [
      _QA(Icons.article_outlined, 'Posts', _tgBlue, _openPostsScreen,
          postState.unreadCount),
      _QA(Icons.event_outlined, 'Events', const Color(0xFF4CCD5E),
          _openEventsScreen, eventState.unreadCount),
      _QA(Icons.group_outlined, 'Groups', _tgDarkBlue,
          _openCommunitiesScreen, communityState.unreadCount),
      _QA(Icons.forum_outlined, 'Rooms', const Color(0xFF7C3AED),
          _openRoomsScreen, 0),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.4,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final a = items[i];
        return GestureDetector(
          onTap: a.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _tgDivider),
            ),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: a.color.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(a.icon,
                          color: a.color, size: 19),
                    ),
                    if (a.count > 0)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: a.color,
                              shape: BoxShape.circle),
                          child: Text('${a.count}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(a.label,
                      style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        );
      },
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

  List<CareerPost> _trendingPosts() {
    final posts = ref.watch(postViewModelProvider).posts;
    return [...posts]..sort((a, b) => b.likes.compareTo(a.likes));
  }

  Widget _startupRow(BridgePost post) {
    return InkWell(
      onTap: _openStartupFeed,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _tgDivider),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: _tgLightBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.rocket_launch_rounded,
                  color: _tgDarkBlue, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  Text('${post.sourceLabel} · ${post.authorRole}',
                      style: const TextStyle(
                          fontSize: 12, color: _tgSub)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: _tgMuted),
          ],
        ),
      ),
    );
  }

  Widget _hiringCard(BridgeOpportunity opp) {
    return GestureDetector(
      onTap: _openJobsBoard,
      child: Container(
        width: 230,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _tgDivider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                      color: _tgLightBlue,
                      shape: BoxShape.circle),
                  child: Icon(
                      opp.fromStartup
                          ? Icons.rocket_launch_rounded
                          : Icons.work_rounded,
                      color: _tgDarkBlue,
                      size: 16),
                ),
                const Spacer(),
                Text(opp.fromStartup ? 'STARTUP' : 'CAREER',
                    style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: _tgSub)),
              ],
            ),
            const SizedBox(height: 8),
            Text(opp.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w700)),
            Text('${opp.company} · ${opp.location}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 12, color: _tgSub)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: const Color(0xFFE9F9EF),
                  borderRadius: BorderRadius.circular(8)),
              child: Text(opp.salary,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF15803D))),
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  Widget _postCard(CareerPost post) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _tgDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _avatar(post.authorName, _tgBlue, 38),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.authorName,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700)),
                    Text(_timeAgo(post.createdAt),
                        style: const TextStyle(
                            fontSize: 11.5, color: _tgSub)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: _tgLightBlue,
                    borderRadius: BorderRadius.circular(10)),
                child: const Text('Post',
                    style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: _tgDarkBlue)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => PostDetailScreen(post: post)),
            ),
            child: Text(
                post.content.isNotEmpty
                    ? post.content
                    : post.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 14, color: _tgText, height: 1.5)),
          ),
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
                        size: 18,
                        color: post.isLiked
                            ? _tgBlue
                            : _tgSub),
                    const SizedBox(width: 4),
                    Text('${post.likes}',
                        style: TextStyle(
                            fontSize: 13,
                            color: post.isLiked
                                ? _tgBlue
                                : _tgSub,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          PostDetailScreen(post: post)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline_rounded,
                        size: 18, color: _tgSub),
                    const SizedBox(width: 4),
                    Text('${post.comments}',
                        style: const TextStyle(
                            fontSize: 13,
                            color: _tgSub,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: post.title));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12)),
                      content: const Text(
                          'Post link copied to clipboard'),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Icon(Icons.share_outlined,
                        size: 18, color: _tgSub),
                    SizedBox(width: 4),
                    Text('Share',
                        style: TextStyle(
                            fontSize: 13,
                            color: _tgSub,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _activityRow(dynamic activity) {
    return InkWell(
      onTap: () => openActivityItem(
        context,
        ref,
        activity,
        onOpenMessages: _goToChats,
      ),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _tgDivider),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (activity.color as Color)
                    .withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(activity.icon as IconData,
                  color: activity.color as Color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(activity.title as String,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  Text(activity.subtitle as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12.5, color: _tgSub)),
                ],
              ),
            ),
            Text(activity.timeAgo as String,
                style: const TextStyle(
                    fontSize: 11, color: _tgMuted)),
          ],
        ),
      ),
    );
  }

  // ── Telegram drawer ─────────────────────────────────────────────────────
  Widget _buildTelegramDrawer(String userName, String email) {
    final session = ref.watch(authViewModelProvider).session;
    final photoPath = session?.profilePhotoPath ?? '';
    final hasPhoto = photoPath.isNotEmpty && File(photoPath).existsSync();

    String initials(String name) {
      final parts =
          name.split(' ').where((p) => p.isNotEmpty).toList();
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      if (parts.isNotEmpty) return parts[0][0].toUpperCase();
      return 'C';
    }

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [_tgDarkBlue, _tgBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(20, 16, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      backgroundImage: hasPhoto
                          ? FileImage(File(photoPath))
                          : null,
                      child: hasPhoto
                          ? null
                          : Text(initials(userName),
                              style: const TextStyle(
                                  color: _tgDarkBlue,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800)),
                    ),
                    const SizedBox(height: 12),
                    Text(userName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700)),
                    if (email.isNotEmpty)
                      Text(email,
                          style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13)),
                    const SizedBox(height: 2),
                    const Text('online',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _drawerItem(Icons.group_outlined, 'New Community',
                    _openCreateCommunityScreen),
                _drawerItem(Icons.forum_outlined, 'New Room',
                    _openCreateRoomScreen),
                _drawerItem(Icons.person_outline_rounded,
                    'My Profile', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ProfileScreen()),
                  );
                }),
                _drawerItem(Icons.chat_bubble_outline_rounded,
                    'Saved Messages', () {
                  Navigator.pop(context);
                  _goToChats();
                }),
                _drawerItem(Icons.article_outlined, 'Posts',
                    () {
                  Navigator.pop(context);
                  _openPostsScreen();
                }),
                _drawerItem(Icons.event_outlined, 'Events', () {
                  Navigator.pop(context);
                  _openEventsScreen();
                }),
                _drawerItem(Icons.notifications_none_rounded,
                    'Notifications', () {
                  Navigator.pop(context);
                  _openNotificationsScreen();
                }),
                _drawerItem(Icons.alt_route_rounded, 'Connect',
                    () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ConnectScreen(
                            modeTheme: 'community')),
                  );
                }),
                _drawerItem(Icons.swap_horiz_rounded, 'Switch Tab',
                    () {
                  Navigator.pop(context);
                  RoleSwitcherSheet.show(context);
                }),
              ],
            ),
          ),
          const Divider(height: 1, color: _tgDivider),
          _drawerItem(Icons.logout_rounded, 'Log Out', () async {
            Navigator.pop(context);
            await ref.read(authViewModelProvider.notifier).logout();
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => const SignInScreen()),
            );
          }, danger: true),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String label, VoidCallback onTap,
      {bool danger = false}) {
    return ListTile(
      leading: Icon(icon,
          color: danger ? Colors.redAccent : _tgSub, size: 22),
      title: Text(label,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: danger ? Colors.redAccent : _tgText)),
      onTap: onTap,
      dense: true,
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────
Widget _avatar(String name, Color color, double size,
    {IconData? icon, bool online = false}) {
  String initial = '?';
  final t = name.trim();
  if (t.isNotEmpty) initial = t.characters.first.toUpperCase();
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [color, color.withValues(alpha: 0.75)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      shape: BoxShape.circle,
    ),
    child: Center(
      child: icon != null && size >= 44
          ? Icon(icon, color: Colors.white, size: size * 0.42)
          : Text(initial,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.38,
                  fontWeight: FontWeight.w700)),
    ),
  );
}

class _StoryAddButton extends StatelessWidget {
  const _StoryAddButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 59,
      height: 59,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: Colors.grey.shade300, width: 2, style: BorderStyle.solid),
      ),
      child: const Center(
        child: Icon(Icons.add_rounded, color: _tgBlue, size: 26),
      ),
    );
  }
}

class _DialogData {
  final String id;
  final String title;
  final String preview;
  final String time;
  final int unread;
  final bool isOnline;
  final bool isRoom;
  final bool isChannel;
  final bool isMine;
  final Color color;
  final IconData icon;
  final Conversation? conversation;
  final WhatsHappeningItem? whatsHappening;

  bool get isCommunityChannel => whatsHappening != null;

  const _DialogData({
    required this.id,
    required this.title,
    required this.preview,
    required this.time,
    required this.unread,
    required this.isOnline,
    required this.isRoom,
    required this.color,
    required this.icon,
    this.isChannel = false,
    this.isMine = false,
    this.conversation,
    this.whatsHappening,
  });
}

class _QA {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final int count;
  const _QA(this.icon, this.label, this.color, this.onTap, this.count);
}

// ── Telegram bottom nav (kept for mode parity, fixed wiring) ──────────────
class _TelegramBottomNav extends StatelessWidget {
  const _TelegramBottomNav({required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _tgDivider, width: 1)),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: 62,
        child: Row(
          children: [
            _item(0, Icons.home_outlined,
                Icons.home_rounded, 'Home'),
            _item(1, Icons.group_outlined, Icons.group_rounded, 'Groups'),
            _centerFab(),
            _item(3, Icons.chat_bubble_outline_rounded,
                Icons.chat_bubble_rounded, 'Chats'),
            _item(4, Icons.person_outline_rounded,
                Icons.person_rounded, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _item(
      int index, IconData icon, IconData activeIcon, String label) {
    final selected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(selected ? activeIcon : icon,
                color: selected ? _tgBlue : _tgMuted, size: 24),
            const SizedBox(height: 3),
            Text(label,
                style: TextStyle(
                    fontSize: 10.5,
                    fontWeight:
                        selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? _tgBlue : _tgMuted)),
          ],
        ),
      ),
    );
  }

  Widget _centerFab() {
    return Expanded(
      child: Center(
        child: GestureDetector(
          onTap: () => onTap(2),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_tgDarkBlue, _tgBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _tgBlue.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(Icons.add_rounded,
                color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}
