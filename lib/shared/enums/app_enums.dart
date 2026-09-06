import 'package:flutter/material.dart';

extension UserRoleIcons on UserRole {
  IconData get icon {
    switch (this) {
      case UserRole.founder:
        return Icons.rocket_launch_rounded;
      case UserRole.company:
        return Icons.business_rounded;
      case UserRole.investor:
        return Icons.trending_up_rounded;
      case UserRole.creator:
        return Icons.palette_rounded;
      case UserRole.influencer:
        return Icons.campaign_rounded;
      case UserRole.other:
        return Icons.dynamic_feed_rounded;
    }
  }

  Color get color {
    switch (this) {
      case UserRole.founder:
        return const Color(0xFFF59E0B);
      case UserRole.company:
        return const Color(0xFF8B5CF6);
      case UserRole.investor:
        return const Color(0xFF10B981);
      case UserRole.creator:
        return const Color(0xFFEC4899);
      case UserRole.influencer:
        return const Color(0xFFF43F5E);
      case UserRole.other:
        return const Color(0xFF4338CA);
    }
  }
}

enum UserRole {
  founder('Startup', 'Building my own startup'),
  company('Startup', 'Managing a company'),
  investor('Investor', 'Investing in opportunities'),
  creator('Community', 'Creating content and value'),
  influencer('Community', 'Inspiring and influencing people'),
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
      case UserRole.creator:
      case UserRole.influencer:
        return 'Community Hub';
      case UserRole.other:
        return 'Collabster';
    }
  }

  String get iconKey => name;

  static UserRole fromString(String? value) {
    if (value == null) return UserRole.other;
    return UserRole.values.firstWhere(
      (role) => role.name == value || role.label == value,
      orElse: () => UserRole.other,
    );
  }
}
