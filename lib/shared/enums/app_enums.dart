import 'package:flutter/material.dart';

extension UserRoleIcons on UserRole {
  IconData get icon {
    switch (this) {
      case UserRole.student:
        return Icons.school_rounded;
      case UserRole.professional:
        return Icons.work_rounded;
      case UserRole.founder:
        return Icons.rocket_launch_rounded;
      case UserRole.company:
        return Icons.business_rounded;
      case UserRole.investor:
        return Icons.trending_up_rounded;
      case UserRole.creator:
        return Icons.palette_rounded;
      case UserRole.mentor:
        return Icons.psychology_rounded;
      case UserRole.influencer:
        return Icons.campaign_rounded;
      case UserRole.serviceProvider:
        return Icons.build_rounded;
      case UserRole.learner:
        return Icons.auto_stories_rounded;
      case UserRole.other:
        return Icons.dynamic_feed_rounded;
    }
  }

  Color get color {
    switch (this) {
      case UserRole.student:
        return const Color(0xFF3B82F6);
      case UserRole.professional:
        return const Color(0xFF6366F1);
      case UserRole.founder:
        return const Color(0xFFF59E0B);
      case UserRole.company:
        return const Color(0xFF8B5CF6);
      case UserRole.investor:
        return const Color(0xFF10B981);
      case UserRole.creator:
        return const Color(0xFFEC4899);
      case UserRole.mentor:
        return const Color(0xFF14B8A6);
      case UserRole.influencer:
        return const Color(0xFFF43F5E);
      case UserRole.serviceProvider:
        return const Color(0xFF0EA5E9);
      case UserRole.learner:
        return const Color(0xFF8B5CF6);
      case UserRole.other:
        return const Color(0xFF4338CA);
    }
  }
}

enum UserRole {
  student('Career', 'Learning and building skills'),
  professional('Career', 'Working professional or employee'),
  founder('Startup', 'Building my own startup'),
  company('Startup', 'Managing a company'),
  investor('Investor', 'Investing in opportunities'),
  creator('Community', 'Creating content and value'),
  mentor('Mentor', 'Guiding and mentoring others'),
  influencer('Community', 'Inspiring and influencing people'),
  serviceProvider('Event', 'Offering professional services'),
  learner('Learn', 'Upskilling and continuous learning'),
  other('Feed', 'Explore community feed & updates');

  const UserRole(this.label, this.description);

  final String label;
  final String description;

  bool get isStartupRole => this == UserRole.founder || this == UserRole.company;

  String get dashboardTitle {
    switch (this) {
      case UserRole.founder:
      case UserRole.company:
        return 'Startup Info';
      case UserRole.investor:
        return 'Investor Hub';
      case UserRole.student:
      case UserRole.professional:
        return 'Career Hub';
      case UserRole.mentor:
        return 'Mentor Hub';
      case UserRole.creator:
      case UserRole.influencer:
        return 'Community Hub';
      case UserRole.serviceProvider:
        return 'Event Hub';
      case UserRole.learner:
        return 'Learn Hub';
      case UserRole.other:
        return 'Collabster';
    }
  }

  String get iconKey => name;

  static UserRole fromString(String? value) {
    if (value == null) return UserRole.professional;
    return UserRole.values.firstWhere(
      (role) => role.name == value || role.label == value,
      orElse: () => UserRole.professional,
    );
  }
}
