import 'package:flutter/material.dart';

import '../../../auth/view/screens/profile_screen.dart';

/// Working Explore: discover people, startups and opportunities.
/// Frontend-only mock data until backend search APIs exist.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  int _chip = 0; // 0 All, 1 People, 2 Startups, 3 Jobs
  final Set<String> _following = {};
  final Set<String> _joined = {};

  static const _chips = ['All', 'People', 'Startups', 'Jobs'];

  static const _people = [
    ('Rahul Sharma', 'Startup Founder • Fintech', 'R'),
    ('Emma Williams', 'Marketing Strategist', 'E'),
    ('Priya Nair', 'Product Designer • SaaS', 'P'),
    ('Arjun Mehta', 'Angel Investor • Seed', 'A'),
  ];

  static const _startups = [
    ('Alpha Tech', 'Productivity • Hiring', 'A'),
    ('FinTech Lab', 'Fintech • Seed funded', 'F'),
    ('DesignBridge', 'Design • Early stage', 'D'),
    ('GreenKart', 'E-commerce • Growth', 'G'),
  ];

  static const _jobs = [
    ('Flutter Developer', 'Alpha Tech • Remote • Full-time'),
    ('Growth Marketer', 'FinTech Lab • Bengaluru • Full-time'),
    ('Product Intern', 'DesignBridge • Hybrid • Internship'),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  bool _match(String s) =>
      _query.isEmpty || s.toLowerCase().contains(_query.toLowerCase());

  @override
  Widget build(BuildContext context) {
    final people =
        _people.where((p) => _match('${p.$1} ${p.$2}')).toList();
    final startups =
        _startups.where((s) => _match('${s.$1} ${s.$2}')).toList();
    final jobs = _jobs.where((j) => _match('${j.$1} ${j.$2}')).toList();
    final showPeople = _chip == 0 || _chip == 1;
    final showStartups = _chip == 0 || _chip == 2;
    final showJobs = _chip == 0 || _chip == 3;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: Color(0xFF111827)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              const Icon(Icons.search_rounded,
                  size: 18, color: Color(0xFF9CA3AF)),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) =>
                      setState(() => _query = v.trim()),
                  decoration: const InputDecoration(
                    hintText: 'Search people, startups, jobs',
                    hintStyle: TextStyle(
                        fontSize: 13.5, color: Color(0xFF9CA3AF)),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              if (_query.isNotEmpty)
                GestureDetector(
                  onTap: () => setState(() {
                    _searchCtrl.clear();
                    _query = '';
                  }),
                  child: const Icon(Icons.close_rounded,
                      size: 18, color: Color(0xFF9CA3AF)),
                ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _chips.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final active = _chip == i;
                return GestureDetector(
                  onTap: () => setState(() => _chip = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: active
                          ? const Color(0xFF2563EB)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: active
                            ? const Color(0xFF2563EB)
                            : const Color(0xFFE5E7EB),
                      ),
                    ),
                    child: Text(
                      _chips[i],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: active
                            ? Colors.white
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (showPeople) ...[
            const SizedBox(height: 16),
            _sectionTitle('Suggested people'),
            const SizedBox(height: 8),
            if (people.isEmpty)
              _empty('No people match "$_query"')
            else
              for (final p in people)
                _rowCard(
                  initial: p.$3,
                  title: p.$1,
                  subtitle: p.$2,
                  actionLabel: _following.contains(p.$1)
                      ? 'Following'
                      : 'Follow',
                  actionActive:
                      _following.contains(p.$1),
                  onAction: () => setState(() =>
                      _following.contains(p.$1)
                          ? _following.remove(p.$1)
                          : _following.add(p.$1)),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ProfileScreen()),
                  ),
                ),
          ],
          if (showStartups) ...[
            const SizedBox(height: 16),
            _sectionTitle('Startups to watch'),
            const SizedBox(height: 8),
            if (startups.isEmpty)
              _empty('No startups match "$_query"')
            else
              for (final s in startups)
                _rowCard(
                  initial: s.$3,
                  title: s.$1,
                  subtitle: s.$2,
                  actionLabel: _joined.contains(s.$1)
                      ? 'Joined'
                      : 'Follow',
                  actionActive:
                      _joined.contains(s.$1),
                  onAction: () => setState(() =>
                      _joined.contains(s.$1)
                          ? _joined.remove(s.$1)
                          : _joined.add(s.$1)),
                  onTap: () {},
                ),
          ],
          if (showJobs) ...[
            const SizedBox(height: 16),
            _sectionTitle('Opportunities'),
            const SizedBox(height: 8),
            if (jobs.isEmpty)
              _empty('No jobs match "$_query"')
            else
              for (final j in jobs)
                _rowCard(
                  initial: j.$1.isEmpty
                      ? 'J'
                      : j.$1[0].toUpperCase(),
                  title: j.$1,
                  subtitle: j.$2,
                  actionLabel: 'View',
                  actionActive: false,
                  onAction: () {},
                  onTap: () {},
                ),
          ],
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) {
    return Text(
      t,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: Color(0xFF111827),
      ),
    );
  }

  Widget _empty(String msg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        msg,
        style:
            const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
      ),
    );
  }

  Widget _rowCard({
    required String initial,
    required String title,
    required String subtitle,
    required String actionLabel,
    required bool actionActive,
    required VoidCallback onAction,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFFEFF6FF),
              child: Text(
                initial,
                style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: onAction,
              style: OutlinedButton.styleFrom(
                foregroundColor: actionActive
                    ? const Color(0xFF6B7280)
                    : const Color(0xFF2563EB),
                side: BorderSide(
                  color: actionActive
                      ? const Color(0xFFE5E7EB)
                      : const Color(0xFF2563EB),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}
