import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import '../../model/community_model.dart';
import 'community_detail_screen.dart';

class RecommendedCommunitiesScreen extends ConsumerWidget {
  const RecommendedCommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommended = ref
        .watch(communityViewModelProvider)
        .recommendedCommunities;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Recommended for you',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFF229ED9),
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  '${recommended.length}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF229ED9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: recommended.isEmpty
          ? _buildEmptyState(context)
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: recommended.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _RecommendedCard(community: recommended[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: const Color(0xFF229ED9).withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 42,
              color: Color(0xFF229ED9),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No recommendations yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll recommend communities\nbased on your interests.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendedCard extends ConsumerWidget {
  final RecommendedCommunityItem community;

  const _RecommendedCard({required this.community});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CommunityDetailScreen(
              title: community.title,
              memberCount: community.memberCount,
              tag: community.tag,
              icon: community.icon,
              gradientColors: const [Color(0xFF2563EB), Color(0xFF3B82F6)],
              communityId: community.id,
              isJoined: community.isJoined,
              onToggleJoin: () => ref
                  .read(communityViewModelProvider.notifier)
                  .toggleJoinRecommended(community.id),
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: community.iconBgColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      community.icon,
                      color: community.iconColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          community.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${community.memberCount} • ${community.tag}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => ref
                        .read(communityViewModelProvider.notifier)
                        .toggleJoinRecommended(community.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: community.isJoined
                            ? const Color(0xFF229ED9)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF229ED9),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        community.isJoined ? 'Joined' : 'Join',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: community.isJoined
                              ? Colors.white
                              : const Color(0xFF229ED9),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
