import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import '../../model/startup_models.dart';
import 'network_person_profile_screen.dart';
import 'network_startup_profile_screen.dart';

class StartupNetworkScreen extends ConsumerStatefulWidget {
  const StartupNetworkScreen({super.key, required this.startupName});
  final String startupName;

  @override
  ConsumerState<StartupNetworkScreen> createState() =>
      _StartupNetworkScreenState();
}

class _StartupNetworkScreenState extends ConsumerState<StartupNetworkScreen> {
  final TextEditingController _searchController = TextEditingController();

  final Set<String> _connectedStartupNames = {};
  final Set<String> _connectedPersonNames = {};

  // ── Sample data ────────────────────────────────────────────────────────────
  final List<SuggestedStartup> _suggestedStartups = [
    const SuggestedStartup(
      name: 'GreenLeaf Energy',
      industry: 'CleanTech',
      location: 'Bangalore',
      teamMembers: 12,
      stage: 'Seed',
      tags: ['Sustainability', 'B2B'],
    ),
    const SuggestedStartup(
      name: 'FinServe Pro',
      industry: 'FinTech',
      location: 'Mumbai',
      teamMembers: 28,
      stage: 'Series A',
      tags: ['Payments', 'SaaS'],
    ),
    const SuggestedStartup(
      name: 'HealthBridge',
      industry: 'HealthTech',
      location: 'Delhi',
      teamMembers: 8,
      stage: 'Pre-Seed',
      tags: ['Telemedicine', 'AI'],
    ),
    const SuggestedStartup(
      name: 'EduSpark',
      industry: 'EdTech',
      location: 'Hyderabad',
      teamMembers: 15,
      stage: 'Seed',
      tags: ['Online Learning', 'B2C'],
    ),
  ];

  final List<_NetworkPerson> _people = [
    const _NetworkPerson(
      name: 'Vikram Singh',
      role: 'Founder & CEO',
      company: 'CodeCraft Labs',
      initials: 'VS',
      color: Color(0xFF0088CC),
      mutualConnections: 4,
    ),
    const _NetworkPerson(
      name: 'Meera Reddy',
      role: 'VP Engineering',
      company: 'DataSphere',
      initials: 'MR',
      color: Color(0xFF2563EB),
      mutualConnections: 7,
    ),
    const _NetworkPerson(
      name: 'Arjun Nair',
      role: 'Product Manager',
      company: 'InnoLab',
      initials: 'AN',
      color: Color(0xFF059669),
      mutualConnections: 2,
    ),
    const _NetworkPerson(
      name: 'Sneha Gupta',
      role: 'Marketing Lead',
      company: 'BrandWave',
      initials: 'SG',
      color: Color(0xFFD97706),
      mutualConnections: 5,
    ),
    const _NetworkPerson(
      name: 'Karthik Menon',
      role: 'Co-Founder',
      company: 'CloudSync',
      initials: 'KM',
      color: Color(0xFFE11D48),
      mutualConnections: 3,
    ),
    const _NetworkPerson(
      name: 'Divya Iyer',
      role: 'UX Designer',
      company: 'PixelCraft',
      initials: 'DI',
      color: Color(0xFF0088CC),
      mutualConnections: 6,
    ),
  ];

  List<_NetworkPerson> get _filteredPeople {
    return _people.where(_matchesSearch).toList();
  }

  List<_NetworkPerson> get _filteredAcceptedPeople => ref
      .read(requestsViewModelProvider)
      .accepted
      .map(_personFromAcceptedRequest)
      .where(_matchesSearch)
      .toList();

  bool _matchesSearch(_NetworkPerson person) {
    final query = _searchController.text.toLowerCase();
    return query.isEmpty ||
        person.name.toLowerCase().contains(query) ||
        person.company.toLowerCase().contains(query) ||
        person.role.toLowerCase().contains(query);
  }

