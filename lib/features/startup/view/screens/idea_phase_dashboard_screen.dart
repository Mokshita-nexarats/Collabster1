import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/theme/investor_colors.dart';
import '../../../auth/view/sign_in_screen.dart';
import '../../../../shared/widgets/mode_drawer.dart';
import '../../../../shared/widgets/mode_menu_bar.dart';
import '../../../../shared/widgets/role_switcher_sheet.dart';
import 'idea_phase_verification_screen.dart';
import 'notifications_screen.dart';

/// Saved workspace for an unincorporated idea. It keeps early-stage work
/// separate from the registered-company Startup dashboard.
class IdeaPhaseDashboardScreen extends ConsumerStatefulWidget {
  const IdeaPhaseDashboardScreen({super.key});

  @override
  ConsumerState<IdeaPhaseDashboardScreen> createState() =>
      _IdeaPhaseDashboardScreenState();
}

class _IdeaPhaseDashboardScreenState
    extends ConsumerState<IdeaPhaseDashboardScreen> {
  static const _primary = InvestorColors.goldPrimary;
  static const _deep = InvestorColors.goldDeep;
  static const _soft = InvestorColors.goldSoft;
  static const _ink = Color(0xFF13233B);
  static const _muted = Color(0xFF64748B);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authViewModelProvider).session;
    final data = session?.activeIdeaPhaseData ?? const <String, dynamic>{};
    final ideaName = _text(data, 'ideaName', fallback: 'Your idea');
    final founder = _text(
      data,
      'founderName',
      fallback: session?.fullName ?? 'Founder',
    );
    final photoPath = _text(data, 'profilePhotoPath');

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FCFF),
      drawer: _drawer(
        session?.fullName ?? founder,
        session?.email ?? '',
        photoPath,
      ),
      body: Column(
        children: [
          _workspaceHeader(ideaName, photoPath),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: KeyedSubtree(
                key: ValueKey(_selectedTab),
                child: _tabBody(data, founder, session?.email ?? ''),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ModeMenuBar(
        selectedIndex: _selectedTab,
        onTap: _selectTab,
        selectedColor: _primary,
        fabGradient: const [InvestorColors.goldPrimary, InvestorColors.gold],
        onFabTap: () => _showAddSignalSheet(data),
        items: const [
          ModeMenuItem(
            index: 0,
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: 'Home',
          ),
          ModeMenuItem(
            index: 1,
            icon: Icons.insights_outlined,
            activeIcon: Icons.insights_rounded,
            label: 'Progress',
          ),
          ModeMenuItem(
            index: 3,
            icon: Icons.auto_stories_outlined,
            activeIcon: Icons.auto_stories_rounded,
            label: 'Resources',
          ),
          ModeMenuItem(
            index: 4,
            icon: Icons.swap_horiz_rounded,
            activeIcon: Icons.swap_horiz_rounded,
            label: 'Switch',
          ),
        ],
      ),
    );
  }

  Widget _workspaceHeader(String ideaName, String photoPath) {
    return Container(
      decoration: const BoxDecoration(gradient: InvestorColors.headerGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
          child: Row(
            children: [
              ModeMenuButton(
                onTap: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'IDEA PHASE WORKSPACE',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      ideaName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          NotificationsScreen(startupName: ideaName),
                    ),
                  );
                },
                tooltip: 'Notifications',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.16),
                  foregroundColor: Colors.white,
                  fixedSize: const Size(42, 42),
                ),
                icon: const Icon(Icons.notifications_none_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabBody(
    Map<String, dynamic> data,
    String founder,
    String sessionEmail,
  ) {
    return switch (_selectedTab) {
      0 => _homeTab(data, founder),
      1 => _progressTab(data),
      3 => _resourcesTab(),
      _ => _profileTab(data, founder, sessionEmail),
    };
  }

  Widget _homeTab(Map<String, dynamic> data, String founder) {
    final ideaName = _text(data, 'ideaName', fallback: 'Your idea');
    final tagline = _text(data, 'tagline');
    final industries = _strings(data, 'industries');
    final validation = _strings(data, 'validation');

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
      children: [
        Text(
          'Good progress, ${_firstName(founder)}.',
          style: const TextStyle(
            color: _ink,
            fontSize: 25,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Keep validating while our team reviews your idea profile.',
          style: TextStyle(color: _muted, fontSize: 15, height: 1.4),
        ),
        const SizedBox(height: 20),
        _ideaCard(ideaName, tagline, industries),
        const SizedBox(height: 20),
        _sectionTitle(
          'Verification status',
          'Your profile is in the early-stage review queue.',
        ),
        const SizedBox(height: 12),
        _reviewStatusCard(),
        const SizedBox(height: 24),
        _sectionTitle(
          'Validation snapshot',
          'The signals you have already captured.',
        ),
        const SizedBox(height: 12),
        _metricRow(validation.length, industries.length),
        const SizedBox(height: 24),
        _sectionTitle(
          'Recommended next step',
          'One action can make your idea more concrete.',
        ),
        const SizedBox(height: 12),
        _focusCard(
          Icons.record_voice_over_outlined,
          'Speak with five potential users',
          'Listen for the problem in their words before choosing a solution.',
        ),
      ],
    );
  }

  Widget _progressTab(Map<String, dynamic> data) {
    final validation = _strings(data, 'validation');
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
      children: [
        _tabHeading(
          'Validation progress',
          'Build evidence step by step. Every signal makes your profile stronger.',
        ),
        const SizedBox(height: 22),
        _sectionTitle(
          'Review timeline',
          'We will notify you when the review is complete.',
        ),
        const SizedBox(height: 12),
        _timelineCard(),
        const SizedBox(height: 24),
        _sectionTitle(
          'Your signals',
          'Captured from your submitted verification.',
        ),
        const SizedBox(height: 12),
        _validationCard(validation),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () => _showAddSignalSheet(data),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add validation signal'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            foregroundColor: _primary,
            side: const BorderSide(color: _primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _resourcesTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
      children: [
        _tabHeading(
          'Founder resources',
          'Practical support for turning an early idea into a confident next step.',
        ),
        const SizedBox(height: 22),
        _resourceCard(
          Icons.forum_outlined,
          'Customer interview guide',
          'Plan focused conversations to discover real pain points.',
          'Start interviews',
        ),
        const SizedBox(height: 12),
        _resourceCard(
          Icons.draw_outlined,
          'Prototype checklist',
          'Build only what you need to test the core idea.',
          'View checklist',
        ),
        const SizedBox(height: 12),
        _resourceCard(
          Icons.group_add_outlined,
          'Find a collaborator',
          'Meet people with complementary skills for your idea.',
          'Explore network',
        ),
        const SizedBox(height: 12),
        _resourceCard(
          Icons.rocket_launch_outlined,
          'From idea to startup',
          'Understand the milestones before formal registration.',
          'See roadmap',
        ),
      ],
    );
  }

  Widget _profileTab(
    Map<String, dynamic> data,
    String founder,
    String sessionEmail,
  ) {
    final photoPath = _text(data, 'profilePhotoPath');
    final email = _text(data, 'founderEmail', fallback: sessionEmail);
    final phone = _text(data, 'founderPhone');
    final ideaName = _text(data, 'ideaName', fallback: 'Your idea');
    final problem = _text(data, 'problem');
    final website = _text(data, 'website');

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
          decoration: BoxDecoration(
            gradient: InvestorColors.goldGradient,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: _ProfileAvatar(photoPath: photoPath, radius: 42),
              ),
              const SizedBox(height: 13),
              Text(
                founder,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                email,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.82),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white38),
                ),
                child: const Text(
                  'IDEA PHASE FOUNDER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        _sectionTitle(
          'Contact information',
          'Details shared with the verification team.',
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: InvestorColors.border),
          ),
          child: Column(
            children: [
              _detailRow(Icons.person_outline_rounded, 'Founder', founder),
              const Divider(height: 26, color: InvestorColors.border),
              _detailRow(Icons.mail_outline_rounded, 'Email address', email),
              if (phone.isNotEmpty)
                const Divider(height: 26, color: InvestorColors.border),
              if (phone.isNotEmpty)
                _detailRow(Icons.phone_outlined, 'Mobile number', phone),
            ],
          ),
        ),
        const SizedBox(height: 26),
        _sectionTitle(
          'Idea ownership',
          'The early-stage workspace you submitted for review.',
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: InvestorColors.border),
          ),
          child: Column(
            children: [
              _detailRow(
                Icons.lightbulb_outline_rounded,
                'Idea workspace',
                ideaName,
              ),
              if (problem.isNotEmpty)
                const Divider(height: 26, color: InvestorColors.border),
              if (problem.isNotEmpty)
                _detailRow(Icons.manage_search_rounded, 'Problem', problem),
              if (website.isNotEmpty)
                const Divider(height: 26, color: InvestorColors.border),
              if (website.isNotEmpty)
                _detailRow(Icons.link_rounded, 'Link', website),
            ],
          ),
        ),
      ],
    );
  }

  Widget _ideaCard(String name, String tagline, List<String> industries) =>
      Container(
        padding: const EdgeInsets.all(21),
        decoration: BoxDecoration(
          gradient: InvestorColors.goldGradient,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                const Spacer(),
                _statusPill(),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (tagline.isNotEmpty) ...[
              const SizedBox(height: 7),
              Text(
                tagline,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.86),
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ],
            if (industries.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: industries.map(_tag).toList(),
              ),
            ],
          ],
        ),
      );

  Widget _reviewStatusCard() => Container(
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: InvestorColors.border),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.schedule_rounded, color: _primary, size: 24),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Under review',
                style: TextStyle(color: _ink, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 4),
              Text(
                'Usually completed within 1-2 days. We will notify you when your idea profile is ready.',
                style: TextStyle(color: _muted, fontSize: 13, height: 1.35),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _metricRow(int signals, int industries) => Row(
    children: [
      Expanded(
        child: _metricCard(
          Icons.insights_rounded,
          '$signals',
          'Validation signals',
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _metricCard(
          Icons.category_outlined,
          '$industries',
          'Focus industries',
        ),
      ),
    ],
  );

  Widget _metricCard(IconData icon, String value, String label) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: InvestorColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _primary, size: 22),
        const SizedBox(height: 14),
        Text(
          value,
          style: const TextStyle(
            color: _ink,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: _muted, fontSize: 12)),
      ],
    ),
  );

  Widget _focusCard(IconData icon, String title, String subtitle) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: _soft,
      borderRadius: BorderRadius.circular(17),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _primary, size: 23),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _deep,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: _deep,
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _timelineCard() => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: InvestorColors.border),
    ),
    child: const Column(
      children: [
        _TimelineRow(
          title: 'Idea submitted',
          subtitle: 'Your profile has been received',
          complete: true,
          last: false,
        ),
        _TimelineRow(
          title: 'Clarity and authenticity review',
          subtitle: 'Our team is currently reviewing your idea',
          active: true,
          last: false,
        ),
        _TimelineRow(
          title: 'Idea profile ready',
          subtitle: 'We will notify you when it is complete',
          last: true,
        ),
      ],
    ),
  );

  Widget _validationCard(List<String> signals) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: InvestorColors.border),
    ),
    child: signals.isEmpty
        ? const Text(
            'Add a signal to start tracking your validation.',
            style: TextStyle(color: _muted),
          )
        : Column(
            children: signals
                .map(
                  (signal) => Padding(
                    padding: const EdgeInsets.only(bottom: 13),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: _primary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            signal,
                            style: const TextStyle(color: _ink, height: 1.35),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
  );

  Widget _resourceCard(
    IconData icon,
    String title,
    String subtitle,
    String action,
  ) => Container(
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: InvestorColors.border),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _soft,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: _primary, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _ink,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                action,
                style: const TextStyle(
                  color: _primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _tabHeading(String title, String subtitle) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: _ink,
          fontSize: 25,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.4,
        ),
      ),
      const SizedBox(height: 6),
      Text(subtitle, style: const TextStyle(color: _muted, height: 1.4)),
    ],
  );

  Widget _sectionTitle(String title, String subtitle) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: _ink,
          fontSize: 19,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 4),
      Text(subtitle, style: const TextStyle(color: _muted, height: 1.35)),
    ],
  );

  Widget _detailRow(IconData icon, String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _primary, size: 20),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: _muted, fontSize: 12)),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: _ink,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _statusPill() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white24,
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: Colors.white38),
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.schedule_rounded, color: Colors.white, size: 15),
        SizedBox(width: 5),
        Text(
          'Under review',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );

  Widget _tag(String value) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.white24,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      value,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  Widget _drawer(String userName, String email, String photoPath) => ModeDrawer(
    userName: userName,
    email: email,
    photoPath: photoPath,
    headerGradient: const [InvestorColors.goldDeep, InvestorColors.gold],
    avatarColor: _primary,
    statusText: 'Idea Phase founder',
    items: [
      ModeDrawerItem(
        icon: Icons.home_outlined,
        label: 'Idea Dashboard',
        onTap: () => _selectFromDrawer(0),
      ),
      ModeDrawerItem(
        icon: Icons.insights_outlined,
        label: 'Validation Progress',
        onTap: () => _selectFromDrawer(1),
      ),
      ModeDrawerItem(
        icon: Icons.auto_stories_outlined,
        label: 'Resources',
        onTap: () => _selectFromDrawer(3),
      ),
      ModeDrawerItem(
        icon: Icons.person_outline_rounded,
        label: 'Founder Profile',
        onTap: () => _selectFromDrawer(4),
      ),
      ModeDrawerItem(
        icon: Icons.workspaces_outline,
        label: 'Switch idea workspace',
        onTap: _showWorkspaceSwitcher,
      ),
      ModeDrawerItem(
        icon: Icons.add_circle_outline_rounded,
        label: 'Create new idea',
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const IdeaPhaseVerificationScreen(),
            ),
          );
        },
      ),
    ],
    onLogout: _logout,
  );

  void _selectTab(int index) {
    if (index == 2) return;
    if (index == 4) {
      // Switch tab — founder profile lives in the side menu now.
      RoleSwitcherSheet.show(context);
      return;
    }
    setState(() => _selectedTab = index);
  }

  void _selectFromDrawer(int index) {
    Navigator.pop(context);
    // Drawer sets the tab directly — index 4 here means Founder Profile,
    // while bottom-nav 4 opens the role switcher (see _selectTab).
    if (index == 2) return;
    setState(() => _selectedTab = index);
  }

  Future<void> _showWorkspaceSwitcher() async {
    Navigator.pop(context);
    final session = ref.read(authViewModelProvider).session;
    final profiles = session?.ideaPhaseProfiles ?? const [];
    if (profiles.length < 2) {
      _showMessage('Create another idea to add a second workspace.');
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Switch idea workspace',
              style: TextStyle(
                color: _ink,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Choose the idea you want to work on.',
              style: TextStyle(color: _muted),
            ),
            const SizedBox(height: 12),
            ...profiles.map((profile) {
              final id = profile['id']?.toString() ?? '';
              final isActive = id == session?.activeIdeaPhaseId;
              final name = _text(
                profile,
                'ideaName',
                fallback: 'Untitled idea',
              );
              final tagline = _text(profile, 'tagline');
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isActive ? _soft : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.lightbulb_outline_rounded,
                    color: isActive ? _primary : _muted,
                  ),
                ),
                title: Text(
                  name,
                  style: TextStyle(
                    color: _ink,
                    fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
                subtitle: tagline.isEmpty ? null : Text(tagline, maxLines: 1),
                trailing: isActive
                    ? const Icon(Icons.check_circle_rounded, color: _primary)
                    : null,
                onTap: isActive || id.isEmpty
                    ? null
                    : () async {
                        await ref
                            .read(authViewModelProvider.notifier)
                            .switchIdeaPhaseProfile(id);
                        if (sheetContext.mounted) Navigator.pop(sheetContext);
                      },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _showAddSignalSheet(Map<String, dynamic> data) async {
    const options = [
      'I completed five customer interviews',
      'I tested a clickable prototype',
      'I gathered early waitlist sign-ups',
      'I mapped competing solutions',
    ];
    final current = _strings(data, 'validation');
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Add validation signal',
              style: TextStyle(
                color: _ink,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Choose what you have completed since submitting your idea.',
              style: TextStyle(color: _muted, height: 1.35),
            ),
            const SizedBox(height: 12),
            ...options.map(
              (option) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  current.contains(option)
                      ? Icons.check_circle_rounded
                      : Icons.add_circle_outline_rounded,
                  color: _primary,
                ),
                title: Text(
                  option,
                  style: const TextStyle(
                    color: _ink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: current.contains(option)
                    ? null
                    : () async {
                        final updated = Map<String, dynamic>.from(data);
                        updated['validation'] = [...current, option];
                        await ref
                            .read(authViewModelProvider.notifier)
                            .updateIdeaPhaseData(updated);
                        if (sheetContext.mounted) Navigator.pop(sheetContext);
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    Navigator.pop(context);
    await ref.read(authViewModelProvider.notifier).logout();
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SignInScreen()),
      (_) => false,
    );
  }

  static String _text(
    Map<String, dynamic> data,
    String key, {
    String fallback = '',
  }) {
    final value = data[key]?.toString().trim() ?? '';
    return value.isEmpty ? fallback : value;
  }

  static List<String> _strings(Map<String, dynamic> data, String key) {
    final value = data[key];
    return value is List
        ? value
              .map((item) => item.toString())
              .where((item) => item.isNotEmpty)
              .toList()
        : const [];
  }

  static String _firstName(String name) =>
      name.trim().split(RegExp(r'\s+')).first;
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.photoPath, required this.radius});

  final String photoPath;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final file = photoPath.isEmpty ? null : File(photoPath);
    final hasPhoto = file != null && file.existsSync();
    return CircleAvatar(
      radius: radius,
      backgroundColor: InvestorColors.goldSoft,
      backgroundImage: hasPhoto ? FileImage(file) : null,
      child: hasPhoto
          ? null
          : Icon(
              Icons.person_outline_rounded,
              color: InvestorColors.goldPrimary,
              size: radius,
            ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.title,
    required this.subtitle,
    required this.last,
    this.complete = false,
    this.active = false,
  });

  final String title;
  final String subtitle;
  final bool complete;
  final bool active;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final color = complete || active
        ? InvestorColors.goldPrimary
        : const Color(0xFFCBD5E1);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              complete
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_checked,
              color: color,
              size: 22,
            ),
            if (!last)
              Container(
                width: 2,
                height: 34,
                color: complete
                    ? InvestorColors.goldPrimary
                    : const Color(0xFFE2E8F0),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF13233B),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
