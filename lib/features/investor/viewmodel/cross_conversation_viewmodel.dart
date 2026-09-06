import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/cross_conversation_model.dart';
import '../model/cross_conversation_state.dart';

class CrossConversationViewModel extends StateNotifier<CrossConversationState> {
  CrossConversationViewModel() : super(const CrossConversationState());

  void loadConversations() {
    // Load once per session — reloading would wipe read states.
    if (state.conversations.isNotEmpty) return;
    final now = DateTime.now();
    final conversations = [
      CrossConversation(
        id: 'conv-1',
        participant1Id: 'investor-1',
        participant1Name: 'Vertex Capital',
        participant1Role: 'investor',
        participant1Avatar: 'VC',
        participant2Id: 'startup-1',
        participant2Name: 'Nova Robotics',
        participant2Role: 'startup',
        participant2Avatar: 'NR',
        lastMessage: 'Thanks for the intro! We\'ll review the deck this week.',
        lastMessageTime: now.subtract(const Duration(hours: 2)),
        unreadCount: 1,
        isOnline: true,
      ),
      CrossConversation(
        id: 'conv-2',
        participant1Id: 'investor-1',
        participant1Name: 'NorthStar Ventures',
        participant1Role: 'investor',
        participant1Avatar: 'NV',
        participant2Id: 'startup-2',
        participant2Name: 'FinEdge',
        participant2Role: 'startup',
        participant2Avatar: 'FE',
        lastMessage: 'Scheduled call for tomorrow 10 AM. Looking forward!',
        lastMessageTime: now.subtract(const Duration(hours: 5)),
        unreadCount: 0,
        isOnline: false,
      ),
      CrossConversation(
        id: 'conv-3',
        participant1Id: 'investor-1',
        participant1Name: 'GoldenLeaf Capital',
        participant1Role: 'investor',
        participant1Avatar: 'GC',
        participant2Id: 'startup-3',
        participant2Name: 'Cloudly AI',
        participant2Role: 'startup',
        participant2Avatar: 'CA',
        lastMessage: 'Great meeting today. Sending term sheet by EOD.',
        lastMessageTime: now.subtract(const Duration(days: 1)),
        unreadCount: 0,
        isOnline: true,
      ),
      CrossConversation(
        id: 'conv-4',
        participant1Id: 'investor-1',
        participant1Name: 'You',
        participant1Role: 'investor',
        participant1Avatar: 'YU',
        participant2Id: 'investor-2',
        participant2Name: 'Sarah Jenkins (Apex VC)',
        participant2Role: 'investor',
        participant2Avatar: 'SJ',
        lastMessage: 'Let\'s co-invest in Nova Robotics Series A round.',
        lastMessageTime: now.subtract(const Duration(hours: 3)),
        unreadCount: 1,
        isOnline: true,
      ),
      CrossConversation(
        id: 'conv-5',
        participant1Id: 'investor-1',
        participant1Name: 'You',
        participant1Role: 'investor',
        participant1Avatar: 'YU',
        participant2Id: 'investor-3',
        participant2Name: 'Marcus Sterling (Horizon)',
        participant2Role: 'investor',
        participant2Avatar: 'MS',
        lastMessage: 'Shared Syndicate Term Sheet details with LPs.',
        lastMessageTime: now.subtract(const Duration(days: 2)),
        unreadCount: 0,
        isOnline: false,
      ),
    ];

    state = state.copyWith(conversations: conversations);
  }

  void selectConversation(String conversationId) {
    state = state.copyWith(currentConversationId: conversationId);
    // Mark as read
    final updated = state.conversations.map((c) {
      if (c.id == conversationId && c.unreadCount > 0) {
        return c.copyWith(unreadCount: 0);
      }
      return c;
    }).toList();
    state = state.copyWith(conversations: updated);
  }

  void sendMessage(String conversationId, String text, {String senderId = 'investor-1', String senderName = 'You', String senderRole = 'investor'}) {
    final message = CrossMessage(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: senderId,
      senderName: senderName,
      senderRole: senderRole,
      text: text,
      createdAt: DateTime.now(),
    );
    state = state.copyWith(messages: [...state.messages, message]);

    // Update conversation last message
    final updated = state.conversations.map((c) {
      if (c.id == conversationId) {
        return c.copyWith(
          lastMessage: text,
          lastMessageTime: DateTime.now(),
        );
      }
      return c;
    }).toList();
    state = state.copyWith(conversations: updated);
  }

  void startConversationWithStartup(String startupName, String startupId, String startupAvatar) {
    final now = DateTime.now();
    final conversation = CrossConversation(
      id: 'conv-$startupId-${DateTime.now().millisecondsSinceEpoch}',
      participant1Id: 'investor-1',
      participant1Name: 'You',
      participant1Role: 'investor',
      participant1Avatar: 'YU',
      participant2Id: startupId,
      participant2Name: startupName,
      participant2Role: 'startup',
      participant2Avatar: startupAvatar,
      lastMessage: '',
      lastMessageTime: now,
      unreadCount: 0,
      isOnline: true,
    );
    state = state.copyWith(
      conversations: [conversation, ...state.conversations],
      currentConversationId: conversation.id,
    );
  }

  void markAllAsRead() {
    final updated = state.conversations.map((c) => c.copyWith(unreadCount: 0)).toList();
    state = state.copyWith(conversations: updated);
  }
}