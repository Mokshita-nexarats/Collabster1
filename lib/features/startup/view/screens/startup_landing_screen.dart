import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/view/secondary_goal_screen.dart';
import 'company_type_screen.dart';
import 'startup_dashboard_screen.dart';
import 'startup_registration_intro_screen.dart';

class StartupLandingScreen extends ConsumerWidget {
  const StartupLandingScreen({super.key, this.selectedRole = 'Startup'});

  final String selectedRole;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authViewModelProvider).session;
    final existingStartupName = (session?.startupName?.isNotEmpty == true)
        ? session!.startupName!
        : (session?.joinedStartupName?.isNotEmpty == true)
            ? session!.joinedStartupName!
            : null;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SecondaryGoalScreen(),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.arrow_back_rounded),
                              color: const Color(0xFF0088CC),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFBAE6FD),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Welcome to the',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 34,
                            height: 1.05,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF13233B),
                            letterSpacing: -0.6,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Startup Hub',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 34,
                            height: 1.05,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0088CC),
                            letterSpacing: -0.6,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 22),
                          child: Text(
                            'Create your startup or join an existing team to start collaborating.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.5,
                              height: 1.45,
                              color: Color(0xFF5F6676),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        if (existingStartupName != null) ...[
                          _StartupActionCard(
                            icon: Icons.dashboard_rounded,
                            iconBackground: const Color(0xFFD1FAE5),
                            title: 'Open $existingStartupName Dashboard',
                            description:
                                'Access your active workspace for $existingStartupName to manage team, pitch decks, and posts.',
                            buttonLabel: 'Go to Dashboard',
                            buttonIcon: Icons.arrow_forward_rounded,
                            buttonFilled: true,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StartupDashboardScreen(
                                    startupName: existingStartupName,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
                        _StartupActionCard(
                          icon: Icons.rocket_launch_rounded,
                          iconBackground: const Color(0xFFE0F2FE),
                          title: 'Create Startup',
                          description:
                              'Build your startup profile, invite your team, showcase your products, raise funding and grow your company.',
                          buttonLabel: 'Create Startup',
                          buttonIcon: Icons.arrow_forward_rounded,
                          buttonFilled: existingStartupName == null,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      StartupRegistrationIntroScreen(
                                    selectedRole: selectedRole,
                                  ),
                                ),
                              );
                            },
                        ),
                        const SizedBox(height: 12),
                        _StartupActionCard(
                          icon: Icons.apartment_rounded,
                          iconBackground: const Color(0xFFE5EAFB),
                          title: 'Join Existing Startup',
                          description:
                              'Already working at a startup? Join your company’s workspace using an invitation link or organizational email.',
                          buttonLabel: 'Join Startup',
                          buttonFilled: false,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CompanyTypeScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StartupActionCard extends StatelessWidget {
  const _StartupActionCard({
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.buttonFilled,
    required this.onPressed,
    this.buttonIcon,
  });

  final IconData icon;
  final Color iconBackground;
  final String title;
  final String description;
  final String buttonLabel;
  final bool buttonFilled;
  final VoidCallback onPressed;
  final IconData? buttonIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFBAE6FD)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x09000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 30, color: const Color(0xFF0088CC)),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              height: 1.1,
              fontWeight: FontWeight.w800,
              color: Color(0xFF13233B),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14.5,
              height: 1.5,
              color: Color(0xFF5F6676),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: buttonFilled
                ? FilledButton(
                    onPressed: onPressed,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(42),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          buttonLabel,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        if (buttonIcon != null) ...[
                          const SizedBox(width: 8),
                          Icon(buttonIcon, size: 18),
                        ],
                      ],
                    ),
                  )
                : OutlinedButton(
                    onPressed: onPressed,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(42),
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: Color(0xFF0284C7)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: Text(
                      buttonLabel,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
