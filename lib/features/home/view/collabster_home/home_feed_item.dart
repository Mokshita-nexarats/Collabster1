/// Unified feed item for the new Collabster Home.
///
/// Backend contract (to agree with backend team):
/// Every item must carry [roleTag] (`startup` | `community` | `investor`),
/// [isDiscovery] (true for the ~20% out-of-role slot) and [sourceRole].
/// Frontend only renders the order backend sends. Until backend is ready,
/// [mixFeed] does a local 80/20 interleave: 8 active-role + 2 others.
enum HomeRole { startup, community, investor }

class HomeFeedPost {
  final String id;
  final HomeRole roleTag;
  final String authorName;
  final String authorSub;
  final String initials;
  final String timeAgo;
  final String title;
  final String body;
  final bool hasImage;
  final int likes;
  final int comments;
  final bool likedByMe;
  final bool bookmarked;
  final bool isDiscovery;
  final String? discoveryLabel;
  final bool followed;
  // Poll (LinkedIn-style): options + votes, [votedIndex] set after voting.
  final List<String> pollOptions;
  final List<int> pollVotes;
  final int? votedIndex;

  const HomeFeedPost({
    required this.id,
    required this.roleTag,
    required this.authorName,
    required this.authorSub,
    required this.initials,
    required this.timeAgo,
    required this.title,
    required this.body,
    this.hasImage = false,
    this.likes = 0,
    this.comments = 0,
    this.likedByMe = false,
    this.bookmarked = false,
    this.isDiscovery = false,
    this.discoveryLabel,
    this.followed = false,
    this.pollOptions = const [],
    this.pollVotes = const [],
    this.votedIndex,
  });

  bool get isPoll => pollOptions.isNotEmpty;

  HomeFeedPost copyWith({
    int? likes,
    int? comments,
    bool? likedByMe,
    bool? bookmarked,
    bool? followed,
    List<int>? pollVotes,
    int? votedIndex,
  }) {
    return HomeFeedPost(
      id: id,
      roleTag: roleTag,
      authorName: authorName,
      authorSub: authorSub,
      initials: initials,
      timeAgo: timeAgo,
      title: title,
      body: body,
      hasImage: hasImage,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      likedByMe: likedByMe ?? this.likedByMe,
      bookmarked: bookmarked ?? this.bookmarked,
      isDiscovery: isDiscovery,
      discoveryLabel: discoveryLabel,
      followed: followed ?? this.followed,
      pollOptions: pollOptions,
      pollVotes: pollVotes ?? this.pollVotes,
      votedIndex: votedIndex ?? this.votedIndex,
    );
  }
}

class HomeJob {
  final String id;
  final HomeRole roleTag;
  final String title;
  final String company;
  final String location;
  final String type;

  const HomeJob({
    required this.id,
    required this.roleTag,
    required this.title,
    required this.company,
    required this.location,
    required this.type,
  });
}

/// Local mock source. Replace with `GET /feed?activeRole=` later.
/// Backend must return the list already mixed 80/20 with `isDiscovery`.
List<HomeFeedPost> buildMockPosts(HomeRole activeRole) {
  final own = <HomeFeedPost>[
    const HomeFeedPost(
      id: 's1',
      roleTag: HomeRole.startup,
      authorName: 'Alpha Tech Team',
      authorSub: 'Product Development',
      initials: 'A',
      timeAgo: '2h',
      title: 'Project Alpha: Beta Launch Today!',
      body:
          'Beta is live after 6 months of work. Looking for early adopters to try it and share feedback.',
      hasImage: true,
      likes: 248,
      comments: 42,
      followed: true,
    ),
    const HomeFeedPost(
      id: 's2',
      roleTag: HomeRole.startup,
      authorName: 'Rahul Sharma',
      authorSub: 'Startup Founder',
      initials: 'R',
      timeAgo: '8h',
      title: 'We just crossed 10,000 users!',
      body:
          'Six months ago we launched with zero users. Today we hit 10K. Thank you for believing in us.',
      likes: 1204,
      comments: 89,
      followed: true,
    ),
    const HomeFeedPost(
      id: 's3',
      roleTag: HomeRole.startup,
      authorName: 'FinTech Lab',
      authorSub: 'Community Page',
      initials: 'F',
      timeAgo: '12h',
      title: 'Seed Funding Round Closed!',
      body:
          'Closed our \$2.4M seed round. Hiring engineers to scale our AI credit scoring model.',
      hasImage: true,
      likes: 563,
      comments: 74,
    ),
    const HomeFeedPost(
      id: 's4',
      roleTag: HomeRole.startup,
      authorName: 'DesignBridge',
      authorSub: 'Hiring • Product',
      initials: 'D',
      timeAgo: '1d',
      title: 'Hiring a founding designer',
      body:
          'Looking for a product designer who loves fast iterations and talking to users weekly.',
      likes: 187,
      comments: 31,
    ),
  ];

  final others = <HomeFeedPost>[
    const HomeFeedPost(
      id: 'c1',
      roleTag: HomeRole.community,
      authorName: 'Emma Williams',
      authorSub: 'Marketing Strategist',
      initials: 'E',
      timeAgo: '5h',
      title: '',
      body:
          'Joined DesignBridge as Head of Marketing! Excited to build community-led campaigns.',
      likes: 892,
      comments: 156,
      isDiscovery: true,
      discoveryLabel: 'Suggested from Community',
    ),
    const HomeFeedPost(
      id: 'i1',
      roleTag: HomeRole.investor,
      authorName: 'GreenPeak Capital',
      authorSub: 'Seed • Fintech • SaaS',
      initials: 'G',
      timeAgo: '6h',
      title: 'Office hours next Friday',
      body:
          'Opening 5 slots for pre-seed fintech teams. Share your deck and one metric you are proud of.',
      likes: 421,
      comments: 58,
      isDiscovery: true,
      discoveryLabel: 'Suggested from Investors',
    ),
  ];

  // For community/investor active roles the same mixer applies; keep it
  // simple: active-role posts first, discovery interleaved by caller.
  if (activeRole == HomeRole.startup) return [...own, ...others];
  return [...own, ...others];
}

/// Frontend-only 80/20 mixer (temporary until backend mixes).
/// Returns feed order: 4 own + 1 discovery, repeating.
List<HomeFeedPost> mixFeed(List<HomeFeedPost> all) {
  final own = all.where((p) => !p.isDiscovery).toList();
  final discovery = all.where((p) => p.isDiscovery).toList();
  if (discovery.isEmpty) return own;
  final out = <HomeFeedPost>[];
  var d = 0;
  for (var i = 0; i < own.length; i++) {
    out.add(own[i]);
    if ((i + 1) % 4 == 0 && d < discovery.length) {
      out.add(discovery[d++]);
    }
  }
  while (d < discovery.length) {
    out.add(discovery[d++]);
  }
  return out;
}

List<HomeJob> buildMockJobs() {
  return const [
    HomeJob(
      id: 'j1',
      roleTag: HomeRole.startup,
      title: 'Flutter Developer',
      company: 'Alpha Tech',
      location: 'Remote',
      type: 'Full-time',
    ),
    HomeJob(
      id: 'j2',
      roleTag: HomeRole.startup,
      title: 'Growth Marketer',
      company: 'FinTech Lab',
      location: 'Bengaluru',
      type: 'Full-time',
    ),
    HomeJob(
      id: 'j3',
      roleTag: HomeRole.startup,
      title: 'Product Intern',
      company: 'DesignBridge',
      location: 'Hybrid',
      type: 'Internship',
    ),
  ];
}
