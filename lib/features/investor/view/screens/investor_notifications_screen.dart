import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/theme/investor_colors.dart';
import '../../model/notification_model.dart';
import 'deal_flow_screen.dart';
import 'investor_meetings_screen.dart';
import 'pitch_deck_screen.dart';
import 'portfolio_screen.dart';

class InvestorNotificationsScreen extends ConsumerStatefulWidget {
  const InvestorNotificationsScreen({super.key});

  @override
  ConsumerState<InvestorNotificationsScreen> createState() => _InvestorNotificationsScreenState();
}

class _InvestorNotificationsScreenState extends ConsumerState<InvestorNotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(investorNotificationsViewModelProvider.notifier).loadNotifications();
    });
  }

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  IconData _getIconForType(InvestorNotificationType type) {
    switch (type) {
      case InvestorNotificationType.deal:
        return Icons.trending_up_rounded;
      case InvestorNotificationType.pitch:
        return Icons.description_rounded;
      case InvestorNotificationType.portfolio:
        return Icons.pie_chart_rounded;
      case InvestorNotificationType.meeting:
        return Icons.video_call_rounded;
      case InvestorNotificationType.market:
        return Icons.insights_rounded;
      case InvestorNotificationType.system:
        return Icons.notifications_rounded;
    }
  }

  Color _getColorForType(InvestorNotificationType type) {
    switch (type) {
      case InvestorNotificationType.deal:
        return InvestorColors.goldDeep;
      case InvestorNotificationType.pitch:
        return const Color(0xFF0284C7);
      case InvestorNotificationType.portfolio:
        return const Color(0xFF15803D);
      case InvestorNotificationType.meeting:
        return const Color(0xFF229ED9);
      case InvestorNotificationType.market:
        return const Color(0xFF64748B);
      case InvestorNotificationType.system:
        return const Color(0xFF0088CC);
    }
  }

  void _handleNotificationTap(InvestorNotification notification) {
    ref.read(investorNotificationsViewModelProvider.notifier).markAsRead(notification.id);

    switch (notification.type) {
      case InvestorNotificationType.deal:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const DealFlowScreen(embedded: false),
          ),
        );
        break;
      case InvestorNotificationType.pitch:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PitchDeckScreen()),
        );
        break;
      case InvestorNotificationType.portfolio:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const PortfolioScreen(embedded: false),
          ),
        );
        break;
      case InvestorNotificationType.meeting:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const InvestorMeetingsScreen()),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(notification.title),
            backgroundColor: InvestorColors.goldDeep,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(investorNotificationsViewModelProvider);
    final notifications = state.filteredNotifications;
    final unreadCount = state.notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: InvestorColors.goldBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Executive Header Banner
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
                                  'Deal & Market Alerts',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Funding rounds, pitch decks & portfolio updates',
                                  style: TextStyle(color: Colors.white70, fontSize: 12.5),
                                ),
                              ],
                            ),
                          ),
                          if (unreadCount > 0)
                            GestureDetector(
                              onTap: () {
                                ref.read(investorNotificationsViewModelProvider.notifier).markAllAsRead();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('All alerts marked as read'),
                                    backgroundColor: InvestorColors.goldDeep,
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  'Mark $unreadCount read',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Type Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip(null, 'All (${state.notifications.length})'),
                            _buildFilterChip(InvestorNotificationType.deal, 'Deals'),
                            _buildFilterChip(InvestorNotificationType.pitch, 'Pitch Decks'),
                            _buildFilterChip(InvestorNotificationType.portfolio, 'Portfolio'),
                            _buildFilterChip(InvestorNotificationType.meeting, 'Meetings'),
                            _buildFilterChip(InvestorNotificationType.market, 'Market'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Notifications List
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (notifications.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: InvestorColors.border),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.notifications_off_outlined, size: 48, color: InvestorColors.textMuted),
                        SizedBox(height: 12),
                        Text(
                          'No alerts found',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: InvestorColors.ink),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'You have no deal or market notifications matching this filter.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12.5, color: InvestorColors.textMuted),
                        ),
                      ],
                    ),
                  )
                else
                  ...notifications.map((notif) {
                    final color = _getColorForType(notif.type);
                    final iconData = _getIconForType(notif.type);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: notif.isRead ? Colors.white : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: notif.isRead ? InvestorColors.border : color.withValues(alpha: 0.4),
                          width: notif.isRead ? 1.0 : 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: notif.isRead ? const Color(0x06000000) : color.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _handleNotificationTap(notif),
                          borderRadius: BorderRadius.circular(18),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(iconData, color: color, size: 22),
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
                                              notif.title,
                                              style: TextStyle(
                                                fontSize: 14.5,
                                                fontWeight: notif.isRead ? FontWeight.w700 : FontWeight.w900,
                                                color: InvestorColors.ink,
                                              ),
                                            ),
                                          ),
                                          if (!notif.isRead)
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
                                        notif.subtitle,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          height: 1.4,
                                          color: InvestorColors.inkSoft,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.access_time_rounded, size: 13, color: color.withValues(alpha: 0.8)),
                                          const SizedBox(width: 4),
                                          Text(
                                            _formatTimeAgo(notif.createdAt),
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w600,
                                              color: color.withValues(alpha: 0.8),
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            'View Details',
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w700,
                                              color: color,
                                            ),
                                          ),
                                          Icon(Icons.chevron_right_rounded, size: 15, color: color),
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
                    );
                  }),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(InvestorNotificationType? type, String label) {
    final state = ref.watch(investorNotificationsViewModelProvider);
    final isSelected = state.selectedFilter == type;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          ref.read(investorNotificationsViewModelProvider.notifier).setFilter(type);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? InvestorColors.ink : Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
