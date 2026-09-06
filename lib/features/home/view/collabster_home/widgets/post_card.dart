import 'package:flutter/material.dart';
import '../home_feed_item.dart';

/// Standard vertical post card: avatar, name, time, menu, title, body,
/// image, Like | Comment | Share | Bookmark.
class PostCard extends StatelessWidget {
  final HomeFeedPost post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onBookmark;
  final VoidCallback onMenu;
  final VoidCallback? onAuthorTap;
  final ValueChanged<int>? onPollVote;

  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onBookmark,
    required this.onMenu,
    this.onAuthorTap,
    this.onPollVote,
  });

  String _count(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 8, 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFFDBEAFE),
                  child: Text(
                    post.initials,
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: onAuthorTap,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.authorName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              '${post.authorSub} • ${post.timeAgo}',
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.public_rounded,
                                size: 12, color: Color(0xFF9CA3AF)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onMenu,
                  icon: const Icon(Icons.more_horiz_rounded,
                      color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.title.isNotEmpty) ...[
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
                Text(
                  post.body,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF374151),
                    height: 1.5,
                  ),
                ),
                if (post.isPoll) ...[
                  const SizedBox(height: 10),
                  _pollBlock(),
                ],
              ],
            ),
          ),
          if (post.hasImage) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 170,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFDBEAFE), Color(0xFFEFF6FF)],
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.image_rounded,
                        size: 40, color: Color(0xFF93C5FD)),
                  ),
                ),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Row(
              children: [
                _action(
                  icon: post.likedByMe
                      ? Icons.thumb_up_rounded
                      : Icons.thumb_up_outlined,
                  label: _count(post.likes),
                  color: post.likedByMe
                      ? const Color(0xFF2563EB)
                      : const Color(0xFF6B7280),
                  onTap: onLike,
                ),
                const SizedBox(width: 18),
                _action(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: _count(post.comments),
                  color: const Color(0xFF6B7280),
                  onTap: onComment,
                ),
                const SizedBox(width: 18),
                _action(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  color: const Color(0xFF6B7280),
                  onTap: onShare,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onBookmark,
                  child: Icon(
                    post.bookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_outline_rounded,
                    size: 20,
                    color: post.bookmarked
                        ? const Color(0xFF2563EB)
                        : const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pollBlock() {
    final total = post.pollVotes.fold<int>(0, (a, b) => a + b);
    return Column(
      children: List.generate(post.pollOptions.length, (i) {
        final votes = i < post.pollVotes.length ? post.pollVotes[i] : 0;
        final pct = total == 0 ? 0 : ((votes / total) * 100).round();
        final voted = post.votedIndex == i;
        final hasVoted = post.votedIndex != null;
        return GestureDetector(
          onTap: hasVoted ? null : () => onPollVote?.call(i),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: voted
                    ? const Color(0xFF2563EB)
                    : const Color(0xFFD1D5DB),
                width: voted ? 1.5 : 1,
              ),
              color: voted
                  ? const Color(0xFFEFF6FF)
                  : const Color(0xFFF9FAFB),
            ),
            child: Stack(
              children: [
                if (hasVoted)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: total == 0 ? 0 : votes / total,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFBFDBFE),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        post.pollOptions[i],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                    if (hasVoted)
                      Text(
                        '$pct%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2563EB),
                        ),
                      )
                    else
                      const Icon(Icons.radio_button_unchecked_rounded,
                          size: 18, color: Color(0xFF9CA3AF)),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _action({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
