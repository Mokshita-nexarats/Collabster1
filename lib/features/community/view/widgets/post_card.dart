import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import '../../model/post_model.dart';
import '../screens/post_detail_screen.dart';

class PostCard extends ConsumerWidget {
  final CareerPost post;
  final int maxContentLines;

  const PostCard({super.key, required this.post, this.maxContentLines = 3});

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  void _openDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PostDetailScreen(post: post)),
    );
  }

  void _share(BuildContext context) {
    Clipboard.setData(ClipboardData(text: post.title));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: const Row(
          children: [
            Icon(Icons.link_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text('Post link copied to clipboard'),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openDetail(context),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(
                      0xFF229ED9,
                    ).withValues(alpha: 0.12),
                    child: Text(
                      post.authorName.isNotEmpty
                          ? post.authorName[0].toUpperCase()
                          : 'A',
                      style: const TextStyle(
                        color: Color(0xFF229ED9),
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
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
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Row(
                          children: [
                            if (post.authorRole.isNotEmpty) ...[
                              Flexible(
                                child: Text(
                                  post.authorRole,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                              Text(
                                ' · ',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ],
                            Text(
                              _timeAgo(post.createdAt),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
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
              const SizedBox(height: 12),

              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 6),

              Text(
                post.content,
                maxLines: maxContentLines,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.5,
                  color: Colors.grey.shade600,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 14),

              Divider(height: 1, color: Colors.grey.shade100),
              const SizedBox(height: 10),

              Row(
                children: [
                  _ActionButton(
                    icon: post.isLiked
                        ? Icons.thumb_up_rounded
                        : Icons.thumb_up_outlined,
                    label: '${post.likes}',
                    color: post.isLiked
                        ? const Color(0xFF229ED9)
                        : Colors.grey.shade500,
                    onTap: () => ref
                        .read(postViewModelProvider.notifier)
                        .toggleLike(post.id),
                  ),
                  const SizedBox(width: 20),
                  _ActionButton(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: '${post.comments}',
                    color: Colors.grey.shade500,
                    onTap: () => _openDetail(context),
                  ),
                  const Spacer(),
                  _ActionButton(
                    icon: Icons.share_outlined,
                    label: 'Share',
                    color: Colors.grey.shade500,
                    onTap: () => _share(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
