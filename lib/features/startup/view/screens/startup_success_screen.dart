import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'startup_dashboard_screen.dart';
import 'startup_public_profile_screen.dart';

class StartupSuccessScreen extends ConsumerWidget {
  const StartupSuccessScreen({
    super.key,
    required this.startupName,
    required this.selectedRole,
    required this.completion,
    this.industry = '',
    this.stage = '',
    this.tagline = '',
    this.country = '',
    this.city = '',
    this.legalStructure = '',
  });

  final String startupName;
  final String selectedRole;
  final int completion;
  final String industry;
  final String stage;
  final String tagline;
  final String country;
  final String city;
  final String legalStructure;

  String _orDash(String v) => v.trim().isEmpty ? '—' : v.trim();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jurisdictionParts = [
      city.trim(),
      country.trim(),
    ].where((s) => s.isNotEmpty).toList();
    final jurisdiction =
        jurisdictionParts.isEmpty ? '—' : jurisdictionParts.join(', ');

    void openDashboard({bool replace = true}) {
      final route = MaterialPageRoute(
        builder: (context) => StartupDashboardScreen(startupName: startupName),
      );
      if (replace) {
        Navigator.of(context).pushReplacement(route);
      } else {
        Navigator.of(context).push(route);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 55, 20, 20),
                child: Column(
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.rocket_launch,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Your company is ready to\nlaunch.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF12233D),
                      ),
                    ),
                    const SizedBox(height: 13),
                    const Text(
                      'All steps completed successfully.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                    const SizedBox(height: 34),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(
                          color: const Color(0xFFBAE6FD),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0F2FE),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.business,
                                  color: Color(0xFF0284C7),
                                  size: 25,
                                ),
                              ),
                              const SizedBox(width: 13),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      startupName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF12233D),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      _orDash(legalStructure),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF5D6472),
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      _orDash(stage),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF5D6472),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE7F8EA),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 14,
                                      color: Color(0xFF4CAF50),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Verified',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF2E7D32),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          const Divider(
                            color: Color(0xFFBAE6FD),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _CompanyInfo(
                                  title: 'Industry',
                                  value: _orDash(industry),
                                ),
                              ),
                              Expanded(
                                child: _CompanyInfo(
                                  title: 'Jurisdiction',
                                  value: jurisdiction,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 34),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'NEXT STEPS',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0284C7),
                        ),
                      ),
                    ),
                    const SizedBox(height: 13),
                    _nextStep(
                      icon: Icons.grid_view_rounded,
                      title: 'Manage your company',
                      onTap: () => openDashboard(replace: false),
                    ),
                    const SizedBox(height: 9),
                    _nextStep(
                      icon: Icons.group_add_outlined,
                      title: 'Hire talent',
                      onTap: () => openDashboard(replace: false),
                    ),
                    const SizedBox(height: 9),
                    _nextStep(
                      icon: Icons.event_available_outlined,
                      title: 'Connect with investors',
                      onTap: () => openDashboard(replace: false),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFBAE6FD),
                  ),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => openDashboard(),
                      icon: const Icon(
                        Icons.rocket_launch_outlined,
                        size: 18,
                      ),
                      label: const Text(
                        'Launch Company Workspace',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0284C7),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StartupPublicProfileScreen(
                              startupName: startupName,
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF25283A),
                        side: const BorderSide(
                          color: Color(0xFFBAE6FD),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'View Public Profile',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nextStep({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: const Color(0xFFBAE6FD),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFE0F2FE),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFF0284C7),
                size: 21,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF172033),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF5D6472),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class _CompanyInfo extends StatelessWidget {
  final String title;
  final String value;

  const _CompanyInfo({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF5D6472),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF172033),
          ),
        ),
      ],
    );
  }
}
