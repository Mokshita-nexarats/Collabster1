class ConnectionRequest {
  final String name;
  final String role;
  final String initials;
  final String category;
  final String note;
  final String time;
  final int mutualConnections;

  const ConnectionRequest({
    required this.name,
    required this.role,
    required this.initials,
    this.category = 'Investor',
    this.note = 'Would love to connect and discuss potential synergies with your startup!',
    this.time = '2h ago',
    this.mutualConnections = 5,
  });
}

class ActivityItem {
  final String iconKey;
  final String title;
  final String subtitle;
  final String colorKey;
  const ActivityItem({required this.iconKey, required this.title, required this.subtitle, required this.colorKey});
}

class FundraisingInvestor {
  final String name;
  final String fund;
  final String amount;
  final String meetingIn;
  final String initials;
  final String colorKey;
  final String? leadPartner;
  final String? email;
  final String? notes;

  const FundraisingInvestor({
    required this.name,
    required this.fund,
    required this.amount,
    required this.meetingIn,
    required this.initials,
    required this.colorKey,
    this.leadPartner,
    this.email,
    this.notes,
  });

  FundraisingInvestor copyWith({
    String? name,
    String? fund,
    String? amount,
    String? meetingIn,
    String? initials,
    String? colorKey,
    String? leadPartner,
    String? email,
    String? notes,
  }) {
    return FundraisingInvestor(
      name: name ?? this.name,
      fund: fund ?? this.fund,
      amount: amount ?? this.amount,
      meetingIn: meetingIn ?? this.meetingIn,
      initials: initials ?? this.initials,
      colorKey: colorKey ?? this.colorKey,
      leadPartner: leadPartner ?? this.leadPartner,
      email: email ?? this.email,
      notes: notes ?? this.notes,
    );
  }
}

class FundraisingDocument {
  final String name;
  final String size;
  final String dateAdded;

  const FundraisingDocument({
    required this.name,
    required this.size,
    required this.dateAdded,
  });
}

class FundraisingTask {
  final String title;
  final String subtitle;
  final String iconKey;
  final bool isUrgent;

  const FundraisingTask({
    required this.title,
    required this.subtitle,
    required this.iconKey,
    required this.isUrgent,
  });
}

class OpenRole {
  final String title;
  final String department;
  final int applicants;
  final int shortlisted;
  final String status;
  final String statusColorKey;
  final String? salaryLpa;
  final String? skills;
  final String? location;
  final String? experience;
  final String roleType; // 'job' | 'internship'

  const OpenRole({
    required this.title,
    required this.department,
    required this.applicants,
    required this.shortlisted,
    required this.status,
    required this.statusColorKey,
    this.salaryLpa,
    this.skills,
    this.location,
    this.experience,
    this.roleType = 'job',
  });
}

class InvestorEntry {
  final String name;
  final String fund;
  final String amount;
  final String status;
  final String statusColorKey;
  final String initials;
  final String colorKey;
  final int contacted;
  final int replied;
  const InvestorEntry({required this.name, required this.fund, required this.amount, required this.status, required this.statusColorKey, required this.initials, required this.colorKey, required this.contacted, required this.replied});
}

class SuggestedStartup {
  final String name;
  final String industry;
  final String location;
  final int teamMembers;
  final String stage;
  final List<String> tags;
  final String tagline;
  final String description;
  final String problem;
  final String solution;
  final String mission;
  final String vision;
  final String website;
  final String founderName;
  final String incorporationDate;
  final String invitationCode;
  final String emailDomain;
  const SuggestedStartup({
    required this.name,
    required this.industry,
    required this.location,
    required this.teamMembers,
    required this.stage,
    required this.tags,
    this.tagline = '',
    this.description = '',
    this.problem = '',
    this.solution = '',
    this.mission = '',
    this.vision = '',
    this.website = '',
    this.founderName = '',
    this.incorporationDate = '',
    this.invitationCode = '',
    this.emailDomain = '',
  });
}

