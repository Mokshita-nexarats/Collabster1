import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'startup_registration_flow_screen.dart';

class StartupRegistrationIntroScreen extends StatelessWidget {
  const StartupRegistrationIntroScreen({
    super.key,
    this.selectedRole = 'Startup',
  });

  final String selectedRole;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.background;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final cardBg = isDark ? AppColors.darkCardBackground : Colors.white;
    final iconBg = AppColors.primary.withValues(alpha: 0.1);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Back button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          top: 12,
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.maybePop(context),
                          icon: Icon(
                            Icons.arrow_back,
                            size: 27,
                            color: textPrimary,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    // Hero image (falls back to icon if asset missing)
                    Container(
                      width: 165,
                      height: 90,
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        'assets/images/startup_intro.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.rocket_launch_rounded,
                            size: 48,
                            color: AppColors.primary,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 90),

                    // Heading
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'Register your startup in a\nfew simple steps.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          height: 1.12,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 38),
                      child: Text(
                        'Join our ecosystem and unlock opportunities,\n'
                        'resources, and connections to grow your\n'
                        'venture.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.4,
                          color: textSecondary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Features card
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: border,
                        ),
                      ),
                      child: Column(
                        children: [
                          _FeatureItem(
                            icon: Icons.person_add_alt_1,
                            text: '1. Build your startup profile',
                            textColor: textPrimary,
                            iconBg: iconBg,
                          ),
                          const SizedBox(height: 12),
                          _FeatureItem(
                            icon: Icons.build,
                            text: '2. Access to resources & tools',
                            textColor: textPrimary,
                            iconBg: iconBg,
                          ),
                          const SizedBox(height: 12),
                          _FeatureItem(
                            icon: Icons.handshake,
                            text: '3. Connect with investors & partners',
                            textColor: textPrimary,
                            iconBg: iconBg,
                          ),
                          const SizedBox(height: 12),
                          _FeatureItem(
                            icon: Icons.trending_up,
                            text: '4. Grow with our community',
                            textColor: textPrimary,
                            iconBg: iconBg,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom button
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: border,
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StartupRegistrationFlowScreen(
                          selectedRole: selectedRole,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Start Registration',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color textColor;
  final Color iconBg;

  const _FeatureItem({
    required this.icon,
    required this.text,
    required this.textColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 18,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}
