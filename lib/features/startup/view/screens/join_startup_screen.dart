import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../model/startup_models.dart';
import 'join_startup_verification_screen.dart';


class JoinStartupScreen extends ConsumerStatefulWidget {
  const JoinStartupScreen({super.key});

  @override
  ConsumerState<JoinStartupScreen> createState() => _JoinStartupScreenState();
}

class _JoinStartupScreenState extends ConsumerState<JoinStartupScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showAll = false;
  SuggestedStartup? _selectedStartup;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (!mounted) return;
      ref.read(joinStartupViewModelProvider.notifier).loadInitialData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openVerification(SuggestedStartup startup) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JoinStartupVerificationScreen(startup: startup),
      ),
    );
  }

  String _searchHint(String selectedMode) {
    switch (selectedMode) {
      case 'Industry':
        return 'Search by industry (AI, Fintech, HealthTech...)';
      case 'Location':
        return 'Search by city or country...';
      case 'Stage':
        return 'Search by stage (Seed, Series A...)';
      default:
        return 'Search startups...';
    }
  }

  @override
  Widget build(BuildContext context) {
    final startupState = ref.watch(joinStartupViewModelProvider);
    final registryStartups = ref.watch(startupRegistryProvider);
    final allStartups = [...registryStartups, ...startupState.suggestedStartups];
    final filtered = ref.read(joinStartupViewModelProvider.notifier).filterStartups(_searchController.text, allStartups);
    final displayed = _showAll ? filtered : filtered.take(3).toList();


    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      body: CustomScrollView(
        slivers: [
          // Header gradient
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF006699),
                    Color(0xFF0088CC),
                    Color(0xFF0088CC),
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      const SizedBox(height: 20),
                      const Text(
                        'Join Existing Startup',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Search for the startup you want to join by name, ID, invitation code, or website.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Search bar
                      TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: _searchHint(startupState.selectedMode),
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Body content
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Quick Join Options
                const Text(
                  'QUICK JOIN OPTIONS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF9CA3AF),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _quickOptionCard(
                        icon: Icons.domain_add_outlined,
                        label: 'Startup Name',
                        subtitle: 'Search by name',
                        selected: startupState.selectedMode == 'Startup Name',
                        onTap: () {
                          ref.read(joinStartupViewModelProvider.notifier).selectMode('Startup Name');
                          _searchController.clear();
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _quickOptionCard(
                        icon: Icons.category_outlined,
                        label: 'Industry',
                        subtitle: 'AI, Fintech, Health...',
                        selected: startupState.selectedMode == 'Industry',
                        onTap: () {
                          ref.read(joinStartupViewModelProvider.notifier).selectMode('Industry');
                          _searchController.clear();
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _quickOptionCard(
                        icon: Icons.location_on_outlined,
                        label: 'Location',
                        subtitle: 'City or country',
                        selected: startupState.selectedMode == 'Location',
                        onTap: () {
                          ref.read(joinStartupViewModelProvider.notifier).selectMode('Location');
                          _searchController.clear();
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _quickOptionCard(
                        icon: Icons.trending_up_rounded,
                        label: 'Stage',
                        subtitle: 'Seed, Series A...',
                        selected: startupState.selectedMode == 'Stage',
                        onTap: () {
                          ref.read(joinStartupViewModelProvider.notifier).selectMode('Stage');
                          _searchController.clear();
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Suggested Startups
                Row(
                  children: [
                    const Text(
                      'SUGGESTED STARTUPS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF9CA3AF),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Spacer(),
                    if (filtered.length > 3)
                      TextButton(
                        onPressed: () => setState(() => _showAll = !_showAll),
                        child: Text(
                          _showAll ? 'Show Less' : 'View All (${filtered.length})',
                          style: const TextStyle(
                            color: Color(0xFF0088CC),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                ...displayed.map(
                  (startup) => _StartupCard(
                    startup: startup,
                    isSelected: _selectedStartup?.name == startup.name,
                    onTap: () => setState(() {
                      _selectedStartup = startup;
                    }),
                    onContinue: () => _openVerification(startup),
                  ),
                ),

                if (filtered.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.search_off_outlined,
                            size: 48,
                            color: Color(0xFFD1D5DB),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No startups found for "${_searchController.text}"',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    foregroundColor: const Color(0xFF374151),
                    side: const BorderSide(color: Color(0xFFD1D5DB)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _selectedStartup != null ? () => _openVerification(_selectedStartup!) : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    elevation: 0,
                    backgroundColor: const Color(0xFF0088CC),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFF9CA3AF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Next Step',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickOptionCard({
    required IconData icon,
    required String label,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE8F4FB) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFF0088CC) : const Color(0xFFE5E7EB),
            width: selected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? const Color(0xFF0088CC).withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF0088CC).withValues(alpha: 0.15)
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: selected ? const Color(0xFF0088CC) : const Color(0xFF6B7280),
                    size: 18,
                  ),
                ),
                const Spacer(),
                if (selected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF0088CC),
                    size: 18,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: selected ? const Color(0xFF0088CC) : const Color(0xFF12233D),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: selected ? const Color(0xFF229ED9).withValues(alpha: 0.7) : const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StartupCard extends StatelessWidget {
  const _StartupCard({
    required this.startup,
    required this.isSelected,
    required this.onTap,
    required this.onContinue,
  });
  final SuggestedStartup startup;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F4FB) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF0088CC) : Colors.transparent,
            width: isSelected ? 1.5 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF0088CC).withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.03),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0088CC), Color(0xFF0088CC)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      startup.name[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            startup.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF12233D),
                            ),
                          ),
                          const SizedBox(width: 6),
                        const Icon(
                          Icons.verified_rounded,
                          size: 16,
                          color: Color(0xFF0088CC),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 16,
                            color: Color(0xFF0088CC),
                          ),
                        ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${startup.industry} · ${startup.location}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F4FB),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    startup.stage,
                    style: const TextStyle(
                      color: Color(0xFF0088CC),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              startup.tagline,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              children: startup.tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6B7280),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.people_outline,
                  size: 14,
                  color: Color(0xFF9CA3AF),
                ),
                const SizedBox(width: 4),
                Text(
                  '${startup.teamMembers} Team Members',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    backgroundColor: const Color(0xFF0088CC),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    minimumSize: Size.zero,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
