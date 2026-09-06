import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/notification_model.dart';
import 'notifications_state.dart';

class NotificationsViewModel extends StateNotifier<NotificationsState> {
  NotificationsViewModel() : super(const NotificationsState());

  void loadNotifications({String? startupName}) {
    // Load once per session — reloading would wipe read/deleted states.
    if (state.notifications.isNotEmpty) return;
    final notifications = _generateSampleNotifications(startupName);
    final sorted = [...notifications]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = state.copyWith(notifications: sorted);
  }

  void markAsRead(String notificationId) {
    final updated = state.notifications.map((n) {
      if (n.id == notificationId) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();
    state = state.copyWith(notifications: updated);
  }

  void markAllAsRead() {
    final updated = state.notifications.map((n) {
      if (!n.isRead) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();
    state = state.copyWith(notifications: updated);
  }

  void deleteNotification(String notificationId) {
    final updated = state.notifications.where((n) => n.id != notificationId).toList();
    state = state.copyWith(notifications: updated);
  }

  void clearAll() {
    state = state.copyWith(notifications: []);
  }

  void setFilter(NotificationType? type) {
    state = state.copyWith(selectedFilter: type, clearFilter: type == null);
  }

  List<AppNotification> _generateSampleNotifications(String? startupName) {
    final now = DateTime.now();
    return [
      AppNotification(
        id: '1',
        title: 'Connection Request',
        subtitle: 'Sarah Miller wants to connect with you',
        body: 'Lead Designer at Design Studio with 8 years of experience.',
        type: NotificationType.connection,
        iconKey: 'person_add',
        colorKey: 'primary',
        createdAt: now.subtract(const Duration(minutes: 5)),
        metadata: {'requesterName': 'Sarah Miller', 'role': 'Lead Designer'},
      ),
      AppNotification(
        id: '2',
        title: 'New Message',
        subtitle: 'Rahul Verma sent you a message',
        body: 'Hey! How\'s everything going with the current sprint?',
        type: NotificationType.message,
        iconKey: 'message',
        colorKey: 'teal',
        createdAt: now.subtract(const Duration(minutes: 15)),
        deepLink: '/messages/rahul-verma',
        metadata: {'senderName': 'Rahul Verma'},
      ),
      AppNotification(
        id: '3',
        title: 'Milestone Achieved',
        subtitle: 'Product Launch milestone completed',
        body: 'Congratulations! Your team has successfully completed the Product Launch milestone.',
        type: NotificationType.milestone,
        iconKey: 'milestone',
        colorKey: 'live',
        createdAt: now.subtract(const Duration(hours: 2)),
        deepLink: '/milestones',
      ),
      AppNotification(
        id: '4',
        title: 'Funding Update',
        subtitle: 'Vertex Capital is interested',
        body: 'Vertex Capital has reviewed your pitch deck and scheduled a meeting.',
        type: NotificationType.funding,
        iconKey: 'money',
        colorKey: 'amber',
        createdAt: now.subtract(const Duration(hours: 5)),
        deepLink: '/investors/vertex-capital',
        metadata: {'investorName': 'Vertex Capital', 'amount': '\$350K'},
      ),
      AppNotification(
        id: '5',
        title: 'Team Update',
        subtitle: 'New team member joined',
        body: 'Anika Patel has joined the team as Product Designer.',
        type: NotificationType.team,
        iconKey: 'group',
        colorKey: 'blue',
        createdAt: now.subtract(const Duration(hours: 8)),
        metadata: {'memberName': 'Anika Patel', 'role': 'Product Designer'},
      ),
      AppNotification(
        id: '6',
        title: 'Document Shared',
        subtitle: 'Q4 Financial Report uploaded',
        body: 'Sneha Iyer shared the Q4 Financial Report document.',
        type: NotificationType.document,
        iconKey: 'document',
        colorKey: 'purple',
        createdAt: now.subtract(const Duration(days: 1)),
        deepLink: '/documents',
        metadata: {'documentName': 'Q4 Financial Report', 'sharedBy': 'Sneha Iyer'},
      ),
      AppNotification(
        id: '7',
        title: 'System Update',
        subtitle: 'Platform maintenance scheduled',
        body: 'Scheduled maintenance window: Tomorrow 2:00 AM - 4:00 AM IST.',
        type: NotificationType.system,
        iconKey: 'system',
        colorKey: 'muted',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    ];
  }
}
