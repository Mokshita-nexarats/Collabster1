import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/theme/app_assets.dart';
import '../../career/view/screens/notifications_screen.dart';
import 'activity_screen.dart';
import 'saved_items_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MainDrawer – left-side navigation panel ("Main Components")
// ─────────────────────────────────────────────────────────────────────────────

class MainDrawer extends ConsumerStatefulWidget {
  const MainDrawer({super.key, this.activeRoute = 'feed'});

  /// Identifies which nav item is currently selected.
  final String activeRoute;

  @override
  ConsumerState<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends ConsumerState<MainDrawer> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _activeRoute = '';

  // Section collapse states
  bool _knowledgeExpanded = true;
  bool _personalExpanded = true;

  static const _kPurple     = Color(0xFF4338CA);
  static const _kPurpleLight = Color(0xFFEEF2FF);
  static const _kTextDark   = Color(0xFF111827);
  static const _kTextMid    = Color(0xFF6B7280);
  static const _kTextSub    = Color(0xFF9CA3AF);
  static const _kBorder     = Color(0xFFE5E7EB);
  static const _kBg         = Color(0xFFF8F9FC);

  @override
  void initState() {
    super.initState();
    _activeRoute = widget.activeRoute;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _navigate(String route) {
    setState(() => _activeRoute = route);
    if (route == 'saved') {
      Navigator.pop(context); // Close drawer
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SavedItemsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState  = ref.watch(authViewModelProvider);
    final session    = authState.session;
    final userName   = session?.fullName ?? 'Member';
    final roleLabel  = session?.activeUserRole.label ?? 'Supporter';
    final photoPath  = session?.profilePhotoPath ?? '';
    final hasPhoto   = photoPath.isNotEmpty && File(photoPath).existsSync();

    String initials(String n) {
      final p = n.split(' ').where((s) => s.isNotEmpty).toList();
      if (p.length >= 2) return '${p[0][0]}${p[1][0]}'.toUpperCase();
      return p.isNotEmpty ? p[0][0].toUpperCase() : '?';
    }

    return Drawer(
      width: 290,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────────────────
            _buildHeader(context),

            // ── Search ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: _buildSearch(),
            ),

            // ── Nav sections ──────────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 16),
                children: [
                  _sectionLabel('COMMAND CENTER'),
                  const SizedBox(height: 4),
                  _navItem('feed',       Icons.dynamic_feed_rounded,    'Feed'),
                  _navItem('investor',   Icons.trending_up_rounded,      'Investor'),
                  _navItem('learn',      Icons.school_outlined,           'Learn'),
                  _navItem('career',     Icons.work_outline_rounded,      'Career'),
                  _navItem('events',     Icons.event_outlined,            'Events'),
                  _navItem('service',    Icons.design_services_outlined,  'Service'),
                  _navItem('enterprise', Icons.grid_view_rounded,         'Enterprise'),

                  const SizedBox(height: 8),
                  _collapsibleSection(
                    label: 'KNOWLEDGE & GROWTH',
                    expanded: _knowledgeExpanded,
                    onToggle: () => setState(() => _knowledgeExpanded = !_knowledgeExpanded),
                    children: [
                      _navItem('testimonials',   Icons.format_quote_rounded,         'Testimonials'),
                      _navItem('resource_vault', Icons.inventory_2_outlined,          'Resource Vault'),
                      _navItem('ai_assistant',   Icons.auto_awesome_rounded,          'AI Assistant',
                          accentOverride: const Color(0xFF7C3AED)),
                    ],
                  ),

                  const SizedBox(height: 8),
                  _collapsibleSection(
                    label: 'PERSONAL CIRCLE & STATUS',
                    expanded: _personalExpanded,
                    onToggle: () => setState(() => _personalExpanded = !_personalExpanded),
                    children: [
                      _navItem('my_network', Icons.group_outlined,       'My Network'),
                      _navItem('saved',      Icons.bookmark_outline_rounded, 'Saved'),
                      _navItem('support',    Icons.help_outline_rounded,  'Help and Support'),
                    ],
                  ),
                ],
              ),
            ),

            // ── Footer: user card ─────────────────────────────────────────
            _buildFooter(context, userName, roleLabel, hasPhoto, photoPath, initials),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      child: Row(
        children: [
          // Brand logo + name
          Image.asset(AppAssets.appLogo, width: 28, height: 28, fit: BoxFit.contain),
          const SizedBox(width: 8),
          const Text(
            'Collabster',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: _kPurple,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          // Close
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _kBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.close_rounded, size: 18, color: _kTextMid),
            ),
          ),
          const SizedBox(width: 8),
          // Mail
          _headerIcon(Icons.mail_outline_rounded),
          const SizedBox(width: 6),
          // Notification
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _headerIcon(Icons.notifications_none_rounded),
                Positioned(
                  top: -1,
                  right: -1,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerIcon(IconData icon, {VoidCallback? onTap}) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _kBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _kBorder),
          ),
          child: Icon(icon, size: 17, color: _kTextMid),
        ),
      );

  // ── Search ─────────────────────────────────────────────────────────────────

  Widget _buildSearch() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: _kPurpleLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _searchCtrl,
        style: const TextStyle(fontSize: 13, color: _kTextDark),
        decoration: InputDecoration(
          hintText: 'Search navigation...',
          hintStyle: const TextStyle(fontSize: 13, color: _kTextSub),
          prefixIcon: const Icon(Icons.search_rounded, size: 18, color: _kTextSub),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  // ── Section label ──────────────────────────────────────────────────────────

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: _kTextSub,
        ),
      ),
    );
  }

  // ── Collapsible section ────────────────────────────────────────────────────

  Widget _collapsibleSection({
    required String label,
    required bool expanded,
    required VoidCallback onToggle,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onToggle,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: _kTextSub,
                    ),
                  ),
                ),
                Icon(
                  expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: _kTextSub,
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Column(children: children),
          secondChild: const SizedBox.shrink(),
        ),
      ],
    );
  }

  // ── Nav item ───────────────────────────────────────────────────────────────

  Widget _navItem(
    String route,
    IconData icon,
    String label, {
    Color? accentOverride,
  }) {
    final isActive = _activeRoute == route;
    final accent = accentOverride ?? _kPurple;

    return GestureDetector(
      onTap: () => _navigate(route),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? _kPurpleLight : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? accent : _kTextMid,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? accent : _kTextDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Footer ─────────────────────────────────────────────────────────────────

  Widget _buildFooter(
    BuildContext context,
    String userName,
    String roleLabel,
    bool hasPhoto,
    String photoPath,
    String Function(String) initials,
  ) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: _kBorder)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User row — tapping avatar/name opens Activity screen
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // close drawer first
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ActivityScreen()),
              );
            },
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 20,
                  backgroundColor: _kPurpleLight,
                  backgroundImage: hasPhoto ? FileImage(File(photoPath)) : null,
                  child: hasPhoto
                      ? null
                      : Text(
                          initials(userName),
                          style: const TextStyle(
                            color: _kPurple,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: _kTextDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            margin: const EdgeInsets.only(right: 4, top: 1),
                            decoration: const BoxDecoration(
                              color: Color(0xFF22C55E),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              roleLabel,
                              style: const TextStyle(fontSize: 11, color: _kTextSub),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Settings gear — separate tap zone, does NOT trigger activity nav
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _kBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _kBorder),
                    ),
                    child: const Icon(Icons.settings_outlined, size: 16, color: _kTextMid),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // View All row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('2 hours ago', style: TextStyle(fontSize: 11, color: _kTextSub)),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _kPurple,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
