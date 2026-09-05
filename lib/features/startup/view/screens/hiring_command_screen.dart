import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/startup_models.dart';
import '../../viewmodel/hiring_state.dart';
import '../../../../core/di/providers.dart';
import '../widgets/startup_color_helper.dart';

class HiringCommandScreen extends ConsumerStatefulWidget {
  const HiringCommandScreen({
    super.key,
    required this.startupName,
    this.autoOpenCreateSheet = false,
  });
  final String startupName;
  final bool autoOpenCreateSheet;

  @override
  ConsumerState<HiringCommandScreen> createState() =>
      _HiringCommandScreenState();
}

class _HiringCommandScreenState extends ConsumerState<HiringCommandScreen> {
  String _selectedFilter = 'ALL';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(hiringViewModelProvider.notifier).loadInitialData();
      if (widget.autoOpenCreateSheet) {
        showCreateJobSheet(context);
      }
    });
  }

  Widget _kindChip(
    String value,
    String label,
    String selectedKind,
    void Function(String) onSelect,
  ) {
    final selected = value == selectedKind;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: const Color(0xFF0088CC),
      labelStyle: TextStyle(
        color: selected ? Colors.white : const Color(0xFF374151),
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
      onSelected: (_) => onSelect(value),
    );
  }

  List<OpenRole> _filteredRoles(HiringState state) {
    if (_selectedFilter == 'ALL') return state.roles;
    return state.roles.where((r) => r.status == _selectedFilter).toList();
  }

  void _addRole(OpenRole role) {
    ref.read(hiringViewModelProvider.notifier).addRole(role);
  }

  void showCreateJobSheet(BuildContext context) {
    final titleCtrl = TextEditingController();
    final salaryCtrl = TextEditingController();
    final skillsCtrl = TextEditingController();
    final locationCtrl = TextEditingController();
    final expCtrl = TextEditingController();

    String selectedDept = 'Engineering';
    String selectedStatus = 'HIRING';
    String selectedKind = 'job';

    final depts = [
      'Engineering',
      'Product',
      'Design',
      'R&D',
      'Growth',
      'Operations'
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF0088CC).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.work_rounded,
                          color: Color(0xFF0088CC),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Create New Job Post',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF12233D),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _kindChip('job', 'Full-time Job', selectedKind, (k) {
                        setModalState(() => selectedKind = k);
                      }),
                      _kindChip('internship', 'Internship', selectedKind, (k) {
                        setModalState(() => selectedKind = k);
                      }),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: titleCtrl,
                    decoration: InputDecoration(
                      labelText: 'Job Title *',
                      hintText: 'e.g. Senior Flutter Developer',
                      prefixIcon: const Icon(Icons.title_rounded),
                      filled: true,
                      fillColor: const Color(0xFFF0F9FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: salaryCtrl,
                          decoration: InputDecoration(
                            labelText: 'Package / LPA *',
                            hintText: 'e.g. 18 - 25 LPA',
                            prefixIcon: const Icon(Icons.payments_outlined),
                            filled: true,
                            fillColor: const Color(0xFFF0F9FF),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: expCtrl,
                          decoration: InputDecoration(
                            labelText: 'Experience *',
                            hintText: 'e.g. 2+ Yrs',
                            prefixIcon: const Icon(Icons.stars_outlined),
                            filled: true,
                            fillColor: const Color(0xFFF0F9FF),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: skillsCtrl,
                    decoration: InputDecoration(
                      labelText: 'Required Skills *',
                      hintText: 'e.g. Flutter, Dart, Firebase, AI/ML',
                      prefixIcon: const Icon(Icons.psychology_outlined),
                      filled: true,
                      fillColor: const Color(0xFFF0F9FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: locationCtrl,
                    decoration: InputDecoration(
                      labelText: 'Location / Work Mode *',
                      hintText: 'e.g. Remote / Hybrid Bangalore',
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      filled: true,
                      fillColor: const Color(0xFFF0F9FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Department',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: depts.map((d) {
                      final isSelected = d == selectedDept;
                      return ChoiceChip(
                        label: Text(d),
                        selected: isSelected,
                        selectedColor: const Color(0xFF0088CC),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF374151),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                        onSelected: (_) {
                          setModalState(() {
                            selectedDept = d;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final title = titleCtrl.text.trim();
                        if (title.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a job title'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }

                        final newRole = OpenRole(
                          title: title,
                          department: '$selectedDept / Core Team',
                          applicants: 0,
                          shortlisted: 0,
                          status: selectedStatus,
                          statusColorKey: 'live',
                          roleType: selectedKind,
                          salaryLpa: selectedKind == 'internship'
                              ? 'Stipend'
                              : salaryCtrl.text.trim().isNotEmpty
                                  ? salaryCtrl.text.trim()
                                  : '18-25 LPA',
                          skills: skillsCtrl.text.trim().isNotEmpty
                              ? skillsCtrl.text.trim()
                              : 'Flutter, Firebase, REST APIs',
                          location: locationCtrl.text.trim().isNotEmpty
                              ? locationCtrl.text.trim()
                              : 'Remote',
                          experience: expCtrl.text.trim().isNotEmpty
                              ? expCtrl.text.trim()
                              : '2+ Yrs',
                        );

                        _addRole(newRole);
                        Navigator.pop(ctx);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '"$title" ${selectedKind == 'internship' ? 'internship' : 'role'} published — now live on Career & Community hubs!',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        backgroundColor: const Color(0xFF0088CC),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.check_circle_rounded, size: 18),
                      label: Text(
                        selectedKind == 'internship'
                            ? 'Publish Internship'
                            : 'Publish Job',
                        style: const TextStyle(fontWeight: FontWeight.w700),
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

  void _showApplicantsSheet(BuildContext context, OpenRole role) {
    final candidates = [
      {
        'name': 'Alex Rivers',
        'role': 'Senior Flutter Dev',
        'match': '96%',
        'status': 'Shortlisted'
      },
      {
        'name': 'Elena Rostova',
        'role': 'AI / ML Specialist',
        'match': '92%',
        'status': 'Interviewing'
      },
      {
        'name': 'Marcus Vance',
        'role': 'Fullstack Engineer',
        'match': '88%',
        'status': 'Applied'
      },
      {
        'name': 'Priya Sharma',
        'role': 'Mobile Lead',
        'match': '85%',
        'status': 'Applied'
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.all(20),
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
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFF0088CC).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.people_rounded,
                        color: Color(0xFF0088CC),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Applicants for ${role.title}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF12233D),
                            ),
                          ),
                          Text(
                            '${role.applicants} candidates applied • ${role.shortlisted} shortlisted',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: ListView.separated(
                    itemCount: candidates.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (ctx, i) {
                      final candidate = candidates[i];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: const Color(0xFFE8F4FB),
                              child: Text(
                                candidate['name']![0],
                                style: const TextStyle(
                                  color: Color(0xFF0088CC),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        candidate['name']!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF12233D),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF059669)
                                              .withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'Match ${candidate['match']}',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF059669),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    candidate['role']!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  candidate['status'] =
                                      candidate['status'] == 'Shortlisted'
                                          ? 'Applied'
                                          : 'Shortlisted';
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${candidate['name']} status set to ${candidate['status']}'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: candidate['status'] == 'Shortlisted'
                                      ? const Color(0xFF059669)
                                      : const Color(0xFF0088CC),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  candidate['status'] == 'Shortlisted'
                                      ? 'Shortlisted'
                                      : 'Shortlist',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showInterviewModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
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
            const Icon(Icons.schedule_rounded,
                color: Color(0xFF0088CC), size: 40),
            const SizedBox(height: 12),
            const Text(
              'Upcoming Interview',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF12233D)),
            ),
            const SizedBox(height: 6),
            const Text(
              'Candidate: Sarah Miller (Senior AI Lead)\nTomorrow at 10:00 AM PST',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Joining interview room...'),
                            behavior: SnackBarBehavior.floating),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0088CC),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Join Video Room',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Reschedule link sent to candidate.'),
                            behavior: SnackBarBehavior.floating),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF374151),
                      side: const BorderSide(color: Color(0xFFD1D5DB)),
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Reschedule',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String key, String label) {
    final isSelected = _selectedFilter == key;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0088CC) : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0088CC)
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF4B5563),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showFullListSheet(BuildContext context, HiringState hiringState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final allRoles = hiringState.roles;
          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.all(20),
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
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0088CC).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.list_alt_rounded,
                          color: Color(0xFF0088CC), size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Full Roles Directory',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF12233D)),
                        ),
                        Text(
                          '${allRoles.length} Total Job Openings Active',
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: allRoles.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) {
                      final role = allRoles[i];
                      return _RoleCard(
                        role: role,
                        onViewApplicants: () {
                          Navigator.pop(ctx);
                          _showApplicantsSheet(context, role);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hiringState = ref.watch(hiringViewModelProvider);
    final filtered = _filteredRoles(hiringState);

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
                  colors: [
                    Color(0xFF0088CC),
                    Color(0xFF229ED9),
                    Color(0xFF0088CC)
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
                      const Text(
                        'Hiring',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
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
                              const Text('ACTIVE RECRUITING',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1)),
                              const SizedBox(height: 6),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('${hiringState.roles.length}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 36,
                                          fontWeight: FontWeight.w800)),
                                  const SizedBox(width: 4),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 6),
                                    child: Text('Open Roles',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 13)),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.bolt,
                                      color: Colors.amber, size: 28),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                          child: _pipelineStat('${hiringState.totalApplicants}', 'APPLIED',
                              const Color(0xFF818CF8))),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _pipelineStat('${hiringState.totalShortlisted}',
                              'SHORTLISTED', const Color(0xFF34D399))),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _pipelineStat('${hiringState.totalInterviews}',
                              'INTERVIEWS', const Color(0xFFFBBF24))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Open Roles',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF12233D))),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _showFullListSheet(context, hiringState),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                              color: const Color(0xFFE0F2FE),
                              borderRadius: BorderRadius.circular(999)),
                          child: const Text(
                            'Full List →',
                            style: TextStyle(
                                color: Color(0xFF0088CC),
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _filterChip('ALL', 'All Roles (${hiringState.roles.length})'),
                        const SizedBox(width: 8),
                        _filterChip('HIRING', 'Hiring (${hiringState.roles.where((r) => r.status == "HIRING").length})'),
                        const SizedBox(width: 8),
                        _filterChip('PAUSED', 'Paused (${hiringState.roles.where((r) => r.status == "PAUSED").length})'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                child: _RoleCard(
                  role: filtered[index],
                  onViewApplicants: () =>
                      _showApplicantsSheet(context, filtered[index]),
                ),
              ),
              childCount: filtered.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Needs Your Attention',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF12233D))),
                  const SizedBox(height: 12),
                  _attentionCard(
                    Icons.people_alt_outlined,
                    'Review 6 applicants for Senior AI Engineer',
                    'Shortlist before Friday',
                    onAct: () =>
                        _showApplicantsSheet(context, hiringState.roles.first),
                  ),
                  const SizedBox(height: 10),
                  _attentionCard(
                    Icons.schedule_outlined,
                    'Interview scheduled tomorrow',
                    '10:00 AM – Sarah M.',
                    onAct: () => _showInterviewModal(context),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _pipelineStat(String value, String label, Color color) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label pipeline: $value candidates'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    color: color, fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6)),
          ],
        ),
      ),
    );
  }

  Widget _attentionCard(IconData icon, String title, String subtitle,
      {required VoidCallback onAct}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Color(0x08000000), blurRadius: 12, offset: Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: const Color(0xFFE8F4FB),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: const Color(0xFF0088CC), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF12233D))),
                Text(subtitle,
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              ],
            ),
          ),
          TextButton(
            onPressed: onAct,
            child: const Text('Act',
                style: TextStyle(
                    color: Color(0xFF0088CC), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard(
      {required this.role, required this.onViewApplicants});
  final OpenRole role;
  final VoidCallback onViewApplicants;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Color(0x08000000), blurRadius: 14, offset: Offset(0, 6))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(role.title,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF12233D))),
                    const SizedBox(height: 2),
                    Text(role.department,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF6B7280))),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: StartupColorHelper.fromKey(role.statusColorKey).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(role.status,
                    style: TextStyle(
                        color: StartupColorHelper.fromKey(role.statusColorKey),
                        fontSize: 11,
                        fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          if (role.salaryLpa != null || role.experience != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                if (role.salaryLpa != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF059669).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.payments_outlined,
                            size: 13, color: Color(0xFF059669)),
                        const SizedBox(width: 4),
                        Text(
                          role.salaryLpa!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (role.salaryLpa != null && role.experience != null)
                  const SizedBox(width: 8),
                if (role.experience != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.stars_outlined,
                            size: 13, color: Color(0xFF2563EB)),
                        const SizedBox(width: 4),
                        Text(
                          role.experience!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (role.location != null) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '📍 ${role.location}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
          if (role.skills != null) ...[
            const SizedBox(height: 8),
            Text(
              '⚡ Skills: ${role.skills}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11.5,
                color: Color(0xFF4B5563),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              _stat('${role.applicants}', 'Applicants'),
              const SizedBox(width: 20),
              _stat('${role.shortlisted}', 'Shortlisted'),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onViewApplicants,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0088CC),
                side: const BorderSide(color: Color(0xFF0088CC)),
                minimumSize: const Size.fromHeight(44),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('View Applicants →',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF12233D))),
        Text(label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
      ],
    );
  }
}
