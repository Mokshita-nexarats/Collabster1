import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/bridge/view/connect_screen.dart';
import '../../../../shared/utils/app_snackbar.dart';
import '../../../../shared/widgets/role_switcher_sheet.dart';
import '../../model/startup_models.dart';
import '../../viewmodel/startup_dashboard_state.dart';
import '../../../auth/view/sign_in_screen.dart';
import '../../../auth/view/screens/profile_screen.dart';
import 'fundraising_dashboard_screen.dart';
import 'hiring_command_screen.dart';
import 'investor_pipeline_screen.dart';
import 'join_startup_screen.dart';
import 'messages_inbox_screen.dart';
import 'startup_analytics_screen.dart';
import 'startup_documents_screen.dart';
import 'startup_events_screen.dart';
import 'startup_info_screen.dart';
import 'startup_milestones_screen.dart';
import 'startup_network_screen.dart';
import 'startup_post_update_screen.dart';
import 'startup_posts_feed_screen.dart';
import 'startup_products_screen.dart';
import 'startup_requests_screen.dart';
import 'notifications_screen.dart';
import 'team_command_screen.dart';

class StartupDashboardScreen extends ConsumerStatefulWidget {
  const StartupDashboardScreen({super.key, required this.startupName});
  final String startupName;

  @override
  ConsumerState<StartupDashboardScreen> createState() =>
      _StartupDashboardScreenState();
}

