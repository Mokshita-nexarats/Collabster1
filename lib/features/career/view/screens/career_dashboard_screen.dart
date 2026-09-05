import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/role_switcher_sheet.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/bridge/view/connect_screen.dart';
import '../../../auth/view/screens/profile_screen.dart';
import '../../../auth/view/sign_in_screen.dart';
import 'internships_screen.dart';
import 'jobs_screen.dart';
import 'freelance_screen.dart';
import 'resume_screen.dart';
import 'mock_interviews_screen.dart';
import 'notifications_screen.dart';
import 'saved_jobs_screen.dart';
import 'submission_details_screen.dart';
import 'applied_applications_screen.dart';
import '../../../inbox/view/inbox_screen.dart';
import 'booked_sessions_screen.dart';
import 'job_detail_screen.dart';
import 'explore_screen.dart';
import 'upload_resume_screen.dart';
import 'professional_templates_screen.dart';
import '../../providers/career_providers.dart';

class CareerDashboardScreen extends ConsumerStatefulWidget {
  const CareerDashboardScreen({super.key});

  @override
  ConsumerState<CareerDashboardScreen> createState() => _CareerDashboardScreenState();
}

class _CareerDashboardScreenState extends ConsumerState<CareerDashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(careerViewModelProvider.notifier).loadInitialData();
    });
  }

  String get _timeBasedGreeting {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good Morning';
    if (hour >= 12 && hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  void _onNavTap(int index) {
    if (index == 2) {
      _showCreateSheet();
      return;
    }
    if (index == 4) {
      _showProfileSheet();
      return;
    }
    setState(() => _selectedIndex = index);
  }

  void _showCreateSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        child: SafeArea(
          top: false,
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
                  const Text(
                    'Quick Actions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12233D)),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(999)),
                      child: const Icon(Icons.close_rounded, color: Color(0xFF4B5563), size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.0,
                children: [
                  _buildCreateAction(ctx, icon: Icons.search_rounded, label: 'Find\nJobs', color: const Color(0xFF0284C7), onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const JobsScreen()));
                  }),
                  _buildCreateAction(ctx, icon: Icons.school_rounded, label: 'Find\nInternships', color: const Color(0xFF0EA5E9), onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => InternshipsScreen(onBack: () => Navigator.pop(context))));
                  }),
                  _buildCreateAction(ctx, icon: Icons.laptop_mac_rounded, label: 'Find\nFreelance', color: const Color(0xFF0891B2), onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const FreelanceScreen()));
                  }),
                  _buildCreateAction(ctx, icon: Icons.videocam_rounded, label: 'Mock\nInterview', color: const Color(0xFF0E7490), onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => MockInterviewsScreen(onBack: () => Navigator.pop(context))));
                  }),
                  _buildCreateAction(ctx, icon: Icons.upload_file_rounded, label: 'Upload\nResume', color: const Color(0xFF0369A1), onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const UploadResumeScreen()));
                  }),
                  _buildCreateAction(ctx, icon: Icons.add_circle_outline_rounded, label: 'Add\nSkill', color: const Color(0xFF0284C7), onTap: () {
                    Navigator.pop(ctx);
                    _showEmptyAddSkillDialog(context);
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEmptyAddSkillDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.add_circle_outline_rounded, color: Color(0xFF0284C7)),
            SizedBox(width: 8),
            Text('Add Skill', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter a new skill to add to your profile:', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'e.g. Flutter, React, Python...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF0284C7), width: 1.5),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref.read(careerStateProvider.notifier).addSkill(controller.text.trim());
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added "${controller.text.trim()}" to your skills!'),
                    backgroundColor: const Color(0xFF0284C7),
                  ),
                );
              }
            },
            child: const Text('Add Skill', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateAction(BuildContext ctx, {required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF374151), height: 1.25),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeContent(),
      _buildExplorePage(),
      const SizedBox.shrink(),
      _buildSavedPage(),
      const SizedBox.shrink(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      body: pages[_selectedIndex],
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }

  // ── Home tab ──────────────────────────────────────────────────────────
  Widget _buildHomeContent() {
    final authState = ref.watch(authViewModelProvider);
    final careerState = ref.watch(careerViewModelProvider);
    final jobs = careerState.jobs;
    final session = authState.session;
    final userName = session?.fullName ?? 'Professional';
    final greetingName = userName.split(RegExp(r'\s+')).first;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0284C7),
                  Color(0xFF0EA5E9),
                  Color(0xFF0284C7),
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
                              colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(Icons.work_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Career Hub',
                                style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
                              ),
                              Text(
                                'Find your next opportunity',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12.5),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const InboxScreen(),
                            ),
                          ),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.forum_outlined,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => _openNotifications(),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              children: [
                                const Center(
                                  child: Icon(Icons.notifications_outlined, color: Colors.white, size: 22),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(color: Color(0xFFF87171), shape: BoxShape.circle),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '$_timeBasedGreeting, $greetingName',
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Here's what's happening with your career today.",
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Actions
              _buildSectionHeader('Actions', null),
              const SizedBox(height: 12),
              _buildQuickActionsGrid(),
              const SizedBox(height: 24),

              // Opportunity Feed
              _buildSectionHeader('Opportunity Feed', 'View all', onCtaTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const JobsScreen()));
              }),
              const SizedBox(height: 4),
              Text('Based on your skills in UI & React', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              const SizedBox(height: 14),
              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _JobCard(
                        title: job.title,
                        company: job.company,
                        location: job.location,
                        tags: job.tags,
                        status: 'Active',
                        accent: const Color(0xFF0284C7),
                        statusBg: const Color(0xFFE0F2FE),
                        statusFg: const Color(0xFF0369A1),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 26),

              // Build your resume
              _buildSectionHeader('Build your resume', 'View All', onCtaTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfessionalTemplatesScreen()));
              }),
              const SizedBox(height: 14),
              SizedBox(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _ResumeCard(
                      title: 'Professional Template',
                      desc: 'Optimized for tech recruiters.',
                      colorA: Color(0xFF0284C7),
                      colorB: Color(0xFF0EA5E9),
                    ),
                    SizedBox(width: 12),
                    _ResumeCard(
                      title: 'Creative Template',
                      desc: 'Stand out with style.',
                      colorA: Color(0xFF0369A1),
                      colorB: Color(0xFF0EA5E9),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),

              // Practice for Interviews
              _buildSectionHeader('Practice for Interviews', 'View All', onCtaTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => MockInterviewsScreen(onBack: () => Navigator.pop(context))));
              }),
              const SizedBox(height: 14),
              SizedBox(
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _PracticeCard(
                      title: 'AI Mock Interview',
                      desc: 'Simulate a live video interview with AI feedback.',
                      icon: Icons.smart_toy_outlined,
                      iconBg: Color(0xFFE0F2FE),
                      iconFg: Color(0xFF0284C7),
                    ),
                    SizedBox(width: 12),
                    _PracticeCard(
                      title: 'Coding Challenge',
                      desc: 'Solve algorithmic problems in our custom IDE.',
                      icon: Icons.code_rounded,
                      iconBg: Color(0xFFE0F2FE),
                      iconFg: Color(0xFF0284C7),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),

              // Freelance Picks
              _buildSectionHeader('Freelance Picks', 'View All', onCtaTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FreelanceScreen()));
              }),
              const SizedBox(height: 14),
              const _FreelanceCard(
                title: 'E-commerce Landing Page',
                price: '\$2,400',
                duration: '2 weeks',
                tags: ['Shopify', 'UI Design'],
                rating: '4.9',
                reviews: '12',
                hot: true,
              ),
              const SizedBox(height: 12),
              const _FreelanceCard(
                title: 'SaaS Dashboard UI',
                price: '\$3,800',
                duration: '3 weeks',
                tags: ['React', 'Figma'],
                rating: '5.0',
                reviews: '8',
                hot: false,
              ),
            ]),
          ),
        ),
      ],
    );
  }

  // ── Quick Actions ──────────────────────────────────────────────────
  Widget _buildQuickActionsGrid() {
    final actions = [
      _QuickAction(Icons.work_outline_rounded, 'Applied Jobs', const Color(0xFF0284C7), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AppliedApplicationsScreen(categoryFilter: 'Job', title: 'Applied Jobs')));
      }),
      _QuickAction(Icons.school_outlined, 'Applied Internships', const Color(0xFF0EA5E9), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AppliedApplicationsScreen(categoryFilter: 'Internship', title: 'Applied Internships')));
      }),
      _QuickAction(Icons.laptop_mac_outlined, 'Applied Freelances', const Color(0xFF0891B2), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AppliedApplicationsScreen(categoryFilter: 'Freelance', title: 'Applied Freelances')));
      }),
      _QuickAction(Icons.description_outlined, 'My Resume', const Color(0xFF0369A1), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ResumeScreen()));
      }),
      _QuickAction(Icons.verified_outlined, 'Completed Mock Interviews', const Color(0xFF0E7490), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const BookedSessionsScreen()));
      }),
      _QuickAction(Icons.bookmark_outline_rounded, 'Saved Jobs', const Color(0xFF0284C7), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => SavedJobsScreen(onBack: () => Navigator.pop(context))));
      }),
      _QuickAction(Icons.alt_route_rounded, 'Connect', const Color(0xFF0284C7), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ConnectScreen(modeTheme: 'career')));
      }),
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildQuickActionItem(actions[0]),
              const SizedBox(width: 10),
              _buildQuickActionItem(actions[1]),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildQuickActionItem(actions[2]),
              const SizedBox(width: 10),
              _buildQuickActionItem(actions[3]),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildQuickActionItem(actions[4]),
              const SizedBox(width: 10),
              _buildQuickActionItem(actions[5]),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildQuickActionItem(actions[6]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(_QuickAction action) {
    return Expanded(
      child: GestureDetector(
        onTap: action.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            color: action.color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: action.color.withValues(alpha: 0.12)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: action.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(action.icon, color: action.color, size: 19),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  action.label,
                  maxLines: 2,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade900,
                    height: 1.15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Section Header ──────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, String? cta, {VoidCallback? onCtaTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF111827), letterSpacing: -0.2)),
        if (cta != null)
          GestureDetector(
            onTap: onCtaTap ?? () {},
            child: Text(cta, style: const TextStyle(fontSize: 13, color: Color(0xFF0284C7), fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }



  Widget _buildExplorePage() {
    return ExploreScreen(
      onBack: () => setState(() => _selectedIndex = 0),
    );
  }

  Widget _buildSavedPage() {
    final careerState = ref.watch(careerViewModelProvider);
    final savedJobs = careerState.jobs.map((job) => _SavedJob(
      title: job.title,
      company: job.company,
      location: job.location,
      salary: job.salaryTag,
      posted: job.timeAgo,
      tags: job.tags,
      savedAgo: job.timeAgo,
    )).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF111827)),
          onPressed: () => setState(() => _selectedIndex = 0),
        ),
        title: const Text('Saved Jobs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
        centerTitle: false,
      ),
      body: savedJobs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border_rounded, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text('No saved jobs yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
                  const SizedBox(height: 6),
                  Text('Bookmark jobs you like and they will appear here.', style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: savedJobs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) => _buildSavedJobCard(savedJobs[i]),
            ),
    );
  }

  Widget _buildSavedJobCard(_SavedJob job) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0F2FE), width: 1.2),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.business_rounded, color: Color(0xFF0284C7), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111827), height: 1.25)),
                    const SizedBox(height: 3),
                    Text('${job.company} • ${job.location}', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  ],
                ),
              ),
              Icon(Icons.bookmark_rounded, color: const Color(0xFF0284C7), size: 22),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(8)),
                child: Text(job.salary, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0284C7))),
              ),
              const SizedBox(width: 8),
              Text(job.posted, style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
              const Spacer(),
              Text('Saved ${job.savedAgo}', style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: job.tags.map((t) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFF0284C7).withValues(alpha: 0.06), borderRadius: BorderRadius.circular(20)),
                child: Text(t, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF0284C7))),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SubmissionDetailsScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    minimumSize: const Size(0, 38),
                    padding: EdgeInsets.zero,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Apply Now', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 38,
                height: 38,
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Job removed from saved list'), duration: Duration(seconds: 2)),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    side: const BorderSide(color: Color(0xFFBAE6FD)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF0284C7)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
    );
  }

  // ── Profile bottom sheet ──────────────────────────────────────────
  void _showProfileSheet() {
    final session = ref.read(authViewModelProvider).session;
    final userName = session?.fullName ?? 'Member';
    final email = session?.email ?? '';
    final roleLabel = session?.activeUserRole.label ?? 'Member';
    final photoPath = session?.profilePhotoPath ?? '';
    final hasPhoto = photoPath.isNotEmpty && File(photoPath).existsSync();

    String getInitials(String name) {
      final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
      if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      if (parts.isNotEmpty) return parts[0][0].toUpperCase();
      return '?';
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.85),
          child: Container(
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(999))),
                  const SizedBox(height: 14),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFFE0F2FE),
                    backgroundImage: hasPhoto ? FileImage(File(photoPath)) : null,
                    child: hasPhoto ? null : Text(getInitials(userName), style: const TextStyle(color: Color(0xFF0284C7), fontSize: 24, fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(height: 10),
                  Text(userName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                  if (email.isNotEmpty) ...[const SizedBox(height: 2), Text(email, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280), fontWeight: FontWeight.w500))],
                  const SizedBox(height: 2),
                  Text(roleLabel, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                  const SizedBox(height: 14),
                  _sheetAction(Icons.person_outline_rounded, 'View Profile', const Color(0xFF0284C7), () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                  }),
                  const SizedBox(height: 8),
                  _sheetAction(Icons.swap_horiz_rounded, 'Switch Tab', const Color(0xFF0284C7), () {
                    Navigator.pop(ctx);
                    RoleSwitcherSheet.show(context);
                  }),
                  const SizedBox(height: 8),
                  _sheetAction(Icons.logout_rounded, 'Logout', const Color(0xFFEF4444), () async {
                    Navigator.pop(ctx);
                    await ref.read(authViewModelProvider.notifier).logout();
                    if (!mounted) return;
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignInScreen()));
                  }),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sheetAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE5E7EB))),
          child: Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF12233D))),
              const Spacer(),
              Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade400, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// REUSABLE WIDGETS
