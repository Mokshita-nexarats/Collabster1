import 'package:flutter/material.dart';

/// Sticky top bar: avatar | search | bell(dot).
/// No role dropdown, no hamburger, no chat icon (messages live in bottom nav).
class HomeAppBar extends StatelessWidget {
  final String avatarLabel;
  final VoidCallback onAvatarTap;
  final VoidCallback onSearchTap;
  final VoidCallback onBellTap;
  final bool hasUnread;

  const HomeAppBar({
    super.key,
    this.avatarLabel = 'C',
    required this.onAvatarTap,
    required this.onSearchTap,
    required this.onBellTap,
    this.hasUnread = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: onAvatarTap,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFDBEAFE),
              child: Text(
                avatarLabel,
                style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: onSearchTap,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: const Row(
                  children: [
                    Icon(Icons.search_rounded,
                        size: 18, color: Color(0xFF9CA3AF)),
                    SizedBox(width: 8),
                    Text(
                      'Search Collabster',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          _iconButton(
            icon: Icons.notifications_none_rounded,
            showDot: hasUnread,
            onTap: onBellTap,
          ),
        ],
      ),
    );
  }

  Widget _iconButton({
    required IconData icon,
    required VoidCallback onTap,
    bool showDot = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, size: 24, color: const Color(0xFF111827)),
            if (showDot)
              Positioned(
                top: 1,
                right: 1,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
