import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'sign_up_screen.dart';
import 'sign_in_screen.dart';

class GuestExploreScreen extends StatefulWidget {
  const GuestExploreScreen({super.key});

  @override
  State<GuestExploreScreen> createState() => _GuestExploreScreenState();
}

class _GuestExploreScreenState extends State<GuestExploreScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  final List<_ExploreMode> _modes = [
    _ExploreMode(
      title: 'Startup Mode',
      description: 'Launch your dream. Manage your team, track milestones, and secure funding all in one command center.',
      icon: Icons.rocket_launch_rounded,
      colors: [Color(0xFF5B21B6), Color(0xFF7C3AED)],
    ),
    _ExploreMode(
      title: 'Community Mode',
      description: 'Join discussions, ask questions, and learn from a vibrant community of founders, builders, and creators.',
      icon: Icons.groups_rounded,
      colors: [Color(0xFFBE185D), Color(0xFFE11D48)],
    ),
    _ExploreMode(
      title: 'Investor Mode',
      description: 'Discover high-potential startups. Manage your deal flow pipeline and connect with visionary founders.',
      icon: Icons.attach_money_rounded,
      colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
    ),
    _ExploreMode(
      title: 'Feed Mode',
      description: 'Stay updated with posts, startup updates, and community highlights in one social feed.',
      icon: Icons.dynamic_feed_rounded,
      colors: [Color(0xFF4338CA), Color(0xFF7C3AED)],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showSignUpPrompt() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              const Text(
                'Unlock Full Access',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Create an account to fully explore this mode and connect with the Collabster community.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUpScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Create an Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Maybe Later', style: TextStyle(color: AppColors.textSecondary)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                    onPressed: () {
                      final canPop = Navigator.of(context).canPop();
                      if (canPop) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const SignInScreen()),
                        );
                      }
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const SignUpScreen()),
                      );
                    },
                    child: const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                'Explore Collabster',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Swipe through to discover all the modes we offer to accelerate your journey.',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _modes.length,
                itemBuilder: (context, index) {
                  final mode = _modes[index];
                  final isCurrent = index == _currentPage;
                  
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    margin: EdgeInsets.only(
                      right: 16,
                      left: index == 0 ? 0 : 8,
                      top: isCurrent ? 0 : 32,
                      bottom: isCurrent ? 24 : 56,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: mode.colors,
                      ),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        if (isCurrent)
                          BoxShadow(
                            color: mode.colors[0].withOpacity(0.3),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _showSignUpPrompt,
                        borderRadius: BorderRadius.circular(32),
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(mode.icon, color: Colors.white, size: 42),
                              ),
                              const Spacer(),
                              Text(
                                mode.title,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                mode.description,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white.withOpacity(0.9),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  const Text(
                                    'Learn More',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                                ],
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
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_modes.length, (index) {
                  final isCurrent = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: isCurrent ? 24 : 8,
                    decoration: BoxDecoration(
                      color: isCurrent ? AppColors.primary : AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExploreMode {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> colors;

  const _ExploreMode({
    required this.title,
    required this.description,
    required this.icon,
    required this.colors,
  });
}