// ═══════════════════════════════════════════════════════════════════════════

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction(this.icon, this.label, this.color, this.onTap);
}

class _SavedJob {
  final String title, company, location, salary, posted, savedAgo;
  final List<String> tags;
  const _SavedJob({required this.title, required this.company, required this.location, required this.salary, required this.posted, required this.tags, required this.savedAgo});
}



class _JobCard extends StatelessWidget {
  final String title, company, location, status;
  final List<String> tags;
  final Color accent, statusBg, statusFg;

  const _JobCard({required this.title, required this.company, required this.location, required this.status, required this.tags, required this.accent, required this.statusBg, required this.statusFg});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0F2FE), width: 1.2),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.grid_view_rounded, color: accent, size: 18),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(20)),
                child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusFg)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111827), height: 1.25)),
          const SizedBox(height: 4),
          Text('$company • $location', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          const SizedBox(height: 10),
          Row(
            children: tags.take(2).map((t) {
              return Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: accent.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(20)),
                child: Text(t, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: accent)),
              );
            }).toList(),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JobDetailsScreen(
                          title: title,
                          company: company,
                          location: location.contains('Remote') ? 'Remote (Worldwide)' : location,
                          salary: '\$80k – \$110k USD',
                          tags: tags,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0284C7), minimumSize: const Size(0, 36), padding: EdgeInsets.zero, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('Apply', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(border: Border.all(color: const Color(0xFFBAE6FD)), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.bookmark_border_rounded, size: 17, color: Color(0xFF0284C7)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResumeCard extends StatelessWidget {
  final String title, desc;
  final Color colorA, colorB;

  const _ResumeCard({required this.title, required this.desc, required this.colorA, required this.colorB});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(colors: [colorA, colorB], begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: [BoxShadow(color: colorA.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfessionalTemplatesScreen()),
            );
          },
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -30,
                child: Container(width: 110, height: 110, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.06))),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...List.generate(6, (i) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        height: i == 0 ? 9.0 : 5.0,
                        width: i == 0 ? 80.0 : (i.isEven ? 130.0 : 75.0),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: i == 0 ? 0.9 : 0.35), borderRadius: BorderRadius.circular(3)),
                      );
                    }),
                    const Spacer(),
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 3),
                    Text(desc, style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 11)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                            alignment: Alignment.center,
                            child: Text('Use Template', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorA)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.bookmark_border_rounded, size: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PracticeCard extends StatelessWidget {
  final String title, desc;
  final IconData icon;
  final Color iconBg, iconFg;

  const _PracticeCard({required this.title, required this.desc, required this.icon, required this.iconBg, required this.iconFg});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 195,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0F2FE), width: 1.2),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: iconFg, size: 20)),
          const SizedBox(height: 10),
          Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF111827), height: 1.3)),
          const SizedBox(height: 4),
          Expanded(child: Text(desc, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: Colors.grey.shade500, height: 1.4))),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(color: const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            child: const Text('Start Practice', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0284C7))),
          ),
        ],
      ),
    );
  }
}

