import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../comments_sheet.dart';
import '../share_sheet.dart';
import '../activity_screen.dart';
import 'home_feed_item.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/feed_tabs.dart';
import 'widgets/post_card.dart';
import 'widgets/discovery_card.dart';
import 'widgets/job_strip.dart';

/// Result of the composer: a feed post plus an optional job entry
/// (created when the Job type is picked). Frontend-only until backend.
typedef CreateResult = ({HomeFeedPost post, HomeJob? job});

/// LinkedIn-style composer. Returns the created post (or null on cancel).
/// Shows Photo / Job / Poll type options inside the sheet.
Future<CreateResult?> showHomeCreateSheet(
  BuildContext context, {
  required String authorName,
  required String initials,
  required HomeRole activeRole,
  String preset = 'Post',
}) {
  return showModalBottomSheet<CreateResult>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _ComposerSheet(
      authorName: authorName,
      initials: initials,
      activeRole: activeRole,
      preset: preset,
    ),
  );
}

class _ComposerSheet extends StatefulWidget {
  final String authorName;
  final String initials;
  final HomeRole activeRole;
  final String preset;

  const _ComposerSheet({
    required this.authorName,
    required this.initials,
    required this.activeRole,
    required this.preset,
  });

  @override
  State<_ComposerSheet> createState() => _ComposerSheetState();
}

class _ComposerSheetState extends State<_ComposerSheet> {
  static const _types = [
    ('photo', Icons.image_outlined, 'Photo', Color(0xFF059669)),
    ('job', Icons.work_outline_rounded, 'Job', Color(0xFF2563EB)),
    ('poll', Icons.poll_outlined, 'Poll', Color(0xFFD97706)),
  ];

  String? _selected;
  final _textCtrl = TextEditingController();
  final _jobTitleCtrl = TextEditingController();
  final _optionCtrls = List.generate(4, (_) => TextEditingController());
  var _optionCount = 2;

