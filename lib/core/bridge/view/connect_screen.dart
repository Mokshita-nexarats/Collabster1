import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/community/view/screens/posts_list_screen.dart';
import '../../../features/startup/view/screens/investor_pipeline_screen.dart';
import '../../../features/startup/view/screens/startup_posts_feed_screen.dart';
import '../../../features/investor/view/screens/deal_flow_screen.dart';
import '../../di/providers.dart';
import '../bridge_models.dart';
import '../bridge_state.dart';
import '../../../shared/enums/app_enums.dart';

const _bg = Color(0xFFF8FAFC);
const _textPrimary = Color(0xFF0F172A);
const _textSecondary = Color(0xFF64748B);
const _borderColor = Color(0xFFE2E8F0);

class ConnectTheme {
  final List<Color> gradientColors;
  final Color primaryColor;

  const ConnectTheme({
    required this.gradientColors,
    required this.primaryColor,
  });

  static ConnectTheme forRole(UserRole? role, String? modeTheme) {
    String modeKey = modeTheme?.toLowerCase() ?? '';
    if (modeKey.isEmpty && role != null) {
      if (role.isStartupRole) {
        modeKey = 'startup';
      } else if (role == UserRole.creator || role == UserRole.influencer) {
        modeKey = 'community';
      } else if (role == UserRole.investor) {
        modeKey = 'investor';
      } else {
        modeKey = 'startup';
      }
    }

    switch (modeKey) {
      case 'community':
        return const ConnectTheme(
          gradientColors: [Color(0xFF9A3412), Color(0xFFEA580C), Color(0xFFF97316)],
          primaryColor: Color(0xFFEA580C),
        );
      case 'investor':
        return const ConnectTheme(
          gradientColors: [Color(0xFF78350F), Color(0xFFD97706), Color(0xFFF59E0B)],
          primaryColor: Color(0xFFD97706),
        );
      case 'startup':
      default:
        return const ConnectTheme(
          gradientColors: [Color(0xFF4A0E8F), Color(0xFF6D28D9), Color(0xFF4F46E5)],
          primaryColor: Color(0xFF6D28D9),
        );
    }
  }
}

/// The Connection Bridge hub: one feed across Startup, Community & Investor.
/// Aggregates Startup hiring, Community & Startup posts,
/// and Investor connections — each tagged with its source.
class ConnectScreen extends ConsumerStatefulWidget {
  const ConnectScreen({super.key, this.modeTheme});
  final String? modeTheme;