class _FreelanceCard extends StatelessWidget {
  final String title, price, duration, rating, reviews;
  final List<String> tags;
  final bool hot;

  const _FreelanceCard({required this.title, required this.price, required this.duration, required this.tags, required this.rating, required this.reviews, required this.hot});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0F2FE), width: 1.2),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827), height: 1.3))),
                    if (hot) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(6)),
                        child: const Icon(Icons.bolt_rounded, size: 13, color: Color(0xFFD97706)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(price, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0284C7))),
                    Text('  •  $duration', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(20)),
                      child: Text(tag, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF0284C7))),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFBBF24)),
                    const SizedBox(width: 3),
                    Text('$rating ($reviews reviews)', style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SubmissionDetailsScreen()));
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0284C7), minimumSize: const Size(72, 36), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(horizontal: 12)),
            child: const Text('Apply', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BOTTOM NAVIGATION BAR
// ═══════════════════════════════════════════════════════════════════════════
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.selectedIndex, required this.onTap});
  final int selectedIndex;
  final ValueChanged<int> onTap;

  static const double _navBarHeight = 64;
  static const double _fabSize = 56;
  static const double _navBarTop = 14;
  static const double _fabTop = -12;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final totalHeight = _navBarTop + _navBarHeight + bottomInset + 8;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: _navBarTop,
            left: 12,
            right: 12,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: CustomPaint(
                painter: _SeamlessNavPainter(fillColor: Colors.white, borderColor: const Color(0xFFE2E4EA), shadowColor: Colors.black.withValues(alpha: 0.08)),
                size: Size.infinite,
                child: SizedBox(
                  height: _navBarHeight,
                  child: Row(
                    children: [
                      _navItem(0, Icons.home_outlined, Icons.home_rounded, 'Home'),
                      _navItem(1, Icons.explore_outlined, Icons.explore_rounded, 'Explore'),
                      SizedBox(width: _fabSize + 12),
                      _navItem(3, Icons.bookmark_outline_rounded, Icons.bookmark_rounded, 'Saved'),
                      _navItem(4, Icons.person_outline, Icons.person, 'Profile'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(top: _fabTop, left: 0, right: 0, child: Center(child: _addButton())),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, IconData activeIcon, String label) {
    final selected = selectedIndex == index;
    const selectedColor = Color(0xFF0284C7);
    const unselectedColor = Color(0xFF9CA3AF);

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(selected ? activeIcon : icon, color: selected ? selectedColor : unselectedColor, size: 24),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: selected ? FontWeight.w700 : FontWeight.w500, color: selected ? selectedColor : unselectedColor)),
          ],
        ),
      ),
    );
  }

  Widget _addButton() {
    return GestureDetector(
      onTap: () => onTap(2),
      child: Container(
        width: _fabSize,
        height: _fabSize,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF0284C7), Color(0xFF0EA5E9)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: const Color(0xFF0284C7).withValues(alpha: 0.30), blurRadius: 14, offset: const Offset(0, 6))],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}

