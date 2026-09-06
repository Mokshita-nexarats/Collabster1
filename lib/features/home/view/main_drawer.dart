import 'package:flutter/material.dart';

import '../../../core/theme/app_assets.dart';
import '../../auth/view/screens/profile_screen.dart';
import 'saved_items_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MainDrawer – left-side navigation panel ("Main Components")
// ─────────────────────────────────────────────────────────────────────────────

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key, this.activeRoute = 'feed'});

  /// Identifies which nav item is currently selected.
  final String activeRoute;

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String _activeRoute = '';

  // Section collapse states
  bool _knowledgeExpanded = true;
  bool _personalExpanded = true;

  static const _kPurple = Color(0xFF4338CA);
  static const _kPurpleLight = Color(0xFFEEF2FF);
  static const _kTextDark = Color(0xFF111827);
  static const _kTextMid = Color(0xFF6B7280);
  static const _kTextSub = Color(0xFF9CA3AF);
  static const _kBg = Color(0xFFF8F9FC);

  @override
  void initState() {
    super.initState();
    _activeRoute = widget.activeRoute;
  }

  @override
  void dispose() {
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
    } else if (route == 'profile') {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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

            // ── Nav sections ──────────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 16),
                children: [
                  _collapsibleSection(
                    label: 'KNOWLEDGE & GROWTH',
                    expanded: _knowledgeExpanded,
                    onToggle: () => setState(
                      () => _knowledgeExpanded = !_knowledgeExpanded,
                    ),
                    children: [
                      _navItem(
                        'testimonials',
                        Icons.format_quote_rounded,
                        'Testimonials',
                      ),
                      _navItem(
                        'resource_vault',
                        Icons.inventory_2_outlined,
                        'Resource Vault',
                      ),
                      _navItem(
                        'ai_assistant',
                        Icons.auto_awesome_rounded,
                        'AI Assistant',
                        accentOverride: const Color(0xFF7C3AED),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  _collapsibleSection(
                    label: 'PERSONAL CIRCLE & STATUS',
                    expanded: _personalExpanded,
                    onToggle: () =>
                        setState(() => _personalExpanded = !_personalExpanded),
                    children: [
                      _navItem(
                        'my_network',
                        Icons.group_outlined,
                        'My Network',
                      ),
                      _navItem(
                        'saved',
                        Icons.bookmark_outline_rounded,
                        'Saved',
                      ),
                      _navItem(
                        'profile',
                        Icons.person_outline_rounded,
                        'Profile',
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
          Image.asset(
            AppAssets.appLogo,
            width: 28,
            height: 28,
            fit: BoxFit.contain,
          ),
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
              child: const Icon(
                Icons.close_rounded,
                size: 18,
                color: _kTextMid,
              ),
            ),
          ),
        ],
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
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: _kTextSub,
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: expanded
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
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
            Icon(icon, size: 18, color: isActive ? accent : _kTextMid),
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
}