class TeamMember {
  final String name;
  final String role;
  final String department;
  final String badge;
  final String badgeColorKey;
  final String initials;
  final String? email;
  final bool isFollowing;

  const TeamMember({
    required this.name,
    required this.role,
    required this.department,
    required this.badge,
    required this.badgeColorKey,
    required this.initials,
    this.email,
    this.isFollowing = false,
  });

  TeamMember copyWith({
    String? name,
    String? role,
    String? department,
    String? badge,
    String? badgeColorKey,
    String? initials,
    String? email,
    bool? isFollowing,
  }) {
    return TeamMember(
      name: name ?? this.name,
      role: role ?? this.role,
      department: department ?? this.department,
      badge: badge ?? this.badge,
      badgeColorKey: badgeColorKey ?? this.badgeColorKey,
      initials: initials ?? this.initials,
      email: email ?? this.email,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}

class StartupProduct {
  final String name;
  final String description;
  final String status;
  final String statusColorKey;
  final String version;
  final double rating;
  final int saves;
  final int downloads;
  final String tagColorKey;
  const StartupProduct({required this.name, required this.description, required this.status, required this.statusColorKey, required this.version, required this.rating, required this.saves, required this.downloads, required this.tagColorKey});
}

class DocumentItem {
  final String name;
  final String type;
  final String size;
  final String category;
  final String colorKey;
  final String? dateAdded;
  final String? description;
  final bool isPinned;

  const DocumentItem({
    required this.name,
    required this.type,
    required this.size,
    required this.category,
    required this.colorKey,
    this.dateAdded,
    this.description,
    this.isPinned = false,
  });

  DocumentItem copyWith({
    String? name,
    String? type,
    String? size,
    String? category,
    String? colorKey,
    String? dateAdded,
    String? description,
    bool? isPinned,
  }) {
    return DocumentItem(
      name: name ?? this.name,
      type: type ?? this.type,
      size: size ?? this.size,
      category: category ?? this.category,
      colorKey: colorKey ?? this.colorKey,
      dateAdded: dateAdded ?? this.dateAdded,
      description: description ?? this.description,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}

class DocumentCollection {
  final String name;
  final int count;
  final String colorKey;
  final String? description;
  final List<DocumentItem>? items;

  const DocumentCollection({
    required this.name,
    required this.count,
    required this.colorKey,
    this.description,
    this.items,
  });
}

class Milestone {
  final String title;
  final String date;
  final bool completed;
  final bool active;
  final String? category;
  final String? description;
  final String? targetDate;

  const Milestone({
    required this.title,
    required this.date,
    required this.completed,
    required this.active,
    this.category,
    this.description,
    this.targetDate,
  });

  Milestone copyWith({
    String? title,
    String? date,
    bool? completed,
    bool? active,
    String? category,
    String? description,
    String? targetDate,
  }) {
    return Milestone(
      title: title ?? this.title,
      date: date ?? this.date,
      completed: completed ?? this.completed,
      active: active ?? this.active,
      category: category ?? this.category,
      description: description ?? this.description,
      targetDate: targetDate ?? this.targetDate,
    );
  }
}

class StartupMember {
  final String name;
  final String role;
  final String status;
  final String initials;
  const StartupMember({required this.name, required this.role, required this.status, required this.initials});
}

class SocialLink {
  final String platform;
  final String url;
  const SocialLink({required this.platform, required this.url});

  SocialLink copyWith({String? platform, String? url}) {
    return SocialLink(
      platform: platform ?? this.platform,
      url: url ?? this.url,
    );
  }
}

class StartupPost {
  final String id;
  final String type;
  final String title;
  final String description;
  final DateTime createdAt;
  final String? imageUrl;
  final List<String> tags;

  const StartupPost({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.createdAt,
    this.imageUrl,
    this.tags = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'title': title,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
        'imageUrl': imageUrl,
        'tags': tags,
      };

  factory StartupPost.fromJson(Map<String, dynamic> json) => StartupPost(
        id: json['id'] as String,
        type: json['type'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        imageUrl: json['imageUrl'] as String?,
        tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? const [],
      );
}
