import 'bridge_models.dart';

/// Aggregated cross-mode data surfaced by the Connection Bridge
/// (Startup / Community / Investor / Feed).
class BridgeState {
  const BridgeState({
    this.opportunities = const [],
    this.posts = const [],
    this.events = const [],
    this.investors = const [],
    this.fundingRounds = const [],
    this.notifications = const [],
    this.isLoaded = false,
  });

  final List<BridgeOpportunity> opportunities;
  final List<BridgePost> posts;
  final List<BridgeEvent> events;
  final List<BridgeInvestor> investors;
  final List<BridgeFundingRound> fundingRounds;
  final List<BridgeNotification> notifications;
  final bool isLoaded;

  int get startupCount => opportunities.where((o) => o.fromStartup).length;
  int get communityCount => posts.where((p) => p.source == 'community').length;
  int get unreadNotifications => notifications.where((n) => !n.isRead).length;

  BridgeState copyWith({
    List<BridgeOpportunity>? opportunities,
    List<BridgePost>? posts,
    List<BridgeEvent>? events,
    List<BridgeInvestor>? investors,
    List<BridgeFundingRound>? fundingRounds,
    List<BridgeNotification>? notifications,
    bool? isLoaded,
  }) {
    return BridgeState(
      opportunities: opportunities ?? this.opportunities,
      posts: posts ?? this.posts,
      events: events ?? this.events,
      investors: investors ?? this.investors,
      fundingRounds: fundingRounds ?? this.fundingRounds,
      notifications: notifications ?? this.notifications,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}
