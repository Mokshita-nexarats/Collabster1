import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../auth/model/auth_session.dart';
import '../../../community/view/screens/chat_screen.dart';
import '../../../investor/model/cross_conversation_model.dart';
import '../../../investor/view/screens/cross_conversation_chat_screen.dart';
import '../../../startup/view/screens/startup_requests_screen.dart';
import '../../../startup/view/screens/team_chat_screen.dart';

/// One startup workspace the user can jump into from messages:
/// a created startup, a joined startup, or an idea-phase profile.
class StartupWorkspace {
  final String name;
  final String phase; // Created | Joined | Idea phase
  const StartupWorkspace(this.name, this.phase);
}

/// Workspaces from session phase fields. Pure — unit-tested.
List<StartupWorkspace> startupWorkspacesFor(AuthSession? session) {
  final out = <StartupWorkspace>[];
  final seen = <String>{};
  void add(String? name, String phase) {
    final n = name?.trim() ?? '';
    if (n.isEmpty || !seen.add(n.toLowerCase())) return;
    out.add(StartupWorkspace(n, phase));
  }

  add(session?.originalStartupName, 'Created');
  add(session?.joinedStartupName, 'Joined');
  for (final p in session?.ideaPhaseProfiles ?? const <Map<String, dynamic>>[]) {
    add(p['ideaName']?.toString(), 'Idea phase');
  }
  return out;
}

/// Role-filtered messages for the universal feed.
///
/// Chips (Investor / Startup / Community) only list roles the user owns.
/// Investor-only users see investor chats; multi-role users can switch.
/// The Startup tab adapts to the user's phase: created / joined / idea-phase.
class FeedMessagesScreen extends ConsumerStatefulWidget {
  const FeedMessagesScreen({super.key});

  @override
  ConsumerState<FeedMessagesScreen> createState() =>
      _FeedMessagesScreenState();
}

class _FeedMessagesScreenState extends ConsumerState<FeedMessagesScreen> {
  String _chip = 'Startup';
  String _query = '';
  final _searchCtrl = TextEditingController();
  bool _chipsInit = false;
  /// Manually picked startup workspace (null = follow active session phase).
  String? _startupScope;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(teamViewModelProvider.notifier).loadInitialData();
      ref.read(requestsViewModelProvider.notifier).loadInitialData();
      ref.read(crossConversationViewModelProvider.notifier).loadConversations();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  /// Role labels the user owns (Startup / Investor / Community).
  List<String> _ownedRoles(AuthSession? session) {
    final seen = <String>{};
    final out = <String>[];
    for (final r in session?.userRoles ?? const []) {
      if (r.label == 'Feed') continue;
      if (seen.add(r.label)) out.add(r.label);
    }
    return out.isEmpty ? const ['Startup', 'Investor', 'Community'] : out;
  }

  String _activeLabel(AuthSession? session) {
    final label = session?.activeUserRole.label ?? '';
    if (label == 'Feed') return 'Startup';
    return label;
  }

  /// Startup phase context line + chat scope name.
  /// A manually picked workspace wins; otherwise follows the session phase.
  ({String label, String scope}) _startupContext(AuthSession? session) {
    final spaces = startupWorkspacesFor(session);
    if (_startupScope != null) {
      final picked = spaces.where((w) => w.name == _startupScope);
      if (picked.isNotEmpty) {
        final w = picked.first;
        return (
          label: w.phase == 'Created'
              ? 'Your startup'
              : w.phase == 'Joined'
                  ? 'Joined team'
                  : 'Idea phase',
          scope: w.name,
        );
      }
    }
    final active = (session?.startupName?.isNotEmpty == true)
        ? session!.startupName!
        : null;
    final joined = session?.joinedStartupName;
    final original = session?.originalStartupName;
    final idea =
        session?.activeIdeaPhaseData?['ideaName']?.toString().trim() ?? '';
    if (active != null) {
      if (joined != null && joined.isNotEmpty && active == joined) {
        return (label: 'Joined team', scope: active);
      }
      return (label: 'Your startup', scope: active);
    }
    if (original != null && original.isNotEmpty) {
      return (label: 'Your startup', scope: original);
    }
    if (joined != null && joined.isNotEmpty) {
      return (label: 'Joined team', scope: joined);
    }
    if (idea.isNotEmpty) return (label: 'Idea phase', scope: idea);
    return (label: 'No startup yet', scope: 'Startup');
  }

