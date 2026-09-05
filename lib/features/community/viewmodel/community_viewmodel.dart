import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/community_model.dart';
import 'community_state.dart';

class CommunityViewModel extends StateNotifier<CommunityState> {
  CommunityViewModel() : super(const CommunityState());

  void loadInitialData() {
    if (state.myCommunities.isNotEmpty) return;
    state = state.copyWith(
      categories: const [
        CommunityCategory(
          id: 'all',
          label: 'All',
          icon: Icons.grid_view_rounded,
        ),
        CommunityCategory(id: 'tech', label: 'Tech', icon: Icons.code_rounded),
        CommunityCategory(
          id: 'startup',
          label: 'Startup',
          icon: Icons.rocket_launch_outlined,
        ),
        CommunityCategory(
          id: 'design',
          label: 'Design',
          icon: Icons.edit_outlined,
        ),
        CommunityCategory(
          id: 'ai_ml',
          label: 'AI / ML',
          icon: Icons.psychology_outlined,
        ),
      ],
      whatsHappening: const [
        WhatsHappeningItem(
          id: 'wh_1',
          title: 'Flutter Developers',
          subtitle: '12 new discussions • 36 new replies',
          icon: Icons.chat_bubble_rounded,
          iconColor: Color(0xFF229ED9),
          iconBgColor: Color(0xFFE8F4FB),
        ),
        WhatsHappeningItem(
          id: 'wh_2',
          title: 'Startup Founders',
          subtitle: '5 new discussions • 2 upcoming events',
          icon: Icons.calendar_today_rounded,
          iconColor: Color(0xFF229ED9),
          iconBgColor: Color(0xFFE8F4FB),
        ),
        WhatsHappeningItem(
          id: 'wh_3',
          title: 'UI/UX Designers',
          subtitle: '8 new posts • 14 new replies',
          icon: Icons.palette_outlined,
          iconColor: Color(0xFF0284C7),
          iconBgColor: Color(0xFFE0F2FE),
        ),
      ],
      myCommunities: [
        MyCommunityItem(
          id: 'mc_1',
          title: 'Flutter Developers',
          memberCount: '2.4K Members',
          activeTodayCount: '86 active today',
          avatarUrls: const [],
          overflowCount: 32,
          gradientColors: const [Color(0xFF229ED9), Color(0xFF0088CC)],
          logoIcon: Icons.widgets_rounded,
          categoryId: 'tech',
        ),
        MyCommunityItem(
          id: 'mc_2',
          title: 'Startup Founders',
          memberCount: '1.8K Members',
          activeTodayCount: '42 active today',
          avatarUrls: const [],
          overflowCount: 18,
          gradientColors: const [Color(0xFF0088CC), Color(0xFF229ED9)],
          logoIcon: Icons.rocket_launch_rounded,
          categoryId: 'startup',
        ),
      ],
      recommendedCommunities: [
        RecommendedCommunityItem(
          id: 'rc_1',
          title: 'AI Engineers',
          memberCount: '3.8K Members',
          tag: 'AI / ML',
          categoryId: 'ai_ml',
          icon: Icons.psychology_rounded,
          iconBgColor: Color(0xFF1E293B),
          iconColor: Colors.white,
        ),
        RecommendedCommunityItem(
          id: 'rc_2',
          title: 'Product Managers',
          memberCount: '2.6K Members',
          tag: 'Product',
          categoryId: 'startup',
          icon: Icons.work_rounded,
          iconBgColor: Color(0xFF0D9488),
          iconColor: Colors.white,
        ),
        RecommendedCommunityItem(
          id: 'rc_3',
          title: 'Growth Hackers',
          memberCount: '1.9K Members',
          tag: 'Marketing',
          categoryId: 'startup',
          icon: Icons.trending_up_rounded,
          iconBgColor: Color(0xFF229ED9),
          iconColor: Colors.white,
        ),
      ],
      rooms: [
        CommunityRoom(
          id: 'room_1',
          communityId: 'mc_1',
          communityTitle: 'Flutter Developers',
          name: 'General',
          memberCount: '2.1K members',
          isJoined: true,
        ),
        CommunityRoom(
          id: 'room_2',
          communityId: 'mc_1',
          communityTitle: 'Flutter Developers',
          name: 'Showcase & Wins',
          memberCount: '864 members',
        ),
        CommunityRoom(
          id: 'room_3',
          communityId: 'mc_2',
          communityTitle: 'Startup Founders',
          name: 'Founder Advice',
          memberCount: '1.2K members',
        ),
        CommunityRoom(
          id: 'room_4',
          communityId: 'mc_2',
          communityTitle: 'Startup Founders',
          name: 'Investor Talks',
          memberCount: '648 members',
        ),
      ],
      unreadCount: 2,
    );
  }

  void selectCategory(String categoryId) {
    state = state.copyWith(selectedCategoryId: categoryId);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void toggleJoinMyCommunity(String id) {
    final updated = state.myCommunities.map((c) {
      if (c.id == id) {
        c.isJoined = !c.isJoined;
      }
      return c;
    }).toList();
    state = state.copyWith(myCommunities: updated);
  }

  void toggleJoinRecommended(String id) {
    final updated = state.recommendedCommunities.map((c) {
      if (c.id == id) {
        c.isJoined = !c.isJoined;
      }
      return c;
    }).toList();
    state = state.copyWith(recommendedCommunities: updated);
  }

  void addCommunity(MyCommunityItem community) {
    state = state.copyWith(myCommunities: [community, ...state.myCommunities]);
  }

  void addRoom(CommunityRoom room) {
    state = state.copyWith(rooms: [...state.rooms, room]);
  }

  void toggleJoinRoom(String id) {
    final updated = state.rooms.map((room) {
      if (room.id == id) {
        room.isJoined = !room.isJoined;
      }
      return room;
    }).toList();
    state = state.copyWith(rooms: updated);
  }

  void markCommunitiesAsRead() {
    state = state.copyWith(unreadCount: 0);
  }
}
