import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/viewmodel/auth_viewmodel.dart';
import '../../features/community/viewmodel/community_notifications_viewmodel.dart';
import '../../features/community/viewmodel/post_viewmodel.dart';
import '../../features/investor/viewmodel/cross_conversation_viewmodel.dart';
import '../../features/investor/viewmodel/investor_notifications_viewmodel.dart';
import '../../features/investor/viewmodel/investor_viewmodel.dart';
import '../../features/startup/viewmodel/fundraising_viewmodel.dart';
import '../../features/startup/viewmodel/hiring_viewmodel.dart';
import '../../features/startup/viewmodel/investor_pipeline_viewmodel.dart';
import '../../features/startup/viewmodel/notifications_viewmodel.dart';
import 'bridge_models.dart';
import 'bridge_state.dart';

/// Aggregates data from Startup, Community, Investor + Feed into unified
/// cross-mode lists consumed by the Connect hub and by bridged sections
/// inside each mode's home.
class BridgeViewModel extends StateNotifier<BridgeState> {
  final HiringViewModel _hiringViewModel;
  final PostViewModel _postViewModel;
  final InvestorPipelineViewModel _investorPipelineViewModel;
  final InvestorViewModel _investorViewModel;
  final FundraisingViewModel _fundraisingViewModel;
  final NotificationsViewModel _startupNotificationsViewModel;
  final CommunityNotificationsViewModel _communityNotificationsViewModel;
  final InvestorNotificationsViewModel _investorNotificationsViewModel;
  final CrossConversationViewModel _crossConversationViewModel;
  final AuthViewModel _authViewModel;

  BridgeViewModel({
    required HiringViewModel hiringViewModel,
    required PostViewModel postViewModel,
    required InvestorPipelineViewModel investorPipelineViewModel,
    required InvestorViewModel investorViewModel,
    required FundraisingViewModel fundraisingViewModel,
    required NotificationsViewModel startupNotificationsViewModel,
    required CommunityNotificationsViewModel communityNotificationsViewModel,
    required InvestorNotificationsViewModel investorNotificationsViewModel,
    required CrossConversationViewModel crossConversationViewModel,
    required AuthViewModel authViewModel,
  })  : _hiringViewModel = hiringViewModel,
        _postViewModel = postViewModel,
        _investorPipelineViewModel = investorPipelineViewModel,
        _investorViewModel = investorViewModel,
        _fundraisingViewModel = fundraisingViewModel,
        _startupNotificationsViewModel = startupNotificationsViewModel,
        _communityNotificationsViewModel = communityNotificationsViewModel,
        _investorNotificationsViewModel = investorNotificationsViewModel,
        _crossConversationViewModel = crossConversationViewModel,
        _authViewModel = authViewModel,
        super(const BridgeState());

  /// Loads (and re-aggregates) data from every connected mode.
  void loadAll() {
    _hiringViewModel.loadInitialData();
    _postViewModel.loadPosts();
    _investorPipelineViewModel.loadInitialData();
    _investorViewModel.loadInvestors();
    _fundraisingViewModel.loadInitialData();
    _startupNotificationsViewModel.loadNotifications();
    _communityNotificationsViewModel.loadNotifications();
    _investorNotificationsViewModel.loadNotifications();
    _crossConversationViewModel.loadConversations();

    final session = _authViewModel.state.session;
    final startupName = (session?.startupName?.isNotEmpty == true)
        ? session!.startupName!
        : session?.joinedStartupName;

    final opportunities = [
      ...startupHiringOpportunities(
        _hiringViewModel.state.roles
            .where((r) => r.roleType == 'job')
            .toList(),
        startupName: startupName ?? 'Startup',
      ),
      ...startupHiringOpportunities(
        _hiringViewModel.state.roles
            .where((r) => r.roleType == 'internship')
            .toList(),
        startupName: startupName ?? 'Startup',
      ),
    ];

    final posts = [
      ...(session?.posts ?? const [])
          .map((p) => startupPostToBridge(p, startupName: startupName ?? 'Startup')),
      ..._postViewModel.state.posts.map(communityPostToBridge),
    ];

    final investors = [
      ...startupPipelineToBridge(
        _investorPipelineViewModel.state.discoverInvestors,
        sourceLabel: startupName ?? 'Startup Pipeline',
      ),
      ...investorModeToBridge(_investorViewModel.state.investors),
    ];

    final fundingRounds = [
      ...investorFundingRoundsToBridge(
        _investorViewModel.state.fundingRounds,
        sourceLabel: 'Investor Deal Flow',
      ),
      ...startupFundraisingToBridge(
        _fundraisingViewModel.state.targetAmount,
        _fundraisingViewModel.state.raisedAmount,
        startupName ?? 'Startup',
      ),
    ];

    final notifications = [
      ...startupNotificationsToBridge(
        _startupNotificationsViewModel.state.notifications,
        startupName: startupName ?? 'Startup',
      ),
      ...communityNotificationsToBridge(_communityNotificationsViewModel.state.notifications),
      ...investorNotificationsToBridge(_investorNotificationsViewModel.state.notifications),
    ];

    state = BridgeState(
      opportunities: opportunities,
      posts: posts,
      events: const [],
      investors: investors,
      fundingRounds: fundingRounds,
      notifications: notifications,
      isLoaded: true,
    );
  }
}