  /// Tapping Startup opens the workspace picker (idea / created / joined)
  /// so the user jumps into the right startup's messages.
  void _pickWorkspace() {
    final session = ref.read(authViewModelProvider).session;
    final spaces = startupWorkspacesFor(session);
    if (spaces.isEmpty) {
      setState(() => _chip = 'Startup');
      return;
    }
    final current = _startupContext(session).scope;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose workspace',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Jump into messages for an idea, created or joined startup.',
                style: TextStyle(fontSize: 12.5, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: spaces.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final w = spaces[i];
                    final active = w.name == current;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _startupScope = w.name;
                          _chip = 'Startup';
                        });
                        Navigator.pop(ctx);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: active
                              ? const Color(0xFFEFF6FF)
                              : Colors.white,
                          borderRadius:
                              BorderRadius.circular(12),
                          border: Border.all(
                            color: active
                                ? const Color(0xFF2563EB)
                                : const Color(0xFFE5E7EB),
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: active
                                  ? const Color(0xFF2563EB)
                                  : const Color(0xFFEFF6FF),
                              child: Text(
                                w.name[0].toUpperCase(),
                                style: TextStyle(
                                  color: active
                                      ? Colors.white
                                      : const Color(0xFF2563EB),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    w.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                  Text(
                                    w.phase,
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (active)
                              const Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xFF2563EB)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _match(String s) =>
      _query.isEmpty || s.toLowerCase().contains(_query.toLowerCase());

  String _timeAgo(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return 'now';
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    return '${d.inDays}d';
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authViewModelProvider).session;
    final roles = _ownedRoles(session);
    if (!_chipsInit) {
      final active = _activeLabel(session);
      _chip = roles.contains(active) ? active : roles.first;
      _chipsInit = true;
    }

    final crossState = ref.watch(crossConversationViewModelProvider);
    final teamState = ref.watch(teamViewModelProvider);
    final requestsState = ref.watch(requestsViewModelProvider);
    final messageState = ref.watch(messageViewModelProvider);

    final investorUnread =
        crossState.conversations.fold<int>(0, (a, c) => a + c.unreadCount);
    final startupUnread =
        teamState.totalUnread + requestsState.pendingCount;
    final communityUnread = messageState.totalUnread;

    int unreadFor(String chip) => switch (chip) {
          'Investor' => investorUnread,
          'Startup' => startupUnread,
          _ => communityUnread,
        };

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: Color(0xFF111827)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Messages',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111827),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Column(
              children: [
                Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(21),
                    border:
                        Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded,
                          size: 18, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: (v) => setState(
                              () => _query = v.trim()),
                          decoration: const InputDecoration(
                            hintText: 'Search messages',
                            hintStyle: TextStyle(
                                fontSize: 13.5,
                                color: Color(0xFF9CA3AF)),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      if (_query.isNotEmpty)
                        GestureDetector(
                          onTap: () => setState(() {
                            _searchCtrl.clear();
                            _query = '';
                          }),
                          child: const Icon(Icons.close_rounded,
                              size: 18,
                              color: Color(0xFF9CA3AF)),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Scrollable so chips + unread badges never overflow.
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final role in roles)
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => role == 'Startup'
                                ? _pickWorkspace()
                                : setState(() => _chip = role),
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8),
                            decoration: BoxDecoration(
                              color: _chip == role
                                  ? const Color(0xFF2563EB)
                                  : Colors.white,
                              borderRadius:
                                  BorderRadius.circular(20),
                              border: Border.all(
                                color: _chip == role
                                    ? const Color(0xFF2563EB)
                                    : const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  role,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: _chip == role
                                        ? Colors.white
                                        : const Color(0xFF6B7280),
                                  ),
                                ),
                                if (unreadFor(role) > 0) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _chip == role
                                          ? Colors.white
                                          : const Color(0xFFEF4444),
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '${unreadFor(role)}',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w800,
                                        color: _chip == role
                                            ? const Color(0xFF2563EB)
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (_chip) {
              'Investor' => _investorList(),
              'Startup' => _startupList(session),
              _ => _communityList(),
            },
          ),
        ],
      ),
    );
  }

  // ── Investor chats ──────────────────────────────────────────────

  Widget _investorList() {
    final convos = ref
        .watch(crossConversationViewModelProvider)
        .conversations
        .where((c) => _match('${_investorName(c)} ${c.lastMessage}'))
        .toList();
    if (convos.isEmpty) return _empty('No investor messages found.');
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: convos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final c = convos[i];
        return _row(
          title: _investorName(c),
          preview: c.lastMessage,
          time: _timeAgo(c.lastMessageTime),
          unread: c.unreadCount,
          online: c.isOnline,
          onTap: () {
            ref
                .read(crossConversationViewModelProvider.notifier)
                .selectConversation(c.id);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    CrossConversationChatScreen(conversation: c),
              ),
            );
          },
        );
      },
    );
  }

  String _investorName(CrossConversation c) =>
      c.participant1Role == 'investor'
          ? c.participant2Name
          : c.participant1Name;

  // ── Startup chats + requests (phase-aware) ─────────────────────

  Widget _startupList(AuthSession? session) {
    final ctx = _startupContext(session);
    final teamVm = ref.read(teamViewModelProvider.notifier);
    final team = ref.watch(teamViewModelProvider);
    final requests = ref.watch(requestsViewModelProvider);
    final members = team.members
        .where((m) => _match('${m.name} ${m.role}'))
        .toList();
    final pending = requests.pending
        .where((r) => _match('${r.name} ${r.role} ${r.note}'))
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: Row(
            children: [
              const Icon(Icons.rocket_launch_rounded,
                  size: 18, color: Color(0xFF2563EB)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${ctx.label} • ${ctx.scope}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E40AF),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        if (pending.isNotEmpty) ...[
          _section('Requests (${pending.length})', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StartupRequestsScreen(
                    startupName: ctx.scope),
              ),
            );
          }),
          const SizedBox(height: 8),
          for (final r in pending)
            _requestRow(r.name, r.role, r.note, r.time,
                r.initials),
          const SizedBox(height: 14),
        ],
        _section('Team chats', null),
        const SizedBox(height: 8),
        if (members.isEmpty)
          _empty('No team chats found.')
        else
          for (final m in members)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _row(
                title: m.name,
                preview:
                    teamVm.lastMessageFor(m.name)?.text ?? m.role,
                time:
                    teamVm.lastMessageFor(m.name)?.time ?? '',
                unread: team.unreadCountFor(m.name),
                online: false,
                initials: m.initials,
                onTap: () {
                  teamVm.markAsRead(m.name);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TeamChatScreen(
                        member: m,
                        startupName: ctx.scope,
                      ),
                    ),
                  );
                },
              ),
            ),
      ],
    );
  }

  // ── Community chats ────────────────────────────────────────────

  Widget _communityList() {
    final convos = ref
        .watch(messageViewModelProvider)
        .conversations
        .where((c) => _match('${c.name} ${c.subtitle}'))
        .toList();
    if (convos.isEmpty) return _empty('No community messages found.');
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: convos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final c = convos[i];
        return _row(
          title: c.name,
          preview: c.subtitle,
          time: c.timeLabel,
          unread: c.unreadCount,
          online: c.isOnline,
          onTap: () {
            ref
                .read(messageViewModelProvider.notifier)
                .markRead(c.id);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ChatScreen(conversationId: c.id),
              ),
            );
          },
        );
      },
    );
  }

  // ── Shared row widgets ─────────────────────────────────────────

  Widget _section(String title, VoidCallback? onSeeAll) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: const Text(
              'See All >',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2563EB),
              ),
            ),
          ),
      ],
    );
  }

  Widget _empty(String msg) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Center(
        child: Text(
          msg,
          style:
              const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        ),
      ),
    );
  }

  String _avatarText(String? initials, String title) {
    final src =
        (initials?.isNotEmpty == true ? initials! : title).trim();
    if (src.isEmpty) return '?';
    final parts = src.split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return src.substring(0, src.length.clamp(1, 2)).toUpperCase();
  }

  Widget _row({
    required String title,
    required String preview,
    required String time,
    required int unread,
    required bool online,
    String? initials,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor:
                      const Color(0xFFEFF6FF),
                  child: Text(
                    _avatarText(initials, title),
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (online)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: unread > 0
                          ? FontWeight.w800
                          : FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    preview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                if (unread > 0) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$unread',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _requestRow(
    String name,
    String role,
    String note,
    String time,
    String initials,
  ) {
    final crud = ref.read(requestsViewModelProvider.notifier);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor:
                    const Color(0xFFEFF6FF),
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                    Text(
                      '$role • $time',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            note,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => crud.ignore(name),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        const Color(0xFF6B7280),
                    side: const BorderSide(
                        color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Ignore'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: () => crud.accept(name),
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Accept'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