  _NetworkPerson _personFromAcceptedRequest(ConnectionRequest request) {
    final roleParts = request.role.split(' • ');
    final accent = switch (request.category) {
      'Investor' => const Color(0xFFD97706),
      'Founder' => const Color(0xFF0088CC),
      'Mentor' => const Color(0xFF0088CC),
      _ => const Color(0xFF059669),
    };

    return _NetworkPerson(
      name: request.name,
      role: roleParts.first,
      company: roleParts.skip(1).join(' • ').isEmpty
          ? 'Startup Network'
          : roleParts.skip(1).join(' • '),
      initials: request.initials,
      color: accent,
      mutualConnections: request.mutualConnections,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openStartupProfile(SuggestedStartup startup, Color accent) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NetworkStartupProfileScreen(
          startup: startup,
          accent: accent,
          isConnected: _connectedStartupNames.contains(startup.name),
          onConnect: () => setState(() {
            if (_connectedStartupNames.contains(startup.name)) {
              _connectedStartupNames.remove(startup.name);
            } else {
              _connectedStartupNames.add(startup.name);
            }
          }),
        ),
      ),
    );
  }

  void _openPersonProfile(_NetworkPerson person) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NetworkPersonProfileScreen(
          name: person.name,
          role: person.role,
          company: person.company,
          initials: person.initials,
          color: person.color,
          mutualConnections: person.mutualConnections,
          isConnected: _connectedPersonNames.contains(person.name),
          onConnect: () => setState(() {
            if (_connectedPersonNames.contains(person.name)) {
              _connectedPersonNames.remove(person.name);
            } else {
              _connectedPersonNames.add(person.name);
            }
          }),
        ),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(requestsViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      body: CustomScrollView(
        slivers: [
          // ── App Bar ────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            centerTitle: true,
            backgroundColor: const Color(0xFF0088CC),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Network',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            actions: [],
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF229ED9), Color(0xFF006699)],
                ),
              ),
            ),
          ),

          // ── Search bar ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF12233D),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search people, startups...',
                    hintStyle: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF9CA3AF),
                      size: 20,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Color(0xFF9CA3AF),
                              size: 18,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Stats row ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Row(
                children: [
                  _statCard(
                    '${state.connected}',
                    'Connections',
                    const Color(0xFF0088CC),
                    Icons.people_rounded,
                    null,
                  ),
                  const SizedBox(width: 10),
                  _statCard(
                    '${state.pendingCount}',
                    'Pending',
                    const Color(0xFFD97706),
                    Icons.pending_actions_rounded,
                    null,
                  ),
                  const SizedBox(width: 10),
                  _statCard(
                    '12',
                    'Following',
                    const Color(0xFF059669),
                    Icons.bookmark_border_rounded,
                    null,
                  ),
                ],
              ),
            ),
          ),

          // ── Connection Requests preview ────────────────────────────────

          // ── Suggested Startups ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 10),
              child: _sectionHeader(
                'Suggested Startups',
                'Based on your industry',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 215,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _suggestedStartups.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => _startupCard(_suggestedStartups[i]),
              ),
            ),
          ),

          // ── People You May Know ────────────────────────────────────────
          if (_filteredAcceptedPeople.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 22, 16, 10),
                child: _sectionHeader(
                  'New Connections',
                  '${_filteredAcceptedPeople.length} added',
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _personCard(_filteredAcceptedPeople[i]),
                  childCount: _filteredAcceptedPeople.length,
                ),
              ),
            ),
          ],
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 10),
              child: _sectionHeader(
                'People You May Know',
                '${_filteredPeople.length} people',
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _personCard(_filteredPeople[i]),
                childCount: _filteredPeople.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  // ── Section header ─────────────────────────────────────────────────────────
  Widget _sectionHeader(String title, String sub) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF12233D),
          ),
        ),
        const Spacer(),
        Text(
          sub,
          style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
        ),
      ],
    );
  }

  // ── Stats card ─────────────────────────────────────────────────────────────
  Widget _statCard(
    String value,
    String label,
    Color color,
    IconData icon,
    VoidCallback? onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
            border: onTap != null
                ? Border.all(color: color.withValues(alpha: 0.2))
                : null,
          ),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Suggested startup card ─────────────────────────────────────────────────
  static const List<Color> _startupColors = [
    Color(0xFF0088CC),
    Color(0xFF059669),
    Color(0xFF0088CC),
    Color(0xFFD97706),
  ];

  Widget _startupCard(SuggestedStartup startup) {
    final idx = _suggestedStartups.indexOf(startup);
    final accent = _startupColors[idx % _startupColors.length];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _openStartupProfile(startup, accent),
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.rocket_launch_rounded,
                      color: accent,
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      startup.stage,
                      style: TextStyle(
                        fontSize: 10,
                        color: accent,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                startup.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF12233D),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${startup.industry} • ${startup.location}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  for (
                    var index = 0;
                    index < startup.tags.take(2).length;
                    index++
                  ) ...[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          startup.tags[index],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF374151),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    if (index < startup.tags.take(2).length - 1)
                      const SizedBox(width: 4),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final isConnected = _connectedStartupNames.contains(
                      startup.name,
                    );
                    setState(() {
                      if (isConnected) {
                        _connectedStartupNames.remove(startup.name);
                      } else {
                        _connectedStartupNames.add(startup.name);
                      }
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isConnected
                              ? 'Disconnected from ${startup.name}'
                              : 'Connection request sent to ${startup.name}!',
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _connectedStartupNames.contains(startup.name)
                        ? const Color(0xFFF3F4F6)
                        : accent,
                    foregroundColor:
                        _connectedStartupNames.contains(startup.name)
                        ? const Color(0xFF6B7280)
                        : Colors.white,
                    minimumSize: const Size.fromHeight(34),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    _connectedStartupNames.contains(startup.name)
                        ? 'Pending'
                        : 'Connect',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── People card ─────────────────────────────────────────────────────────────
  Widget _personCard(_NetworkPerson person) {
    final isAccepted = ref
        .read(requestsViewModelProvider)
        .accepted
        .any((request) => request.name == person.name);
    final isPending = _connectedPersonNames.contains(person.name);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openPersonProfile(person),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: person.color.withValues(alpha: 0.12),
                child: Text(
                  person.initials,
                  style: TextStyle(
                    color: person.color,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      person.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF12233D),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${person.role} · ${person.company}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 12,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${person.mutualConnections} mutual',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: isAccepted
                    ? null
                    : () {
                        final isConnected = _connectedPersonNames.contains(
                          person.name,
                        );
                        setState(() {
                          if (isConnected) {
                            _connectedPersonNames.remove(person.name);
                          } else {
                            _connectedPersonNames.add(person.name);
                          }
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isConnected
                                  ? 'Connection cancelled for ${person.name}'
                                  : 'Connection request sent to ${person.name}!',
                            ),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isAccepted || isPending
                        ? const Color(0xFFF3F4F6)
                        : person.color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isAccepted || isPending
                          ? const Color(0xFFE5E7EB)
                          : person.color.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    isAccepted
                        ? 'Connected'
                        : isPending
                        ? 'Pending'
                        : 'Connect',
                    style: TextStyle(
                      color: isAccepted || isPending
                          ? const Color(0xFF6B7280)
                          : person.color,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Model ──────────────────────────────────────────────────────────────────────
class _NetworkPerson {
  final String name;
  final String role;
  final String company;
  final String initials;
  final Color color;
  final int mutualConnections;

  const _NetworkPerson({
    required this.name,
    required this.role,
    required this.company,
    required this.initials,
    required this.color,
    required this.mutualConnections,
  });
}
