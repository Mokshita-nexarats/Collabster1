import 'package:flutter/material.dart';
import 'peer_booking_screen.dart';

class MatchPeerScreen extends StatefulWidget {
  const MatchPeerScreen({super.key});

  @override
  State<MatchPeerScreen> createState() => _MatchPeerScreenState();
}

class _MatchPeerScreenState extends State<MatchPeerScreen> {
  int _selectedDomain = 0;
  final Set<String> _selectedSkills = {'JavaScript', 'Node.js'};
  final TextEditingController _searchController = TextEditingController();

  // ── Palette (mirrors the dark Events screen) ──────────────────────────────
  static const _bg = Color(0xFF0D0D1A);
  static const _surface = Color(0xFF1A1A2E);
  static const _surfaceAlt = Color(0xFF16213E);
  static const _purple = Color(0xFF229ED9);
  static const _purpleLight = Color(0xFFE8F4FB);
  static const _purpleSubtle = Color(0xFF0F172A);
  static const _textPrimary = Colors.white;
  static const _textSecondary = Color(0xFF9CA3AF);
  static const _green = Color(0xFF10B981);
  static const _divider = Color(0xFF1E1E3A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _divider, width: 1),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: _textPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Title
                  const Text(
                    'Match your Peer',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: _textPrimary,
                    ),
                  ),
                  const Spacer(),
                  // Bell icon (mirrors the Events screen header)
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _divider, width: 1),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.notifications_none_rounded,
                          color: _textPrimary,
                          size: 20,
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: _purple,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Scrollable body ─────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subtitle
                    const Text(
                      'Select Skill Focus',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Choose a domain to find peers specializing in that stack.',
                      style: TextStyle(
                        fontSize: 13,
                        color: _textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Active-peers badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: _purpleSubtle,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFF229ED9).withValues(alpha: 0.3), width: 1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: _green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              '42 active peers matching your profile skills',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _purpleLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Search bar (styled like Events screen)
                    Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _divider, width: 1),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 14),
                          const Icon(Icons.search_rounded, color: _textSecondary, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(
                                fontSize: 13,
                                color: _textPrimary,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Search skill, framework, or peer...',
                                hintStyle: TextStyle(
                                  fontSize: 13,
                                  color: _textSecondary,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (v) => setState(() {}),
                            ),
                          ),
                          // Filter icon button
                          GestureDetector(
                            onTap: () => setState(() {
                              _selectedDomain = (_selectedDomain + 1) % 4;
                            }),
                            child: Container(
                              width: 36,
                              height: 36,
                              margin: const EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                color: _selectedDomain != 0 ? _purple : _surfaceAlt,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.tune_rounded,
                                color: _textPrimary,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Domain filter chips (horizontal scroll)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          _buildDomainChip(0, 'All'),
                          const SizedBox(width: 8),
                          _buildDomainChip(1, 'Frontend'),
                          const SizedBox(width: 8),
                          _buildDomainChip(2, 'Backend'),
                          const SizedBox(width: 8),
                          _buildDomainChip(3, 'Data Science'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Skill card — Languages
                    _buildSkillGroupCard(
                      icon: Icons.code_rounded,
                      title: 'Languages',
                      skills: const ['Python', 'JavaScript', 'Java', 'Go', 'C++'],
                    ),
                    const SizedBox(height: 14),

                    // Skill card — Backend & Data
                    _buildSkillGroupCard(
                      icon: Icons.dns_outlined,
                      title: 'Backend & Data',
                      skills: const ['Node.js', 'Python Django', 'PostgreSQL', 'System Design'],
                    ),
                    const SizedBox(height: 24),

                    // Section label
                    const Text(
                      'RECOMMENDED MATCHES BASED ON FOCUS',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: _textSecondary,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Match rows
                    _buildMatchRow(
                      name: 'Sarah Chen',
                      desc: 'L7 at BigTech • React Expert',
                      avatarUrl: 'https://i.pravatar.cc/150?img=34',
                    ),
                    const SizedBox(height: 10),
                    _buildMatchRow(
                      name: 'Marcus Thorne',
                      desc: 'Backend Lead • Node.js / Go',
                      avatarUrl: 'https://i.pravatar.cc/150?img=33',
                    ),
                    const SizedBox(height: 10),
                    _buildMatchRow(
                      name: 'Elena Rodriguez',
                      desc: 'Systems Arch • PostgreSQL',
                      avatarUrl: 'https://i.pravatar.cc/150?img=28',
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),

            // ── Sticky bottom panel ─────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              decoration: BoxDecoration(
                color: _surface,
                border: Border(top: BorderSide(color: _divider, width: 1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Selected skill tags
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSelectionTag('JavaScript'),
                      const SizedBox(width: 6),
                      _buildSelectionTag('React.js'),
                      const SizedBox(width: 6),
                      const Text(
                        '+ 1 more',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // CTA button — mirrors the "Register Now" button style
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PeerBookingScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _purple,
                        elevation: 0,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Find Peer Match',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.bolt_rounded, color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Domain chip ────────────────────────────────────────────────────────────
  Widget _buildDomainChip(int index, String label) {
    final selected = _selectedDomain == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedDomain = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? _purple : _surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? _purple : _divider,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : _textSecondary,
          ),
        ),
      ),
    );
  }

  // ── Skill group card ───────────────────────────────────────────────────────
  Widget _buildSkillGroupCard({
    required IconData icon,
    required String title,
    required List<String> skills,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _divider, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _purpleSubtle,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: _purple, size: 17),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((s) => _buildSkillChip(s)).toList(),
          ),
        ],
      ),
    );
  }

  // ── Skill chip ─────────────────────────────────────────────────────────────
  Widget _buildSkillChip(String label) {
    final isSelected = _selectedSkills.contains(label);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedSkills.remove(label);
          } else {
            _selectedSkills.add(label);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _purple : _surfaceAlt,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? _purple : _divider,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : _textSecondary,
          ),
        ),
      ),
    );
  }

  // ── Match row ──────────────────────────────────────────────────────────────
  Widget _buildMatchRow({
    required String name,
    required String desc,
    required String avatarUrl,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _divider, width: 1),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(avatarUrl),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: _green,
                    shape: BoxShape.circle,
                    border: Border.all(color: _surface, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 11,
                    color: _textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: _textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }

  // ── Selection tag ──────────────────────────────────────────────────────────
  Widget _buildSelectionTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _purpleSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF229ED9).withValues(alpha: 0.4), width: 1),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: _purpleLight,
        ),
      ),
    );
  }
}
