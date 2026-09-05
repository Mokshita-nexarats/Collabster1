import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  final List<_Leader> _leaders = const [
    _Leader(name: 'Priya Sharma', points: 2450, rank: 1, courses: 15, streak: 42),
    _Leader(name: 'Alex Chen', points: 2180, rank: 2, courses: 12, streak: 35),
    _Leader(name: 'Marcus Lee', points: 1920, rank: 3, courses: 11, streak: 28),
    _Leader(name: 'You', points: 1650, rank: 4, courses: 8, streak: 21),
    _Leader(name: 'Sarah Johnson', points: 1520, rank: 5, courses: 9, streak: 18),
    _Leader(name: 'David Kim', points: 1380, rank: 6, courses: 7, streak: 15),
    _Leader(name: 'Emma Wilson', points: 1240, rank: 7, courses: 6, streak: 12),
    _Leader(name: 'James Rodriguez', points: 1100, rank: 8, courses: 5, streak: 10),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF8B5CF6), size: 22),
                  ),
                  const SizedBox(width: 14),
                  const Text('Leaderboard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildTopThree(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: _leaders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (ctx, i) => _buildLeaderRow(_leaders[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopThree() {
    final top3 = _leaders.take(3).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildPodium(top3[1], 56, const Color(0xFFC0C0C0)),
          _buildPodium(top3[0], 72, const Color(0xFFFFD700)),
          _buildPodium(top3[2], 48, const Color(0xFFCD7F32)),
        ],
      ),
    );
  }

  Widget _buildPodium(_Leader leader, double avatarSize, Color color) {
    final isYou = leader.name == 'You';
    return Column(
      children: [
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(leader.name[0], style: TextStyle(fontSize: avatarSize * 0.35, fontWeight: FontWeight.bold, color: color)),
          ),
        ),
        const SizedBox(height: 6),
        Text(leader.name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isYou ? const Color(0xFF8B5CF6) : const Color(0xFF111827))),
        Text('${leader.points} pts', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
        const SizedBox(height: 8),
        Container(
          width: 50,
          height: leader.rank == 1 ? 60 : leader.rank == 2 ? 45 : 35,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Center(
            child: Text('#${leader.rank}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderRow(_Leader leader) {
    final isYou = leader.name == 'You';
    final medalColor = leader.rank <= 3 ? [const Color(0xFFFFD700), const Color(0xFFC0C0C0), const Color(0xFFCD7F32)][leader.rank - 1] : null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isYou ? const Color(0xFFEDE9FE) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isYou ? const Color(0xFF8B5CF6) : const Color(0xFFE5E7EB), width: isYou ? 1.5 : 1),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: medalColor != null
                ? Icon(Icons.emoji_events_rounded, color: medalColor, size: 20)
                : Text('#${leader.rank}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFEDE9FE),
            child: Text(leader.name[0], style: const TextStyle(color: Color(0xFF8B5CF6), fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(leader.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isYou ? const Color(0xFF8B5CF6) : const Color(0xFF111827))),
                Text('${leader.courses} courses • ${leader.streak} day streak', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Text('${leader.points}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isYou ? const Color(0xFF8B5CF6) : const Color(0xFF111827))),
          Text(' pts', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}

class _Leader {
  final String name;
  final int points, rank, courses, streak;
  const _Leader({required this.name, required this.points, required this.rank, required this.courses, required this.streak});
}