class _StartupDashboardScreenState extends ConsumerState<StartupDashboardScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnim;
  StartupDashboardState get _state => ref.read(startupDashboardViewModelProvider);

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _loadSessionData();
  }

  Future<void> _loadSessionData() async {
    await Future.delayed(Duration.zero);
    if (!mounted) return;
    final session = ref.read(authViewModelProvider).session;
    if (session != null && mounted) {
      ref.read(startupDashboardViewModelProvider.notifier).loadSessionData(
        startupIndustry: session.startupIndustry,
        startupStage: session.startupStage,
        startupCountry: session.startupCountry,
        country: session.country,
        startupCity: session.startupCity,
        city: session.city,
        startupTagline: session.startupTagline,
        profilePhotoPath: session.profilePhotoPath,
        fullName: session.fullName,
        email: session.email,
        startupName: widget.startupName,
      );
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  String get _locationLabel => _state.locationLabel;

  int get _profileCompletion {
    final filledFields = [
      widget.startupName,
      _state.industry,
      _state.stage,
      _state.tagline,
      _state.country,
      _state.city,
    ].where((value) => value.isNotEmpty).length;
    return (filledFields / 6 * 100).round();
  }

  String get _greetingName {
    final name = _state.ownerName.trim();
    if (name.isEmpty) return 'there';
    return name.split(RegExp(r'\s+')).first;
  }

  String get _timeBasedGreeting {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String get _profileInitials {
    final words = _state.ownerName.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return 'U';
    return words.take(2).map((word) => word[0]).join().toUpperCase();
  }

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bgColor => _isDark ? const Color(0xFF0F1123) : const Color(0xFFF6F3FF);

  @override
  Widget build(BuildContext context) {
    ref.watch(startupDashboardViewModelProvider);
    final session = ref.watch(authViewModelProvider).session;
    final logoPath = session?.startupLogoPath ?? '';
    final hasStartupLogo = logoPath.isNotEmpty && File(logoPath).existsSync();

    return Scaffold(
      backgroundColor: _bgColor,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: CustomScrollView(
          slivers: [
            // ── Header gradient ──
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4A0E8F),
                      Color(0xFF6D28D9),
                      Color(0xFF5B21B6),
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
                        // Top row
                        Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                gradient: hasStartupLogo
                                    ? null
                                    : const LinearGradient(
                                        colors: [
                                          Color(0xFF7C3AED),
                                          Color(0xFF5B21B6),
                                        ],
                                      ),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: hasStartupLogo
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        File(logoPath),
                                        width: 46,
                                        height: 46,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.rocket_launch_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          widget.startupName,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.verified_rounded,
                                        color: Color(0xFF93C5FD),
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                  if (_state.tagline.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      _state.tagline,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.82,
                                        ),
                                        fontSize: 12.5,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 6),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: [
                                      if (_state.industry.isNotEmpty)
                                        _tagChip(_state.industry),
                                      if (_state.stage.isNotEmpty)
                                        _tagChip(_state.stage),
                                      if (_locationLabel.isNotEmpty)
                                        _tagChip(_locationLabel),
                                    ],
                                  ),
                                ],
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
                                      child: Icon(
                                        Icons.notifications_outlined,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFF87171),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                        const SizedBox(height: 20),

                        // Greeting
                        Text(
                          '$_timeBasedGreeting, $_greetingName',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Here's what's happening with your startup today.",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Startup score card
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'STARTUP SCORE',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '$_profileCompletion',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 52,
                                              fontWeight: FontWeight.w900,
                                              height: 1,
                                            ),
                                          ),
                                          const Text(
                                            '/100',
                                            style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  _CircularScoreGauge(
                                    score: _profileCompletion,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _scoreStat(
                                    '$_profileCompletion%',
                                    'PROFILE\nCOMPLETION',
                                  ),
                                  _divider(),
                                  _scoreStat(
                                    '${_state.recentActivity.length}',
                                    'RECENT\nACTIVITIES',
                                  ),
                                  _divider(),
                                  _scoreStat(
                                    widget.startupName.isNotEmpty ? '1' : '0',
                                    'STARTUP\nPROFILES',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Container(
                                height: 1,
                                color: Colors.white.withValues(alpha: 0.15),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _scoreStat(
                                    _state.stage.isNotEmpty ? '1' : '0',
                                    'STAGE\nSET',
                                  ),
                                  _divider(),
                                  _scoreStat(
                                    _state.country.isNotEmpty ? '1' : '0',
                                    'LOCATION\nSET',
                                  ),
                                  _divider(),
                                  _scoreStat(
                                    _state.tagline.isNotEmpty ? '1' : '0',
                                    'TAGLINE\nSET',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Body ──
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Quick Actions
                  _SectionHeader(title: 'Quick Actions', onSeeAll: null),
                  const SizedBox(height: 12),
                  _QuickActionsGrid(startupName: widget.startupName, startupHubOnTap: _showStartupQuickMenu, routeBuilder: _smoothRoute),
                  const SizedBox(height: 24),

                  // AI Insights
                  GestureDetector(
                    onTap: () => _showAIInsightsModal(context),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF5B21B6), Color(0xFF7C3AED)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF5B21B6,
                            ).withValues(alpha: 0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
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
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.auto_awesome,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'AI Insights',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text(
                                  '83/100 Health',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Improve your funding profile by adding your latest financial statements to attract more institutional investors.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 13.5,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'Explore AI Recommendations',
                                  style: TextStyle(
                                    color: Color(0xFF5B21B6),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(
                                  Icons.chevron_right,
                                  color: Color(0xFF5B21B6),
                                  size: 18,
                                ),
                              ],
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
      ),
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _state.selectedNavIndex,
        onTap: _handleBottomNav,
        messagesUnread: 0,
      ),
    );
  }

  void _showAIInsightsModal(BuildContext context) {
    int overallScore = 83;
    int pitchScore = 80;
    int teamScore = 90;
    int tractionScore = 78;
    int legalScore = 85;
    bool isAnalyzing = false;

    final List<Map<String, dynamic>> recommendations = [
      {
        'icon': Icons.account_balance_rounded,
        'color': const Color(0xFF059669),
        'title': 'Financial Projections Audit',
        'description':
            'Uploading Q3 projected revenue forecast boosts VC matching by +24%.',
        'btnLabel': 'Upload Financials',
      },
      {
        'icon': Icons.analytics_rounded,
        'color': const Color(0xFF2563EB),
        'title': 'Pitch Deck Analyzer',
        'description':
            'AI Audit detected 2 missing slides: Competitor Landscape & TAM.',
        'btnLabel': 'Run Deck Audit',
      },
      {
        'icon': Icons.radar_rounded,
        'color': const Color(0xFFD97706),
        'title': 'Smart VC Matchmaker',
        'description':
            '5 new Seed VCs actively investing in SaaS match your traction profile.',
        'btnLabel': 'Explore VC Radar',
      },
      {
        'icon': Icons.person_add_alt_1_rounded,
        'color': const Color(0xFF7C3AED),
        'title': 'Talent Acquisition Bot',
        'description':
            'Based on Q4 roadmap goals, AI suggests adding a Senior Flutter Lead.',
        'btnLabel': 'Post Open Role',
      },
    ];

    String getTierLabel(int score) {
      if (score >= 90) return 'Tier-1 Ready';
      if (score >= 75) return 'Tier-2 Ready';
      if (score >= 60) return 'Tier-3 Ready';
      return 'Needs Work';
    }

    void runAnalysis(StateSetter setModalState) async {
      setModalState(() => isAnalyzing = true);

      await Future.delayed(const Duration(milliseconds: 600));
      if (!context.mounted) return;

      final random = DateTime.now().millisecond;
      int varyScore(int base, int range) {
        final delta = (random % (range * 2 + 1)) - range;
        return (base + delta).clamp(50, 99);
      }

      setModalState(() {
        pitchScore = varyScore(pitchScore, 5);
        teamScore = varyScore(teamScore, 3);
        tractionScore = varyScore(tractionScore, 6);
        legalScore = varyScore(legalScore, 4);
        overallScore =
            ((pitchScore + teamScore + tractionScore + legalScore) / 4).round();
      });

      await Future.delayed(const Duration(milliseconds: 400));
      if (!context.mounted) return;

      final updatedRecs = [
        {
          'icon': Icons.account_balance_rounded,
          'color': const Color(0xFF059669),
          'title': 'Financial Projections Audit',
          'description': pitchScore < 85
              ? 'Revenue forecast accuracy improved to $pitchScore%. Upload Q3 data to reach 90%+.'
              : 'Strong financial projections detected. Consider adding unit economics breakdown.',
          'btnLabel': 'Upload Financials',
        },
        {
          'icon': Icons.analytics_rounded,
          'color': const Color(0xFF2563EB),
          'title': 'Pitch Deck Analyzer',
          'description': teamScore >= 88
              ? 'Team composition scores $teamScore%. Add 2 advisory board members for Tier-1.'
              : 'AI detected gaps in team expertise. Consider adding a CTO-level advisor.',
          'btnLabel': 'Run Deck Audit',
        },
        {
          'icon': Icons.radar_rounded,
          'color': const Color(0xFFD97706),
          'title': 'Smart VC Matchmaker',
          'description': tractionScore >= 80
              ? '$tractionScore% traction score. 7 new Seed VCs match your growth profile.'
              : 'Traction at $tractionScore%. Focus on MRR growth to unlock Series A investors.',
          'btnLabel': 'Explore VC Radar',
        },
        {
          'icon': Icons.person_add_alt_1_rounded,
          'color': const Color(0xFF7C3AED),
          'title': 'Talent Acquisition Bot',
          'description': legalScore >= 82
              ? 'Legal readiness at $legalScore%. AI suggests hiring a compliance lead for enterprise deals.'
              : 'Legal score at $legalScore%. Prioritize IP filing and employee contracts.',
          'btnLabel': 'Post Open Role',
        },
      ];

      setModalState(() {
        isAnalyzing = false;
        recommendations
          ..clear()
          ..addAll(updatedRecs);
      });

      if (mounted) {
        _showSnack('AI Insights updated! Scores refreshed successfully.');
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.88,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F5FF),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1D5DB),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF5B21B6), Color(0xFF7C3AED)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Startup Insights',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF12233D),
                            ),
                          ),
                          Text(
                            'Real-time automated traction & investor readiness',
                            style: TextStyle(
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
                        color: isAnalyzing
                            ? const Color(0xFFF59E0B).withValues(alpha: 0.12)
                            : const Color(0xFF059669).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: isAnalyzing
                              ? const Color(0xFFF59E0B).withValues(alpha: 0.3)
                              : const Color(0xFF059669).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isAnalyzing
                                ? Icons.hourglass_top_rounded
                                : Icons.bolt,
                            color: isAnalyzing
                                ? const Color(0xFFF59E0B)
                                : const Color(0xFF059669),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isAnalyzing ? 'Analyzing...' : 'Active',
                            style: TextStyle(
                              color: isAnalyzing
                                  ? const Color(0xFFF59E0B)
                                  : const Color(0xFF059669),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF5B21B6), Color(0xFF4338CA)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Overall Health Score',
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.8,
                                          ),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '$overallScore / 100',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      getTierLabel(overallScore),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              LinearProgressIndicator(
                                value: overallScore / 100,
                                backgroundColor: const Color(0x33FFFFFF),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                minHeight: 8,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(999),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _aiScorePill('Pitch: $pitchScore%'),
                                  _aiScorePill('Team: $teamScore%'),
                                  _aiScorePill('Traction: $tractionScore%'),
                                  _aiScorePill('Legal: $legalScore%'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'ACTIONABLE AI RECOMMENDATIONS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF6B7280),
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...recommendations.map(
                          (rec) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _aiRecTile(
                              icon: rec['icon'] as IconData,
                              color: rec['color'] as Color,
                              title: rec['title'] as String,
                              description: rec['description'] as String,
                              btnLabel: rec['btnLabel'] as String,
                              onTap: () {
                                if (Navigator.canPop(ctx)) Navigator.pop(ctx);
                                final title = rec['title'] as String;
                                if (title == 'Financial Projections Audit') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const StartupDocumentsScreen(),
                                    ),
                                  );
                                } else if (title == 'Pitch Deck Analyzer') {
                                  _showDeckAuditModal(context);
                                } else if (title == 'Smart VC Matchmaker') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const InvestorPipelineScreen(),
                                    ),
                                  );
                                } else if (title == 'Talent Acquisition Bot') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => HiringCommandScreen(
                                        startupName: widget.startupName,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: isAnalyzing
                                ? null
                                : () => runAnalysis(setModalState),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5B21B6),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: const Color(0xFF9CA3AF),
                              disabledForegroundColor: Colors.white70,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: isAnalyzing
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.refresh_rounded, size: 18),
                            label: Text(
                              isAnalyzing
                                  ? 'Analyzing...'
                                  : 'Re-run AI Analysis',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _aiScorePill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _aiRecTile({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required String btnLabel,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF12233D),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          btnLabel,
                          style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: color,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showDeckAuditModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 16),
            const Icon(
              Icons.analytics_rounded,
              color: Color(0xFF2563EB),
              size: 40,
            ),
            const SizedBox(height: 12),
            const Text(
              'AI Pitch Deck Audit Complete',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF12233D),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Scanned "Nexarats_Deck_v3.pdf" • Overall Rating: 84/100',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: Color(0xFFD97706),
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Missing: Add a dedicated slide for "Competitive Advantage Matrix" to satisfy Series A investor requirements.',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF92400E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (Navigator.canPop(ctx)) Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Got It, Update Deck',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _scoreStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _divider() => Container(
    width: 1,
    height: 36,
    color: Colors.white.withValues(alpha: 0.15),
  );

  Route<T> _smoothRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curved),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.08, 0.0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  void _handleBottomNav(int index) {
    switch (index) {
      case 0:
        // Already home — no-op
        break;
      case 1:
        Navigator.push(
          context,
          _smoothRoute(StartupNetworkScreen(startupName: widget.startupName)),
        );
        break;
      case 2:
        // + button: briefly highlight it then reset after sheet dismissed
        ref.read(startupDashboardViewModelProvider.notifier).selectNav(2);
        _showCreateSheet();
        break;
      case 3:
        Navigator.push(
          context,
          _smoothRoute(MessagesInboxScreen(
            startupName: widget.startupName,
          )),
        );
        break;
      case 4:
        ref.read(startupDashboardViewModelProvider.notifier).selectNav(4);
        _showProfileSheet();
        break;
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    if (isError) {
      AppSnackBar.showError(context, msg);
    } else {
      AppSnackBar.showSuccess(context, msg);
    }
  }

  void _openNotifications() {
    Navigator.push(
      context,
      _smoothRoute(NotificationsScreen(startupName: widget.startupName)),
    );
  }

  void _showProfileSheet() {
    final photoPath = _state.profilePhotoPath;
    final hasPhoto = photoPath.isNotEmpty && File(photoPath).existsSync();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1A1D35) : Colors.white;
    final handleColor = isDark ? const Color(0xFF2D3352) : const Color(0xFFE5E7EB);
    final textColor = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF12233D);
    final subtitleColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
    final session = ref.read(authViewModelProvider).session;
    final roleLabel = session?.activeUserRole.label ?? 'Member';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.85,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: sheetBg,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: handleColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFFEDE9FE),
                    backgroundImage: hasPhoto ? FileImage(File(photoPath)) : null,
                    child: hasPhoto
                        ? null
                        : Text(
                            _profileInitials,
                            style: const TextStyle(
                              color: Color(0xFF5B21B6),
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _state.ownerName.isEmpty ? 'Your profile' : _state.ownerName,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  if (_state.email.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      _state.email,
                      style: TextStyle(
                        fontSize: 13,
                        color: subtitleColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  const SizedBox(height: 2),
                  Text(roleLabel, style: TextStyle(fontSize: 13, color: subtitleColor)),
                  const SizedBox(height: 14),
                  _sheetAction(
                    Icons.person_outline_rounded,
                    'View Profile',
                    const Color(0xFF5B21B6),
                    () {
                      Navigator.pop(ctx);
                      Navigator.push(context, _smoothRoute(const ProfileScreen()));
                    },
                  ),
                  const SizedBox(height: 8),
                  _sheetAction(
                    Icons.swap_horiz_rounded,
                    'Switch Tab',
                    const Color(0xFF5B21B6),
                    () {
                      Navigator.pop(ctx);
                      RoleSwitcherSheet.show(context);
                    },
                  ),
                  const SizedBox(height: 8),
                  _sheetAction(
                    Icons.apartment_rounded,
                    'Join Another Startup',
                    const Color(0xFF5B21B6),
                    () {
                      Navigator.pop(ctx);
                      Navigator.push(context, _smoothRoute(const JoinStartupScreen()));
                    },
                  ),
                  const SizedBox(height: 8),
                  // ── Dynamic switch buttons (only when relevant) ───────────
                  Consumer(
                    builder: (context, ref, _) {
                      final session = ref.watch(authViewModelProvider).session;
                      final originalName = session?.originalStartupName;
                      final joinedName = session?.joinedStartupName;

                      final showSwitchToOwn = originalName != null &&
                          originalName.isNotEmpty &&
                          session?.startupName != originalName;

                      final showSwitchToJoined = joinedName != null &&
                          joinedName.isNotEmpty &&
                          session?.startupName != joinedName;

                      if (!showSwitchToOwn && !showSwitchToJoined) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        children: [
                          if (showSwitchToOwn) ...[
                            _sheetAction(
                              Icons.swap_horizontal_circle_outlined,
                              'Switch to $originalName',
                              const Color(0xFF5B21B6),
                              () async {
                                Navigator.pop(ctx);
                                final data = session?.originalStartupData;
                                await ref.read(authViewModelProvider.notifier).updateStartupData(
                                  startupName: originalName,
                                  industry: data?['startupIndustry'] as String?,
                                  stage: data?['startupStage'] as String?,
                                  tagline: data?['startupTagline'] as String?,
                                  country: data?['startupCountry'] as String?,
                                  city: data?['startupCity'] as String?,
                                  description: data?['startupDescription'] as String?,
                                  problem: data?['startupProblem'] as String?,
                                  solution: data?['startupSolution'] as String?,
                                  mission: data?['startupMission'] as String?,
                                  vision: data?['startupVision'] as String?,
                                  website: data?['startupWebsite'] as String?,
                                  incorporationDate: data?['startupIncorporationDate'] as String?,
                                  founderName: data?['startupFounderName'] as String?,
                                  founderDesignation: data?['startupFounderDesignation'] as String?,
                                  founderEmail: data?['startupFounderEmail'] as String?,
                                  founderPhone: data?['startupFounderPhone'] as String?,
                                  founderLinkedin: data?['startupFounderLinkedin'] as String?,
                                  founderBio: data?['startupFounderBio'] as String?,
                                  socialWebsite: data?['startupSocialWebsite'] as String?,
                                  socialLinkedin: data?['startupSocialLinkedin'] as String?,
                                  socialProductHunt: data?['startupSocialProductHunt'] as String?,
                                  useOfFunds: data?['startupUseOfFunds'] as String?,
                                  teamSize: data?['startupTeamSize'] as String?,
                                  fundingStage: data?['startupFundingStage'] as String?,
                                  currentlyRaising: data?['startupCurrentlyRaising'] as bool?,
                                  visibility: data?['startupVisibility'] as String?,
                                  originalStartupName: originalName,
                                  originalStartupData: data,
                                );
                                if (!context.mounted) return;
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => StartupDashboardScreen(startupName: originalName),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (showSwitchToJoined) ...[
                            _sheetAction(
                              Icons.apartment_rounded,
                              'Switch to $joinedName',
                              const Color(0xFF0891B2),
                              () async {
                                Navigator.pop(ctx);
                                final data = session?.joinedStartupData;
                                await ref.read(authViewModelProvider.notifier).updateStartupData(
                                  startupName: joinedName,
                                  industry: data?['startupIndustry'] as String?,
                                  stage: data?['startupStage'] as String?,
                                  tagline: data?['startupTagline'] as String?,
                                  city: data?['startupCity'] as String?,
                                  originalStartupName: originalName,
                                  originalStartupData: session?.originalStartupData,
                                  joinedStartupName: joinedName,
                                  joinedStartupData: data,
                                );
                                if (!context.mounted) return;
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => StartupDashboardScreen(startupName: joinedName),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                          ],
                        ],
                      );
                    },
                  ),
                  _sheetAction(
                    Icons.logout_rounded,
                    'Sign Out',
                    const Color(0xFFDC2626),
                    () async {
                      final nav = Navigator.of(context);
                      Navigator.pop(ctx);
                      await ref.read(authViewModelProvider.notifier).logout();
                      if (!mounted) return;
                      nav.pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const SignInScreen()),
                        (_) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).then((_) {
      if (mounted) ref.read(startupDashboardViewModelProvider.notifier).selectNav(0);
    });
  }


  Widget _sheetAction(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF12233D),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFF4B5563),
                        size: 20,
                      ),
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
                  _simpleActionItem(
                    ctx,
                    icon: Icons.person_add_rounded,
                    label: 'Add Team',
                    color: const Color(0xFF2563EB),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TeamCommandScreen(
                          startupName: widget.startupName,
                          autoOpenInviteSheet: true,
                        ),
                      ),
                    ),
                  ),
                  _simpleActionItem(
                    ctx,
                    icon: Icons.account_balance_wallet_rounded,
                    label: 'Add Investor',
                    color: const Color(0xFFF59E0B),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FundraisingDashboardScreen(
                          startupName: widget.startupName,
                          autoOpenAddInvestorSheet: true,
                        ),
                      ),
                    ),
                  ),
                  _simpleActionItem(
                    ctx,
                    icon: Icons.work_rounded,
                    label: 'Create Job',
                    color: const Color(0xFFD97706),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HiringCommandScreen(
                          startupName: widget.startupName,
                          autoOpenCreateSheet: true,
                        ),
                      ),
                    ),
                  ),
                  _simpleActionItem(
                    ctx,
                    icon: Icons.inventory_2_rounded,
                    label: 'Add Product',
                    color: const Color(0xFF7C3AED),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StartupProductsScreen(
                          startupName: widget.startupName,
                          autoOpenAddProductSheet: true,
                        ),
                      ),
                    ),
                  ),
                  _simpleActionItem(
                    ctx,
                    icon: Icons.event_rounded,
                    label: 'Create Event',
                    color: const Color(0xFF0891B2),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StartupEventsScreen(
                          startupName: widget.startupName,
                          autoOpenCreateEvent: true,
                        ),
                      ),
                    ),
                  ),
                  _simpleActionItem(
                    ctx,
                    icon: Icons.post_add_rounded,
                    label: 'Add Post',
                    color: const Color(0xFF5B21B6),
                    onTap: () async {
                      final post = await Navigator.push<StartupPost>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StartupPostUpdateScreen(
                            startupName: widget.startupName,
                          ),
                        ),
                      );
                      if (post != null && mounted) {
                        ref.read(authViewModelProvider.notifier).addPost(post);
                        _showSnack('Post published successfully!');
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).then((_) {
      if (mounted) ref.read(startupDashboardViewModelProvider.notifier).selectNav(0);
    });
  }

  Widget _simpleActionItem(
    BuildContext ctx, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(ctx);
        onTap();
      },
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
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF12233D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createActionCard(
    BuildContext ctx, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accent,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(ctx);
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: accent.withValues(alpha: 0.18)),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accent.withValues(alpha: 0.16),
                    accent.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: accent, size: 23),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF12233D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12.8,
                      height: 1.4,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.chevron_right_rounded, color: accent, size: 22),
            ),
          ],
        ),
      ),
    );
  }

  void _showStartupQuickMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
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
            const SizedBox(height: 16),
            const Text(
              'Startup',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF12233D),
              ),
            ),
            const SizedBox(height: 14),
            _menuItem(
              ctx,
              Icons.info_outline_rounded,
              'Startup Info',
              const Color(0xFF4A0E8F),
              () => Navigator.push(context, _smoothRoute(const StartupInfoScreen())),
            ),
          ],
        ),
      ),
    ).then((_) {
      if (mounted) ref.read(startupDashboardViewModelProvider.notifier).selectNav(0);
    });
  }

  Widget _menuItem(
    BuildContext ctx,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(ctx);
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 14),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF12233D),
                ),
              ),
              const Spacer(),
              Icon(Icons.chevron_right, color: color.withValues(alpha: 0.6)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Circular Score Gauge ──
class _CircularScoreGauge extends StatelessWidget {
  const _CircularScoreGauge({required this.score});
  final int score;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: CustomPaint(
        painter: _GaugePainter(score / 100),
        child: Center(
          child: Text(
            '$score',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  const _GaugePainter(this.fraction);
  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final fgPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
    const startAngle = -3.14 / 2;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      2 * 3.14159 * fraction,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.fraction != fraction;
}

// ── Section Header ──
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onSeeAll});
  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF12233D);

    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: textPrimary,
          ),
        ),
        const Spacer(),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: const Text(
              'View All',
              style: TextStyle(
                color: Color(0xFF5B21B6),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

// ── Quick Actions Grid ──
class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid({required this.startupName, this.startupHubOnTap, this.routeBuilder});
  final String startupName;
  final VoidCallback? startupHubOnTap;
  final Route<dynamic> Function(Widget)? routeBuilder;

  Route<T> _smoothRoute<T>(Widget page) {
    if (routeBuilder != null) return routeBuilder!(page) as Route<T>;
    return MaterialPageRoute<T>(builder: (_) => page);
  }

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: Icons.info_outline_rounded,
        label: 'Startup Info',
        color: const Color(0xFF5B21B6),
        onTap: () => Navigator.push(context, _smoothRoute(const StartupInfoScreen())),
      ),
      _QuickAction(
        icon: Icons.post_add_outlined,
        label: 'Posts',
        color: const Color(0xFF5B21B6),
        onTap: () => Navigator.push(context, _smoothRoute(StartupPostsFeedScreen(startupName: startupName))),
      ),
      _QuickAction(
        icon: Icons.group_outlined,
        label: 'Team Members',
        color: const Color(0xFF2563EB),
        onTap: () => Navigator.push(context, _smoothRoute(TeamCommandScreen(startupName: startupName))),
      ),
      _QuickAction(
        icon: Icons.trending_up,
        label: 'Raise Fund',
        color: const Color(0xFF059669),
        onTap: () => Navigator.push(context, _smoothRoute(FundraisingDashboardScreen(startupName: startupName))),
      ),
      _QuickAction(
        icon: Icons.work_outline,
        label: 'Jobs',
        color: const Color(0xFFD97706),
        onTap: () => Navigator.push(context, _smoothRoute(HiringCommandScreen(startupName: startupName))),
      ),
      _QuickAction(
        icon: Icons.inventory_2_outlined,
        label: 'Products',
        color: const Color(0xFF7C3AED),
        onTap: () => Navigator.push(context, _smoothRoute(StartupProductsScreen(startupName: startupName))),
      ),
      _QuickAction(
        icon: Icons.event_outlined,
        label: 'Event',
        color: const Color(0xFF0891B2),
        onTap: () => Navigator.push(context, _smoothRoute(StartupEventsScreen(startupName: startupName))),
      ),
      _QuickAction(
        icon: Icons.account_balance_wallet_outlined,
        label: 'Investors',
        color: const Color(0xFFF59E0B),
        onTap: () => Navigator.push(context, _smoothRoute(const InvestorPipelineScreen())),
      ),
      _QuickAction(
        icon: Icons.analytics_outlined,
        label: 'Analytics',
        color: const Color(0xFF0891B2),
        onTap: () => Navigator.push(context, _smoothRoute(const StartupAnalyticsScreen())),
      ),
      _QuickAction(
        icon: Icons.flag_outlined,
        label: 'Milestones',
        color: const Color(0xFFE11D48),
        onTap: () => Navigator.push(context, _smoothRoute(const StartupMilestonesScreen())),
      ),
      _QuickAction(
        icon: Icons.folder_outlined,
        label: 'Documents',
        color: const Color(0xFF64748B),
        onTap: () => Navigator.push(context, _smoothRoute(const StartupDocumentsScreen())),
      ),
      _QuickAction(
        icon: Icons.mark_email_unread_outlined,
        label: 'Requests',
        color: const Color(0xFF8B5CF6),
        onTap: () => Navigator.push(context, _smoothRoute(StartupRequestsScreen(startupName: startupName))),
      ),
      _QuickAction(
        icon: Icons.alt_route_rounded,
        label: 'Connect',
        color: const Color(0xFF4F46E5),
        onTap: () => Navigator.push(context, _smoothRoute(const ConnectScreen())),
      ),
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1A1D35) : Colors.white;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : const Color(0xFF000000)).withValues(alpha: isDark ? 0.3 : 0.03),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 14,
        crossAxisSpacing: 8,
        childAspectRatio: 0.82,
        children: actions.map((a) => _QuickActionCell(action: a)).toList(),
      ),
    );
  }
}

