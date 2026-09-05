import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/notification_model.dart';
import '../model/event_notification_state.dart';

class EventNotificationsViewModel extends StateNotifier<EventNotificationState> {
  EventNotificationsViewModel() : super(const EventNotificationState());

  void loadNotifications() {
    final now = DateTime.now();
    final notifications = [
      EventNotification(
        id: 'evt-1',
        title: 'Event Starting Soon',
        subtitle: 'Flutter Conference 2024 starts in 30 minutes',
        type: EventNotificationType.reminder,
        iconName: 'schedule_outline',
        iconColor: 0xFF0088CC,
        iconBg: 0xFFEFF6FF,
        createdAt: now.subtract(const Duration(minutes: 45)),
        deepLink: '/events/flutter-conf-2024',
      ),
      EventNotification(
        id: 'evt-2',
        title: 'Registration Confirmed',
        subtitle: 'You\'re registered for React Workshop - Sep 20',
        type: EventNotificationType.registration,
        iconName: 'check_circle_outline',
        iconColor: 0xFF15803D,
        iconBg: 0xFFE8F5E9,
        createdAt: now.subtract(const Duration(hours: 3)),
        deepLink: '/events/react-workshop',
      ),
      EventNotification(
        id: 'evt-3',
        title: 'Event Update',
        subtitle: 'Venue changed for Tech Meetup - now at Hall B',
        type: EventNotificationType.update,
        iconName: 'edit_outline',
        iconColor: 0xFF0284C7,
        iconBg: 0xFFE8F0FE,
        createdAt: now.subtract(const Duration(hours: 6)),
        deepLink: '/events/tech-meetup',
      ),
      EventNotification(
        id: 'evt-4',
        title: 'Waitlist Cleared',
        subtitle: 'You got a spot at AI Hackathon!',
        type: EventNotificationType.waitlist,
        iconName: 'celebration_outline',
        iconColor: 0xFFF59E0B,
        iconBg: 0xFFFFF8E1,
        createdAt: now.subtract(const Duration(days: 1)),
        deepLink: '/events/ai-hackathon',
      ),
      EventNotification(
        id: 'evt-5',
        title: 'Event Cancelled',
        subtitle: 'Startup Pitch Night has been cancelled by organizer',
        type: EventNotificationType.cancellation,
        iconName: 'cancel_outline',
        iconColor: 0xFFE04444,
        iconBg: 0xFFFDEBEB,
        createdAt: now.subtract(const Duration(days: 2)),
        deepLink: '/events/startup-pitch-night',
      ),
      EventNotification(
        id: 'evt-6',
        title: 'Certificate of Attendance',
        subtitle: 'Your certificate for UI/UX Design Masterclass is ready to download',
        body: 'Thank you for participating! Click here to download your verified certificate of completion.',
        type: EventNotificationType.system,
        iconName: 'notifications_outline',
        iconColor: 0xFF229ED9,
        iconBg: 0xFFF0F9FF,
        createdAt: now.subtract(const Duration(days: 3)),
        deepLink: '/events/uiux-masterclass',
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

  void deleteNotification(String notificationId) {
    final updated = state.notifications.where((n) => n.id != notificationId).toList();
    state = state.copyWith(notifications: updated);
  }

  void clearAll() {
    state = state.copyWith(notifications: []);
  }

  void setFilter(EventNotificationType? type) {
    state = state.copyWith(
      selectedFilter: type,
      clearFilter: type == null,
    );
  }

  void clearFilter() {
    state = state.copyWith(clearFilter: true);
  }
}