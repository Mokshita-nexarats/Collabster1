import 'package:flutter/material.dart';

enum ActivityType {
  postCreated,
  postLiked,
  commentAdded,
  memberJoined,
  eventCreated,
  communityCreated,
  communityJoined,
  replyAdded,
  roomCreated,
  messageSent,
}

class ActivityItem {
  final String id;
  final ActivityType type;
  final String title;
  final String subtitle;
  final DateTime timestamp;

  const ActivityItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.timestamp,
  });

  IconData get icon {
    switch (type) {
      case ActivityType.postCreated:
      case ActivityType.commentAdded:
        return Icons.article_outlined;
      case ActivityType.postLiked:
        return Icons.thumb_up_outlined;
      case ActivityType.memberJoined:
      case ActivityType.communityJoined:
        return Icons.person_add_outlined;
      case ActivityType.eventCreated:
        return Icons.event_outlined;
      case ActivityType.communityCreated:
        return Icons.people_outline_rounded;
      case ActivityType.replyAdded:
        return Icons.chat_bubble_outline_rounded;
      case ActivityType.roomCreated:
        return Icons.forum_outlined;
      case ActivityType.messageSent:
        return Icons.send_rounded;
    }
  }

  Color get color {
    switch (type) {
      case ActivityType.postCreated:
      case ActivityType.eventCreated:
        return const Color(0xFF2563EB);
      case ActivityType.postLiked:
        return const Color(0xFF229ED9);
      case ActivityType.memberJoined:
      case ActivityType.communityJoined:
        return const Color(0xFF059669);
      case ActivityType.commentAdded:
      case ActivityType.replyAdded:
        return const Color(0xFF7C3AED);
      case ActivityType.communityCreated:
        return const Color(0xFF0D9488);
      case ActivityType.roomCreated:
        return const Color(0xFF7C3AED);
      case ActivityType.messageSent:
        return const Color(0xFF2563EB);
    }
  }

  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${diff.inDays ~/ 7}w ago';
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}
