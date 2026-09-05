import 'package:flutter/material.dart';
import '../../../../core/theme/investor_colors.dart';

class DiligenceNote {
  DiligenceNote({
    required this.id,
    required this.title,
    required this.content,
    required this.tag,
    required this.date,
    required this.startup,
    this.isPinned = false,
  });

  final String id;
  final String title;
  final String content;
  final String tag;
  final String date;
  final String startup;
  bool isPinned;
}

/// Notes Screen — view & manage private diligence notes
class InvestorNotesScreen extends StatefulWidget {
  const InvestorNotesScreen({super.key});

  @override
  State<InvestorNotesScreen> createState() => _InvestorNotesScreenState();
}

class _InvestorNotesScreenState extends State<InvestorNotesScreen> {
  String _selectedTag = 'All';

  final List<DiligenceNote> _notes = [
    DiligenceNote(
      id: 'n1',
      title: 'Cap Table & Valuation Expectations',
      content: 'Founders agreed to \$15M post-money cap for Series A. Existing seed investors participating with \$250K pro-rata.',
      tag: 'Cap Table',
      date: 'Today, 2:15 PM',
      startup: 'Nova Robotics',
      isPinned: true,
    ),
    DiligenceNote(
      id: 'n2',
      title: 'Technical Stack & Patent IP Verification',
      content: 'CTO confirmed 3 granted patents in autonomous spatial navigation. Architecture audited by external cloud security team.',
      tag: 'Diligence',
      date: 'Yesterday',
      startup: 'Nova Robotics',
      isPinned: true,
    ),
    DiligenceNote(
      id: 'n3',
      title: 'Founder Reference Check Notes',
      content: 'Former VP of Eng at Stripe highly recommended founder. Strong technical execution capability & high integrity.',
      tag: 'Reference',
      date: 'Aug 22, 2026',
      startup: 'FinEdge Tech',
    ),
    DiligenceNote(
      id: 'n4',
      title: 'Valuation Audit & MoIC Model',
      content: 'Current ARR \$1.2M growing 18% MoM. 3x MoIC projected over 36 months under base case scenario.',
      tag: 'Valuation',
      date: 'Aug 18, 2026',
      startup: 'QuantumPay',
    ),
  ];

  List<DiligenceNote> get _filtered {
    if (_selectedTag == 'All') return _notes;
    return _notes.where((n) => n.tag == _selectedTag).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: InvestorColors.goldBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
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
                                  'Diligence Notes',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Private cap table & valuation findings',
                                  style: TextStyle(color: Colors.white70, fontSize: 12.5),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '${_notes.length} Notes',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Tag Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['All', 'Cap Table', 'Diligence', 'Reference', 'Valuation'].map((t) {
                            final isSel = _selectedTag == t;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedTag = t),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: isSel ? Colors.white : Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    t,
                                    style: TextStyle(
                                      color: isSel ? InvestorColors.ink : Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ..._filtered.map((note) => Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: InvestorColors.border),
                        boxShadow: const [
                          BoxShadow(color: Color(0x08000000), blurRadius: 10, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF229ED9).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  note.tag,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF229ED9),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                note.startup,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: InvestorColors.textMuted,
                                ),
                              ),
                              const Spacer(),
                              if (note.isPinned)
                                const Icon(Icons.push_pin_rounded, size: 16, color: Color(0xFF229ED9)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            note.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: InvestorColors.ink,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            note.content,
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: InvestorColors.inkSoft,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                note.date,
                                style: const TextStyle(fontSize: 11.5, color: InvestorColors.textMuted),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Note copied to clipboard!'),
                                          backgroundColor: Color(0xFF229ED9),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.copy_rounded, size: 18, color: InvestorColors.textMuted),
                                    constraints: const BoxConstraints(),
                                    padding: EdgeInsets.zero,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
