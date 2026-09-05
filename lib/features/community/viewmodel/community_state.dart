import '../model/community_model.dart';

class CommunityState {
  const CommunityState({
    this.categories = const [],
    this.whatsHappening = const [],
    this.myCommunities = const [],
    this.recommendedCommunities = const [],
    this.rooms = const [],
    this.selectedCategoryId = 'all',
    this.searchQuery = '',
    this.unreadCount = 2,
  });

  final List<CommunityCategory> categories;
  final List<WhatsHappeningItem> whatsHappening;
  final List<MyCommunityItem> myCommunities;
  final List<RecommendedCommunityItem> recommendedCommunities;
  final List<CommunityRoom> rooms;
  final String selectedCategoryId;
  final String searchQuery;
  final int unreadCount;

  List<MyCommunityItem> get filteredMyCommunities {
    var list = myCommunities;
    if (selectedCategoryId != 'all') {
      list = list.where((c) => c.categoryId == selectedCategoryId).toList();
    }
    final q = searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where((c) =>
              c.title.toLowerCase().contains(q) ||
              c.memberCount.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  List<RecommendedCommunityItem> get filteredRecommended {
    var list = recommendedCommunities;
    if (selectedCategoryId != 'all') {
      list = list.where((c) => c.categoryId == selectedCategoryId).toList();
    }
    final q = searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where((c) =>
              c.title.toLowerCase().contains(q) ||
              c.memberCount.toLowerCase().contains(q) ||
              c.tag.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  List<WhatsHappeningItem> get filteredWhatsHappening {
    final q = searchQuery.trim().toLowerCase();
    if (q.isEmpty) return whatsHappening;
    return whatsHappening
        .where((w) =>
            w.title.toLowerCase().contains(q) ||
            w.subtitle.toLowerCase().contains(q))
        .toList();
  }

  CommunityState copyWith({
    List<CommunityCategory>? categories,
    List<WhatsHappeningItem>? whatsHappening,
    List<MyCommunityItem>? myCommunities,
    List<RecommendedCommunityItem>? recommendedCommunities,
    List<CommunityRoom>? rooms,
    String? selectedCategoryId,
    String? searchQuery,
    int? unreadCount,
  }) {
    return CommunityState(
      categories: categories ?? this.categories,
      whatsHappening: whatsHappening ?? this.whatsHappening,
      myCommunities: myCommunities ?? this.myCommunities,
      recommendedCommunities:
          recommendedCommunities ?? this.recommendedCommunities,
      rooms: rooms ?? this.rooms,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchQuery: searchQuery ?? this.searchQuery,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
