import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/bridge/view/connect_screen.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/theme/investor_colors.dart';
import '../../../auth/view/screens/profile_screen.dart';
import '../../../auth/view/sign_in_screen.dart';
import '../../../../shared/widgets/role_switcher_sheet.dart';
import '../../model/funding_round_model.dart';
import '../../viewmodel/investor_viewmodel.dart';
import 'deal_flow_screen.dart';
import 'investor_detail_screen.dart';
import 'investor_messages_screen.dart';
import 'investor_profile_screen.dart';
import 'pitch_deck_screen.dart';
import 'portfolio_screen.dart';
import 'investor_reminders_screen.dart';
import 'investor_notes_screen.dart';
import 'investor_meetings_screen.dart';
import 'investor_notifications_screen.dart';

class InvestorHomeScreen extends ConsumerStatefulWidget {
  const InvestorHomeScreen({super.key});

  @override
  ConsumerState<InvestorHomeScreen> createState() => _InvestorHomeScreenState();
}

class _InvestorHomeScreenState extends ConsumerState<InvestorHomeScreen> {
  int _selectedIndex = 0;

  String get _timeBasedGreeting {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good Morning';
    if (hour >= 12 && hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(investorViewModelProvider.notifier).loadInvestorData();
      ref.read(pitchDeckViewModelProvider.notifier).loadPitchDecks();
      ref.read(bridgeViewModelProvider.notifier).loadAll();
    });
  }

  void _onNavTap(int index) {
    if (index == 4) {
      _showProfileSheet();
      return;
    }
    setState(() => _selectedIndex = index);
  }

  void _openTab(int index) => setState(() => _selectedIndex = index);

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
                    icon: Icons.add_chart_rounded,
                    label: 'Add Deal',
                    color: InvestorColors.goldDeep,
                    onTap: () {
                      Navigator.pop(ctx);
                      _showAddDealSheet(context);
                    },
                  ),
                  _simpleActionItem(
                    ctx,
                    icon: Icons.edit_note_rounded,
                    label: 'Post Update',
                    color: const Color(0xFFEA580C),
                    onTap: () {
                      Navigator.pop(ctx);
                      _showPostUpdateSheet(context);
                    },
                  ),
                  _simpleActionItem(
                    ctx,
                    icon: Icons.calendar_month_rounded,
                    label: 'Schedule Meet',
                    color: const Color(0xFF0D9488),
                    onTap: () {
                      Navigator.pop(ctx);
                      _showScheduleMeetingSheet(context);
                    },
                  ),
                  _simpleActionItem(
                    ctx,
                    icon: Icons.description_rounded,
                    label: 'Pitch Decks',
                    color: const Color(0xFF2563EB),
                    onTap: () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PitchDeckScreen()),
                      );
                    },
                  ),
                  _simpleActionItem(
                    ctx,
                    icon: Icons.note_add_rounded,
                    label: 'Quick Note',
                    color: const Color(0xFF7C3AED),
                    onTap: () {
                      Navigator.pop(ctx);
                      _showQuickNoteSheet(context);
                    },
                  ),
                  _simpleActionItem(
                    ctx,
                    icon: Icons.flag_rounded,
                    label: 'Set Reminder',
                    color: const Color(0xFFF59E0B),
                    onTap: () {
                      Navigator.pop(ctx);
                      _showSetReminderSheet(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _simpleActionItem(
    BuildContext ctx, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
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

  void _showAddDealSheet(BuildContext context) {
    final startupController = TextEditingController();
    final targetController = TextEditingController(text: '1200000');
    final raisedController = TextEditingController(text: '450000');
    final locationController = TextEditingController(text: 'San Francisco, US');
    String selectedStage = 'Seed';
    String selectedSector = 'Robotics';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
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
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [InvestorColors.goldDeep, Color(0xFFF59E0B)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.add_chart_rounded, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Add New Deal',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12233D)),
                              ),
                              Text(
                                'Publish a startup funding round to Live Deal Flow',
                                style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Icon(Icons.close_rounded, color: Color(0xFF4B5563), size: 20),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: startupController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.business_rounded, color: InvestorColors.goldDeep, size: 20),
                        labelText: 'Startup Name',
                        hintText: 'e.g. Zenith Quantum AI',
                        filled: true,
                        fillColor: const Color(0xFFF9FAFB),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedStage,
                            items: const [
                              DropdownMenuItem(value: 'Pre-Seed', child: Text('Pre-Seed')),
                              DropdownMenuItem(value: 'Seed', child: Text('Seed')),
                              DropdownMenuItem(value: 'Series A', child: Text('Series A')),
                              DropdownMenuItem(value: 'Series B', child: Text('Series B')),
                            ],
                            onChanged: (val) {
                              if (val != null) setModalState(() => selectedStage = val);
                            },
                            decoration: InputDecoration(
                              labelText: 'Stage',
                              filled: true,
                              fillColor: const Color(0xFFF9FAFB),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedSector,
                            items: const [
                              DropdownMenuItem(value: 'Robotics', child: Text('Robotics')),
                              DropdownMenuItem(value: 'Fintech', child: Text('Fintech')),
                              DropdownMenuItem(value: 'AI / SaaS', child: Text('AI / SaaS')),
                              DropdownMenuItem(value: 'HealthTech', child: Text('HealthTech')),
                              DropdownMenuItem(value: 'CleanTech', child: Text('CleanTech')),
                            ],
                            onChanged: (val) {
                              if (val != null) setModalState(() => selectedSector = val);
                            },
                            decoration: InputDecoration(
                              labelText: 'Sector',
                              filled: true,
                              fillColor: const Color(0xFFF9FAFB),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: targetController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Target (\$)',
                              filled: true,
                              fillColor: const Color(0xFFF9FAFB),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: raisedController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Raised (\$)',
                              filled: true,
                              fillColor: const Color(0xFFF9FAFB),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.location_on_rounded, color: InvestorColors.goldDeep, size: 20),
                        labelText: 'HQ Location',
                        filled: true,
                        fillColor: const Color(0xFFF9FAFB),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [InvestorColors.goldDeep, Color(0xFFD97706)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final sName = startupController.text.trim();
                          final name = sName.isEmpty ? 'Zenith Quantum AI' : sName;
                          final target = double.tryParse(targetController.text) ?? 1200000;
                          final raised = double.tryParse(raisedController.text) ?? 450000;
                          final loc = locationController.text.trim().isEmpty ? 'San Francisco, US' : locationController.text.trim();

                          final newRound = FundingRound(
                            id: 'fr_${DateTime.now().millisecondsSinceEpoch}',
                            startup: name,
                            sector: selectedSector,
                            stage: selectedStage,
                            targetAmount: target,
                            raisedAmount: raised,
                            location: loc,
                            colorKey: 'gold',
                            investors: 1,
                            closeDate: 'Sep 30',
                          );

                          ref.read(investorViewModelProvider.notifier).addFundingRound(newRound);

                          Navigator.pop(ctx);
                          _openTab(2);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Deal "$name" added to Live Deal Flow!'),
                              backgroundColor: InvestorColors.goldDeep,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        icon: const Icon(Icons.publish_rounded, color: Colors.white, size: 18),
                        label: const Text('Publish Deal to Live Flow', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPostUpdateSheet(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedCategory = 'Market Thesis';
    final categories = ['Market Thesis', 'Deal Announcement', 'Co-Investment', 'Portfolio Update'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEA580C), Color(0xFFF97316)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFEA580C).withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Post Investment Update',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12233D)),
                            ),
                            Text(
                              'Publish thesis & updates to investor network',
                              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Icon(Icons.close_rounded, color: Color(0xFF4B5563), size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((cat) {
                        final isSel = selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSel,
                            onSelected: (_) => setModalState(() => selectedCategory = cat),
                            selectedColor: const Color(0xFFEA580C),
                            backgroundColor: const Color(0xFFF9FAFB),
                            labelStyle: TextStyle(
                              color: isSel ? Colors.white : const Color(0xFF4B5563),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            side: BorderSide(color: isSel ? Colors.transparent : const Color(0xFFE5E7EB)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.title_rounded, color: Color(0xFFEA580C), size: 20),
                      labelText: 'Headline',
                      hintText: 'e.g. Co-leading Series A round in AI Health',
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFEA580C), width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: contentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.article_rounded, color: Color(0xFFEA580C), size: 20),
                      labelText: 'Update Details',
                      hintText: 'Share market insights, thesis or milestone...',
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFEA580C), width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEA580C), Color(0xFFF97316)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFEA580C).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Update published to Investor Network!'),
                            backgroundColor: Color(0xFFEA580C),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      label: const Text('Publish Update', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showScheduleMeetingSheet(BuildContext context) {
    final titleController = TextEditingController(text: 'Founder Pitch & Sync');
    String selectedType = 'Pitch Call';
    String selectedTime = 'Today 3:00 PM';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0D9488).withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Schedule Meeting',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12233D)),
                            ),
                            Text(
                              'Sync with founders & deal teams',
                              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Icon(Icons.close_rounded, color: Color(0xFF4B5563), size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['Pitch Call', 'Founder Sync', 'Diligence Call', 'Term Sheet'].map((type) {
                        final isSel = selectedType == type;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(type),
                            selected: isSel,
                            onSelected: (_) => setModalState(() => selectedType = type),
                            selectedColor: const Color(0xFF0D9488),
                            backgroundColor: const Color(0xFFF9FAFB),
                            labelStyle: TextStyle(
                              color: isSel ? Colors.white : const Color(0xFF4B5563),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            side: BorderSide(color: isSel ? Colors.transparent : const Color(0xFFE5E7EB)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.subject_rounded, color: Color(0xFF0D9488), size: 20),
                      labelText: 'Subject',
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: 'Nova Robotics',
                    items: const [
                      DropdownMenuItem(value: 'Nova Robotics', child: Text('Nova Robotics (Series A)')),
                      DropdownMenuItem(value: 'FinEdge Tech', child: Text('FinEdge Tech (Seed)')),
                      DropdownMenuItem(value: 'QuantumPay', child: Text('QuantumPay (Pre-Seed)')),
                      DropdownMenuItem(value: 'Aura BioHealth', child: Text('Aura BioHealth (Seed)')),
                    ],
                    onChanged: (_) {},
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.rocket_launch_rounded, color: Color(0xFF0D9488), size: 20),
                      labelText: 'Startup / Founder',
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['Today 3:00 PM', 'Tomorrow 10:00 AM', 'Friday 2:00 PM'].map((time) {
                        final isSel = selectedTime == time;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(time),
                            selected: isSel,
                            onSelected: (_) => setModalState(() => selectedTime = time),
                            selectedColor: const Color(0xFF0D9488).withValues(alpha: 0.15),
                            checkmarkColor: const Color(0xFF0D9488),
                            labelStyle: TextStyle(
                              color: isSel ? const Color(0xFF0D9488) : const Color(0xFF4B5563),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            side: BorderSide(color: isSel ? const Color(0xFF0D9488) : const Color(0xFFE5E7EB)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0D9488).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Meeting scheduled! Calendar invite sent.'),
                            backgroundColor: Color(0xFF0D9488),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.event_available_rounded, color: Colors.white, size: 18),
                      label: const Text('Confirm Schedule', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showQuickNoteSheet(BuildContext context) {
    final noteController = TextEditingController();
    String selectedTag = 'Diligence';
    bool pinToTop = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.note_add_rounded, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Private Diligence Note',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12233D)),
                            ),
                            Text(
                              'Log cap table, valuation & findings',
                              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Icon(Icons.close_rounded, color: Color(0xFF4B5563), size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['Diligence', 'Cap Table', 'Valuation', 'Red Flags', 'Reference'].map((tag) {
                        final isSel = selectedTag == tag;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(tag),
                            selected: isSel,
                            onSelected: (_) => setModalState(() => selectedTag = tag),
                            selectedColor: const Color(0xFF7C3AED),
                            backgroundColor: const Color(0xFFF9FAFB),
                            labelStyle: TextStyle(
                              color: isSel ? Colors.white : const Color(0xFF4B5563),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            side: BorderSide(color: isSel ? Colors.transparent : const Color(0xFFE5E7EB)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: noteController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.sticky_note_2_rounded, color: Color(0xFF7C3AED), size: 20),
                      labelText: 'Note Content',
                      hintText: 'Valuation expectations at \$15M, tech IP verified, cap table audited...',
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.push_pin_rounded, size: 18, color: Color(0xFF7C3AED)),
                      const SizedBox(width: 8),
                      const Text(
                        'Pin note to top of deal vault',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF12233D)),
                      ),
                      const Spacer(),
                      Switch(
                        value: pinToTop,
                        activeColor: const Color(0xFF7C3AED),
                        onChanged: (val) => setModalState(() => pinToTop = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Private diligence note saved!'),
                            backgroundColor: Color(0xFF7C3AED),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.bookmark_added_rounded, color: Colors.white, size: 18),
                      label: const Text('Save Note', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSetReminderSheet(BuildContext context) {
    final titleController = TextEditingController(text: 'Review Series A Term Sheet');
    String selectedPriority = 'Important';
    String selectedTrigger = 'Tomorrow 9 AM';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.flag_rounded, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Set Deal Reminder',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF12233D)),
                            ),
                            Text(
                              'Track closing alerts & milestone follow-ups',
                              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Icon(Icons.close_rounded, color: Color(0xFF4B5563), size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: ['Normal', 'Important', 'High Urgent'].map((prio) {
                      final isSel = selectedPriority == prio;
                      Color chipColor = const Color(0xFFF59E0B);
                      if (prio == 'Normal') chipColor = const Color(0xFF10B981);
                      if (prio == 'High Urgent') chipColor = const Color(0xFFEF4444);

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(prio),
                          selected: isSel,
                          onSelected: (_) => setModalState(() => selectedPriority = prio),
                          selectedColor: chipColor,
                          backgroundColor: const Color(0xFFF9FAFB),
                          labelStyle: TextStyle(
                            color: isSel ? Colors.white : const Color(0xFF4B5563),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          side: BorderSide(color: isSel ? Colors.transparent : const Color(0xFFE5E7EB)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.notifications_active_rounded, color: Color(0xFFF59E0B), size: 20),
                      labelText: 'Reminder Task',
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFF59E0B), width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['In 2 Hours', 'Tomorrow 9 AM', 'In 3 Days', 'In 1 Week'].map((trig) {
                        final isSel = selectedTrigger == trig;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(trig),
                            selected: isSel,
                            onSelected: (_) => setModalState(() => selectedTrigger = trig),
                            selectedColor: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                            checkmarkColor: const Color(0xFFF59E0B),
                            labelStyle: TextStyle(
                              color: isSel ? const Color(0xFFD97706) : const Color(0xFF4B5563),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            side: BorderSide(color: isSel ? const Color(0xFFF59E0B) : const Color(0xFFE5E7EB)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Deal reminder set! Alert scheduled.'),
                            backgroundColor: Color(0xFFF59E0B),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.notifications_active_rounded, color: Colors.white, size: 18),
                      label: const Text('Set Reminder', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeTab(),
      PortfolioScreen(
        embedded: true,
        onViewAllDeals: () => _openTab(2),
      ),
      DealFlowScreen(
        embedded: true,
        onViewPortfolio: () => _openTab(1),
      ),
      const InvestorMessagesScreen(),
      InvestorProfileScreen(
        embedded: true,
        onGoHome: () => _openTab(0),
      ),
    ];

    return Scaffold(
      backgroundColor: InvestorColors.goldBg,
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: _InvestorNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onNavTap,
        onAddTap: _showCreateSheet,
      ),
    );
  }

  // ═══════════════════════ HOME TAB ═══════════════════════

  Widget _buildHomeTab() {
    final authState = ref.watch(authViewModelProvider);
    final session = authState.session;
    final userName = session?.fullName ?? 'Investor';
    final firstName = userName.split(RegExp(r'\s+')).first;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(gradient: InvestorColors.headerGradient),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderRow(),
                    const SizedBox(height: 22),
                    Text(
                      '$_timeBasedGreeting, $firstName',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Here\'s how your investments are performing today.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _PortfolioHeroCard(
                      onTap: () => _openTab(1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 18),
              _buildSectionHeader('Quick Actions'),
              const SizedBox(height: 12),
              _buildActionGrid(),
              const SizedBox(height: 26),
              _buildSectionHeader('Live Deal Flow', onViewAll: () => _openTab(2)),
              const SizedBox(height: 12),
              _buildDealPreview(),
              const SizedBox(height: 26),
              _buildSectionHeader('Investor Network', onViewAll: () => _openTab(2)),
              const SizedBox(height: 12),
              _buildInvestorNetwork(),
              const SizedBox(height: 26),
              _buildConnectBanner(),
            ]),
          ),
        ),
      ],
    );
  }

  void _openNotificationsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const InvestorNotificationsScreen()),
    );
  }

  void _openInvestorProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InvestorProfileScreen(
          embedded: false,
          onGoHome: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showProfileSheet() {
    final session = ref.read(authViewModelProvider).session;
    final userName = session?.fullName ?? 'Investor';
    final email = session?.email ?? '';
    final roleLabel = session?.activeUserRole.label ?? 'Investor';
    final photoPath = session?.profilePhotoPath ?? '';
    final hasPhoto = photoPath.isNotEmpty && File(photoPath).existsSync();

    String getInitials(String name) {
      final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
      if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      if (parts.isNotEmpty) return parts[0][0].toUpperCase();
      return 'IN';
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (ctx) => SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(ctx).viewPadding.bottom + 24),
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
                  const SizedBox(height: 14),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: InvestorColors.goldSoft,
                    backgroundImage: hasPhoto ? FileImage(File(photoPath)) : null,
                    child: hasPhoto
                        ? null
                        : Text(
                            getInitials(userName),
                            style: const TextStyle(
                              color: InvestorColors.goldDeep,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: InvestorColors.ink,
                    ),
                  ),
                  if (email.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      email,
                      style: const TextStyle(
                        fontSize: 13,
                        color: InvestorColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  const SizedBox(height: 2),
                  Text(
                    roleLabel,
                    style: const TextStyle(
                      fontSize: 13,
                      color: InvestorColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sheetAction(
                    Icons.person_outline_rounded,
                    'View Account Profile',
                    InvestorColors.goldDeep,
                    () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfileScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _sheetAction(
                    Icons.workspace_premium_rounded,
                    'Investor Thesis Profile',
                    InvestorColors.goldDeep,
                    () {
                      Navigator.pop(ctx);
                      _openInvestorProfile();
                    },
                  ),
                  const SizedBox(height: 8),
                  _sheetAction(
                    Icons.swap_horiz_rounded,
                    'Switch Tab',
                    InvestorColors.blue,
                    () {
                      Navigator.pop(ctx);
                      RoleSwitcherSheet.show(context);
                    },
                  ),
                  const SizedBox(height: 8),
                  _sheetAction(
                    Icons.logout_rounded,
                    'Logout',
                    InvestorColors.red,
                    () async {
                      final navigator = Navigator.of(context);
                      Navigator.pop(ctx);
                      await ref.read(authViewModelProvider.notifier).logout();
                      if (!mounted) return;
                      navigator.pushReplacement(
                        MaterialPageRoute(builder: (_) => const SignInScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                ],
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
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const Spacer(),
              Icon(Icons.chevron_right_rounded, color: color, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE9C04F), Color(0xFFD4A017)],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1.5),
          ),
          child: const Icon(Icons.trending_up_rounded, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Investor Hub',
                style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
              ),
              Text(
                'Grow smart, invest boldly',
                style: TextStyle(color: Colors.white70, fontSize: 12.5),
              ),
            ],
          ),
        ),
        // Notification bell matching other modes
        GestureDetector(
          onTap: _openNotificationsScreen,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 21),
              ),
              Positioned(
                right: 7,
                top: 7,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: InvestorColors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: InvestorColors.ink,
            letterSpacing: -0.2,
          ),
        ),
        if (onViewAll != null)
          GestureDetector(
            onTap: onViewAll,
            child: const Row(
              children: [
                Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: InvestorColors.goldDeep,
                  ),
                ),
                Icon(Icons.arrow_forward_rounded, size: 15, color: InvestorColors.goldDeep),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildActionGrid() {
    final actions = [
      _HomeAction(
        icon: Icons.flag_rounded,
        label: 'Reminders',
        color: const Color(0xFFF59E0B),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const InvestorRemindersScreen()),
          );
        },
      ),
      _HomeAction(
        icon: Icons.note_add_rounded,
        label: 'Notes',
        color: const Color(0xFF7C3AED),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const InvestorNotesScreen()),
          );
        },
      ),
      _HomeAction(
        icon: Icons.edit_note_rounded,
        label: 'Posts',
        color: const Color(0xFFEA580C),
        onTap: () {
          _showPostUpdateSheet(context);
        },
      ),
      _HomeAction(
        icon: Icons.calendar_month_rounded,
        label: 'Meets',
        color: const Color(0xFF0D9488),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const InvestorMeetingsScreen()),
          );
        },
      ),
      _HomeAction(
        icon: Icons.explore_rounded,
        label: 'Discover Deals',
        color: InvestorColors.goldDeep,
        onTap: () => _openTab(2),
      ),
      _HomeAction(
        icon: Icons.description_rounded,
        label: 'Pitch Decks',
        color: InvestorColors.blue,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PitchDeckScreen()),
          );
        },
      ),
      _HomeAction(
        icon: Icons.alt_route_rounded,
        label: 'Connect',
        color: InvestorColors.purple,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ConnectScreen(modeTheme: 'investor')),
          );
        },
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: InvestorColors.border, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: actions
              .map(
                (a) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: a.onTap,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [a.color, a.color.withValues(alpha: 0.8)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: a.color.withValues(alpha: 0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(a.icon, color: Colors.white, size: 24),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          a.label,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: InvestorColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildDealPreview() {
    final state = ref.watch(investorViewModelProvider);
    final rounds = state.fundingRounds;

    if (rounds.isEmpty) {
      return _EmptyCard(
        icon: Icons.trending_up_rounded,
        title: 'No live rounds',
        subtitle: 'Funding rounds will appear here when startups start raising.',
      );
    }

    return Column(
      children: [
        for (final round in rounds.take(3)) ...[
          _DealPreviewCard(
            round: round,
            onTap: () => _openTab(2),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _buildInvestorNetwork() {
    final state = ref.watch(investorViewModelProvider);
    final investors = state.investors;

    return SizedBox(
      height: 132,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: investors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final investor = investors[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => InvestorDetailScreen(investor: investor),
                ),
              );
            },
            child: Container(
              width: 128,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: InvestorColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          InvestorColors.colorForKey(investor.colorKey),
                          InvestorColors.colorForKey(investor.colorKey).withValues(alpha: 0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        investor.initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    investor.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: InvestorColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${investor.focus} • ${investor.location}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: InvestorColors.textMuted,
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

  Widget _buildConnectBanner() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ConnectScreen(modeTheme: 'investor')),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: InvestorColors.heroGradient,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: InvestorColors.goldDeep.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.alt_route_rounded, color: Colors.white, size: 22),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Open Connect Hub — see Startup, Career, Community, Events & Investors in one feed',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════ PORTFOLIO HERO ═══════════════════════

class _PortfolioHeroCard extends ConsumerWidget {
  const _PortfolioHeroCard({required this.onTap});

  final VoidCallback onTap;

  String _compact(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(2)}M';
    }
    if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(0)}K';
    }
    return '\$${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(investorViewModelProvider);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Color(0x22000000), blurRadius: 20, offset: Offset(0, 8)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'PORTFOLIO VALUE',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                    color: InvestorColors.textMuted,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: InvestorColors.greenSoft,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_upward_rounded, size: 12, color: InvestorColors.green),
                      const SizedBox(width: 2),
                      Text(
                        '${state.roiPercent >= 0 ? '+' : ''}${state.roiPercent.toStringAsFixed(1)}% ROI',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: InvestorColors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: state.portfolioValue),
              duration: const Duration(milliseconds: 1100),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) => Text(
                _compact(value),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: InvestorColors.ink,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Text(
                  'of ${_compact(state.totalInvested)} invested',
                  style: const TextStyle(fontSize: 12, color: InvestorColors.textMuted),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: state.totalGain >= 0 ? InvestorColors.greenSoft : InvestorColors.redSoft,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${state.totalGain >= 0 ? '+' : ''}${_compact(state.totalGain)}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: state.totalGain >= 0 ? InvestorColors.green : InvestorColors.red,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 110,
              child: _GrowthLineChart(
                values: portfolioGrowthSeries,
                lineColor: InvestorColors.gold,
                fillColor: InvestorColors.goldLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════ GROWTH LINE CHART ═══════════════════════

class _GrowthLineChart extends StatelessWidget {
  const _GrowthLineChart({
    required this.values,
    required this.lineColor,
    required this.fillColor,
  });

  final List<double> values;
  final Color lineColor;
  final Color fillColor;

  String _compact(double value) {
    if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(0)}K';
    }
    return '\$${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final minY = values.reduce((a, b) => a < b ? a : b);
    final maxY = values.reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.25;

    final spots = <FlSpot>[
      for (int i = 0; i < values.length; i++) FlSpot(i.toDouble(), values[i]),
    ];

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (values.length - 1).toDouble(),
        minY: minY - padding,
        maxY: maxY + padding,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => InvestorColors.ink,
            getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
              return LineTooltipItem(
                _compact(spot.y),
                const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              );
            }).toList(),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.32,
            preventCurveOverShooting: true,
            barWidth: 3,
            color: lineColor,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  fillColor.withValues(alpha: 0.85),
                  fillColor.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 1400),
      curve: Curves.easeOutCubic,
    );
  }
}

// ═══════════════════════ DEAL PREVIEW CARD ═══════════════════════

class _DealPreviewCard extends StatelessWidget {
  const _DealPreviewCard({required this.round, required this.onTap});

  final FundingRound round;
  final VoidCallback onTap;

  String _compact(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(0)}K';
    }
    return '\$${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final color = InvestorColors.colorForKey(round.colorKey);
    final soft = InvestorColors.softForKey(round.colorKey);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: InvestorColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: soft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.rocket_launch_rounded, color: color, size: 21),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        round.startup,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: InvestorColors.ink,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${round.stage} • ${round.sector} • ${round.location}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: InvestorColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: InvestorColors.goldSoft,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: InvestorColors.goldLight),
                  ),
                  child: Text(
                    _compact(round.targetAmount),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: InvestorColors.goldDeep,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_compact(round.raisedAmount)} raised',
                  style: const TextStyle(fontSize: 11.5, color: InvestorColors.textMuted),
                ),
                Text(
                  '${(round.progress * 100).toStringAsFixed(0)}% of goal',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: round.progress),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor: soft,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.people_rounded, size: 13, color: InvestorColors.textMuted),
                const SizedBox(width: 4),
                Text(
                  '${round.investors} investors already in',
                  style: const TextStyle(fontSize: 10.5, color: InvestorColors.textMuted),
                ),
                const Spacer(),
                Text(
                  'Closes ${round.closeDate}',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: InvestorColors.goldDeep,
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

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: InvestorColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: InvestorColors.textMuted, size: 40),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: InvestorColors.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12.5, color: InvestorColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _HomeAction {
  const _HomeAction({
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

// ═══════════════════════ BOTTOM NAV ═══════════════════════

class _InvestorNavBar extends StatelessWidget {
  const _InvestorNavBar({
    required this.selectedIndex,
    required this.onTap,
    required this.onAddTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAddTap;

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
    final navBorder = isDark ? const Color(0xFF2D3352) : InvestorColors.border;
    final selectedColor = InvestorColors.goldDeep;
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
                painter: _InvestorNavPainter(
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
                      _navItem(1, Icons.pie_chart_outline_rounded, Icons.pie_chart_rounded, 'Portfolio', selectedColor: selectedColor, unselectedColor: unselectedColor),
                      SizedBox(width: _fabSize + 12),
                      _navItem(3, Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded, 'Messages', selectedColor: selectedColor, unselectedColor: unselectedColor),
                      _navItem(4, Icons.person_outline_rounded, Icons.person_rounded, 'Profile', selectedColor: selectedColor, unselectedColor: unselectedColor),
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

  Widget _addButton() {
    return GestureDetector(
      onTap: onAddTap,
      child: Container(
        width: _fabSize,
        height: _fabSize,
        decoration: BoxDecoration(
          gradient: InvestorColors.goldGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: InvestorColors.goldDeep.withValues(alpha: 0.30),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, IconData activeIcon, String label, {
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
            Icon(
              selected ? activeIcon : icon,
              color: selected ? selectedColor : unselectedColor,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                color: selected ? selectedColor : unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InvestorNavPainter extends CustomPainter {
  const _InvestorNavPainter({
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
        centerX - notchR * 0.08, notchR * 1.1,
        centerX, notchR * 1.1,
      )
      // Right bottom — mirror
      ..cubicTo(
        centerX + notchR * 0.08, notchR * 1.1,
        centerX + notchR * 0.28, notchR * 1.05,
        centerX + notchR * 0.5, notchR * 0.98,
      )
      // Right wall
      ..cubicTo(
        centerX + notchR * 0.75, notchR * 0.85,
        centerX + notchR * 0.92, notchR * 0.6,
        centerX + notchR, notchR * 0.35,
      )
      // Right entry — exit U
      ..cubicTo(
        centerX + notchR * 1.1, notchR * 0.06,
        centerX + notchW - 10, 0,
        centerX + notchW, 0,
      )
      // Top edge right
      ..lineTo(w - cornerRadius, 0)
      ..quadraticBezierTo(w, 0, w, cornerRadius)
      // Right side
      ..lineTo(w, h - bottomArc)
      ..quadraticBezierTo(w, h, w - bottomArc, h)
      // Bottom edge
      ..lineTo(bottomArc, h)
      ..quadraticBezierTo(0, h, 0, h - bottomArc)
      // Left side
      ..lineTo(0, cornerRadius)
      ..quadraticBezierTo(0, 0, cornerRadius, 0)
      ..close();

    // Shadow
    canvas.drawPath(
      path.shift(const Offset(0, 3)),
      Paint()..color = shadowColor,
    );
    // Fill
    canvas.drawPath(path, Paint()..color = fillColor);
    // Border
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = borderColor
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}