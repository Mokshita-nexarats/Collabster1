import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import '../../model/comment_model.dart';
import '../../model/post_model.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final CareerPost post;

  const PostDetailScreen({super.key, required this.post});

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final _commentController = TextEditingController();
  final _commentFocus = FocusNode();

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocus.dispose();
    super.dispose();
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  void _share() {
    Clipboard.setData(
      ClipboardData(text: '${widget.post.title} — Check out this post'),
    );
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

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    final session = ref.read(authViewModelProvider).session;
    ref
        .read(postViewModelProvider.notifier)
        .addComment(
          widget.post.id,
          text,
          authorName: session?.fullName ?? 'You',
        );
    _commentController.clear();
    _commentFocus.unfocus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final postState = ref.watch(postViewModelProvider);
    final post = postState.posts.firstWhere(
      (p) => p.id == widget.post.id,
      orElse: () => widget.post,
    );
    final comments = postState.comments
        .where((c) => c.postId == post.id)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Post',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _share,
            icon: const Icon(
              Icons.share_outlined,
              color: Color(0xFF1E293B),
              size: 22,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              children: [
                _buildAuthorHeader(post),
                const SizedBox(height: 16),
                Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  post.content,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF334155),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 18),
                _buildActionRow(post),
                const SizedBox(height: 18),
                Divider(color: Colors.grey.shade200, height: 1),
                const SizedBox(height: 16),
                Text(
                  'Comments (${comments.length})',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),
                if (comments.isEmpty)
                  _buildNoComments()
                else
                  ...comments.map(
                    (comment) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _CommentTile(comment: comment),
                    ),
                  ),
              ],
            ),
          ),
          _buildCommentBar(),
        ],
      ),
    );
  }

  Widget _buildAuthorHeader(CareerPost post) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xFF229ED9).withValues(alpha: 0.12),
          child: Text(
            post.authorName.isNotEmpty ? post.authorName[0].toUpperCase() : 'A',
            style: const TextStyle(
              color: Color(0xFF229ED9),
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.authorName,
                style: const TextStyle(
                  fontSize: 15,
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
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    Text(
                      ' · ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                  Text(
                    _timeAgo(post.createdAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow(CareerPost post) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Row(
        children: [
          _ActionButton(
            icon: post.isLiked
                ? Icons.thumb_up_rounded
                : Icons.thumb_up_outlined,
            label: '${post.likes}',
            color: post.isLiked
                ? const Color(0xFF229ED9)
                : Colors.grey.shade600,
            onTap: () =>
                ref.read(postViewModelProvider.notifier).toggleLike(post.id),
          ),
          const SizedBox(width: 24),
          _ActionButton(
            icon: Icons.chat_bubble_outline_rounded,
            label: '${post.comments}',
            color: Colors.grey.shade600,
            onTap: () => _commentFocus.requestFocus(),
          ),
          const Spacer(),
          _ActionButton(
            icon: Icons.share_outlined,
            label: 'Share',
            color: Colors.grey.shade600,
            onTap: _share,
          ),
        ],
      ),
    );
  }

  Widget _buildNoComments() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.chat_bubble_outline_rounded,
            color: Color(0xFF94A3B8),
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            'No comments yet. Be the first to join the conversation!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        10,
        12,
        MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: const Color(0xFFE2E8F0), width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(22),
              ),
              child: TextField(
                controller: _commentController,
                focusNode: _commentFocus,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _submitComment(),
                style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle: TextStyle(
                    fontSize: 13.5,
                    color: Colors.grey.shade500,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 11,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _submitComment,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF229ED9), Color(0xFF0088CC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF229ED9).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentTile extends ConsumerWidget {
  final PostComment comment;

  const _CommentTile({required this.comment});

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFF229ED9).withValues(alpha: 0.1),
                child: Text(
                  comment.authorName.isNotEmpty
                      ? comment.authorName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: Color(0xFF229ED9),
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.authorName,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      _timeAgo(comment.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                comment.isLiked
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                size: 17,
                color: comment.isLiked
                    ? const Color(0xFF229ED9)
                    : Colors.grey.shade400,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment.text,
            style: const TextStyle(
              fontSize: 13.5,
              color: Color(0xFF334155),
              height: 1.5,
            ),
          ),
        ],
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
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 19, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
