import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../model/activity_model.dart';
import '../../model/post_model.dart';
import '../screens/communities_list_screen.dart';
import '../screens/post_detail_screen.dart';
import '../screens/posts_list_screen.dart';
import '../screens/rooms_list_screen.dart';

/// Opens the most relevant screen for a tapped activity item.
void openActivityItem(
  BuildContext context,
  WidgetRef ref,
  ActivityItem item, {
  VoidCallback? onOpenMessages,
}) {
  switch (item.type) {
    case ActivityType.postCreated:
    case ActivityType.postLiked:
    case ActivityType.commentAdded:
    case ActivityType.replyAdded:
      _openRelatedPost(context, ref, item);
      break;
    case ActivityType.eventCreated:
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const RoomsListScreen()));
      break;
    case ActivityType.roomCreated:
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const RoomsListScreen()));
      break;
    case ActivityType.communityCreated:
    case ActivityType.communityJoined:
    case ActivityType.memberJoined:
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const CommunitiesListScreen()));
      break;
    case ActivityType.messageSent:
      if (onOpenMessages != null) {
        onOpenMessages();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Open the Messages tab to view your chats'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      break;
  }
}

void _openRelatedPost(BuildContext context, WidgetRef ref, ActivityItem item) {
  final posts = ref.read(postViewModelProvider).posts;

  CareerPost? match;
  for (final post in posts) {
    if (item.subtitle == post.title ||
        item.subtitle.contains(post.title) ||
        post.title.contains(item.subtitle)) {
      match = post;
      break;
    }
  }

  if (match != null) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => PostDetailScreen(post: match!)));
  } else {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PostsListScreen()));
  }
}
