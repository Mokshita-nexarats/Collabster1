import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/theme/investor_colors.dart';
import '../../../../shared/widgets/role_switcher_sheet.dart';
import '../../../auth/view/screens/profile_screen.dart';
import '../../../auth/view/sign_in_screen.dart';

/// Investor's own profile — rich identity, interactive preferences, stats and settings.
class InvestorProfileScreen extends ConsumerStatefulWidget {
  const InvestorProfileScreen({
    super.key,
    this.embedded = false,
    this.onGoHome,
  });

  final bool embedded;
  final VoidCallback? onGoHome;

  @override
  ConsumerState<InvestorProfileScreen> createState() => _InvestorProfileScreenState();
}

class _InvestorProfileScreenState extends ConsumerState<InvestorProfileScreen> {
  int _activeTab = 0; // 0: Overview & Preferences, 1: Portfolio & Activity, 2: Account & Settings

  // Interactive Preference State
  final Set<String> _selectedStages = {'Pre-Seed', 'Seed', 'Series A'};
  final Set<String> _selectedSectors = {'Fintech', 'AI / SaaS', 'HealthTech', 'Robotics'};
  RangeValues _checkSizeRange = const RangeValues(25000, 250000);
  bool _accreditedVerified = true;
  bool _dealNotifications = true;

  static const _allStages = ['Pre-Seed', 'Seed', 'Series A', 'Series B', 'Growth'];
  static const _allSectors = [
    'Fintech',
    'AI / SaaS',
    'HealthTech',
    'Robotics',
    'Climate Tech',
    'Web3 / Crypto',
    'EdTech',
    'E-commerce'
  ];