  @override
  ConsumerState<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends ConsumerState<ConnectScreen> {
  int _tabIndex = 0;

  static const _allTabs = ['All', 'Opportunities', 'Posts', 'Investors', 'Deals', 'Notifications'];

  ConnectTheme get _theme {
    final session = ref.watch(authViewModelProvider).session;
    return ConnectTheme.forRole(session?.activeUserRole, widget.modeTheme);
  }

  List<String> get _visibleTabs {
    final session = ref.read(authViewModelProvider).session;
    final activeRole = session?.activeUserRole ?? UserRole.other;
    final showInvestorDeals = activeRole.isStartupRole || activeRole == UserRole.investor;

    if (showInvestorDeals) {
      return _allTabs;
    }
    return _allTabs.where((t) => t != 'Investors' && t != 'Deals').toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(bridgeViewModelProvider.notifier).loadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bridgeState = ref.watch(bridgeViewModelProvider);

    if (_tabIndex >= _visibleTabs.length) {
      _tabIndex = 0;
    }

    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _buildHeader(bridgeState),
          _buildTabBar(),
          Expanded(
            child: _buildTabContent(bridgeState),
          ),
        ],
      ),
    );
  }

  // ─── Header ─────────────────────────────────────────────────
  Widget _buildHeader(BridgeState state) {
    final topPadding = MediaQuery.of(context).padding.top;
    final theme = _theme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18, topPadding + 12, 18, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: theme.gradientColors,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Connect',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.alt_route_rounded, color: Colors.white, size: 15),
                    SizedBox(width: 5),
                    Text(
                      'All Modes',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'One feed across Startup, Community & Investors',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statChip(Icons.rocket_launch_rounded, '${state.startupCount}', 'Startup'),
              _statChip(Icons.forum_rounded, '${state.communityCount}', 'Community'),
              _statChip(Icons.trending_up_rounded, '${state.investors.length}', 'Investors'),
              _statChip(Icons.notifications_rounded, '${state.unreadNotifications}', 'Alerts'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white, size: 13),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ─── Tabs ───────────────────────────────────────────────────
  Widget _buildTabBar() {
    final primaryColor = _theme.primaryColor;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_visibleTabs.length, (i) {
            final isSelected = _tabIndex == i;
            return GestureDetector(
              onTap: () => setState(() => _tabIndex = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _visibleTabs[i],
                  style: TextStyle(
                    color: isSelected ? Colors.white : _textSecondary,
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ─── Content ────────────────────────────────────────────────
  Widget _buildTabContent(BridgeState state) {
    if (!state.isLoaded) {
      return Center(
        child: CircularProgressIndicator(color: _theme.primaryColor),
      );
    }

    final items = <Widget>[];
    final selectedTab = _visibleTabs[_tabIndex];
    final showAll = selectedTab == 'All';

    if (showAll || selectedTab == 'Opportunities') {
      final opportunities = state.opportunities;
      if (showAll || opportunities.isNotEmpty) {
        items.add(_sectionHeader(
          'Opportunities',
          'Startup hiring roles',
          onViewAll: () => _openTabByName('Opportunities'),
        ));
        if (opportunities.isEmpty) {
          items.add(_emptyRow('No open opportunities right now'));
        } else {
          items.addAll(opportunities.take(6).map(_buildOpportunityCard));
        }
      }
    }

    if (showAll || selectedTab == 'Posts') {
      final posts = state.posts;
      if (showAll || posts.isNotEmpty) {
        items.add(_sectionHeader(
          'Posts',
          'Startup updates + Community talks',
          onViewAll: () => _openTabByName('Posts'),
        ));
        if (posts.isEmpty) {
          items.add(_emptyRow('No posts yet — create one from Startup or Community'));
        } else {
          items.addAll(posts.take(6).map(_buildPostCard));
        }
      }
    }

    if (_visibleTabs.contains('Investors') && (showAll || selectedTab == 'Investors')) {
      final investors = state.investors;
      if (showAll || investors.isNotEmpty) {
        items.add(_sectionHeader(
          'Investors',
          'Startup pipeline + Investor network',
          onViewAll: () => _openTabByName('Investors'),
        ));
        if (investors.isEmpty) {
          items.add(_emptyRow('No investor connections yet'));
        } else {
          items.addAll(investors.take(6).map(_buildInvestorCard));
        }
      }
    }

    if (_visibleTabs.contains('Deals') && (showAll || selectedTab == 'Deals')) {
      final deals = state.fundingRounds;
      if (showAll || deals.isNotEmpty) {
        items.add(_sectionHeader(
          'Deals',
          'Live funding rounds + Startup raises',
          onViewAll: () => _openTabByName('Deals'),
        ));
        if (deals.isEmpty) {
          items.add(_emptyRow('No live deals at the moment'));
        } else {
          items.addAll(deals.take(6).map(_buildFundingRoundCard));
        }
      }
    }

    if (showAll || selectedTab == 'Notifications') {
      final notifications = state.notifications;
      if (showAll || notifications.isNotEmpty) {
        items.add(_sectionHeader(
          'Notifications',
          'Cross-mode alerts & updates',
          onViewAll: () => _openTabByName('Notifications'),
        ));
        if (notifications.isEmpty) {
          items.add(_emptyRow('No notifications yet'));
        } else {
          items.addAll(notifications.take(6).map(_buildNotificationCard));
        }
      }
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 40),
      children: items,
    );
  }

  void _openTabByName(String tabName) {
    final index = _visibleTabs.indexOf(tabName);
    if (index != -1) {
      setState(() => _tabIndex = index);
    }
  }

  Widget _sectionHeader(String title, String subtitle, {VoidCallback? onViewAll}) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: _textSecondary, fontSize: 11.5),
                ),
              ],
            ),
          ),
          if (onViewAll != null)
            GestureDetector(
              onTap: onViewAll,
              child: Text(
                'View all',
                style: TextStyle(
                  color: _theme.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _emptyRow(String message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: _textSecondary, fontSize: 12.5),
      ),
    );
  }

  // ─── Cards ──────────────────────────────────────────────────
  Widget _buildOpportunityCard(BridgeOpportunity opp) {
    final isStartup = opp.fromStartup;
    return _card(
      onTap: () {},
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isStartup ? const Color(0xFFF3E8FF) : const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              isStartup ? Icons.rocket_launch_rounded : Icons.work_rounded,
              color: isStartup ? const Color(0xFF6D28D9) : const Color(0xFF0284C7),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  opp.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${opp.company} • ${opp.location}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _textSecondary, fontSize: 11.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _sourceBadge('STARTUP', true),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              opp.salary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF15803D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(BridgePost post) {
    final isStartup = post.source == 'startup';
    return _card(
      onTap: () {
        if (isStartup) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StartupPostsFeedScreen(startupName: post.sourceLabel),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PostsListScreen()),
          );
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isStartup ? const Color(0xFFF3E8FF) : const Color(0xFFFFF4E6),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              isStartup ? Icons.rocket_launch_rounded : Icons.forum_rounded,
              color: isStartup ? const Color(0xFF6D28D9) : const Color(0xFFEA580C),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${post.authorName} • ${post.authorRole} • ${post.likes} likes',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _textSecondary, fontSize: 11.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _sourceBadge(isStartup ? 'STARTUP' : 'COMMUNITY', isStartup),
        ],
      ),
    );
  }

  Widget _buildInvestorCard(BridgeInvestor investor) {
    final isPipeline = investor.source == 'startup-pipeline';
    return _card(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const InvestorPipelineScreen()),
        );
      },
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isPipeline ? const Color(0xFFE0F2FE) : const Color(0xFFF3E8FF),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Center(
              child: Text(
                investor.initials,
                style: TextStyle(
                  color: isPipeline ? const Color(0xFF0284C7) : const Color(0xFF6D28D9),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  investor.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${investor.fund} • ${investor.amount}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _textSecondary, fontSize: 11.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              investor.status,
              style: const TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF15803D),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _sourceBadge(isPipeline ? 'PIPELINE' : 'INVESTOR', isPipeline),
        ],
      ),
    );
  }

  Widget _buildFundingRoundCard(BridgeFundingRound deal) {
    final isInvestorMode = deal.source == 'investor-mode';
    final color = isInvestorMode ? const Color(0xFF0284C7) : const Color(0xFF6D28D9);
    final bgColor = isInvestorMode ? const Color(0xFFE0F2FE) : const Color(0xFFF3E8FF);

    return _card(
      onTap: () {
        if (isInvestorMode) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DealFlowScreen(embedded: false)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const InvestorPipelineScreen()),
          );
        }
      },
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              Icons.attach_money_rounded,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deal.startup,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${deal.stage} • ${deal.sector} • ${deal.location}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _textSecondary, fontSize: 11.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${(deal.progress * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF15803D),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _sourceBadge(
            isInvestorMode ? 'DEAL FLOW' : 'STARTUP RAISE',
            isInvestorMode,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(BridgeNotification notification) {
    final isUnread = !notification.isRead;
    final sourceColors = {
      'startup': const Color(0xFF6D28D9),
      'community': const Color(0xFFEA580C),
      'investor': const Color(0xFFF59E0B),
    };
    final color = sourceColors[notification.source] ?? _textPrimary;
    final bgColor = sourceColors[notification.source]?.withValues(alpha: 0.1) ?? const Color(0xFFF3F4F6);

    return _card(
      onTap: () {
        // Mark as read logic could be added here
      },
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              _iconForType(notification.type),
              color: color,
              size: 20,
            ),
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
                        notification.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _textPrimary,
                          fontSize: 14,
                          fontWeight: isUnread ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  notification.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _textSecondary, fontSize: 11.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _sourceBadge(notification.source.toUpperCase(), true),
        ],
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'connection':
        return Icons.person_add_rounded;
      case 'message':
        return Icons.message_rounded;
      case 'milestone':
        return Icons.flag_rounded;
      case 'funding':
        return Icons.attach_money_rounded;
      case 'team':
        return Icons.groups_rounded;
      case 'document':
        return Icons.description_rounded;
      case 'system':
        return Icons.settings_rounded;
      case 'post':
        return Icons.article_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Widget _sourceBadge(String label, bool purple) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: purple ? const Color(0xFFEDE9FE) : const Color(0xFFE0F2FE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 8.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _card({required VoidCallback onTap, required Widget child}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _borderColor),
        ),
        child: child,
      ),
    );
  }
}