import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/bridge/bridge_models.dart';
import '../../../../shared/enums/app_enums.dart';
import '../../../community/view/screens/community_home_screen.dart';
import '../../model/startup_models.dart';

class StartupPostsFeedScreen extends ConsumerStatefulWidget {
  const StartupPostsFeedScreen({super.key, required this.startupName});
  final String startupName;

  @override
  ConsumerState<StartupPostsFeedScreen> createState() =>
      _StartupPostsFeedScreenState();
}

class _StartupPostsFeedScreenState
    extends ConsumerState<StartupPostsFeedScreen> {
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(postViewModelProvider.notifier).loadPosts();
    });
  }

  static const Map<String, _CategoryChip> _categories = {
    'All': _CategoryChip(color: Color(0xFF0088CC), icon: Icons.grid_view_rounded),
    'Company News': _CategoryChip(color: Color(0xFF0088CC), icon: Icons.campaign_rounded),
    'Product Launch': _CategoryChip(color: Color(0xFF2563EB), icon: Icons.rocket_launch_rounded),
    'Milestone': _CategoryChip(color: Color(0xFFD97706), icon: Icons.emoji_events_rounded),
    'Team Update': _CategoryChip(color: Color(0xFF059669), icon: Icons.group_add_rounded),
    'Fundraising': _CategoryChip(color: Color(0xFF0088CC), icon: Icons.trending_up_rounded),
    'Hiring': _CategoryChip(color: Color(0xFFE11D48), icon: Icons.work_rounded),
  };

  List<StartupPost> _filteredPosts(List<StartupPost> allPosts) {
    if (_selectedCategory == 'All') return allPosts;
    return allPosts.where((p) => p.type == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authViewModelProvider).session;
    final posts = session?.posts ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      body: Column(
        children: [
          _buildHeader(context),
          _buildCategoryChips(),
          Expanded(
            child: posts.isEmpty
                ? _buildOnlyCommunityTalks()
                : _buildPostsList(_filteredPosts(posts)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.fromLTRB(20, topPadding + 12, 20, 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF006699), Color(0xFF0088CC)],
        ),
      ),
      child: Row(
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
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Posts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.startupName,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${ref.watch(authViewModelProvider).session?.posts.length ?? 0} posts',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final key = _categories.keys.elementAt(index);
          final chip = _categories[key]!;
          final selected = _selectedCategory == key;

          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? chip.color : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected ? chip.color : const Color(0xFFE5E7EB),
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: chip.color.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    chip.icon,
                    size: 16,
                    color: selected ? Colors.white : chip.color,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    key,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : const Color(0xFF374151),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF0088CC).withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.post_add_rounded,
              color: Color(0xFF0088CC),
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No posts yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF12233D),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to create your first post',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsList(List<StartupPost> posts) {
    if (posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_list_off_rounded,
              color: Colors.grey.shade400,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              'No posts in this category',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      itemCount: posts.length + 1,
      itemBuilder: (context, index) {
        if (index == posts.length) {
          return _buildCommunityTalksSection();
        }
        return _PostCard(post: posts[index]);
      },
    );
  }

  // ── Bridge: community discussions surfaced inside the startup feed ─────
  Widget _buildCommunityTalksSection() {
    final communityPosts = ref
        .watch(postViewModelProvider)
        .posts
        .map(careerPostToBridge)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Community Talks',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF12233D),
              ),
            ),
            GestureDetector(
              onTap: () {
                ref
                    .read(authViewModelProvider.notifier)
                    .switchRole(UserRole.creator);
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const CommunityHomeScreen(),
                  ),
                  (_) => false,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0088CC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Open Community',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Trending discussions across the CollabSphere community',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 14),
        if (communityPosts.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Text(
              'No community discussions yet.',
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
          )
        else
          ...communityPosts.take(3).map(
                (post) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE0E7FF)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.forum_rounded,
                          color: Color(0xFF229ED9),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${post.authorName} • ${post.authorRole} • ${post.likes} likes',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildOnlyCommunityTalks() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        _buildEmptyState(),
        const SizedBox(height: 8),
        _buildCommunityTalksSection(),
      ],
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});
  final StartupPost post;

  static const Map<String, _PostTypeStyle> _typeStyles = {
    'Company News': _PostTypeStyle(color: Color(0xFF0088CC), icon: Icons.campaign_rounded),
    'Product Launch': _PostTypeStyle(color: Color(0xFF2563EB), icon: Icons.rocket_launch_rounded),
    'Milestone': _PostTypeStyle(color: Color(0xFFD97706), icon: Icons.emoji_events_rounded),
    'Team Update': _PostTypeStyle(color: Color(0xFF059669), icon: Icons.group_add_rounded),
    'Fundraising': _PostTypeStyle(color: Color(0xFF0088CC), icon: Icons.trending_up_rounded),
    'Hiring': _PostTypeStyle(color: Color(0xFFE11D48), icon: Icons.work_rounded),
  };

  @override
  Widget build(BuildContext context) {
    final style = _typeStyles[post.type] ??
        const _PostTypeStyle(color: Color(0xFF6B7280), icon: Icons.article_rounded);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: style.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(style.icon, color: style.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF12233D),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: style.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            post.type,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: style.color,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _timeAgo(post.createdAt),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.more_horiz_rounded,
                color: Colors.grey.shade400,
                size: 20,
              ),
            ],
          ),
          if (post.description.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              post.description,
              style: const TextStyle(
                fontSize: 13.5,
                height: 1.5,
                color: Color(0xFF374151),
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (post.imageUrl != null) ...[
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                height: 180,
                color: const Color(0xFFF3F4F6),
                child: Image.network(
                  post.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: Colors.grey.shade400,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              _actionButton(Icons.favorite_border_rounded, 'Like', () {}),
              const SizedBox(width: 16),
              _actionButton(Icons.chat_bubble_outline_rounded, 'Comment', () {}),
              const SizedBox(width: 16),
              _actionButton(Icons.share_rounded, 'Share', () {}),
              const Spacer(),
              _actionButton(Icons.bookmark_border_rounded, '', () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF9CA3AF), size: 18),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF9CA3AF),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 30) return '${diff.inDays}d ago';
    return '${(diff.inDays / 30).floor()}mo ago';
  }
}

class _CategoryChip {
  final Color color;
  final IconData icon;
  const _CategoryChip({required this.color, required this.icon});
}

class _PostTypeStyle {
  final Color color;
  final IconData icon;
  const _PostTypeStyle({required this.color, required this.icon});
}
