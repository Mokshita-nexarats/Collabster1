import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/theme/investor_colors.dart';
import 'idea_phase_dashboard_screen.dart';
import 'startup_dashboard_screen.dart';

/// Compact workspace picker for all Startup-mode work owned by the user.
class YourStartupsScreen extends ConsumerWidget {
  const YourStartupsScreen({super.key});

  static const _ink = Color(0xFF13233B);
  static const _muted = Color(0xFF64748B);
  static const _primary = InvestorColors.goldPrimary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authViewModelProvider).session;
    final originalName = session?.originalStartupName?.trim() ?? '';
    final joinedName = session?.joinedStartupName?.trim() ?? '';
    final activeName = session?.startupName?.trim() ?? '';
    final createdName = originalName.isNotEmpty
        ? originalName
        : (joinedName.isEmpty ? activeName : '');
    final profiles = session?.ideaPhaseProfiles.isNotEmpty == true
        ? session!.ideaPhaseProfiles
        : (session?.activeIdeaPhaseData == null
              ? const <Map<String, dynamic>>[]
              : [session!.activeIdeaPhaseData!]);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: _ink),
          tooltip: 'Back',
        ),
        title: const Text(
          'Your Startups',
          style: TextStyle(color: _ink, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: InvestorColors.goldLight),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
        children: [
          const Text(
            'Workspaces in one place',
            style: TextStyle(
              color: _ink,
              fontSize: 25,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Open a registered startup, a joined team workspace, or an early-stage idea.',
            style: TextStyle(color: _muted, height: 1.4),
          ),
          if (createdName.isNotEmpty) ...[
            const SizedBox(height: 26),
            _sectionTitle('CREATED STARTUPS'),
            const SizedBox(height: 10),
            _workspaceTile(
              icon: Icons.rocket_launch_outlined,
              title: createdName,
              subtitle: 'Created startup workspace',
              label: 'Open dashboard',
              onTap: () async {
                if (originalName.isNotEmpty) {
                  await ref
                      .read(authViewModelProvider.notifier)
                      .switchStartup(joined: false);
                }
                if (!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        StartupDashboardScreen(startupName: createdName),
                  ),
                );
              },
            ),
          ],
          if (joinedName.isNotEmpty) ...[
            const SizedBox(height: 26),
            _sectionTitle('JOINED STARTUPS'),
            const SizedBox(height: 10),
            _workspaceTile(
              icon: Icons.groups_outlined,
              title: joinedName,
              subtitle: 'Joined team workspace',
              label: 'Open workspace',
              onTap: () async {
                await ref
                    .read(authViewModelProvider.notifier)
                    .switchStartup(joined: true);
                if (!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        StartupDashboardScreen(startupName: joinedName),
                  ),
                );
              },
            ),
          ],
          if (profiles.isNotEmpty) ...[
            const SizedBox(height: 26),
            _sectionTitle('IDEA PHASE WORKSPACES'),
            const SizedBox(height: 10),
            ...profiles.map((profile) {
              final id = profile['id']?.toString() ?? '';
              final name = _text(
                profile,
                'ideaName',
                fallback: 'Untitled idea',
              );
              final tagline = _text(profile, 'tagline');
              final active = id.isNotEmpty && id == session?.activeIdeaPhaseId;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _workspaceTile(
                  icon: Icons.lightbulb_outline_rounded,
                  title: name,
                  subtitle: tagline.isEmpty ? 'Idea Phase workspace' : tagline,
                  label: active ? 'Current workspace' : 'Open workspace',
                  active: active,
                  onTap: () async {
                    if (id.isNotEmpty) {
                      await ref
                          .read(authViewModelProvider.notifier)
                          .switchIdeaPhaseProfile(id);
                    }
                    if (!context.mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const IdeaPhaseDashboardScreen(),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
    title,
    style: const TextStyle(
      color: _muted,
      fontSize: 11,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.0,
    ),
  );

  Widget _workspaceTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String label,
    required VoidCallback onTap,
    bool active = false,
  }) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: active ? InvestorColors.goldSoft : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: active ? _primary : InvestorColors.border,
            width: active ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: active ? Colors.white : InvestorColors.goldSoft,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: _primary, size: 23),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _ink,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    label,
                    style: const TextStyle(
                      color: _primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Icon(Icons.arrow_forward_rounded, color: _primary),
            ),
          ],
        ),
      ),
    ),
  );

  static String _text(
    Map<String, dynamic> data,
    String key, {
    String fallback = '',
  }) {
    final value = data[key]?.toString().trim() ?? '';
    return value.isEmpty ? fallback : value;
  }
}
