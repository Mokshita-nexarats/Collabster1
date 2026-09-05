import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../model/startup_models.dart';
import '../../viewmodel/investor_pipeline_state.dart';
import '../widgets/startup_color_helper.dart';

class InvestorPipelineScreen extends ConsumerStatefulWidget {
  const InvestorPipelineScreen({super.key});

  @override
  ConsumerState<InvestorPipelineScreen> createState() => _InvestorPipelineScreenState();
}

class _InvestorPipelineScreenState extends ConsumerState<InvestorPipelineScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  int _selectedTab = 0;
  String? _statusFilter;
  bool _showAllPriority = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _selectedTab = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<InvestorEntry> _filteredInvestors(InvestorPipelineState state) {
    final query = _searchController.text.toLowerCase();
    List<InvestorEntry> source;
    switch (_selectedTab) {
      case 1:
        source = state.pipelineInvestors;
        break;
      case 2:
        source = state.savedInvestors;
        break;
      default:
        source = state.discoverInvestors;
    }
    return source.where((i) {
      final matchesQuery = query.isEmpty ||
          i.name.toLowerCase().contains(query) ||
          i.fund.toLowerCase().contains(query);
      final matchesStatus = _statusFilter == null ||
          i.status.toLowerCase().contains(_statusFilter!.toLowerCase());
      return matchesQuery && matchesStatus;
    }).toList();
  }

  Future<void> _showAddInvestorSheet() async {
    final created = await showModalBottomSheet<InvestorEntry>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _AddInvestorBottomSheet(),
    );

    if (created != null) {
      ref.read(investorPipelineViewModelProvider.notifier).addInvestor(created);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${created.name} added to investor pipeline!'),
            backgroundColor: const Color(0xFF059669),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showScheduleCallSheet(String name) {
    String selectedSlot = 'Tomorrow 10:00 AM';
    String format = 'Google Meet';
    final agendaCtrl = TextEditingController(text: 'Initial Pitch & Q&A Session');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 26),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
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
                          color: const Color(0xFFE8F4FB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.event_available_rounded,
                            color: Color(0xFF0088CC), size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Schedule Meeting',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF12233D))),
                            Text('With $name',
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xFF6B7280))),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close, color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text('Select Time Slot',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4B5563))),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Tomorrow 10:00 AM',
                      'Tomorrow 2:30 PM',
                      'Thursday 11:00 AM',
                      'Friday 4:00 PM',
                    ].map((slot) {
                      final isSelected = slot == selectedSlot;
                      return ChoiceChip(
                        label: Text(slot),
                        selected: isSelected,
                        selectedColor: const Color(0xFF0088CC),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF374151),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        onSelected: (_) => setModalState(() => selectedSlot = slot),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Meeting Format',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4B5563))),
                  const SizedBox(height: 8),
                  Row(
                    children: ['Google Meet', 'Zoom', 'In Person'].map((fmt) {
                      final isSelected = fmt == format;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(fmt),
                          selected: isSelected,
                          selectedColor: const Color(0xFF0088CC),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF374151),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          onSelected: (_) => setModalState(() => format = fmt),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: agendaCtrl,
                    decoration: InputDecoration(
                      labelText: 'Agenda / Notes',
                      prefixIcon: const Icon(Icons.notes_outlined),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Meeting scheduled with $name for $selectedSlot ($format)!'),
                            backgroundColor: const Color(0xFF0088CC),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: const Color(0xFF0088CC),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text('Confirm & Send Invite',
                          style: TextStyle(fontWeight: FontWeight.w700)),
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

  void _showExportSheet() {
    final state = ref.read(investorPipelineViewModelProvider);
    final allInvestors = [
      ...state.pipelineInvestors,
      ...state.discoverInvestors,
    ].fold<List<InvestorEntry>>([], (acc, inv) {
      if (!acc.any((i) => i.name == inv.name)) acc.add(inv);
      return acc;
    });

    final buffer = StringBuffer();
    buffer.writeln('INVESTOR PIPELINE EXPORT');
    buffer.writeln('Generated: ${DateTime.now().toString().substring(0, 16)}');
    buffer.writeln('─' * 40);
    buffer.writeln('Name | Fund | Amount | Status | Contacted | Replied');
    buffer.writeln('─' * 40);
    for (final inv in allInvestors) {
      buffer.writeln(
          '${inv.name} | ${inv.fund} | ${inv.amount} | ${inv.status} | ${inv.contacted} | ${inv.replied}');
    }
    buffer.writeln('─' * 40);
    buffer.writeln('Total: ${allInvestors.length} investors');
    buffer.writeln('Pipeline: ${state.pipelineInvestors.length} active');
    buffer.writeln('Saved: ${state.savedInvestors.length} saved');

    final exportText = buffer.toString();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
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
                  child: const Icon(Icons.download_rounded,
                      color: Color(0xFF0088CC), size: 22),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Export Pipeline',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF12233D))),
                      Text('Copy summary to clipboard',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xFF6B7280))),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.close, color: Color(0xFF6B7280)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Stats summary cards
            Row(
              children: [
                _exportStatCard(
                    '${allInvestors.length}', 'Total', const Color(0xFF0088CC)),
                const SizedBox(width: 10),
                _exportStatCard(
                    '${state.pipelineInvestors.length}',
                    'Pipeline',
                    const Color(0xFF059669)),
                const SizedBox(width: 10),
                _exportStatCard('${state.savedInvestors.length}', 'Saved',
                    const Color(0xFFF59E0B)),
              ],
            ),
            const SizedBox(height: 16),
            // Preview
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: allInvestors.map((inv) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: StartupColorHelper.fromKey(inv.colorKey).withValues(alpha: 0.15),
                              child: Text(inv.initials,
                                  style: TextStyle(
                                      color: StartupColorHelper.fromKey(inv.colorKey),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 11)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(inv.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: Color(0xFF12233D))),
                                  Text(
                                      '${inv.fund} · ${inv.amount} · ${inv.contacted} contacted',
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF6B7280))),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: StartupColorHelper.fromKey(inv.statusColorKey).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(inv.status,
                                  style: TextStyle(
                                      color: StartupColorHelper.fromKey(inv.statusColorKey),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10)),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  // Copy summary text to clipboard
                  await _copyToClipboard(exportText);
                  if (ctx.mounted) Navigator.pop(ctx);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle,
                                color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text('Pipeline copied to clipboard!'),
                          ],
                        ),
                        backgroundColor: Color(0xFF059669),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: const Color(0xFF0088CC),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.copy_rounded, size: 20),
                label: const Text('Copy to Clipboard',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  Widget _exportStatCard(String value, String label, Color color) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: color)),
              Text(label,
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF6B7280))),
            ],
          ),
        ),
      );

  Future<void> _openInvestorProfile(InvestorEntry investor) async {

    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => _InvestorProfileScreen(
          investor: investor,
          onScheduleCall: () => _showScheduleCallSheet(investor.name),
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pipelineState = ref.watch(investorPipelineViewModelProvider);
    final activeCount = pipelineState.pipelineInvestors.length + 15;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddInvestorSheet,
        backgroundColor: const Color(0xFF0088CC),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Investor',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0088CC),
                    Color(0xFF229ED9),
                    Color(0xFF0088CC),
                  ],
                ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                left: 20,
                right: 20,
                bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.arrow_back,
                              color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('Investors',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800)),
                      const Spacer(),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert,
                            color: Colors.white.withValues(alpha: 0.8)),
                        onSelected: (val) {
                          if (val == 'export') {
                            _showExportSheet();
                          } else if (val == 'reset') {
                            setState(() => _statusFilter = null);
                          }
                        },
                        itemBuilder: (ctx) => [
                          const PopupMenuItem(
                            value: 'export',
                            child: Row(
                              children: [
                                Icon(Icons.download_outlined, size: 18),
                                SizedBox(width: 8),
                                Text('Export Pipeline'),
                              ],
                            ),
                          ),
                          if (_statusFilter != null)
                            const PopupMenuItem(
                              value: 'reset',
                              child: Row(
                                children: [
                                  Icon(Icons.refresh, size: 18),
                                  SizedBox(width: 8),
                                  Text('Clear Filters'),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('AVAILABLE ROLES',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1)),
                            const Spacer(),
                            if (_statusFilter != null)
                              GestureDetector(
                                onTap: () => setState(() => _statusFilter = null),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text('Filter: $_statusFilter ✕',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('$activeCount',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800)),
                            const SizedBox(width: 8),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 6),
                              child: Text('Active Investors',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 14)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _pipelinePill('Introduction', '6'),
                            _pipelinePill('Meetings', '4'),
                            _pipelinePill('Due Diligence', '2'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14)),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                          color: const Color(0xFF0088CC),
                          borderRadius: BorderRadius.circular(10)),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.white,
                      unselectedLabelColor: const Color(0xFF6B7280),
                      labelStyle: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w700),
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: 'Discover'),
                        Tab(text: 'Pipeline'),
                        Tab(text: 'Saved Talks')
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search investors...',
                      prefixIcon:
                          const Icon(Icons.search, color: Color(0xFF9CA3AF)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('Priority Follow-ups',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF12233D))),
                      const Spacer(),
                      TextButton(
                        onPressed: () =>
                            setState(() => _showAllPriority = !_showAllPriority),
                        child: Text(
                          _showAllPriority ? 'Show Less' : 'View All',
                          style: const TextStyle(color: Color(0xFF0088CC)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _priorityCard('Horizon Ventures', 'Series A', '\$350K',
                      'Meeting Tomorrow'),
                  if (_showAllPriority) ...[
                    const SizedBox(height: 10),
                    _priorityCard('Vertex Capital', 'Series A', '\$350K',
                        'Term Sheet Review'),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('All Investors',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF12233D))),
                      const Spacer(),
                      Text(
                        '${_filteredInvestors(pipelineState).length} total',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          _filteredInvestors(pipelineState).isEmpty
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        const Icon(Icons.search_off_rounded,
                            size: 48, color: Color(0xFF9CA3AF)),
                        const SizedBox(height: 8),
                        const Text('No investors found',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF6B7280))),
                        const SizedBox(height: 4),
                        Text(
                          _statusFilter != null
                              ? 'No investors with status "$_statusFilter"'
                              : 'Try adjusting your search query',
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF9CA3AF)),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final investors = _filteredInvestors(pipelineState);
                      if (index >= investors.length) return null;
                      final inv = investors[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                        child: _InvestorCard(
                          investor: inv,
                          onTap: () => _openInvestorProfile(inv),
                        ),
                      );
                    },
                    childCount: _filteredInvestors(pipelineState).length,
                  ),
                ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _pipelinePill(String label, String count) {
    final isSelected = _statusFilter?.toLowerCase() == label.toLowerCase();

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _statusFilter = null;
          } else {
            _statusFilter = label;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white
              : Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(count,
                style: TextStyle(
                    color: isSelected ? const Color(0xFF0088CC) : Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13)),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    color: isSelected
                        ? const Color(0xFF0088CC)
                        : Colors.white70,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                    fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _priorityCard(
      String name, String fund, String amount, String nextStep) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFFF0EBFF), Color(0xFFE8F4FB)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDD6FE)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor:
                    const Color(0xFF0088CC).withValues(alpha: 0.12),
                child: Text(
                    name.length >= 2 ? name.substring(0, 2).toUpperCase() : 'HV',
                    style: const TextStyle(
                        color: Color(0xFF0088CC), fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF12233D))),
                    Text('$fund · $amount',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF6B7280))),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 12, color: Color(0xFF0088CC)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text('NEXT STEP: $nextStep',
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF0088CC),
                                  fontWeight: FontWeight.w700),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _showScheduleCallSheet(name),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: const Size(0, 36),
                side: const BorderSide(color: Color(0xFF0088CC)),
                foregroundColor: const Color(0xFF0088CC),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999)),
              ),
              child: const Text('Schedule',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _InvestorCard extends StatelessWidget {
  const _InvestorCard({required this.investor, required this.onTap});
  final InvestorEntry investor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
                color: Color(0x08000000), blurRadius: 12, offset: Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: StartupColorHelper.fromKey(investor.colorKey).withValues(alpha: 0.1),
              child: Text(investor.initials,
                  style: TextStyle(
                      color: StartupColorHelper.fromKey(investor.colorKey),
                      fontWeight: FontWeight.w800,
                      fontSize: 13)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(investor.name,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF12233D))),
                  Text('${investor.fund} · ${investor.amount}',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF6B7280))),
                  Text('Status: ${investor.status}',
                      style: TextStyle(
                          fontSize: 11,
                          color: StartupColorHelper.fromKey(investor.statusColorKey),
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            TextButton(
              onPressed: onTap,
              child: const Text('View Profile',
                  style: TextStyle(
                      color: Color(0xFF0088CC),
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddInvestorBottomSheet extends StatefulWidget {
  const _AddInvestorBottomSheet();

  @override
  State<_AddInvestorBottomSheet> createState() =>
      _AddInvestorBottomSheetState();
}

class _AddInvestorBottomSheetState extends State<_AddInvestorBottomSheet> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedStage = 'Seed';
  String _selectedStatus = 'Active';

  final List<String> _stages = [
    'Pre-Seed',
    'Seed',
    'Series A',
    'Series B',
    'Angel'
  ];
  final List<String> _statuses = [
    'Active',
    'Meeting Scheduled',
    'Due Diligence',
    'Term Sheet',
    'Not Engaged'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
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
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4FB),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.account_balance_wallet_outlined,
                          color: Color(0xFF0088CC)),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Add Investor',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF12233D))),
                          SizedBox(height: 2),
                          Text('Add a new investor or fund to your pipeline.',
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xFF6B7280))),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFF3F4F6)),
                      icon: const Icon(Icons.close_rounded,
                          color: Color(0xFF6B7280), size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _inputField('Investor / Fund Name', 'e.g. Sequoia Capital',
                    _nameController, Icons.business_outlined),
                const SizedBox(height: 14),
                _inputField('Target Amount', 'e.g. \$250K', _amountController,
                    Icons.attach_money_outlined),
                const SizedBox(height: 14),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Funding Stage',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4B5563))),
                    const SizedBox(height: 6),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.layers_outlined,
                              color: Color(0xFF6B7280), size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButton<String>(
                              value: _selectedStage,
                              underline: const SizedBox.shrink(),
                              isExpanded: true,
                              items: _stages
                                  .map((s) => DropdownMenuItem(
                                      value: s, child: Text(s)))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedStage = val);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pipeline Status',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4B5563))),
                    const SizedBox(height: 6),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.sync_outlined,
                              color: Color(0xFF6B7280), size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButton<String>(
                              value: _selectedStatus,
                              underline: const SizedBox.shrink(),
                              isExpanded: true,
                              items: _statuses
                                  .map((s) => DropdownMenuItem(
                                      value: s, child: Text(s)))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedStatus = val);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      final name = _nameController.text.trim();
                      if (name.isEmpty) return;
                      final rawAmount = _amountController.text.trim();
                      final amount = rawAmount.isEmpty
                          ? '\$250K'
                          : (rawAmount.startsWith('\$')
                              ? rawAmount
                              : '\$$rawAmount');
                      final initials = name.length >= 2
                          ? name.substring(0, 2).toUpperCase()
                          : name.toUpperCase();

                      final newEntry = InvestorEntry(
                        name: name,
                        fund: _selectedStage,
                        amount: amount,
                        status: _selectedStatus,
                        statusColorKey: 'live',
                        initials: initials,
                        colorKey: 'primary',
                        contacted: 1,
                        replied: 0,
                      );
                      Navigator.pop(context, newEntry);
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Add to Pipeline',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0088CC),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(String label, String hint,
      TextEditingController controller, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4B5563))),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF6B7280), size: 22),
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF0088CC), width: 1.5)),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Full Investor Profile Screen
// ─────────────────────────────────────────────────────────────────────────────

