import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DiscussionForumsScreen extends StatefulWidget {
  const DiscussionForumsScreen({super.key});

  @override
  State<DiscussionForumsScreen> createState() => _DiscussionForumsScreenState();
}

class _DiscussionForumsScreenState extends State<DiscussionForumsScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Flutter', 'React', 'AI/ML', 'System Design'];

  final List<_ForumPost> _allPosts = [
    _ForumPost(title: 'How to implement state management in Flutter 3.x?', author: 'Priya Sharma', replies: 24, likes: 56, timeAgo: '2h ago', tags: ['Flutter', 'State Management'], avatar: 1, category: 'Flutter'),
    _ForumPost(title: 'Best practices for React Server Components', author: 'Alex Chen', replies: 18, likes: 42, timeAgo: '5h ago', tags: ['React', 'Next.js'], avatar: 2, category: 'React'),
    _ForumPost(title: 'Understanding Transformer Architecture', author: 'Dr. Rahul Verma', replies: 31, likes: 89, timeAgo: '1d ago', tags: ['AI/ML', 'Deep Learning'], avatar: 3, category: 'AI/ML'),
    _ForumPost(title: 'System Design: Designing a URL Shortener', author: 'Sarah Johnson', replies: 15, likes: 38, timeAgo: '1d ago', tags: ['System Design', 'Backend'], avatar: 4, category: 'System Design'),
    _ForumPost(title: 'Flutter vs Kotlin Multiplatform in 2026', author: 'Marcus Lee', replies: 42, likes: 112, timeAgo: '2d ago', tags: ['Flutter', 'KMP'], avatar: 5, category: 'Flutter'),
  ];

  List<_ForumPost> get _filteredPosts {
    if (_selectedFilter == 0) return _allPosts;
    return _allPosts.where((p) => p.category == _filters[_selectedFilter]).toList();
  }

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
                  const Text('Discussion Forums', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFF8B5CF6).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.add_rounded, color: Color(0xFF8B5CF6), size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: List.generate(_filters.length, (i) {
                  final selected = _selectedFilter == i;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() => _selectedFilter = i);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? const Color(0xFF8B5CF6) : const Color(0xFFEDE9FE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(_filters[i], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: selected ? Colors.white : const Color(0xFF6D28D9))),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredPosts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.forum_outlined, size: 48, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          Text('No discussions found', style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: _filteredPosts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (ctx, i) => _buildPostCard(_filteredPosts[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(_ForumPost post) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDE9FE), width: 1.2),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFFEDE9FE),
                child: Text(post.author[0], style: const TextStyle(color: Color(0xFF8B5CF6), fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.author, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                    Text(post.timeAgo, style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(post.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111827), height: 1.3)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: post.tags.map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(20)),
              child: Text(t, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF7C3AED))),
            )).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _statChip(Icons.chat_bubble_outline_rounded, '${post.replies} replies', const Color(0xFF8B5CF6)),
              const SizedBox(width: 12),
              _statChip(Icons.favorite_border_rounded, '${post.likes}', const Color(0xFFEF4444)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _ForumPost {
  final String title, author, timeAgo, category;
  final int replies, likes;
  final List<String> tags;
  const _ForumPost({required this.title, required this.author, required this.replies, required this.likes, required this.timeAgo, required this.tags, required int avatar, required this.category});
}
