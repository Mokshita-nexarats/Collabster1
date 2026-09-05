import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/theme/investor_colors.dart';
import '../../model/investment_model.dart';
import '../widgets/investment_tile.dart';
import 'pitch_deck_screen.dart';

/// Portfolio & Syndicate Hub Screen:
/// 1. Holdings & Performance (Allocation Chart & Companies)
/// 2. Syndicates & Co-Investments (Lead Investor Syndicates)
/// 3. Diligence & Vault (Cap Table, Term Sheets & Diligence Checks)
class PortfolioScreen extends ConsumerStatefulWidget {
  const PortfolioScreen({
    super.key,
    this.embedded = false,
    this.onViewAllDeals,
  });

  final bool embedded;
  final VoidCallback? onViewAllDeals;

  @override
  ConsumerState<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends ConsumerState<PortfolioScreen> {
  int _selectedTab = 0; // 0: Holdings, 1: Syndicates, 2: Diligence

  String _compact(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(2)}M';
    }
    if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(0)}K';
    }
    return '\$${value.toStringAsFixed(0)}';
  }

  List<PieChartSectionData> _sections(List<Investment> investments) {
    final bySector = <String, double>{};
    for (final inv in investments) {
      bySector[inv.sector] = (bySector[inv.sector] ?? 0) + inv.currentValue;
    }

    final total = bySector.values.fold(0.0, (a, b) => a + b);
    if (total == 0) return const [];

    final entries = bySector.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return entries.asMap().entries.map((entry) {
      final index = entry.key;
      final value = entry.value.value;
      final color = InvestorColors.chartPalette[index % InvestorColors.chartPalette.length];

      return PieChartSectionData(
        value: value,
        color: color,
        radius: 46,
        title: '${(value / total * 100).toStringAsFixed(0)}%',
        titleStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
        showTitle: value / total >= 0.06,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(investorViewModelProvider);
    final investments = state.investments;
    final total = state.portfolioValue;

    return Scaffold(
      backgroundColor: InvestorColors.goldBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header banner
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(gradient: InvestorColors.headerGradient),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (widget.embedded)
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.pie_chart_rounded, color: Colors.white, size: 21),
                            )
                          else
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 21),
                              ),
                            ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Portfolio & Syndicates',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Holdings, syndicates & diligence vault',
                                  style: TextStyle(color: Colors.white70, fontSize: 12.5),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: state.totalGain >= 0
                                  ? InvestorColors.green.withValues(alpha: 0.25)
                                  : InvestorColors.red.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '${state.totalGain >= 0 ? '+' : ''}${_compact(state.totalGain)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Net Portfolio Value',
                        style: TextStyle(color: Colors.white70, fontSize: 12.5),
                      ),
                      const SizedBox(height: 4),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: total),
                        duration: const Duration(milliseconds: 1100),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, _) => Text(
                          _compact(value),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _headerStat('INVESTED', _compact(state.totalInvested)),
                          const SizedBox(width: 24),
                          _headerStat('TOTAL GAIN', '${state.totalGain >= 0 ? '+' : ''}${_compact(state.totalGain)}'),
                          const SizedBox(width: 24),
                          _headerStat('ROI', '${state.roiPercent >= 0 ? '+' : ''}${state.roiPercent.toStringAsFixed(1)}%'),
                        ],
                      ),
                      const SizedBox(height: 18),
                      // Sub-Tab Switcher Pill Bar
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            _buildSubTab(0, 'Holdings', Icons.pie_chart_rounded),
                            _buildSubTab(1, 'Syndicates', Icons.groups_rounded),
                            _buildSubTab(2, 'Diligence', Icons.fact_check_rounded),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Dynamic Tab Content
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (_selectedTab == 0) _buildHoldingsTab(investments, total),
                if (_selectedTab == 1) _buildSyndicatesTab(),
                if (_selectedTab == 2) _buildDiligenceTab(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubTab(int index, String label, IconData icon) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? InvestorColors.goldDeep : Colors.white.withValues(alpha: 0.75),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? InvestorColors.ink : Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHoldingsTab(List<Investment> investments, double total) {
    final bySector = <String, double>{};
    for (final inv in investments) {
      bySector[inv.sector] = (bySector[inv.sector] ?? 0) + inv.currentValue;
    }
    final sectors = bySector.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Allocation
        const Text(
          'Sector Allocation',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: InvestorColors.ink,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: InvestorColors.border),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: PieChart(
                  PieChartData(
                    sections: _sections(investments),
                    sectionsSpace: 3,
                    centerSpaceRadius: 36,
                    startDegreeOffset: -90,
                  ),
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeOutCubic,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: sectors.asMap().entries.map((entry) {
                    final index = entry.key;
                    final sector = entry.value.key;
                    final value = entry.value.value;
                    final pct = total == 0 ? 0 : value / total * 100;
                    final color = InvestorColors.chartPalette[index % InvestorColors.chartPalette.length];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              sector,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: InvestorColors.ink,
                              ),
                            ),
                          ),
                          Text(
                            '${pct.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: InvestorColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),

        // Holdings
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Holdings',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: InvestorColors.ink,
                letterSpacing: -0.2,
              ),
            ),
            Text(
              '${investments.length} companies',
              style: const TextStyle(
                fontSize: 12.5,
                color: InvestorColors.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (investments.isEmpty)
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: InvestorColors.border),
            ),
            child: const Column(
              children: [
                Icon(Icons.pie_chart_outline_rounded, size: 44, color: InvestorColors.textMuted),
                SizedBox(height: 12),
                Text(
                  'No investments yet',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: InvestorColors.ink,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Discover live funding rounds and build your portfolio.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.5, color: InvestorColors.textMuted),
                ),
              ],
            ),
          )
        else
          ...investments.map(
            (inv) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InvestmentTile(investment: inv),
            ),
          ),
        const SizedBox(height: 6),
        if (widget.onViewAllDeals != null)
          GestureDetector(
            onTap: widget.onViewAllDeals,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: InvestorColors.goldLight),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Discover more deals',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: InvestorColors.goldDeep,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, size: 16, color: InvestorColors.goldDeep),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSyndicatesTab() {
    final syndicates = [
      {
        'name': 'Apex VC Syndicate',
        'lead': 'Sarah Jenkins',
        'role': 'Managing Partner, Apex Ventures',
        'focus': 'Enterprise AI & SaaS',
        'minTicket': '\$25,000',
        'carry': '15%',
        'activeDeal': 'Nova Robotics Series A',
        'allocation': '\$1.2M Allocation',
        'members': '42 LPs',
        'color': InvestorColors.goldDeep,
      },
      {
        'name': 'DeepTech Founders Guild',
        'lead': 'Dr. Marcus Vance',
        'role': 'Founder, Vance Bio Labs',
        'focus': 'Quantum, BioTech & Materials',
        'minTicket': '\$50,000',
        'carry': '20%',
        'activeDeal': 'Aura Bio-Health Seed',
        'allocation': '\$800K Allocation',
        'members': '28 LPs',
        'color': const Color(0xFF0088CC),
      },
      {
        'name': 'FinTech Pioneers Network',
        'lead': 'Elena Rostova',
        'role': 'Ex-Stripe VP, Angel Investor',
        'focus': 'Cross-Border Payments & Web3',
        'minTicket': '\$10,000',
        'carry': '10%',
        'activeDeal': 'FinEdge Seed Round',
        'allocation': '\$600K Allocation',
        'members': '65 LPs',
        'color': const Color(0xFF2563EB),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary stats row
        Row(
          children: [
            Expanded(child: _buildSyndicateStatCard('ACTIVE SYNDICATES', '3 Lead Guilds', Icons.groups_rounded, InvestorColors.goldDeep)),
            const SizedBox(width: 12),
            Expanded(child: _buildSyndicateStatCard('CO-INVESTED', '\$450K', Icons.account_balance_rounded, InvestorColors.green)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Lead Investor Syndicates',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: InvestorColors.ink,
                letterSpacing: -0.2,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: InvestorColors.goldDeep.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'Co-Invest',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: InvestorColors.goldDeep,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...syndicates.map((syn) => Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: InvestorColors.border),
                boxShadow: const [
                  BoxShadow(color: Color(0x08000000), blurRadius: 12, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: (syn['color'] as Color).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(Icons.hub_rounded, color: syn['color'] as Color, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              syn['name'] as String,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: InvestorColors.ink,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Lead: ${syn['lead']} • ${syn['members']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: InvestorColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: (syn['color'] as Color).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${syn['carry']} Carry',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: syn['color'] as Color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: InvestorColors.goldBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.rocket_launch_rounded, size: 16, color: InvestorColors.goldDeep),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                syn['activeDeal'] as String,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: InvestorColors.ink,
                                ),
                              ),
                              Text(
                                syn['allocation'] as String,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: InvestorColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Min: ${syn['minTicket']}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: InvestorColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Requesting allocation in ${syn['name']}...'),
                                backgroundColor: InvestorColors.ink,
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: InvestorColors.border),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text(
                            'View Details',
                            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: InvestorColors.ink),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Joined ${syn['name']} syndicate!'),
                                backgroundColor: InvestorColors.goldDeep,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: syn['color'] as Color,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text(
                            'Join Syndicate',
                            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildSyndicateStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: InvestorColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: InvestorColors.ink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiligenceTab() {
    final diligenceDeals = [
      {
        'startup': 'Nova Robotics',
        'round': 'Series A',
        'progress': 0.85,
        'checks': [
          {'title': 'Financial Audit & Cap Table', 'status': true},
          {'title': 'Technical Architecture & IP', 'status': true},
          {'title': 'Founder Background Verification', 'status': true},
          {'title': 'Term Sheet Finalization', 'status': false},
        ],
      },
      {
        'startup': 'FinEdge Tech',
        'round': 'Seed Round',
        'progress': 0.50,
        'checks': [
          {'title': 'Founding Team Reference Check', 'status': true},
          {'title': 'Regulatory Compliance Check', 'status': true},
          {'title': 'Valuation Audit & MoIC Model', 'status': false},
          {'title': 'Legal Due Diligence Vault', 'status': false},
        ],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Active Diligence Vault',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: InvestorColors.ink,
                letterSpacing: -0.2,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PitchDeckScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: InvestorColors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.description_rounded, size: 14, color: InvestorColors.blue),
                    SizedBox(width: 4),
                    Text(
                      'Pitch Decks',
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: InvestorColors.blue),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...diligenceDeals.map((deal) => Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: InvestorColors.border),
                boxShadow: const [
                  BoxShadow(color: Color(0x08000000), blurRadius: 12, offset: Offset(0, 4)),
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
                          gradient: InvestorColors.goldShimmer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              deal['startup'] as String,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: InvestorColors.ink,
                              ),
                            ),
                            Text(
                              '${deal['round']} • Diligence Checklist',
                              style: const TextStyle(
                                fontSize: 12,
                                color: InvestorColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${((deal['progress'] as double) * 100).toInt()}% Done',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: InvestorColors.goldDeep,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: deal['progress'] as double,
                      minHeight: 6,
                      backgroundColor: InvestorColors.goldBg,
                      valueColor: const AlwaysStoppedAnimation(InvestorColors.goldDeep),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...((deal['checks'] as List<Map<String, dynamic>>).map((check) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                              check['status'] == true ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                              size: 16,
                              color: check['status'] == true ? InvestorColors.green : Colors.grey.shade400,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                check['title'] as String,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: check['status'] == true ? FontWeight.w600 : FontWeight.w400,
                                  color: check['status'] == true ? InvestorColors.ink : Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))),
                ],
              ),
            )),
        const SizedBox(height: 16),

        // Term Sheet Vault
        const Text(
          'Term Sheet Vault & Templates',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: InvestorColors.ink,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: InvestorColors.border),
          ),
          child: Column(
            children: [
              _buildVaultItem('Y-Combinator SAFE Note (MFN)', 'Standard Post-Money SAFE', Icons.article_rounded, InvestorColors.goldDeep),
              const Divider(height: 20),
              _buildVaultItem('Convertible Security Agreement', 'Cap Table Valuation Cap', Icons.gavel_rounded, InvestorColors.purple),
              const Divider(height: 20),
              _buildVaultItem('Series A Preferred Stock Term Sheet', 'NVCA Standard Template', Icons.shield_rounded, InvestorColors.blue),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVaultItem(String title, String subtitle, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
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
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: InvestorColors.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: InvestorColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Downloading $title template...'),
                backgroundColor: InvestorColors.ink,
              ),
            );
          },
          icon: const Icon(Icons.download_rounded, size: 20, color: InvestorColors.goldDeep),
        ),
      ],
    );
  }

  Widget _headerStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}