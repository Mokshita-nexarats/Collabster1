import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import '../../model/startup_models.dart';
import 'team_chat_screen.dart';
import 'team_member_profile_screen.dart';
import '../widgets/startup_color_helper.dart';

class TeamCommandScreen extends ConsumerStatefulWidget {
  const TeamCommandScreen({
    super.key,
    required this.startupName,
    this.autoOpenInviteSheet = false,
  });
  final String startupName;
  final bool autoOpenInviteSheet;

  @override
  ConsumerState<TeamCommandScreen> createState() => _TeamCommandScreenState();
}

class _TeamCommandScreenState extends ConsumerState<TeamCommandScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(teamViewModelProvider.notifier).selectCategory(_tabController.index);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(teamViewModelProvider.notifier).loadInitialData();
      if (widget.autoOpenInviteSheet) {
        showInviteSheet(context);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openProfile(TeamMember member) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TeamMemberProfileScreen(
          member: member,
          startupName: widget.startupName,
        ),
      ),
    );
  }

  void _showContactSheet(BuildContext context, TeamMember member) {
    final memberEmail = member.email ??
        '${member.name.toLowerCase().replaceAll(' ', '.')}@${widget.startupName.toLowerCase().replaceAll(' ', '')}.com';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFFE8F4FB),
                  child: Text(
                    member.initials,
                    style: const TextStyle(
                      color: Color(0xFF0088CC),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF12233D),
                        ),
                      ),
                      Text(
                        member.role,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: StartupColorHelper.fromKey(member.badgeColorKey).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    member.badge,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: StartupColorHelper.fromKey(member.badgeColorKey),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.mail_outline,
                      color: Color(0xFF0088CC), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      memberEmail,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF12233D),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Copied $memberEmail to clipboard!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Copy',
                        style: TextStyle(
                          color: Color(0xFF0088CC),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, a1, a2) => TeamChatScreen(
                            member: member,
                            startupName: widget.startupName,
                          ),
                          transitionsBuilder: (_, anim, __, child) =>
                              SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                                parent: anim,
                                curve: Curves.easeOutCubic)),
                            child: child,
                          ),
                          transitionDuration:
                              const Duration(milliseconds: 320),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_rounded, size: 18),
                    label: const Text('Message'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0088CC),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Drafting email to $memberEmail'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.email_outlined, size: 18),
                    label: const Text('Email'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF12233D),
                      side: const BorderSide(color: Color(0xFFD1D5DB)),
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showInviteSheet(BuildContext context) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final roleCtrl = TextEditingController();
    final deptCtrl = TextEditingController();
    String selectedBadge = 'CORE TEAM';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (modalCtx, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(modalCtx).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4FB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.person_add_rounded,
                          color: Color(0xFF0088CC),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Invite Team Member',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF12233D),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      hintText: 'Full Name (e.g. Alex Morgan)',
                      prefixIcon: const Icon(Icons.person_outline),
                      filled: true,
                      fillColor: const Color(0xFFF0F9FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email Address (e.g. alex@company.com)',
                      prefixIcon: const Icon(Icons.mail_outline),
                      filled: true,
                      fillColor: const Color(0xFFF0F9FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: roleCtrl,
                    decoration: InputDecoration(
                      hintText: 'Role / Title (e.g. Lead Frontend Engineer)',
                      prefixIcon: const Icon(Icons.work_outline),
                      filled: true,
                      fillColor: const Color(0xFFF0F9FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: deptCtrl,
                    decoration: InputDecoration(
                      hintText: 'Department (e.g. Engineering / Tech)',
                      prefixIcon: const Icon(Icons.business_outlined),
                      filled: true,
                      fillColor: const Color(0xFFF0F9FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Member Category',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _badgeChip(setModalState, 'FOUNDER', selectedBadge,
                          (b) => selectedBadge = b),
                      const SizedBox(width: 8),
                      _badgeChip(setModalState, 'CORE TEAM', selectedBadge,
                          (b) => selectedBadge = b),
                      const SizedBox(width: 8),
                      _badgeChip(setModalState, 'MEMBER', selectedBadge,
                          (b) => selectedBadge = b),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final email = emailCtrl.text.trim();
                        final name = nameCtrl.text.trim();
                        if (email.isEmpty || name.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please enter full name and email address.'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }
                        final words = name.split(RegExp(r'\s+'));
                        final initials = words
                            .take(2)
                            .map((w) => w.isNotEmpty ? w[0] : '')
                            .join()
                            .toUpperCase();
                        final role = roleCtrl.text.trim();
                        final dept = deptCtrl.text.trim();

                        final badgeColorKey = selectedBadge == 'FOUNDER'
                            ? 'founder'
                            : (selectedBadge == 'CORE TEAM'
                                ? 'coreTeam'
                                : 'teal');

                        final newMember = TeamMember(
                          name: name,
                          role: role.isEmpty ? 'Team Member' : role,
                          department: dept.isEmpty ? 'General' : dept,
                          badge: selectedBadge,
                          badgeColorKey: badgeColorKey,
                          initials: initials.isEmpty ? 'U' : initials,
                          email: email,
                        );

                        ref.read(teamViewModelProvider.notifier).addMember(newMember);

                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Invite sent to $email & $name added to Team Members!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.send_rounded, size: 18),
                      label: const Text(
                        'Send Invite & Add Member',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        backgroundColor: const Color(0xFF0088CC),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _badgeChip(
    StateSetter setModalState,
    String badge,
    String currentSelected,
    ValueChanged<String> onSelect,
  ) {
    final selected = badge == currentSelected;
    return GestureDetector(
      onTap: () => setModalState(() => onSelect(badge)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF0088CC) : const Color(0xFFF0F9FF),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color:
                selected ? const Color(0xFF0088CC) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          badge,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF4B5563),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teamState = ref.watch(teamViewModelProvider);
    final members = teamState.filteredMembers;
    final totalMembers = teamState.members;

    final smallTeamMembers = [
      const TeamMember(
        name: 'Sarah Miller',
        role: 'Lead Designer',
        department: 'Design / UX',
        badge: 'CORE TEAM',
        badgeColorKey: 'blue',
        initials: 'SM',
        email: 'sarah.miller@collabster.io',
      ),
      const TeamMember(
        name: 'David Kim',
        role: 'Engineer',
        department: 'Engineering / Backend',
        badge: 'CORE TEAM',
        badgeColorKey: 'blue',
        initials: 'DK',
        email: 'david.kim@collabster.io',
      ),
      const TeamMember(
        name: 'Emma Wilson',
        role: 'Product Manager',
        department: 'Product / Strategy',
        badge: 'MEMBER',
        badgeColorKey: 'teal',
        initials: 'EW',
        email: 'emma.wilson@collabster.io',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0088CC),
                    Color(0xFF229ED9),
                    Color(0xFF229ED9),
                  ],
                ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                left: 20,
                right: 20,
                bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Team Members',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'YOUR TEAM',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '${totalMembers.length} Team Members',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _statBox(
                                '${totalMembers.length}', 'FULL-TIME'),
                            _divider(),
                            _statBox('6', 'PART-TIME'),
                            _divider(),
                            _statBox('${totalMembers.length}', 'ACTIVE'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      padding: const EdgeInsets.all(2),
                      labelPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      indicator: BoxDecoration(
                        color: const Color(0xFF0088CC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.white,
                      unselectedLabelColor: const Color(0xFF6B7280),
                      labelStyle: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: 'All'),
                        Tab(text: 'Founders'),
                        Tab(text: 'Core Team'),
                        Tab(text: 'Employees'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Leadership',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF12233D),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= members.length) return null;
                final member = members[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: _MemberCard(
                    member: member,
                    onContact: () => _showContactSheet(context, member),
                    onFollow: () => ref.read(teamViewModelProvider.notifier).toggleFollow(member),
                    onProfile: () => _openProfile(member),
                  ),
                );
              },
              childCount: members.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Team',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF12233D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...smallTeamMembers.map(
                    (m) => _SmallMemberTile(
                      name: m.name,
                      role: m.role,
                      status:
                          m.badge == 'MEMBER' ? 'Part-time' : 'Full-time',
                      initials: m.initials,
                      onTap: () => _openProfile(m),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _statBox(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 40,
        color: Colors.white.withValues(alpha: 0.2),
      );
}

class _MemberCard extends StatelessWidget {
  const _MemberCard({
    required this.member,
    required this.onContact,
    required this.onFollow,
    required this.onProfile,
  });
  final TeamMember member;
  final VoidCallback onContact;
  final VoidCallback onFollow;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    final isFollowing = member.isFollowing;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onProfile,
            child: CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFFE0F2FE),
              child: Text(
                member.initials,
                style: const TextStyle(
                  color: Color(0xFF0088CC),
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: onProfile,
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          member.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF12233D),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: StartupColorHelper.fromKey(member.badgeColorKey).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          member.badge,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: StartupColorHelper.fromKey(member.badgeColorKey),
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    member.role,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                  ),
                  Text(
                    member.department,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              GestureDetector(
                onTap: onContact,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD1D5DB)),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Contact',
                    style: TextStyle(
                      color: Color(0xFF374151),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: onFollow,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isFollowing
                        ? const Color(0xFFE8F4FB)
                        : const Color(0xFF0088CC),
                    borderRadius: BorderRadius.circular(999),
                    border: isFollowing
                        ? Border.all(color: const Color(0xFF229ED9))
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isFollowing) ...[
                        const Icon(
                          Icons.check_rounded,
                          size: 12,
                          color: Color(0xFF0088CC),
                        ),
                        const SizedBox(width: 3),
                      ],
                      Text(
                        isFollowing ? 'Following' : 'Follow',
                        style: TextStyle(
                          color: isFollowing
                              ? const Color(0xFF0088CC)
                              : Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
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

class _SmallMemberTile extends StatelessWidget {
  const _SmallMemberTile({
    required this.name,
    required this.role,
    required this.status,
    required this.initials,
    required this.onTap,
  });

  final String name, role, status, initials;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFE0F2FE),
              child: Text(
                initials,
                style: const TextStyle(
                  color: Color(0xFF0088CC),
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF12233D),
                    ),
                  ),
                  Text(
                    '$role · $status',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }
}