  String _compact(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(2)}M';
    }
    if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(0)}K';
    }
    return '\$${value.toStringAsFixed(0)}';
  }

  String _getInitials(String name) {
    final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts.isNotEmpty) return parts[0][0].toUpperCase();
    return 'IN';
  }

  void _showEditPreferencesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  const SizedBox(height: 14),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: InvestorColors.border,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Edit Preferences',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: InvestorColors.ink,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: InvestorColors.textMuted),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: InvestorColors.border),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PREFERRED STAGES',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                              color: InvestorColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _allStages.map((stage) {
                              final isSelected = _selectedStages.contains(stage);
                              return FilterChip(
                                label: Text(stage),
                                selected: isSelected,
                                onSelected: (val) {
                                  setSheetState(() {
                                    if (val) {
                                      _selectedStages.add(stage);
                                    } else if (_selectedStages.length > 1) {
                                      _selectedStages.remove(stage);
                                    }
                                  });
                                  setState(() {});
                                },
                                selectedColor: InvestorColors.goldDeep,
                                labelStyle: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? Colors.white : InvestorColors.inkSoft,
                                ),
                                backgroundColor: InvestorColors.goldBg,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                  side: BorderSide(
                                    color: isSelected
                                        ? InvestorColors.goldDeep
                                        : InvestorColors.goldLight,
                                  ),
                                ),
                                showCheckmark: false,
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'TARGET SECTORS',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                              color: InvestorColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _allSectors.map((sector) {
                              final isSelected = _selectedSectors.contains(sector);
                              return FilterChip(
                                label: Text(sector),
                                selected: isSelected,
                                onSelected: (val) {
                                  setSheetState(() {
                                    if (val) {
                                      _selectedSectors.add(sector);
                                    } else if (_selectedSectors.length > 1) {
                                      _selectedSectors.remove(sector);
                                    }
                                  });
                                  setState(() {});
                                },
                                selectedColor: InvestorColors.goldDeep,
                                labelStyle: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? Colors.white : InvestorColors.inkSoft,
                                ),
                                backgroundColor: InvestorColors.goldBg,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                  side: BorderSide(
                                    color: isSelected
                                        ? InvestorColors.goldDeep
                                        : InvestorColors.goldLight,
                                  ),
                                ),
                                showCheckmark: false,
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'CHECK SIZE RANGE',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                  color: InvestorColors.textMuted,
                                ),
                              ),
                              Text(
                                '${_compact(_checkSizeRange.start)} - ${_compact(_checkSizeRange.end)}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: InvestorColors.goldDeep,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          RangeSlider(
                            values: _checkSizeRange,
                            min: 10000,
                            max: 1000000,
                            divisions: 99,
                            activeColor: InvestorColors.goldDeep,
                            inactiveColor: InvestorColors.goldLight,
                            labels: RangeLabels(
                              _compact(_checkSizeRange.start),
                              _compact(_checkSizeRange.end),
                            ),
                            onChanged: (values) {
                              setSheetState(() => _checkSizeRange = values);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Investment preferences saved!'),
                              backgroundColor: InvestorColors.goldDeep,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: InvestorColors.goldDeep,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Save Preferences',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authViewModelProvider).session;
    final userName = session?.fullName ?? 'Investor';
    final email = session?.email ?? 'investor@collabsphere.app';
    final photoPath = session?.profilePhotoPath ?? '';
    final hasPhoto = photoPath.isNotEmpty && File(photoPath).existsSync();
    final state = ref.watch(investorViewModelProvider);
    final invested = state.totalInvested;

    return Scaffold(
      backgroundColor: InvestorColors.goldBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header section
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(gradient: InvestorColors.headerGradient),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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
                              child: const Icon(Icons.person_rounded, color: Colors.white, size: 21),
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'My Investor Hub',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Identity, Thesis & Controls',
                                  style: TextStyle(color: Colors.white70, fontSize: 12.5),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Balance spacer so the title stays truly centered
                          const SizedBox(width: 42),
                        ],
                      ),
                      const SizedBox(height: 22),
                      // Profile Identity Header Card
                      Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 34,
                                backgroundColor: Colors.white.withValues(alpha: 0.2),
                                backgroundImage: hasPhoto ? FileImage(File(photoPath)) : null,
                                child: hasPhoto
                                    ? null
                                    : Text(
                                        _getInitials(userName),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                              ),
                              if (_accreditedVerified)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(
                                      color: InvestorColors.goldDeep,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.verified_rounded,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 21,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  email,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.75),
                                    fontSize: 12.5,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 6,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.18),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.workspace_premium_rounded, size: 12, color: Colors.white),
                                          SizedBox(width: 4),
                                          Text(
                                            'Angel Investor',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (_accreditedVerified)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                                        decoration: BoxDecoration(
                                          color: InvestorColors.green.withValues(alpha: 0.25),
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                        child: const Text(
                                          'Accredited',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    _headerAction(
                                      Icons.share_outlined,
                                      'Share profile',
                                      () => _shareProfile(userName),
                                    ),
                                    const SizedBox(width: 10),
                                    _headerAction(
                                      Icons.edit_outlined,
                                      'Edit thesis',
                                      _showEditPreferencesSheet,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Stats Overview Row
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            _headerStatCell('${state.investments.length}', 'DEALS CLOSED'),
                            _headerDivider(),
                            _headerStatCell(_compact(invested), 'CAPITAL DEPLOYED'),
                            _headerDivider(),
                            _headerStatCell('${state.fundingRounds.length}', 'PIPELINE'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content section with tab selector
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Tab Selection Pills
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: InvestorColors.border),
                  ),
                  child: Row(
                    children: [
                      _tabPill(0, 'Preferences'),
                      _tabPill(1, 'Portfolio'),
                      _tabPill(2, 'Settings'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                if (_activeTab == 0) ...[
                  // Overview & Preferences Tab
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Investment Thesis',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: InvestorColors.ink,
                          letterSpacing: -0.2,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _showEditPreferencesSheet,
                        icon: const Icon(Icons.edit_rounded, size: 16, color: InvestorColors.goldDeep),
                        label: const Text(
                          'Edit',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: InvestorColors.goldDeep,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: InvestorColors.border),
                      boxShadow: const [
                        BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TARGET STAGES',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                            color: InvestorColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _selectedStages.map((stage) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                              decoration: BoxDecoration(
                                color: InvestorColors.goldSoft,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: InvestorColors.goldLight),
                              ),
                              child: Text(
                                stage,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: InvestorColors.goldDeep,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'SECTOR FOCUS',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                            color: InvestorColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _selectedSectors.map((sector) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                              decoration: BoxDecoration(
                                color: InvestorColors.goldSoft,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: InvestorColors.goldLight),
                              ),
                              child: Text(
                                sector,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: InvestorColors.goldDeep,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'TARGET CHECK SIZE',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                                color: InvestorColors.textMuted,
                              ),
                            ),
                            Text(
                              '${_compact(_checkSizeRange.start)} - ${_compact(_checkSizeRange.end)}',
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: InvestorColors.ink,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildRangeVisualizer(_checkSizeRange),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Investor Verification & Badges',
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
                      boxShadow: const [
                        BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: InvestorColors.goldSoft,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.workspace_premium_rounded,
                                color: InvestorColors.goldDeep,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Accredited Investor Status',
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w800,
                                      color: InvestorColors.ink,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Verified by CollabSphere Capital Desk',
                                    style: TextStyle(fontSize: 12, color: InvestorColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _accreditedVerified,
                              activeColor: InvestorColors.goldDeep,
                              onChanged: (val) {
                                setState(() => _accreditedVerified = val);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ] else if (_activeTab == 1) ...[
                  // Portfolio Summary & Activity
                  const Text(
                    'Portfolio Snapshot',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: InvestorColors.ink,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: InvestorColors.border),
                      boxShadow: const [
                        BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'TOTAL ASSETS VALUE',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                                color: InvestorColors.textMuted,
                              ),
                            ),
                            Text(
                              '${state.roiPercent >= 0 ? '+' : ''}${state.roiPercent.toStringAsFixed(1)}% ROI',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: state.roiPercent >= 0 ? InvestorColors.green : InvestorColors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _compact(state.portfolioValue),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: InvestorColors.ink,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1, color: InvestorColors.border),
                        const SizedBox(height: 16),
                        if (state.investments.isEmpty)
                          const Text(
                            'No investments yet — deals you close will appear here.',
                            style: TextStyle(fontSize: 12.5, color: InvestorColors.textMuted),
                          )
                        else
                          ...state.investments.take(3).map(
                              (inv) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: InvestorColors.colorForKey(inv.colorKey).withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.show_chart_rounded,
                                        color: InvestorColors.colorForKey(inv.colorKey),
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            inv.company,
                                            style: const TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w800,
                                              color: InvestorColors.ink,
                                            ),
                                          ),
                                          Text(
                                            '${inv.stage} • ${inv.sector}',
                                            style: const TextStyle(fontSize: 11, color: InvestorColors.textMuted),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      _compact(inv.currentValue),
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w800,
                                        color: InvestorColors.ink,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ] else ...[
                  // Settings & Account
                  const Text(
                    'Settings & Preferences',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: InvestorColors.ink,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: InvestorColors.border),
                      boxShadow: const [
                        BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      children: [
                        _settingsTile(
                          icon: Icons.notifications_none_rounded,
                          title: 'Deal Flow Notifications',
                          subtitle: 'Receive alerts when new rounds open',
                          trailing: Switch(
                            value: _dealNotifications,
                            activeColor: InvestorColors.goldDeep,
                            onChanged: (val) => setState(() => _dealNotifications = val),
                          ),
                        ),
                        const Divider(height: 1, color: InvestorColors.border),
                        _settingsActionTile(
                          icon: Icons.account_circle_outlined,
                          title: 'View Account Profile',
                          color: InvestorColors.goldDeep,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ProfileScreen()),
                            );
                          },
                        ),
                        const Divider(height: 1, color: InvestorColors.border),
                        _settingsActionTile(
                          icon: Icons.swap_horiz_rounded,
                          title: 'Switch Tab',
                          color: InvestorColors.blue,
                          onTap: () => RoleSwitcherSheet.show(context),
                        ),
                        const Divider(height: 1, color: InvestorColors.border),
                        _settingsActionTile(
                          icon: Icons.home_rounded,
                          title: 'Go to Home',
                          color: InvestorColors.goldDeep,
                          onTap: widget.onGoHome ?? () => Navigator.pop(context),
                        ),
                        const Divider(height: 1, color: InvestorColors.border),
                        _settingsActionTile(
                          icon: Icons.logout_rounded,
                          title: 'Logout',
                          color: InvestorColors.red,
                          onTap: () async {
                            await ref.read(authViewModelProvider.notifier).logout();
                            if (!context.mounted) return;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const SignInScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabPill(int index, String title) {
    final selected = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? InvestorColors.goldDeep : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              color: selected ? Colors.white : InvestorColors.inkSoft,
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerStatCell(String value, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 8.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 15),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareProfile(String userName) {
    Clipboard.setData(
      ClipboardData(text: 'Check out $userName — Investor on Collabster!'),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile link copied to clipboard'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _headerDivider() {
    return Container(
      width: 1,
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white.withValues(alpha: 0.25),
    );
  }

  Widget _buildRangeVisualizer(RangeValues values) {
    const min = 10000.0;
    const max = 1000000.0;
    final startF = ((values.start - min) / (max - min)).clamp(0.0, 1.0);
    final endF = ((values.end - min) / (max - min)).clamp(0.0, 1.0);

    // LayoutBuilder keeps the fill proportional on every screen width
    // (the old build used a hardcoded 280px width and mis-rendered).
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        return Container(
          height: 10,
          width: double.infinity,
          decoration: BoxDecoration(
            color: InvestorColors.goldBg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: InvestorColors.goldLight),
          ),
          child: Stack(
            children: [
              Positioned(
                left: startF * w,
                width: (endF - startF) * w,
                top: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: InvestorColors.goldShimmer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: InvestorColors.goldSoft,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: InvestorColors.goldDeep, size: 20),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: InvestorColors.ink,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11.5, color: InvestorColors.textMuted),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _settingsActionTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: InvestorColors.ink,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: InvestorColors.textMuted,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}