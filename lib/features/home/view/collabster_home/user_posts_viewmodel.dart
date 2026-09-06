import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_feed_item.dart';

/// In-memory store for posts created from the universal feed composer.
/// Frontend-only until backend POST /feed exists. My Posts screen reads this.
class UserPostsViewModel extends StateNotifier<List<HomeFeedPost>> {
  UserPostsViewModel() : super(const []);

  void add(HomeFeedPost post) {
    state = [post, ...state];
  }

  void update(HomeFeedPost post) {
    state = [
      for (final p in state) if (p.id == post.id) post else p,
    ];
  }

  void remove(String id) {
    state = state.where((p) => p.id != id).toList();
  }
}
