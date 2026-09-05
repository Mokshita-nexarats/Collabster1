import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/theme/investor_colors.dart';
import '../../model/cross_conversation_model.dart';
import 'cross_conversation_chat_screen.dart';

/// Investor Messages screen - cross-mode chats with founders, co-investors & advisors
class InvestorMessagesScreen extends ConsumerStatefulWidget {
  const InvestorMessagesScreen({super.key, this.embedded = false});

  /// When true the screen is shown inside the home tab stack, so no back
  /// arrow is rendered (tapping it would pop the dashboard = black screen).
  final bool embedded;

  @override
  ConsumerState<InvestorMessagesScreen> createState() => _InvestorMessagesScreenState();
}

class _InvestorMessagesScreenState extends ConsumerState<InvestorMessagesScreen> {
  String _searchQuery = '';
  String _roleFilter = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(crossConversationViewModelProvider.notifier).loadConversations();
    });
  }

  List<CrossConversation> _filtered(List<CrossConversation> convos) {
    var result = convos;
    if (_roleFilter == 'Founders') {
      result = result.where((c) => c.participant2Role == 'startup' || c.participant1Role == 'startup').toList();
    } else if (_roleFilter == 'Investors') {
      result = result.where((c) => c.participant2Role == 'investor' || c.participant1Role == 'investor').toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      result = result.where((c) {
        final name = c.participant2Name.toLowerCase();
        final msg = c.lastMessage.toLowerCase();
        return name.contains(q) || msg.contains(q);
      }).toList();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final allConvos = ref.watch(crossConversationViewModelProvider).conversations;
    final convos = _filtered(allConvos);

    return Scaffold(
      backgroundColor: InvestorColors.goldBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(gradient: InvestorColors.headerGradient),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (widget.embedded)
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.forum_rounded, color: Colors.white, size: 21),
                            )
                          else
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 21),
                              ),
                            ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Investor Messages',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Direct chats with founders & co-investors',
                                  style: TextStyle(color: Colors.white70, fontSize: 12.5),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _showRequestsSheet(context),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.person_add_rounded, color: Colors.white, size: 21),
                                ),
                                Positioned(
                                  top: -2,
                                  right: -2,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFEF4444),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Text(
                                      '3',
                                      style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                        ),
                        child: TextField(
                          onChanged: (val) => setState(() => _searchQuery = val),
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          cursorColor: Colors.white,
                          decoration: const InputDecoration(
                            hintText: 'Search conversations or messages...',
                            hintStyle: TextStyle(color: Colors.white60, fontSize: 13.5),
                            prefixIcon: Icon(Icons.search_rounded, color: Colors.white70, size: 20),
                            filled: false,
                            fillColor: Colors.transparent,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final label = ['All', 'Founders', 'Investors'][index];
                      final isSelected = label == _roleFilter;
                      return GestureDetector(
                        onTap: () => setState(() => _roleFilter = label),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? InvestorColors.goldDeep : Colors.white,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: isSelected ? InvestorColors.goldDeep : InvestorColors.border,
                            ),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected ? Colors.white : InvestorColors.inkSoft,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                if (convos.isEmpty)
                  _buildEmptyState()
                else
                  ...convos.map(
                    (convo) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildConversationTile(convo),
                    ),
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showRequestsSheet(BuildContext context) {
    final requests = [
      {
        'id': 'req-1',
        'name': 'Dr. Aris Vance',
        'role': 'Founder & CEO • Nova Robotics',
        'type': 'Founder Intro',
        'message': 'Requesting 1-on-1 diligence chat regarding Series A term sheet & cap table.',
        'time': '10m ago',
        'avatar': 'AV',
      },
      {
        'id': 'req-2',
        'name': 'Elena Rostova',
        'role': 'Co-Founder • FinEdge Tech',
        'type': 'Diligence Request',
        'message': 'Would love to discuss our Seed round allocation with Apex VC.',
        'time': '1h ago',
        'avatar': 'ER',
      },
      {
        'id': 'req-3',
        'name': 'Sarah Jenkins',
        'role': 'Managing Partner • Apex VC',
        'type': 'Syndicate Co-Invest',
        'message': 'Inviting you to join the DeepTech Lead Investor Guild.',
        'time': '3h ago',
        'avatar': 'SJ',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
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
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [InvestorColors.goldDeep, Color(0xFFF59E0B)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.person_add_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Intro & Connection Requests',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12233D)),
                          ),
                          Text(
                            'Incoming requests from founders & syndicate leads',
                            style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Icon(Icons.close_rounded, color: Color(0xFF4B5563), size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                if (requests.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text('No pending requests', style: TextStyle(color: InvestorColors.textMuted)),
                    ),
                  )
                else
                  ...requests.map((req) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                          boxShadow: const [
                            BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 3)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: InvestorColors.goldDeep.withValues(alpha: 0.15),
                                  child: Text(
                                    req['avatar'] as String,
                                    style: const TextStyle(color: InvestorColors.goldDeep, fontSize: 12, fontWeight: FontWeight.w800),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        req['name'] as String,
                                        style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: InvestorColors.ink),
                                      ),
                                      Text(
                                        req['role'] as String,
                                        style: const TextStyle(fontSize: 11.5, color: InvestorColors.textMuted),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  req['time'] as String,
                                  style: const TextStyle(fontSize: 11, color: InvestorColors.textMuted),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              req['message'] as String,
                              style: const TextStyle(fontSize: 12.5, color: InvestorColors.inkSoft, height: 1.4),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      setModalState(() {
                                        requests.removeWhere((r) => r['id'] == req['id']);
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                    ),
                                    child: const Text('Decline', style: TextStyle(fontSize: 12, color: InvestorColors.textMuted)),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      ref.read(crossConversationViewModelProvider.notifier).startConversationWithStartup(
                                        req['name'] as String,
                                        req['id'] as String,
                                        req['avatar'] as String,
                                      );
                                      Navigator.pop(ctx);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Accepted request from ${req['name']}! Chat room opened.'),
                                          backgroundColor: InvestorColors.goldDeep,
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: InvestorColors.goldDeep,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                    ),
                                    child: const Text('Accept & Chat', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: InvestorColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: InvestorColors.goldSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 40,
              color: InvestorColors.goldDeep,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No messages found',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: InvestorColors.ink,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Start a conversation with a startup founder or co-investor.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.5, color: InvestorColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile(CrossConversation convo) {
    final isStartup = convo.participant2Role == 'startup';
    final otherName = isStartup ? convo.participant2Name : convo.participant1Name;
    final otherRole = isStartup ? convo.participant2Role : convo.participant1Role;
    final otherAvatar = isStartup ? convo.participant2Avatar : convo.participant1Avatar;
    final otherInitials = otherAvatar.length >= 2 ? otherAvatar.substring(0, 2).toUpperCase() : otherAvatar.toUpperCase();

    return GestureDetector(
      onTap: () {
        ref.read(crossConversationViewModelProvider.notifier).selectConversation(convo.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CrossConversationChatScreen(conversation: convo),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: InvestorColors.border),
          boxShadow: const [
            BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: InvestorColors.colorForKey(otherRole == 'startup' ? 'purple' : 'gold').withValues(alpha: 0.15),
                  child: Text(
                    otherInitials,
                    style: TextStyle(
                      color: InvestorColors.colorForKey(otherRole == 'startup' ? 'purple' : 'gold'),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (convo.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: InvestorColors.green,
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
                          otherName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: convo.unreadCount > 0 ? InvestorColors.ink : InvestorColors.inkSoft,
                          ),
                        ),
                      ),
                      if (convo.unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: InvestorColors.goldDeep,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${convo.unreadCount}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${otherRole.toUpperCase()} • ${_formatTime(convo.lastMessageTime)}',
                    style: const TextStyle(fontSize: 11, color: InvestorColors.textMuted),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    convo.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: convo.unreadCount > 0 ? InvestorColors.inkSoft : InvestorColors.textMuted,
                      fontWeight: convo.unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}