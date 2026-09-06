import 'package:flutter/material.dart';
import '../home_feed_item.dart';

/// Discovery card: green border/light bg, "Suggested from X" label,
/// Follow + X, Like | Comment | Share, Not interested.
class DiscoveryCard extends StatelessWidget {
  final HomeFeedPost post;
  final VoidCallback onFollow;
  final VoidCallback onClose;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onNotInterested;

  const DiscoveryCard({
    super.key,
    required this.post,
    required this.onFollow,
    required this.onClose,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onNotInterested,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF86EFAC)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  post.discoveryLabel ?? 'Suggested for you',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF059669),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onClose,
                child: const Icon(Icons.close_rounded,
                    size: 18, color: Color(0xFF6B7280)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFD1FAE5),
                child: Text(
                  post.initials,
                  style: const TextStyle(
                    color: Color(0xFF059669),
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
                      post.authorName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    Text(
                      '${post.authorSub} • ${post.timeAgo}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: onFollow,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF059669),
                  side: const BorderSide(color: Color(0xFF059669)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(post.followed ? 'Following' : 'Follow'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (post.title.isNotEmpty)
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),
          Text(
            post.body,
            style: const TextStyle(
              fontSize: 13.5,
              color: Color(0xFF374151),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _mini(Icons.thumb_up_outlined, '${post.likes}', onLike),
              const SizedBox(width: 18),
              _mini(Icons.chat_bubble_outline_rounded, '${post.comments}',
                  onComment),
              const SizedBox(width: 18),
              _mini(Icons.share_outlined, 'Share', onShare),
              const Spacer(),
              GestureDetector(
                onTap: onNotInterested,
                child: const Text(
                  'Not interested',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6B7280),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mini(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF6B7280)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
