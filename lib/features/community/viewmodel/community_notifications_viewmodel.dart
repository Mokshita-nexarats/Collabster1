import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/notification_model.dart';
import '../model/community_notification_state.dart';

class CommunityNotificationsViewModel extends StateNotifier<CommunityNotificationState> {
  CommunityNotificationsViewModel() : super(const CommunityNotificationState());

  void loadNotifications() {
    final now = DateTime.now();
    final notifications = [
      CommunityNotification(
        id: 'comm-1',
        title: 'New Post in Flutter Developers',
        subtitle: 'Priya Sharma: "Just shipped a new feature using Flutter and Riverpod!"',
        type: CommunityNotificationType.post,
        iconName: 'article_outline',
        iconColor: 0xFF229ED9,
        iconBg: 0xFFFFF2E7,
        createdAt: now.subtract(const Duration(minutes: 15)),
        deepLink: '/community/posts/flutter-riverpod-feature',
      ),
      CommunityNotification(
        id: 'comm-2',
        title: 'Comment on your post',
        subtitle: 'Rahul Kumar replied to "Best state management practices"',
        type: CommunityNotificationType.comment,
        iconName: 'comment_outline',
        iconColor: 0xFF0284C7,
        iconBg: 0xFFE8F0FE,
        createdAt: now.subtract(const Duration(hours: 2)),
        deepLink: '/community/posts/state-mgmt#comment-42',
      ),
      CommunityNotification(
        id: 'comm-3',
        title: 'Someone liked your post',
        subtitle: 'Anita Desai and 3 others liked your post about Clean Architecture',
        type: CommunityNotificationType.like,
        iconName: 'favorite_outline',
        iconColor: 0xFFE11D48,
        iconBg: 0xFFFFF0F5,
        createdAt: now.subtract(const Duration(hours: 5)),
        deepLink: '/community/posts/clean-arch',
      ),
      CommunityNotification(
        id: 'comm-4',
        title: 'Mentioned in a comment',
        subtitle: '@yourname was mentioned in "Hiring Flutter devs" discussion',
        type: CommunityNotificationType.mention,
        iconName: 'alternate_email_outline',
        iconColor: 0xFF7C3AED,
        iconBg: 0xFFF5F0FF,
        createdAt: now.subtract(const Duration(hours: 8)),
        deepLink: '/community/posts/hiring-flutter#comment-15',
      ),
      CommunityNotification(
        id: 'comm-5',
        title: 'Weekly Community Digest',
        subtitle: 'Top 5 posts this week in Flutter Developers',
        type: CommunityNotificationType.system,
        iconName: 'email_outline',
        iconColor: 0xFF64748B,
        iconBg: 0xFFF1F5F9,
        createdAt: now.subtract(const Duration(days: 1)),
        deepLink: '/community/digest/weekly',
      ),
    ];

    final sorted = [...notifications]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

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

  void setFilter(CommunityNotificationType? type) {
    state = state.copyWith(
      selectedFilter: type,
      clearFilter: type == null,
    );
  }

  void clearFilter() {
    state = state.copyWith(clearFilter: true);
  }
}