class _QuickActionCell extends StatelessWidget {
  const _QuickActionCell({required this.action});
  final _QuickAction action;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF374151);

    return GestureDetector(
      onTap: action.onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: action.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(action.icon, color: action.color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            action.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: labelColor,
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
}

// ── Bottom Navigation Bar ──
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.selectedIndex,
    required this.onTap,
    this.messagesUnread = 0,
  });
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final int messagesUnread;

  static const double _navBarHeight = 64;
  static const double _fabSize = 56;
  static const double _navBarTop = 14;
  static const double _fabTop = -12;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final totalHeight = _navBarTop + _navBarHeight + bottomInset + 8;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBg = isDark ? const Color(0xFF1A1D35) : Colors.white;
    final navBorder = isDark ? const Color(0xFF2D3352) : const Color(0xFFE2E4EA);
    final selectedColor = const Color(0xFF5B21B6);
    final unselectedColor = isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF);
    final shadowColor = isDark ? Colors.black : Colors.black.withValues(alpha: 0.08);

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
                painter: _SeamlessNavPainter(
                  fillColor: navBg,
                  borderColor: navBorder,
                  shadowColor: shadowColor,
                ),
                size: Size.infinite,
                child: SizedBox(
                  height: _navBarHeight,
                  child: Row(
                    children: [
                      _navItem(0, Icons.home_outlined, Icons.home_rounded, 'Home', selectedColor: selectedColor, unselectedColor: unselectedColor),
                      _navItem(1, Icons.people_outline, Icons.people_rounded, 'Network', selectedColor: selectedColor, unselectedColor: unselectedColor),
                      SizedBox(width: _fabSize + 12),
                      _navItem(3, Icons.chat_bubble_outline, Icons.chat_bubble_rounded, 'Messages', badge: messagesUnread, selectedColor: selectedColor, unselectedColor: unselectedColor),
                      _navItem(4, Icons.person_outline, Icons.person, 'Profile', selectedColor: selectedColor, unselectedColor: unselectedColor),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: _fabTop,
            child: _addButton(),
          ),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, IconData activeIcon, String label, {
    int badge = 0,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    final selected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  selected ? activeIcon : icon,
                  color: selected ? selectedColor : unselectedColor,
                  size: 24,
                ),
                if (badge > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Text(
                        badge > 9 ? '9+' : '$badge',
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? selectedColor : unselectedColor,
              ),
            ),
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
          gradient: const LinearGradient(
            colors: [Color(0xFF5B21B6), Color(0xFF7C3AED)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5B21B6).withValues(alpha: 0.30),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}

class _SeamlessNavPainter extends CustomPainter {
  const _SeamlessNavPainter({
    required this.fillColor,
    required this.borderColor,
    required this.shadowColor,
  });
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
      // Top-left corner
      ..moveTo(cornerRadius, 0)
      // Top edge left — flat to notch entry
      ..lineTo(centerX - notchW, 0)
      // ── Deep U-shaped notch: wraps ~55% of FAB ──
      // Left entry — tangent flows from horizontal into the U-descent
      ..cubicTo(
        centerX - notchW + 10, 0,
        centerX - notchR * 1.1, notchR * 0.06,
        centerX - notchR, notchR * 0.35,
      )
      // Left wall — follows FAB curvature downward
      ..cubicTo(
        centerX - notchR * 0.92, notchR * 0.6,
        centerX - notchR * 0.75, notchR * 0.85,
        centerX - notchR * 0.5, notchR * 0.98,
      )
      // Left bottom — smooth curve into U-base
      ..cubicTo(
        centerX - notchR * 0.28, notchR * 1.05,
        centerX - 14, notchR * 1.06,
        centerX, notchR * 1.06,
      )
      // Right bottom — mirror of left bottom
      ..cubicTo(
        centerX + 14, notchR * 1.06,
        centerX + notchR * 0.28, notchR * 1.05,
        centerX + notchR * 0.5, notchR * 0.98,
      )
      // Right wall — follows FAB curvature upward
      ..cubicTo(
        centerX + notchR * 0.75, notchR * 0.85,
        centerX + notchR * 0.92, notchR * 0.6,
        centerX + notchR, notchR * 0.35,
      )
      // Right exit — tangent flows from U-ascent into horizontal
      ..cubicTo(
        centerX + notchR * 1.1, notchR * 0.06,
        centerX + notchW - 10, 0,
        centerX + notchW, 0,
      )
      // Top edge right — flat surface
      ..lineTo(w - cornerRadius, 0)
      // Top-right corner
      ..arcToPoint(Offset(w, cornerRadius), radius: Radius.circular(cornerRadius))
      // Right edge
      ..lineTo(w, h - cornerRadius)
      // Bottom-right corner
      ..arcToPoint(Offset(w - cornerRadius, h), radius: Radius.circular(cornerRadius))
      // Bottom edge — subtle upward arc
      ..quadraticBezierTo(centerX, h - bottomArc, cornerRadius, h)
      // Bottom-left corner
      ..arcToPoint(Offset(0, h - cornerRadius), radius: Radius.circular(cornerRadius))
      // Left edge
      ..lineTo(0, cornerRadius)
      // Top-left corner
      ..arcToPoint(Offset(cornerRadius, 0), radius: Radius.circular(cornerRadius))
      ..close();

    // Premium shadow
    canvas.drawShadow(path, shadowColor, 24, true);
    canvas.drawShadow(path, shadowColor.withValues(alpha: 0.5), 6, true);

    // Fill
    canvas.drawPath(path, Paint()..style = PaintingStyle.fill..color = fillColor);

    // Border — consistent 1px
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = borderColor,
    );
  }

  @override
  bool shouldRepaint(covariant _SeamlessNavPainter oldDelegate) =>
      oldDelegate.fillColor != fillColor ||
      oldDelegate.borderColor != borderColor ||
      oldDelegate.shadowColor != shadowColor;
}