  @override
  void initState() {
    super.initState();
    _selected = switch (widget.preset) {
      'Photo Post' => 'photo',
      'Job Post' => 'job',
      'Poll' => 'poll',
      _ => null,
    };
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _jobTitleCtrl.dispose();
    for (final c in _optionCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  bool _valid() {
    if (_textCtrl.text.trim().isEmpty) return false;
    if (_selected == 'job' && _jobTitleCtrl.text.trim().isEmpty) {
      return false;
    }
    if (_selected == 'poll') {
      final filled = _optionCtrls
          .take(_optionCount)
          .where((c) => c.text.trim().isNotEmpty)
          .length;
      if (filled < 2) return false;
    }
    return true;
  }

  void _submit() {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final name = widget.authorName;
    final pollOpts = _selected == 'poll'
        ? _optionCtrls
            .take(_optionCount)
            .map((c) => c.text.trim())
            .where((t) => t.isNotEmpty)
            .toList()
        : const <String>[];
    final post = HomeFeedPost(
      id: id,
      roleTag: widget.activeRole,
      authorName: name,
      authorSub: 'Just now',
      initials: widget.initials,
      timeAgo: 'now',
      title: _selected == 'job' ? '💼 ${_jobTitleCtrl.text.trim()}' : '',
      body: _textCtrl.text.trim(),
      hasImage: _selected == 'photo',
      followed: true,
      pollOptions: pollOpts,
      pollVotes: List.filled(pollOpts.length, 0),
    );
    final job = _selected == 'job'
        ? HomeJob(
            id: 'job_$id',
            roleTag: widget.activeRole,
            title: _jobTitleCtrl.text.trim(),
            company: name,
            location: 'Remote',
            type: 'Full-time',
          )
        : null;
    Navigator.pop(context, (post: post, job: job));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFFDBEAFE),
                  child: Text(
                    widget.initials,
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.authorName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const Text(
                        'Post to Anyone',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded,
                      color: Color(0xFF6B7280)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _textCtrl,
                      maxLines: 4,
                      minLines: 2,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText:
                            'Share your ideas, updates and progress...',
                        hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF9CA3AF)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF111827)),
                    ),
                    if (_selected == 'job') ...[
                      const SizedBox(height: 4),
                      TextField(
                        controller: _jobTitleCtrl,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          hintText:
                              'Job title (e.g. Flutter Developer)',
                          hintStyle: TextStyle(
                              fontSize: 13.5,
                              color: Color(0xFF9CA3AF)),
                          filled: true,
                          fillColor: Color(0xFFF3F4F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(12)),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.all(12),
                        ),
                      ),
                    ],
                    if (_selected == 'poll') ...[
                      const SizedBox(height: 4),
                      for (var i = 0; i < _optionCount; i++)
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 8),
                          child: TextField(
                            controller: _optionCtrls[i],
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: 'Option ${i + 1}',
                              hintStyle: const TextStyle(
                                  fontSize: 13.5,
                                  color: Color(0xFF9CA3AF)),
                              filled: true,
                              fillColor:
                                  const Color(0xFFF3F4F6),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(12)),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding:
                                  const EdgeInsets.all(12),
                            ),
                          ),
                        ),
                      if (_optionCount < 4)
                        GestureDetector(
                          onTap: () =>
                              setState(() => _optionCount++),
                          child: const Text(
                            '+ Add option',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
            const Divider(height: 24, color: Color(0xFFE5E7EB)),
            Row(
              children: [
                for (final t in _types)
                  GestureDetector(
                    onTap: () => setState(() =>
                        _selected =
                            _selected == t.$1 ? null : t.$1),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          Icon(
                            t.$2,
                            size: 22,
                            color: _selected == t.$1
                                ? t.$4
                                : const Color(0xFF6B7280),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            t.$3,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _selected == t.$1
                                  ? t.$4
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const Spacer(),
                FilledButton(
                  onPressed: _valid() ? _submit : null,
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF2563EB),
                    disabledBackgroundColor:
                        const Color(0xFFE5E7EB),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Post'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable Home feed body (no Scaffold / bottom nav).
///
/// Drop into any mode shell's Home tab:
/// `CollabsterHomeBody(activeRole: HomeRole.startup)`
/// Feed = 80% active role + 20% discovery (frontend mixer until backend
/// `GET /feed?activeRole=` returns pre-mixed order with `isDiscovery`).
class CollabsterHomeBody extends ConsumerStatefulWidget {
  final HomeRole activeRole;

  const CollabsterHomeBody({
    super.key,
    this.activeRole = HomeRole.startup,
  });

  @override
  ConsumerState<CollabsterHomeBody> createState() => CollabsterHomeBodyState();
}

/// Public so shells can trigger the composer via a GlobalKey.
class CollabsterHomeBodyState extends ConsumerState<CollabsterHomeBody>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  int _tab = 0; // 0 For You, 1 Jobs, 2 Following
  late List<HomeFeedPost> _feed;
  late List<HomeJob> _jobs;
  final Set<String> _dismissedDiscovery = {};

  /// Investor home has no Jobs tab (deal flow lives in its own tabs).
  bool get _showJobs => widget.activeRole != HomeRole.investor;

  List<String> get _tabLabels =>
      _showJobs ? const ['For You', 'Jobs', 'Following'] : const ['For You', 'Following'];

  /// Selected index within [_tabLabels].
  int get _tabIndex {
    if (!_showJobs) return _tab == 0 ? 0 : 1;
    return _tab;
  }

  void _selectTab(int i) {
    setState(() => _tab = _showJobs ? i : (i == 0 ? 0 : 2));
  }

  @override
  void initState() {
    super.initState();
    // Own posts first (persist across visits), then the 80/20 role mix.
    final mine = ref.read(userPostsViewModelProvider);
    _feed = [...mine, ...mixFeed(buildMockPosts(widget.activeRole))];
    _jobs = buildMockJobs();
  }

  List<HomeFeedPost> get _visibleFeed {
    final list =
        _feed.where((p) => !_dismissedDiscovery.contains(p.id)).toList();
    if (_tab == 2) {
      final following = list.where((p) => p.followed).toList();
      return following.isEmpty ? list.take(2).toList() : following;
    }
    return list;
  }

  void _toggleLike(HomeFeedPost post) {
    final i = _feed.indexWhere((p) => p.id == post.id);
    if (i < 0) return;
    setState(() {
      _feed[i] = _feed[i].copyWith(
        likes: post.likedByMe ? post.likes - 1 : post.likes + 1,
        likedByMe: !post.likedByMe,
      );
    });
  }

  void _toggleBookmark(HomeFeedPost post) {
    final i = _feed.indexWhere((p) => p.id == post.id);
    if (i < 0) return;
    setState(() {
      _feed[i] = _feed[i].copyWith(bookmarked: !post.bookmarked);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(post.bookmarked ? 'Removed from saved' : 'Saved to your items'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _toggleFollow(HomeFeedPost post) {
    final i = _feed.indexWhere((p) => p.id == post.id);
    if (i < 0) return;
    setState(() {
      _feed[i] = _feed[i].copyWith(followed: !post.followed);
    });
  }

  void _votePoll(HomeFeedPost post, int option) {
    if (post.votedIndex != null) return;
    final i = _feed.indexWhere((p) => p.id == post.id);
    if (i < 0) return;
    final votes = List<int>.from(post.pollVotes);
    while (votes.length < post.pollOptions.length) {
      votes.add(0);
    }
    votes[option] = votes[option] + 1;
    setState(() {
      _feed[i] = _feed[i].copyWith(pollVotes: votes, votedIndex: option);
    });
  }

  /// Opens the composer; inserted post appears at the top instantly.
  /// Frontend-only until backend POST /post exists.
  Future<void> openCreate({String preset = 'Post'}) async {
    final session = ref.read(authViewModelProvider).session;
    final name = (session?.fullName ?? 'You').trim();
    final initial = name.isEmpty ? 'Y' : name[0].toUpperCase();
    final result = await showHomeCreateSheet(
      context,
      authorName: name.isEmpty ? 'You' : name,
      initials: initial,
      activeRole: widget.activeRole,
      preset: preset,
    );
    if (result == null || !mounted) return;
    ref.read(userPostsViewModelProvider.notifier).add(result.post);
    setState(() {
      _feed.insert(0, result.post);
      if (result.job != null) _jobs.insert(0, result.job!);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final session = ref.watch(authViewModelProvider).session;
    final name = (session?.fullName ?? 'C').trim();
    final initial = name.isEmpty ? 'C' : name[0].toUpperCase();

    return Column(
      children: [
        HomeAppBar(
          avatarLabel: initial,
          // Avatar opens the mode's side menu (drawer). Profile + Logout
          // live there now; bottom nav Profile tab was replaced by Switch.
          onAvatarTap: () => Scaffold.maybeOf(context)?.openDrawer(),
          onSearchTap: () {},
          onBellTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ActivityScreen()),
          ),
        ),
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: const Text(
                    'Latest updates for you',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabsDelegate(
                  child: FeedTabs(
                    labels: _tabLabels,
                    selected: _tabIndex,
                    onSelect: _selectTab,
                  ),
                ),
              ),
              if (_tab == 1)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        JobStrip(
                          jobs: _jobs,
                          onSeeAll: () {},
                        ),
                        const SizedBox(height: 12),
                        ..._jobs.map(
                          (j) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _jobRow(j),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final feed = _visibleFeed;
                      if (index >= feed.length) return null;
                      final post = feed[index];
                      final showJobStrip = _showJobs &&
                          (index + 1) % 3 == 0 &&
                          index != feed.length - 1;

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: Column(
                          children: [
                            if (post.isDiscovery)
                              DiscoveryCard(
                                post: post,
                                onFollow: () => _toggleFollow(post),
                                onClose: () => setState(
                                    () => _dismissedDiscovery.add(post.id)),
                                onLike: () => _toggleLike(post),
                                onComment: () => CommentsSheet.show(
                                  context,
                                  commentCount: post.comments,
                                ),
                                onShare: () => ShareSheet.show(context),
                                onNotInterested: () => setState(
                                    () => _dismissedDiscovery.add(post.id)),
                              )
                            else
                              PostCard(
                                post: post,
                                onLike: () => _toggleLike(post),
                                onComment: () => CommentsSheet.show(
                                  context,
                                  commentCount: post.comments,
                                ),
                                onShare: () => ShareSheet.show(context),
                                onBookmark: () => _toggleBookmark(post),
                                onMenu: () {},
                                onPollVote: (i) => _votePoll(post, i),
                              ),
                            if (showJobStrip) ...[
                              const SizedBox(height: 12),
                              JobStrip(jobs: _jobs, onSeeAll: () {}),
                            ],
                          ],
                        ),
                      );
                    },
                    childCount: _visibleFeed.length,
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _jobRow(HomeJob job) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFEFF6FF),
            child: Text(
              job.company.isEmpty ? 'J' : job.company[0].toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),
                Text(
                  '${job.company} • ${job.location} • ${job.type}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFF9CA3AF)),
        ],
      ),
    );
  }
}

class _TabsDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _TabsDelegate({required this.child});

  @override
  double get minExtent => 45;
  @override
  double get maxExtent => 45;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      elevation: overlapsContent ? 1 : 0,
      color: Colors.white,
      child: Column(
        children: [
          Expanded(child: child),
          Container(height: 1, color: const Color(0xFFE5E7EB)),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _TabsDelegate old) => old.child != child;
}
