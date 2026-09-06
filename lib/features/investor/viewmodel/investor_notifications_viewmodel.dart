import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/notification_model.dart';
import '../model/investor_notification_state.dart';

class InvestorNotificationsViewModel extends StateNotifier<InvestorNotificationState> {
  InvestorNotificationsViewModel() : super(const InvestorNotificationState());

  void loadNotifications() {
    // Load once per session — reloading would wipe read states.
    if (state.notifications.isNotEmpty) return;
    final now = DateTime.now();
    final notifications = [
      InvestorNotification(
        id: 'inv-1',
        title: 'New Deal: Nova Robotics',
        subtitle: 'Series A round opened - \$1.2M target, 74% filled',
        type: InvestorNotificationType.deal,
        iconName: 'trending_up_outline',
        iconColor: 0xFFF59E0B,
        iconBg: 0xFFF0F9FF,
        createdAt: now.subtract(const Duration(minutes: 30)),
        deepLink: '/investor/deals/nova-robotics',
      ),
      InvestorNotification(
        id: 'inv-2',
        title: 'Pitch Deck Received',
        subtitle: 'FinEdge Seed round deck available for review',
        type: InvestorNotificationType.pitch,
        iconName: 'description_outline',
        iconColor: 0xFF0284C7,
        iconBg: 0xFFE8F0FE,
        createdAt: now.subtract(const Duration(hours: 2)),
        deepLink: '/investor/pitch-decks/finedge-seed',
      ),
      InvestorNotification(
        id: 'inv-3',
        title: 'Portfolio Update',
        subtitle: 'Nova Robotics valuation increased 2.3x since investment',
        type: InvestorNotificationType.portfolio,
        iconName: 'show_chart_outline',
        iconColor: 0xFF15803D,
        iconBg: 0xFFE8F5E9,
        createdAt: now.subtract(const Duration(hours: 6)),
        deepLink: '/investor/portfolio/nova-robotics',
      ),
      InvestorNotification(
        id: 'inv-4',
        title: 'Meeting Scheduled',
        subtitle: 'Call with Horizon Ventures tomorrow 10:00 AM',
        type: InvestorNotificationType.meeting,
        iconName: 'video_call_outline',
        iconColor: 0xFF229ED9,
        iconBg: 0xFFF0F9FF,
        createdAt: now.subtract(const Duration(days: 1)),
        deepLink: '/investor/meetings/horizon-ventures',
      ),
      InvestorNotification(
        id: 'inv-5',
        title: 'Market Alert',
        subtitle: 'Fintech sector funding up 40% QoQ in Q3 2024',
        type: InvestorNotificationType.market,
        iconName: 'insights_outline',
        iconColor: 0xFF64748B,
        iconBg: 0xFFF1F5F9,
        createdAt: now.subtract(const Duration(days: 2)),
        deepLink: '/investor/market/fintech-q3',
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

  void setFilter(InvestorNotificationType? type) {
    state = state.copyWith(
      selectedFilter: type,
      clearFilter: type == null,
    );
  }

  void clearFilter() {
    state = state.copyWith(clearFilter: true);
  }
}