class _InvestorProfileScreen extends ConsumerStatefulWidget {
  const _InvestorProfileScreen({
    required this.investor,
    required this.onScheduleCall,
  });

  final InvestorEntry investor;
  final VoidCallback onScheduleCall;

  @override
  ConsumerState<_InvestorProfileScreen> createState() => _InvestorProfileScreenState();
}

class _InvestorProfileScreenState extends ConsumerState<_InvestorProfileScreen> {
  late bool _isSaved;
  final TextEditingController _noteCtrl = TextEditingController();
  String _noteText = '';

  @override
  void initState() {
    super.initState();
    _isSaved = ref.read(investorPipelineViewModelProvider).isSaved(widget.investor.name);
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  void _toggleSave() {
    setState(() {
      if (_isSaved) {
        ref.read(investorPipelineViewModelProvider.notifier).unsaveInvestor(widget.investor.name);
        _isSaved = false;
      } else {
        ref.read(investorPipelineViewModelProvider.notifier).saveInvestor(widget.investor);
        _isSaved = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(_isSaved
          ? '${widget.investor.name} saved!'
          : '${widget.investor.name} removed from saved.'),
      behavior: SnackBarBehavior.floating,
      backgroundColor: _isSaved ? const Color(0xFF059669) : const Color(0xFF6B7280),
    ));
  }

  void _removeInvestor() {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Remove Investor',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: Text(
            'Remove ${widget.investor.name} from all your lists?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        ref.read(investorPipelineViewModelProvider.notifier).removeInvestor(widget.investor.name);
        if (mounted) Navigator.pop(context);
      }
    });
  }

  void _showAddNoteSheet() {
    _noteCtrl.text = _noteText;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(ctx).bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
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
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F4FB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.edit_note_rounded,
                        color: Color(0xFF0088CC), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Add Note',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF12233D))),
                        Text('For ${widget.investor.name}',
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF6B7280))),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _noteCtrl,
                minLines: 4,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'Enter your notes about this investor...',
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Color(0xFF0088CC), width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _noteText = _noteCtrl.text.trim());
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: const Color(0xFF0088CC),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save Note',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inv = widget.investor;
    final email =
        '${inv.name.toLowerCase().replaceAll(' ', '')}@vcfunds.com';
    final replyRate = inv.contacted > 0
        ? ((inv.replied / inv.contacted) * 100).toStringAsFixed(0)
        : '0';

    final portfolioCompanies = [
      'TechNova Inc.',
      'GreenBridge',
      'FinPulse',
      'DataEdge',
    ];

    final investmentFocus = [
      'SaaS',
      'FinTech',
      'AI / ML',
      'B2B',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      body: CustomScrollView(
        slivers: [
          // ── Header ────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    StartupColorHelper.fromKey(inv.colorKey),
                    const Color(0xFF0088CC),
                    const Color(0xFF0088CC),
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                  child: Column(
                    children: [
                      // Top bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.arrow_back,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                          const Text('Investor Profile',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800)),
                          GestureDetector(
                            onTap: _toggleSave,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 40, height: 40,
                              decoration: BoxDecoration(
                                color: _isSaved
                                    ? Colors.white.withValues(alpha: 0.3)
                                    : Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _isSaved
                                    ? Icons.bookmark_rounded
                                    : Icons.bookmark_border_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      // Avatar + info
                      CircleAvatar(
                        radius: 38,
                        backgroundColor:
                            Colors.white.withValues(alpha: 0.2),
                        child: Text(inv.initials,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 22)),
                      ),
                      const SizedBox(height: 14),
                      Text(inv.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      Text(inv.fund,
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 14)),
                      const SizedBox(height: 12),
                      // Stage + status chips
                      Wrap(
                        spacing: 8,
                        children: [
                          _chip(inv.amount,
                              Colors.white.withValues(alpha: 0.2),
                              Colors.white),
                          _chip(inv.status, StartupColorHelper.fromKey(inv.statusColorKey).withValues(alpha: 0.3),
                              Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Stats Row ─────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  _statBox('${inv.contacted}', 'Contacted', Icons.send_rounded),
                  _divider(),
                  _statBox('${inv.replied}', 'Replied', Icons.reply_rounded),
                  _divider(),
                  _statBox('$replyRate%', 'Reply Rate',
                      Icons.trending_up_rounded),
                ],
              ),
            ),
          ),

          // ── Body ──────────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Contact info
                _sectionCard(
                  title: 'Contact Information',
                  icon: Icons.contact_mail_outlined,
                  child: Column(
                    children: [
                      _infoRow(Icons.email_outlined, 'Email', email),
                      const SizedBox(height: 10),
                      _infoRow(Icons.business_outlined, 'Fund Stage',
                          inv.fund),
                      const SizedBox(height: 10),
                      _infoRow(Icons.attach_money_rounded,
                          'Target Cheque', inv.amount),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Investment Focus
                _sectionCard(
                  title: 'Investment Focus',
                  icon: Icons.track_changes_rounded,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: investmentFocus.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4FB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(tag,
                            style: const TextStyle(
                                color: Color(0xFF0088CC),
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // Portfolio
                _sectionCard(
                  title: 'Portfolio Companies',
                  icon: Icons.workspaces_rounded,
                  child: Column(
                    children: portfolioCompanies
                        .asMap()
                        .entries
                        .map((e) => Padding(
                              padding:
                                  EdgeInsets.only(top: e.key == 0 ? 0 : 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      color: StartupColorHelper.fromKey(inv.colorKey)
                                          .withValues(alpha: 0.12),
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        e.value[0],
                                        style: TextStyle(
                                            color: StartupColorHelper.fromKey(inv.colorKey),
                                            fontWeight: FontWeight.w800,
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(e.value,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF12233D))),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // Notes
                _sectionCard(
                  title: 'Notes',
                  icon: Icons.notes_rounded,
                  trailing: GestureDetector(
                    onTap: _showAddNoteSheet,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4FB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('+ Add Note',
                          style: TextStyle(
                              color: Color(0xFF0088CC),
                              fontWeight: FontWeight.w700,
                              fontSize: 12)),
                    ),
                  ),
                  child: _noteText.isEmpty
                      ? const Text(
                          'No notes yet. Tap "+ Add Note" to add your thoughts about this investor.',
                          style: TextStyle(
                              color: Color(0xFF9CA3AF), fontSize: 13))
                      : Text(_noteText,
                          style: const TextStyle(
                              color: Color(0xFF374151), fontSize: 14)),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onScheduleCall();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      backgroundColor: const Color(0xFF0088CC),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.event_rounded, size: 20),
                    label: const Text('Schedule Meeting',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _toggleSave,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          foregroundColor: const Color(0xFF0088CC),
                          side: const BorderSide(
                              color: Color(0xFF0088CC)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        icon: Icon(
                          _isSaved
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          size: 18,
                        ),
                        label: Text(
                            _isSaved ? 'Unsave' : 'Save',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      onPressed: _removeInvestor,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(56, 48),
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.delete_outline_rounded,
                          size: 18),
                      label: const Text('Remove',
                          style: TextStyle(
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, Color bg, Color fg) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
            color: bg, borderRadius: BorderRadius.circular(20)),
        child: Text(label,
            style: TextStyle(
                color: fg, fontWeight: FontWeight.w700, fontSize: 12)),
      );

  Widget _statBox(String value, String label, IconData icon) => Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF0088CC), size: 22),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF12233D))),
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: Color(0xFF6B7280))),
          ],
        ),
      );

  Widget _divider() => Container(
      width: 1, height: 40, color: const Color(0xFFE5E7EB));

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
    Widget? trailing,
  }) =>
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
                color: Color(0x08000000),
                blurRadius: 12,
                offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: const Color(0xFF0088CC)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF374151))),
                ),
                if (trailing != null) trailing,
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      );

  Widget _infoRow(IconData icon, String label, String value) => Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF9CA3AF)),
          const SizedBox(width: 10),
          Text('$label: ',
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280))),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF12233D))),
          ),
        ],
      );
}
