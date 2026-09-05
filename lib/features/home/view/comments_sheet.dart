import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CommentsSheet – Modal bottom sheet for post comments (matching design)
// ─────────────────────────────────────────────────────────────────────────────

class CommentData {
  final String id;
  final String authorName;
  final String authorSub;
  final String body;
  final String timeAgo;
  int likes;
  bool isLiked;
  final bool isReply;
  final String? avatarUrl;
  final Color avatarBg;

  CommentData({
    required this.id,
    required this.authorName,
    required this.authorSub,
    required this.body,
    required this.timeAgo,
    this.likes = 0,
    this.isLiked = false,
    this.isReply = false,
    this.avatarUrl,
    this.avatarBg = const Color(0xFF6366F1),
  });
}

class CommentsSheet extends ConsumerStatefulWidget {
  const CommentsSheet({super.key, this.initialCommentCount = 120});

  final int initialCommentCount;

  static void show(BuildContext context, {int commentCount = 120}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CommentsSheet(initialCommentCount: commentCount),
    );
  }

  @override
  ConsumerState<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends ConsumerState<CommentsSheet> {
  final TextEditingController _commentCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  static const _kPurple = Color(0xFF4338CA);
  static const _kPurpleCard = Color(0xFFF5F3FF);
  static const _kTextDark = Color(0xFF1E1B4B);
  static const _kTextMid = Color(0xFF6B7280);
  static const _kBorder = Color(0xFFE5E7EB);

  late List<CommentData> _comments;
  late int _commentCount;

  @override
  void initState() {
    super.initState();
    _commentCount = widget.initialCommentCount;
    _comments = [
      CommentData(
        id: '1',
        authorName: 'David Chen',
        authorSub: 'Senior Product Designer at Collabster',
        body:
            'This new feature is exactly what we needed. The soft tech approach really shines here, making the interface feel less intimidating while retaining all the power user tools.',
        timeAgo: '2h ago',
        likes: 5,
        isLiked: false,
        isReply: false,
        avatarBg: const Color(0xFF4338CA),
      ),
      CommentData(
        id: '2',
        authorName: 'Elena Rodriguez',
        authorSub: 'UX Researcher',
        body:
            'Agreed! The user testing sessions last week confirmed that the tonal depth model significantly reduces cognitive load during long sessions.',
        timeAgo: '1h ago',
        likes: 2,
        isLiked: true,
        isReply: true,
        avatarBg: const Color(0xFF7C3AED),
      ),
      CommentData(
        id: '3',
        authorName: 'Marcus Thorne',
        authorSub: 'Frontend Engineer',
        body:
            'Can we make sure the animation states for these nested threads perform well on mobile? The CSS transitions looked a bit heavy in the last build.',
        timeAgo: '30m ago',
        likes: 0,
        isLiked: false,
        isReply: false,
        avatarBg: const Color(0xFF059669),
      ),
    ];
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _addComment() {
    final text = _commentCtrl.text.trim();
    if (text.isEmpty) return;

    final session = ref.read(authViewModelProvider).session;
    final name = session?.fullName ?? 'Lobster Member';
    final role = session?.activeUserRole.label ?? 'Member';

    setState(() {
      _comments.add(
        CommentData(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          authorName: name,
          authorSub: role,
          body: text,
          timeAgo: 'Just now',
          likes: 0,
          isLiked: false,
          isReply: false,
          avatarBg: const Color(0xFF4338CA),
        ),
      );
      _commentCount++;
      _commentCtrl.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _toggleLike(CommentData comment) {
    setState(() {
      comment.isLiked = !comment.isLiked;
      if (comment.isLiked) {
        comment.likes++;
      } else {
        comment.likes = (comment.likes - 1).clamp(0, 999);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authViewModelProvider).session;
    final photoPath = session?.profilePhotoPath ?? '';
    final hasPhoto = photoPath.isNotEmpty && File(photoPath).existsSync();
    final initials = (session?.fullName ?? 'L').substring(0, 1).toUpperCase();

    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: keyboardInset),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // ── Top Header ─────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: _kBorder, width: 0.8)),
                ),
                child: Row(
                  children: [
                    // Close button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 22,
                          color: _kTextMid,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Comments ($_commentCount)',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: _kTextDark,
                        ),
                      ),
                    ),
                    // Options button
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.more_horiz_rounded,
                          size: 22,
                          color: _kTextMid,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Comments List ──────────────────────────────────────────
              Expanded(
                child: ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  itemCount: _comments.length,
                  itemBuilder: (context, index) {
                    final comment = _comments[index];
                    return _buildCommentTile(comment);
                  },
                ),
              ),

              // ── Bottom Composer ────────────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: _kBorder, width: 0.8)),
                ),
                child: Row(
                  children: [
                    // User Avatar
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: _kPurpleCard,
                      backgroundImage: hasPhoto ? FileImage(File(photoPath)) : null,
                      child: hasPhoto
                          ? null
                          : Text(
                              initials,
                              style: const TextStyle(
                                color: _kPurple,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                    ),
                    const SizedBox(width: 10),

                    // Input Field
                    Expanded(
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F0FF),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _commentCtrl,
                                textInputAction: TextInputAction.send,
                                onSubmitted: (_) => _addComment(),
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  color: _kTextDark,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Add a comment...',
                                  hintStyle: TextStyle(
                                    fontSize: 13.5,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _addComment,
                              child: const Icon(
                                Icons.send_rounded,
                                color: _kPurple,
                                size: 20,
                              ),
                            ),
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
      ),
    );
  }

  // ── Single Comment Tile Builder ──────────────────────────────────────────

  Widget _buildCommentTile(CommentData comment) {
    return Padding(
      padding: EdgeInsets.only(
        left: comment.isReply ? 38.0 : 0.0,
        bottom: 16.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: comment.isReply ? 15 : 18,
            backgroundColor: comment.avatarBg.withValues(alpha: 0.15),
            child: Text(
              comment.authorName.substring(0, 1).toUpperCase(),
              style: TextStyle(
                color: comment.avatarBg,
                fontSize: comment.isReply ? 12 : 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Comment content box & action links
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Soft purple bubble box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _kPurpleCard,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.authorName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: _kTextDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        comment.authorSub,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: _kTextMid,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        comment.body,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF374151),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),

                // Footer row (Time · Like · Reply)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: [
                      Text(
                        comment.timeAgo,
                        style: const TextStyle(
                          fontSize: 12,
                          color: _kTextMid,
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () => _toggleLike(comment),
                        child: Text(
                          comment.likes > 0
                              ? 'Like (${comment.likes})'
                              : 'Like',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: comment.isLiked ? _kPurple : _kTextMid,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          _commentCtrl.text = '@${comment.authorName} ';
                          _commentCtrl.selection = TextSelection.fromPosition(
                            TextPosition(offset: _commentCtrl.text.length),
                          );
                        },
                        child: const Text(
                          'Reply',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _kTextMid,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
