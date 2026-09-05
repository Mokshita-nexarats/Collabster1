import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/notification_model.dart';
import '../model/career_notification_state.dart';

class CareerNotificationsViewModel extends StateNotifier<CareerNotificationState> {
  CareerNotificationsViewModel() : super(const CareerNotificationState());

  void loadNotifications() {
    final notifications = [
      CareerNotification(
        id: 'career-1',
        title: 'New Job Match',
        description: 'Senior Flutter Developer at TechCorp matches your skills',
        type: CareerNotificationType.job,
        iconName: 'work_outline',
        iconColor: 0xFF0088CC,
        iconBg: 0xFFE8F4FB,
        time: '5m ago',
        deepLink: '/jobs/techcorp-senior-flutter',
      ),
      CareerNotification(
        id: 'career-2',
        title: 'Interview Scheduled',
        description: 'AI Mock Interview confirmed for tomorrow 10:00 AM',
        type: CareerNotificationType.interview,
        iconName: 'videocam_outline',
        iconColor: 0xFF0088CC,
        iconBg: 0xFFE8F4FB,
        time: '1h ago',
        deepLink: '/interviews/mock-ai-001',
      ),
      CareerNotification(
        id: 'career-3',
        title: 'Post in Flutter Community',
        description: 'New discussion: "Best state management for 2024?"',
        type: CareerNotificationType.post,
        iconName: 'article_outline',
        iconColor: 0xFF0088CC,
        iconBg: 0xFFE8F4FB,
        time: '2h ago',
        deepLink: '/community/posts/flutter-state-mgmt',
      ),
      CareerNotification(
        id: 'career-4',
        title: 'Event Reminder',
        description: 'Tech Career Fair starts in 3 hours - Bangalore',
        type: CareerNotificationType.event,
        iconName: 'event_outline',
        iconColor: 0xFF059669,
        iconBg: 0xFFECFDF5,
        time: '3h ago',
        deepLink: '/events/tech-career-fair',
      ),
      CareerNotification(
        id: 'career-5',
        title: 'Application Update',
        description: 'Your application to DataSoft is under review',
        type: CareerNotificationType.job,
        iconName: 'work_outline',
        iconColor: 0xFF0088CC,
        iconBg: 0xFFE8F4FB,
        time: '1d ago',
        deepLink: '/applications/datasoft-001',
      ),
      CareerNotification(
        id: 'career-6',
        title: 'System Maintenance',
        description: 'Platform maintenance scheduled tonight 2-4 AM IST',
        type: CareerNotificationType.system,
        iconName: 'settings_outline',
        iconColor: 0xFF64748B,
        iconBg: 0xFFF1F5F9,
        time: '2d ago',
      ),
    ];

    final sorted = [...notifications]
      ..sort((a, b) => _parseTime(b.time).compareTo(_parseTime(a.time)));

    state = state.copyWith(notifications: sorted);
  }

  DateTime _parseTime(String time) {
    final now = DateTime.now();
    final parts = time.toLowerCase().split(' ');
    if (parts.length != 2) return now;
    final value = int.tryParse(parts[0]) ?? 0;
    final unit = parts[1];
    switch (unit) {
      case 'm':
      case 'min':
      case 'mins':
      case 'minute':
      case 'minutes':
        return now.subtract(Duration(minutes: value));
      case 'h':
      case 'hr':
      case 'hrs':
      case 'hour':
      case 'hours':
        return now.subtract(Duration(hours: value));
      case 'd':
      case 'day':
      case 'days':
        return now.subtract(Duration(days: value));
      default:
        return now;
    }
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

  void setFilter(CareerNotificationType? type) {
    state = state.copyWith(
      selectedFilter: type,
      clearFilter: type == null,
    );
  }

  void clearFilter() {
    state = state.copyWith(clearFilter: true);
  }
}