class _SeamlessNavPainter extends CustomPainter {
  const _SeamlessNavPainter({required this.fillColor, required this.borderColor, required this.shadowColor});
  final Color fillColor;
  final Color borderColor;
  final Color shadowColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final h = size.height;
    final w = size.width;
    final centerX = w / 2;
    const cornerRadius = 28.0;
    const fabRadius = 28.0;
    const clearance = 5.0;
    const notchR = fabRadius + clearance;
    const notchW = notchR + 14;
    const bottomArc = 2.5;

    final path = Path()
      ..moveTo(cornerRadius, 0)
      ..lineTo(centerX - notchW, 0)
      ..cubicTo(centerX - notchW + 10, 0, centerX - notchR * 1.1, notchR * 0.06, centerX - notchR, notchR * 0.35)
      ..cubicTo(centerX - notchR * 0.92, notchR * 0.6, centerX - notchR * 0.75, notchR * 0.85, centerX - notchR * 0.5, notchR * 0.98)
      ..cubicTo(centerX - notchR * 0.28, notchR * 1.05, centerX - 14, notchR * 1.06, centerX, notchR * 1.06)
      ..cubicTo(centerX + 14, notchR * 1.06, centerX + notchR * 0.28, notchR * 1.05, centerX + notchR * 0.5, notchR * 0.98)
      ..cubicTo(centerX + notchR * 0.75, notchR * 0.85, centerX + notchR * 0.92, notchR * 0.6, centerX + notchR, notchR * 0.35)
      ..cubicTo(centerX + notchR * 1.1, notchR * 0.06, centerX + notchW - 10, 0, centerX + notchW, 0)
      ..lineTo(w - cornerRadius, 0)
      ..arcToPoint(Offset(w, cornerRadius), radius: const Radius.circular(cornerRadius))
      ..lineTo(w, h - cornerRadius)
      ..arcToPoint(Offset(w - cornerRadius, h), radius: const Radius.circular(cornerRadius))
      ..quadraticBezierTo(centerX, h - bottomArc, cornerRadius, h)
      ..arcToPoint(Offset(0, h - cornerRadius), radius: const Radius.circular(cornerRadius))
      ..lineTo(0, cornerRadius)
      ..arcToPoint(Offset(cornerRadius, 0), radius: const Radius.circular(cornerRadius))
      ..close();

    canvas.drawShadow(path, shadowColor, 24, true);
    canvas.drawShadow(path, shadowColor.withValues(alpha: 0.5), 6, true);
    canvas.drawPath(path, Paint()..style = PaintingStyle.fill..color = fillColor);
    canvas.drawPath(path, Paint()..style = PaintingStyle.stroke..strokeWidth = 1.0..color = borderColor);
  }

  @override
  bool shouldRepaint(covariant _SeamlessNavPainter oldDelegate) => oldDelegate.fillColor != fillColor || oldDelegate.borderColor != borderColor || oldDelegate.shadowColor != shadowColor;
}
