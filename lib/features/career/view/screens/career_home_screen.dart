import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/view/sign_in_screen.dart';
import '../../../../core/di/providers.dart';
import '../../../../shared/enums/app_enums.dart';
import '../../../../shared/widgets/role_switcher_sheet.dart';

class CareerHomeScreen extends ConsumerWidget {
  const CareerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final session = authState.session;
    final userName = session?.fullName ?? 'Professional';
    final activeRole = session?.activeUserRole ?? UserRole.professional;

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
                    Color(0xFF006699),
                    Color(0xFF0088CC),
                    Color(0xFF006699),
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0088CC), Color(0xFF006699)],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              activeRole.icon,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome, $userName',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  activeRole.dashboardTitle,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.75),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => RoleSwitcherSheet.show(context),
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.swap_horiz_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () async {
                              await ref.read(authViewModelProvider.notifier).logout();
                              if (!context.mounted) return;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const SignInScreen()),
                              );
                            },
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.logout_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        activeRole.dashboardTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Explore opportunities and grow your career.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 13.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildStatRow(
                  const Color(0xFF006699),
                  [
                    _StatItem(value: '0', label: 'APPLICA\nTIONS'),
                    _StatItem(value: '0', label: 'SAVED\nJOBS'),
                    _StatItem(value: '0', label: 'INTERVIEWS\nSCHEDULED'),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSectionHeader('Quick Actions'),
                const SizedBox(height: 12),
                _buildActionGrid(context),
                const SizedBox(height: 24),
                _buildSectionHeader('Recommended For You'),
                const SizedBox(height: 12),
                _buildEmptyState(
                  Icons.work_rounded,
                  'No recommendations yet',
                  'Job listings and opportunities will appear here.',
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(Color color, List<_StatItem> stats) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withValues(alpha: 0.85)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: stats
            .map((stat) => Column(
                  children: [
                    Text(
                      stat.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stat.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: Color(0xFF12233D),
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    final actions = [
      _Action(icon: Icons.search_rounded, label: 'Find Jobs', color: const Color(0xFF006699)),
      _Action(icon: Icons.description_rounded, label: 'My Resume', color: const Color(0xFF229ED9)),
      _Action(icon: Icons.assignment_rounded, label: 'Applications', color: const Color(0xFFFF9800)),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 16, offset: Offset(0, 6)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: actions
            .map((a) => Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: a.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(a.icon, color: a.color, size: 26),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      a.label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF9CA3AF), size: 40),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _StatItem {
  const _StatItem({required this.value, required this.label});
  final String value;
  final String label;
}

class _Action {
  const _Action({required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;
}
