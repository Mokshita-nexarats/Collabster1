import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../shared/widgets/mode_drawer.dart';
import '../../../../shared/widgets/role_switcher_sheet.dart';
import '../../../auth/view/screens/profile_screen.dart';
import '../../../auth/view/sign_in_screen.dart';
import 'collabster_home_body.dart';
import 'explore_screen.dart';
import 'feed_messages_screen.dart';
import 'home_feed_item.dart';
import 'my_posts_screen.dart';
import 'widgets/home_bottom_nav.dart';

/// Universal Feed screen — one feed for every user, any role.
///
/// Opened from the Switch Tab sheet (not a role/mode itself).
/// Bell opens the shared notifications view; avatar opens this drawer.
class CollabsterHomeScreen extends ConsumerStatefulWidget {
  final HomeRole activeRole;

  const CollabsterHomeScreen({
    super.key,
    this.activeRole = HomeRole.startup,
  });

  @override
  ConsumerState<CollabsterHomeScreen> createState() =>
      _CollabsterHomeScreenState();
}

class _CollabsterHomeScreenState extends ConsumerState<CollabsterHomeScreen> {
  int _nav = 0;
  final _bodyKey = GlobalKey<CollabsterHomeBodyState>();

  void _onNavTap(int index) {
    if (index == 2) return; // center + handled by onCreate
    if (index == 4) {
      RoleSwitcherSheet.show(context);
      return;
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ExploreScreen()),
      );
      return;
    }
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const FeedMessagesScreen()),
      );
      return;
    }
    setState(() => _nav = index);
  }

  Future<void> _logout() async {
    Navigator.pop(context);
    await ref.read(authViewModelProvider.notifier).logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authViewModelProvider).session;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: ModeDrawer(
        userName: session?.fullName ?? 'Member',
        email: session?.email ?? '',
        photoPath: session?.profilePhotoPath ?? '',
        headerGradient: const [Color(0xFF2563EB), Color(0xFF3B82F6)],
        avatarColor: const Color(0xFF2563EB),
        items: [
          ModeDrawerItem(
            icon: Icons.person_outline_rounded,
            label: 'My Profile',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
          ModeDrawerItem(
            icon: Icons.article_outlined,
            label: 'My Posts',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyPostsScreen()),
            ),
          ),
          ModeDrawerItem(
            icon: Icons.swap_horiz_rounded,
            label: 'Switch Tab',
            onTap: () {
              Navigator.pop(context);
              RoleSwitcherSheet.show(context);
            },
          ),
        ],
        onLogout: _logout,
      ),
      body: SafeArea(
        bottom: false,
        child: CollabsterHomeBody(key: _bodyKey, activeRole: widget.activeRole),
      ),
      bottomNavigationBar: HomeBottomNav(
        selected: _nav,
        onTap: _onNavTap,
        onCreate: () => _bodyKey.currentState?.openCreate(),
      ),
    );
  }
}
