import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// NotificationsScreen – Exact design matching the Notification Section screenshot
// ─────────────────────────────────────────────────────────────────────────────

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All', 'Jobs', 'Interviews', 'System & Promos'];

  static const _kPurple = Color(0xFF229ED9);
  static const _kTextDark = Color(0xFF0F172A);
  static const _kTextMid = Color(0xFF64748B);

  late List<_NotificationData> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = [
      _NotificationData(
        id: '1',
        title: 'Limited Time Offer: 50% Off Pro',
        time: 'Just now',
        category: 'System & Promos',
        body:
            'Upgrade to ResuAI Pro for just \$9.99/mo. Unlock unlimited mock interviews and advanced resume optimization.',
        icon: Icons.local_offer_rounded,
        accentColor: const Color(0xFF229ED9),
        bgColor: const Color(0xFFE8F4FB),
        primaryActionText: 'Upgrade Now',
        secondaryActionText: 'Dismiss',
      ),
      _NotificationData(
        id: '2',
        title: 'Interview Confirmed!',
        time: '2h ago',
        category: 'Interviews',
        body:
            'Google scheduled your technical round for Monday, Oct 19 at 10:00 AM.',
        icon: Icons.calendar_month_rounded,
        accentColor: const Color(0xFF229ED9),
        bgColor: const Color(0xFFE8F4FB),
        primaryActionText: 'Join Lobby',
        secondaryActionText: 'View Schedule',
      ),
      _NotificationData(
        id: '3',
        title: '98% Match Found',
        time: 'Yesterday',
        category: 'Jobs',
        body:
            'Airbnb just posted a Remote React Developer role matching your exact skills stack.',
        icon: Icons.auto_awesome_rounded,
        accentColor: const Color(0xFF10B981),
        bgColor: const Color(0xFFECFDF5),
        primaryActionText: 'Quick Apply',
        secondaryActionText: 'Dismiss',
      ),
      _NotificationData(
        id: '4',
        title: 'New message from David Chen (Meta)',
        time: '5h ago',
        category: 'System & Promos',
        body:
            '"Hi Alex, great performance in our mock! I\'ve uploaded your full feedback sheet."',
        icon: Icons.chat_bubble_rounded,
        accentColor: const Color(0xFF229ED9),
        bgColor: const Color(0xFFE8F4FB),
        primaryActionText: 'Reply',
        secondaryActionText: 'Open Chat',
      ),
      _NotificationData(
        id: '5',
        title: 'Saved Job Closing Soon',
        time: 'URGENT',
        isUrgent: true,
        category: 'Jobs',
        body:
            'The Backend Engineer role you saved at Figma stops accepting responses in 4 hours.',
        icon: Icons.hourglass_top_rounded,
        accentColor: const Color(0xFFF59E0B),
        bgColor: const Color(0xFFFFFBEB),
        primaryActionText: 'Apply Now',
      ),
      _NotificationData(
        id: '6',
        title: 'Application Status Update',
        time: '2 days ago',
        category: 'Jobs',
        body:
            'Stripe has closed the application for Frontend Engineer. Thank you for applying.',
        icon: Icons.work_rounded,
        accentColor: const Color(0xFF64748B),
        bgColor: const Color(0xFFF8FAFC),
        secondaryActionText: 'View Similar Jobs',
      ),
    ];
  }

  List<_NotificationData> get _filteredNotifications {
    final filter = _filters[_selectedFilterIndex];
    if (filter == 'All') return _notifications;
    return _notifications.where((n) => n.category == filter).toList();
  }

  void _dismissNotification(String id) {
    setState(() {
      _notifications.removeWhere((n) => n.id == id);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notification dismissed'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredNotifications;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Navigation Bar ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: _kPurple,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Title ──────────────────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: _kTextDark,
                  letterSpacing: -0.4,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Category Filter Tabs (With Active Underline Indicator) ─────
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 20),
                itemBuilder: (context, index) {
                  final selected = _selectedFilterIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilterIndex = index),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _filters[index],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                            color: selected ? _kPurple : _kTextMid,
                          ),
                        ),
                        const SizedBox(height: 6),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 3,
                          width: selected ? 24 : 0,
                          decoration: BoxDecoration(
                            color: _kPurple,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),

            // ── Notifications List ─────────────────────────────────────────
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                      physics: const BouncingScrollPhysics(),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return _buildNotificationCard(filtered[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Card Builder ───────────────────────────────────────────────────────────

  Widget _buildNotificationCard(_NotificationData data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: data.accentColor, width: 4),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon box
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: data.bgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(data.icon, color: data.accentColor, size: 20),
                  ),
                  const SizedBox(width: 12),

                  // Title & Time
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                data.title,
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w800,
                                  color: _kTextDark,
                                  height: 1.25,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              data.time,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: data.isUrgent ? FontWeight.w800 : FontWeight.w600,
                                color: data.isUrgent ? const Color(0xFFDC2626) : _kTextMid,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          data.body,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: _kTextMid,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Action Buttons Row
              if (data.primaryActionText != null || data.secondaryActionText != null) ...[
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (data.primaryActionText != null)
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${data.primaryActionText} clicked'),
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: data.accentColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          child: Text(data.primaryActionText!),
                        ),
                      if (data.secondaryActionText != null)
                        GestureDetector(
                          onTap: () {
                            if (data.secondaryActionText == 'Dismiss') {
                              _dismissNotification(data.id);
                            } else {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${data.secondaryActionText} clicked'),
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                            child: Text(
                              data.secondaryActionText!,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: _kTextMid,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F4FB),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_none_rounded, size: 36, color: _kPurple),
          ),
          const SizedBox(height: 16),
          const Text(
            'No notifications',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _kTextDark),
          ),
          const SizedBox(height: 6),
          const Text(
            'You\'re all caught up for this category!',
            style: TextStyle(fontSize: 13, color: _kTextMid),
          ),
        ],
      ),
    );
  }
}

class _NotificationData {
  final String id;
  final String title;
  final String time;
  final bool isUrgent;
  final String category;
  final String body;
  final IconData icon;
  final Color accentColor;
  final Color bgColor;
  final String? primaryActionText;
  final String? secondaryActionText;

  _NotificationData({
    required this.id,
    required this.title,
    required this.time,
    this.isUrgent = false,
    required this.category,
    required this.body,
    required this.icon,
    required this.accentColor,
    required this.bgColor,
    this.primaryActionText,
    this.secondaryActionText,
  });
}
