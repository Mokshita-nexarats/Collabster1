import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../comments_sheet.dart';
import '../share_sheet.dart';
import 'home_feed_item.dart';
import 'user_posts_viewmodel.dart';
import 'widgets/post_card.dart';

/// My Posts — everything the current user published from the feed composer.
/// Reads the shared user-posts store, so it survives navigation.
class MyPostsScreen extends ConsumerWidget {
  const MyPostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(userPostsViewModelProvider);
    final crud = ref.read(userPostsViewModelProvider.notifier);

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
        title: const Text(
          'My Posts',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111827),
          ),
        ),
      ),
      body: posts.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'You have not posted anything yet.\nTap + below to share your first update.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: posts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final post = posts[i];
                return PostCard(
                  post: post,
                  onLike: () => crud.update(post.copyWith(
                    likes: post.likedByMe
                        ? post.likes - 1
                        : post.likes + 1,
                    likedByMe: !post.likedByMe,
                  )),
                  onComment: () => CommentsSheet.show(
                    context,
                    commentCount: post.comments,
                  ),
                  onShare: () => ShareSheet.show(context),
                  onBookmark: () => crud.update(
                      post.copyWith(bookmarked: !post.bookmarked)),
                  onMenu: () => _confirmDelete(context, crud, post),
                  onPollVote: (o) {
                    if (post.votedIndex != null) return;
                    final votes = List<int>.from(post.pollVotes);
                    while (votes.length < post.pollOptions.length) {
                      votes.add(0);
                    }
                    votes[o] = votes[o] + 1;
                    crud.update(post.copyWith(
                        pollVotes: votes, votedIndex: o));
                  },
                );
              },
            ),
    );
  }

  void _confirmDelete(
      BuildContext context, UserPostsViewModel crud, HomeFeedPost post) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded,
                    color: Color(0xFFDC2626)),
                title: const Text('Delete post'),
                onTap: () {
                  crud.remove(post.id);
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.close_rounded,
                    color: Color(0xFF6B7280)),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
