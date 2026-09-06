import 'dart:io';

import 'package:flutter/material.dart';

/// One row inside [ModeDrawer].
class ModeDrawerItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ModeDrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

/// Shared side menu — the same design as Community mode's drawer:
/// gradient profile header, plain item list, red log-out footer.
///
/// Each mode keeps its own [headerGradient], [avatarColor] and [items].
class ModeDrawer extends StatelessWidget {
  const ModeDrawer({
    super.key,
    required this.userName,
    required this.email,
    this.photoPath = '',
    required this.headerGradient,
    required this.avatarColor,
    this.statusText = 'online',
    required this.items,
    required this.onLogout,
    this.logoutLabel = 'Log Out',
  });

  final String userName;
  final String email;
  final String photoPath;
  final List<Color> headerGradient;
  final Color avatarColor;
  final String statusText;
  final List<ModeDrawerItem> items;
  final VoidCallback onLogout;
  final String logoutLabel;

  String _initials(String name) {
    final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    if (parts.isNotEmpty) return parts[0][0].toUpperCase();
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoPath.isNotEmpty && File(photoPath).existsSync();

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: headerGradient.length >= 2
                    ? [headerGradient.first, headerGradient.last]
                    : [headerGradient.first, headerGradient.first],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          hasPhoto ? FileImage(File(photoPath)) : null,
                      child: hasPhoto
                          ? null
                          : Text(
                              _initials(userName),
                              style: TextStyle(
                                color: avatarColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (email.isNotEmpty)
                      Text(
                        email,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    const SizedBox(height: 2),
                    Text(
                      statusText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                for (final item in items)
                  ListTile(
                    leading: Icon(
                      item.icon,
                      color: const Color(0xFF707579),
                      size: 22,
                    ),
                    title: Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF111111),
                      ),
                    ),
                    onTap: item.onTap,
                    dense: true,
                  ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEF1F4)),
          ListTile(
            leading: const Icon(
              Icons.logout_rounded,
              color: Colors.redAccent,
              size: 22,
            ),
            title: Text(
              logoutLabel,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.redAccent,
              ),
            ),
            onTap: onLogout,
            dense: true,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

/// Hamburger button for mode headers (white-on-gradient, matches the
/// other header action buttons).
class ModeMenuButton extends StatelessWidget {
  final VoidCallback onTap;

  const ModeMenuButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.menu_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}
