import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/di/providers.dart';
import '../../../model/event_notification_state.dart';
import '../../../model/notification_model.dart';
import 'event_home_screen.dart';

const _accent = Color(0xFF0088CC);
const _accentLight = Color(0xFF229ED9);
const _bg = Color(0xFFF8FAFC);
const _textPrimary = Color(0xFF0F172A);
const _textSecondary = Color(0xFF64748B);
const _borderColor = Color(0xFFE2E8F0);

class EventNotificationsScreen extends ConsumerStatefulWidget {
  const EventNotificationsScreen({super.key});

  @override
  ConsumerState<EventNotificationsScreen> createState() => _EventNotificationsScreenState();
}

class _EventNotificationsScreenState extends ConsumerState<EventNotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eventNotificationsViewModelProvider.notifier).loadNotifications();
    });
  }

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }

  IconData _getIconForType(EventNotificationType type) {
    switch (type) {
      case EventNotificationType.reminder:
        return Icons.schedule_rounded;
      case EventNotificationType.registration:
        return Icons.check_circle_outline_rounded;
      case EventNotificationType.update:
        return Icons.edit_note_rounded;
      case EventNotificationType.waitlist:
        return Icons.celebration_rounded;
      case EventNotificationType.cancellation:
        return Icons.cancel_outlined;
      case EventNotificationType.system:
        return Icons.notifications_active_outlined;
    }
  }

  Color _getColorForType(EventNotificationType type) {
    switch (type) {
      case EventNotificationType.reminder:
        return const Color(0xFF0088CC);
      case EventNotificationType.registration:
        return const Color(0xFF166534);
      case EventNotificationType.update:
        return const Color(0xFF0284C7);
      case EventNotificationType.waitlist:
        return const Color(0xFFD97706);
      case EventNotificationType.cancellation:
        return const Color(0xFFE11D48);
      case EventNotificationType.system:
        return const Color(0xFF229ED9);
    }
  }

  Color _getBgForType(EventNotificationType type) {
    switch (type) {
      case EventNotificationType.reminder:
        return const Color(0xFFEFF6FF);
      case EventNotificationType.registration:
        return const Color(0xFFDCFCE7);
      case EventNotificationType.update:
        return const Color(0xFFE0F2FE);
      case EventNotificationType.waitlist:
        return const Color(0xFFFEF3C7);
      case EventNotificationType.cancellation:
        return const Color(0xFFFFE4E6);
      case EventNotificationType.system:
        return const Color(0xFFF0F9FF);
    }
  }

  String _getActionTextForType(EventNotificationType type) {
    switch (type) {
      case EventNotificationType.reminder:
        return 'Join Event';
      case EventNotificationType.registration:
        return 'View Ticket';
      case EventNotificationType.update:
        return 'View Updates';
      case EventNotificationType.waitlist:
        return 'Claim Spot';
      case EventNotificationType.cancellation:
        return 'View Details';
      case EventNotificationType.system:
        return 'View Announcement';
    }
  }

  void _handleNotificationTap(EventNotification notification) {
    ref.read(eventNotificationsViewModelProvider.notifier).markAsRead(notification.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${notification.title}...'),
        backgroundColor: _accent,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Clear All Event Alerts',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _textPrimary,
          ),
        ),
        content: const Text(
          'Are you sure you want to clear all notifications? This action cannot be undone.',
          style: TextStyle(
            fontSize: 14,
            color: _textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: _textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(eventNotificationsViewModelProvider.notifier).clearAll();
            },
            child: const Text(
              'Clear All',
              style: TextStyle(
                color: Color(0xFFE11D48),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(eventNotificationsViewModelProvider);
    final notifications = state.filteredNotifications;

    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(state),
          _buildFilterChips(state),
          if (notifications.isEmpty)
            _buildEmptyState()
          else
            _buildNotificationsList(state, notifications),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(EventNotificationState state) {
    return SliverAppBar(
      pinned: true,
      centerTitle: false,
      backgroundColor: _accent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 19,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Event Notifications',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            'Schedule updates, tickets & reminders',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      actions: [
        if (state.unreadCount > 0)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: TextButton(
              onPressed: () {
                ref.read(eventNotificationsViewModelProvider.notifier).markAllAsRead();
              },
              child: const Text(
                'Mark read',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        if (state.notifications.isNotEmpty)
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.white70,
              size: 22,
            ),
            onPressed: _showClearAllDialog,
          ),
        const SizedBox(width: 4),
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_accentLight, _accent],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(EventNotificationState state) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.unreadCount > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: _accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${state.unreadCount} unread update${state.unreadCount > 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: _accent,
                      ),
                    ),
                  ],
                ),
              ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildFilterChip(null, 'All (${state.notifications.length})', state.selectedFilter),
                  const SizedBox(width: 8),
                  _buildFilterChip(EventNotificationType.reminder, 'Reminders', state.selectedFilter),
                  const SizedBox(width: 8),
                  _buildFilterChip(EventNotificationType.registration, 'Registrations', state.selectedFilter),
                  const SizedBox(width: 8),
                  _buildFilterChip(EventNotificationType.update, 'Updates', state.selectedFilter),
                  const SizedBox(width: 8),
                  _buildFilterChip(EventNotificationType.waitlist, 'Waitlist', state.selectedFilter),
                  const SizedBox(width: 8),
                  _buildFilterChip(EventNotificationType.cancellation, 'Cancellations', state.selectedFilter),
                  const SizedBox(width: 8),
                  _buildFilterChip(EventNotificationType.system, 'System', state.selectedFilter),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    EventNotificationType? type,
    String label,
    EventNotificationType? currentFilter,
  ) {
    final isSelected = currentFilter == type;
    return GestureDetector(
      onTap: () {
        ref.read(eventNotificationsViewModelProvider.notifier).setFilter(type);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? _accent : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _accent : _borderColor,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: _accent.withValues(alpha: 0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? Colors.white : _textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  size: 40,
                  color: _accent,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'No event notifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You\'re all caught up! Updates regarding workshops, meetups, and hackathons will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: _textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const EventHomeScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                  decoration: BoxDecoration(
                    color: _accent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _accent.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.explore_outlined, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Explore Events',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsList(
    EventNotificationState state,
    List<EventNotification> notifications,
  ) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final notification = notifications[index];
            return _buildNotificationCard(notification);
          },
          childCount: notifications.length,
        ),
      ),
    );
  }

  Widget _buildNotificationCard(EventNotification notification) {
    final color = _getColorForType(notification.type);
    final bg = _getBgForType(notification.type);
    final icon = _getIconForType(notification.type);
    final actionText = _getActionTextForType(notification.type);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        ref.read(eventNotificationsViewModelProvider.notifier).deleteNotification(notification.id);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFE11D48),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : bg.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notification.isRead ? _borderColor : color.withValues(alpha: 0.4),
            width: notification.isRead ? 1.0 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _handleNotificationTap(notification),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: notification.isRead ? FontWeight.w700 : FontWeight.w900,
                                  color: _textPrimary,
                                ),
                              ),
                            ),
                            if (!notification.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.only(left: 6),
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: _textSecondary,
                            height: 1.4,
                            fontWeight: notification.isRead ? FontWeight.w400 : FontWeight.w500,
                          ),
                        ),
                        if (notification.body.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: _borderColor),
                            ),
                            child: Text(
                              notification.body,
                              style: const TextStyle(
                                fontSize: 12,
                                color: _textSecondary,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    actionText,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: color,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(Icons.arrow_forward_rounded, size: 13, color: color),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _formatTimeAgo(notification.createdAt),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: _textSecondary,
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
        ),
      ),
    );
  }
}
