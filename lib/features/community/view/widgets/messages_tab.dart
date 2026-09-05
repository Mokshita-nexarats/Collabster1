import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../startup/model/startup_models.dart';
import '../../model/chat_model.dart';
import '../screens/chat_screen.dart';
import 'community_search_bar.dart';

class MessagesTab extends ConsumerStatefulWidget {
  const MessagesTab({super.key});

  @override
  ConsumerState<MessagesTab> createState() => _MessagesTabState();
}

class _MessagesTabState extends ConsumerState<MessagesTab>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _searchController = TextEditingController();

  static const _filters = ['All', 'Unread', 'Rooms'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(requestsViewModelProvider.notifier).loadInitialData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _openChat(Conversation conversation) {
    ref.read(messageViewModelProvider.notifier).markRead(conversation.id);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatScreen(conversationId: conversation.id),
      ),
    );
  }

  void _showComposeSheet() {
    final conversations = ref.read(messageViewModelProvider).conversations;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'New message',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pick a community member to start a chat',
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 12),
                for (final conversation in conversations)
                  if (!conversation.isRoom)
                    _ComposeMemberTile(
                      conversation: conversation,
                      onTap: () {
                        Navigator.pop(sheetContext);
                        _openChat(conversation);
                      },
                    ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final messageState = ref.watch(messageViewModelProvider);
    final requestsState = ref.watch(requestsViewModelProvider);
    final pendingRequests = requestsState.pending;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Messages',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        messageState.totalUnread > 0
                            ? '${messageState.totalUnread} unread · Community chats'
                            : 'Community chats & direct messages',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _showComposeSheet,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0088CC), Color(0xFF229ED9)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0088CC).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFF229ED9),
            indicatorWeight: 3,
            labelColor: const Color(0xFF229ED9),
            unselectedLabelColor: const Color(0xFF64748B),
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
                          color: const Color(0xFF229ED9),
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
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildChatsContent(messageState),
                _buildRequestsContent(pendingRequests),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Chats Tab View ───────────────────────────────────────────────────
  Widget _buildChatsContent(dynamic messageState) {
    return Column(
      children: [
        CommunitySearchBar(
          controller: _searchController,
          hintText: 'Search chats and rooms...',
          showClear: _searchController.text.isNotEmpty,
          margin: const EdgeInsets.fromLTRB(20, 14, 20, 10),
          onChanged: (value) {
            ref
                .read(messageViewModelProvider.notifier)
                .setSearchQuery(value);
            setState(() {});
          },
          onClear: () {
            _searchController.clear();
            ref
                .read(messageViewModelProvider.notifier)
                .setSearchQuery('');
            setState(() {});
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              for (final filter in _filters)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _FilterChip(
                    label: filter,
                    selected: messageState.selectedFilter == filter,
                    onTap: () {
                      ref
                          .read(messageViewModelProvider.notifier)
                          .setFilter(filter);
                    },
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: messageState.filteredConversations.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  itemCount: messageState.filteredConversations.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final conversation =
                        messageState.filteredConversations[index];
                    return _ConversationTile(
                      conversation: conversation,
                      onTap: () => _openChat(conversation),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ── Requests Tab View ─────────────────────────────────────────────────
  Widget _buildRequestsContent(List<ConnectionRequest> requests) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 34,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'No chats found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Try a different search or filter',
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE8F4FB) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF229ED9) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? const Color(0xFF229ED9) : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const _ConversationTile({required this.conversation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isRoom = conversation.isRoom;
    final colors = isRoom
        ? const [Color(0xFF7C3AED), Color(0xFFA78BFA)]
        : const [Color(0xFF2563EB), Color(0xFF3B82F6)];
    final initial = conversation.name.trim().characters.first.toUpperCase();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: colors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      initial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                if (!isRoom && conversation.isOnline)
                  Positioned(
                    right: -2,
                    bottom: -2,
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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        conversation.timeLabel,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: conversation.unreadCount > 0
                              ? const Color(0xFF229ED9)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (isRoom)
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDE9FE),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'ROOM',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: Color(0xFF7C3AED),
                            ),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          conversation.lastMessage?.text ??
                              conversation.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: conversation.unreadCount > 0
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: conversation.unreadCount > 0
                                ? const Color(0xFF334155)
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                      if (conversation.unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF229ED9), Color(0xFF0088CC)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${conversation.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
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
}

class _ComposeMemberTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const _ComposeMemberTile({required this.conversation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final initial = conversation.name.trim().characters.first.toUpperCase();

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.name,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    conversation.lastMessage?.text ?? 'Start a conversation',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chat_bubble_outline_rounded,
              color: Color(0xFF94A3B8),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
