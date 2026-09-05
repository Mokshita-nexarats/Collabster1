import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/startup_models.dart';
import '../../../../core/di/providers.dart';

class StartupMilestonesScreen extends ConsumerWidget {
  const StartupMilestonesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final milestonesState = ref.watch(milestonesViewModelProvider);

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
                  colors: [Color(0xFF0088CC), Color(0xFF229ED9), Color(0xFF0088CC)],
                ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                left: 20, right: 20, bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('Milestones', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('YOUR STARTUP JOURNEY', style: TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
                        const SizedBox(height: 8),
                        const Text("You're making great progress!", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${milestonesState.completedCount} of ${milestonesState.totalCount} milestones completed', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                            Text('${(milestonesState.progress * 100).round()}%', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: milestonesState.progress,
                            minHeight: 10,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF34D399)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _statChip('${milestonesState.completedCount}', 'COMPLETED'),
                            const SizedBox(width: 10),
                            _statChip('${milestonesState.inProgressCount}', 'IN PROGRESS'),
                            const SizedBox(width: 10),
                            _statChip('${milestonesState.upcomingCount}', 'UPCOMING'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, index) => Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: MilestoneItem(
                    milestone: milestonesState.milestones[index],
                    isLast: index == milestonesState.milestones.length - 1,
                  ),
                ),
                childCount: milestonesState.milestones.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showAddMilestoneSheet(context, ref),
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Milestone', style: TextStyle(fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor: const Color(0xFF0088CC),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 60)),
        ],
      ),
    );
  }

  Widget _statChip(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
        ],
      ),
    );
  }

  void _showAddMilestoneSheet(BuildContext context, WidgetRef ref) {
    final titleCtrl = TextEditingController();
    final descriptionCtrl = TextEditingController();
    final dateCtrl = TextEditingController();

    String selectedCategory = 'Product';
    String selectedStatus = 'Upcoming';

    final categories = ['Product', 'Fundraising', 'Growth', 'Team & HR', 'Ideation', 'Legal & Operations'];
    final statuses = ['Upcoming', 'In Progress', 'Completed'];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (sheetCtx, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(sheetCtx).viewInsets.bottom),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.88,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
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
                          color: const Color(0xFFE8F4FB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.flag_rounded,
                          color: Color(0xFF0088CC),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add New Milestone',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF12233D),
                              ),
                            ),
                            Text(
                              'Set goals and track your startup progress',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(sheetCtx),
                        icon: const Icon(Icons.close, color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Title Field
                  const Text(
                    'Milestone Title *',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: titleCtrl,
                    decoration: InputDecoration(
                      hintText: 'e.g. Launch Beta Version 2.0',
                      prefixIcon: const Icon(Icons.title_rounded, color: Color(0xFF6B7280), size: 20),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF0088CC), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category Selector
                  const Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map((cat) {
                      final isSelected = cat == selectedCategory;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        selectedColor: const Color(0xFF0088CC),
                        backgroundColor: const Color(0xFFF3F4F6),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF374151),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        onSelected: (_) => setModalState(() => selectedCategory = cat),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Target Date Field
                  const Text(
                    'Target / Completion Date *',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: dateCtrl,
                    readOnly: true,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        builder: (ctx, child) => Theme(
                          data: Theme.of(ctx).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFF0088CC),
                              onPrimary: Colors.white,
                            ),
                          ),
                          child: child!,
                        ),
                      );
                      if (picked != null) {
                        final months = [
                          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                        ];
                        final formatted = '${months[picked.month - 1]} ${picked.day}, ${picked.year}';
                        dateCtrl.text = formatted;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Select Target Date',
                      prefixIcon: const Icon(Icons.calendar_today_rounded, color: Color(0xFF6B7280), size: 20),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF0088CC), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Status Selector
                  const Text(
                    'Initial Status',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: statuses.map((st) {
                      final isSelected = st == selectedStatus;
                      final colors = {
                        'Upcoming': const Color(0xFF6B7280),
                        'In Progress': const Color(0xFF0088CC),
                        'Completed': const Color(0xFF059669),
                      };
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            label: Center(child: Text(st)),
                            selected: isSelected,
                            selectedColor: colors[st],
                            backgroundColor: const Color(0xFFF3F4F6),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF374151),
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                            onSelected: (_) => setModalState(() => selectedStatus = st),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Description / Details Field
                  const Text(
                    'Description / Action Items',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descriptionCtrl,
                    minLines: 3,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Add key deliverables, goals or notes for this milestone...',
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF0088CC), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final title = titleCtrl.text.trim();
                        final targetDate = dateCtrl.text.trim();
                        if (title.isEmpty) {
                          ScaffoldMessenger.of(sheetCtx).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a milestone title'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }
                        if (targetDate.isEmpty) {
                          ScaffoldMessenger.of(sheetCtx).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a target date'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }

                        ref.read(milestonesViewModelProvider.notifier).addMilestone(
                          title: title,
                          category: selectedCategory,
                          targetDate: targetDate,
                          status: selectedStatus,
                          description: descriptionCtrl.text.trim(),
                        );

                        Navigator.pop(sheetCtx);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.white, size: 18),
                                const SizedBox(width: 8),
                                Text('Milestone "$title" added successfully!'),
                              ],
                            ),
                            backgroundColor: const Color(0xFF059669),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        backgroundColor: const Color(0xFF0088CC),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.check_rounded, size: 20),
                      label: const Text(
                        'Save Milestone',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
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
}

class MilestoneItem extends StatelessWidget {
  const MilestoneItem({super.key, required this.milestone, required this.isLast});
  final Milestone milestone;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final dotColor = milestone.completed
        ? const Color(0xFF059669)
        : milestone.active
            ? const Color(0xFF0088CC)
            : const Color(0xFFD1D5DB);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
              child: Icon(
                milestone.completed ? Icons.check : (milestone.active ? Icons.radio_button_checked : Icons.circle_outlined),
                color: Colors.white,
                size: 14,
              ),
            ),
            if (!isLast)
              Container(width: 2, height: 60, color: const Color(0xFFE5E7EB)),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        milestone.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: milestone.completed || milestone.active ? const Color(0xFF12233D) : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                    if (milestone.completed)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(999)),
                        child: const Text('DONE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF059669), letterSpacing: 0.6)),
                      ),
                    if (milestone.active)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: const Color(0xFFE8F4FB), borderRadius: BorderRadius.circular(999)),
                        child: const Text('IN PROGRESS', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF0088CC), letterSpacing: 0.6)),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  milestone.date,
                  style: TextStyle(
                    fontSize: 12,
                    color: milestone.completed || milestone.active ? const Color(0xFF6B7280) : const Color(0xFFD1D5DB),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
