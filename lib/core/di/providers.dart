import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/repository/auth_repository_impl.dart';
import '../../features/auth/repository/i_auth_repository.dart';
import '../../features/auth/viewmodel/auth_viewmodel.dart';
import '../../features/auth/viewmodel/auth_state.dart';
import '../../features/auth/viewmodel/sign_up_viewmodel.dart';
import '../../features/auth/viewmodel/sign_up_state.dart';
import '../../features/community/model/community_notification_state.dart';
import '../../features/community/viewmodel/community_notifications_viewmodel.dart';
import '../../features/community/viewmodel/community_viewmodel.dart';
import '../../features/community/viewmodel/community_state.dart';
import '../../features/community/viewmodel/post_viewmodel.dart';
import '../../features/community/viewmodel/post_state.dart';
import '../../features/home/view/collabster_home/home_feed_item.dart';
import '../../features/home/view/collabster_home/user_posts_viewmodel.dart';
import '../../features/community/viewmodel/activity_viewmodel.dart';
import '../../features/community/viewmodel/activity_state.dart';
import '../../features/community/viewmodel/message_viewmodel.dart';
import '../../features/community/viewmodel/message_state.dart';
import '../../features/investor/model/cross_conversation_state.dart';
import '../../features/investor/viewmodel/cross_conversation_viewmodel.dart';
import '../../features/investor/model/investor_notification_state.dart';
import '../../features/investor/viewmodel/investor_notifications_viewmodel.dart';
import '../../features/investor/viewmodel/investor_viewmodel.dart';
import '../../features/investor/viewmodel/investor_state.dart';
import '../../features/investor/viewmodel/pitch_deck_viewmodel.dart';
import '../../features/investor/viewmodel/pitch_deck_state.dart';
import '../../features/startup/model/startup_models.dart';
import '../../features/startup/viewmodel/documents_viewmodel.dart';
import '../../features/startup/viewmodel/documents_state.dart';
import '../../features/startup/viewmodel/fundraising_viewmodel.dart';
import '../../features/startup/viewmodel/fundraising_state.dart';
import '../../features/startup/viewmodel/hiring_viewmodel.dart';
import '../../features/startup/viewmodel/hiring_state.dart';
import '../../features/startup/viewmodel/investor_pipeline_viewmodel.dart';
import '../../features/startup/viewmodel/investor_pipeline_state.dart';
import '../../features/startup/viewmodel/join_startup_viewmodel.dart';
import '../../features/startup/viewmodel/join_startup_state.dart';
import '../../features/startup/viewmodel/milestones_viewmodel.dart';
import '../../features/startup/viewmodel/milestones_state.dart';
import '../../features/startup/viewmodel/notifications_viewmodel.dart';
import '../../features/startup/viewmodel/notifications_state.dart';
import '../../features/startup/viewmodel/products_viewmodel.dart';
import '../../features/startup/viewmodel/products_state.dart';
import '../../features/startup/viewmodel/registration_viewmodel.dart';
import '../../features/startup/viewmodel/registration_state.dart';
import '../../features/startup/viewmodel/requests_viewmodel.dart';
import '../../features/startup/viewmodel/requests_state.dart';
import '../../features/startup/viewmodel/team_viewmodel.dart';
import '../../features/startup/viewmodel/team_state.dart';
import '../../features/startup/viewmodel/startup_dashboard_viewmodel.dart';
import '../../features/startup/viewmodel/startup_dashboard_state.dart';
import '../theme/theme_provider.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  return AuthViewModel(ref.read(authRepositoryProvider));
});

final signUpViewModelProvider =
    StateNotifierProvider<SignUpViewModel, SignUpState>((ref) {
  return SignUpViewModel();
});

final themeProviderInstance = ChangeNotifierProvider<ThemeProvider>((ref) {
  return ThemeProvider();
});

// ---------------------------------------------------------------------------
// Frontend-only startup registry (replaces backend API for now).
// When the registration flow publishes a startup it is added here.
// The Join Startup screen reads from this list alongside the hardcoded seeds.
// ---------------------------------------------------------------------------
class StartupRegistryNotifier extends StateNotifier<List<SuggestedStartup>> {
  StartupRegistryNotifier() : super(const []);

  void addStartup(SuggestedStartup startup) {
    state = [startup, ...state];
  }
}

final startupRegistryProvider =
    StateNotifierProvider<StartupRegistryNotifier, List<SuggestedStartup>>(
  (ref) => StartupRegistryNotifier(),
);

// ---------------------------------------------------------------------------
// Startup Feature ViewModels
// ---------------------------------------------------------------------------
final documentsViewModelProvider =
    StateNotifierProvider<DocumentsViewModel, DocumentsState>((ref) {
  return DocumentsViewModel();
});

final fundraisingViewModelProvider =
    StateNotifierProvider<FundraisingViewModel, FundraisingState>((ref) {
  return FundraisingViewModel();
});

final hiringViewModelProvider =
    StateNotifierProvider<HiringViewModel, HiringState>((ref) {
  return HiringViewModel();
});

final investorPipelineViewModelProvider =
    StateNotifierProvider<InvestorPipelineViewModel, InvestorPipelineState>((ref) {
  return InvestorPipelineViewModel();
});

final joinStartupViewModelProvider =
    StateNotifierProvider<JoinStartupViewModel, JoinStartupState>((ref) {
  return JoinStartupViewModel();
});

final milestonesViewModelProvider =
    StateNotifierProvider<MilestonesViewModel, MilestonesState>((ref) {
  return MilestonesViewModel();
});

final notificationsViewModelProvider =
    StateNotifierProvider<NotificationsViewModel, NotificationsState>((ref) {
  return NotificationsViewModel();
});

final productsViewModelProvider =
    StateNotifierProvider<ProductsViewModel, ProductsState>((ref) {
  return ProductsViewModel();
});

final registrationViewModelProvider =
    StateNotifierProvider<RegistrationViewModel, RegistrationState>((ref) {
  return RegistrationViewModel();
});

final requestsViewModelProvider =
    StateNotifierProvider<RequestsViewModel, RequestsState>((ref) {
  return RequestsViewModel();
});

final teamViewModelProvider =
    StateNotifierProvider<TeamViewModel, TeamState>((ref) {
  return TeamViewModel();
});

final startupDashboardViewModelProvider =
    StateNotifierProvider<StartupDashboardViewModel, StartupDashboardState>((ref) {
  return StartupDashboardViewModel();
});

// ---------------------------------------------------------------------------
// Community Feature ViewModels
// ---------------------------------------------------------------------------
final communityViewModelProvider =
    StateNotifierProvider<CommunityViewModel, CommunityState>((ref) {
  return CommunityViewModel();
});

final postViewModelProvider =
    StateNotifierProvider<PostViewModel, PostState>((ref) {
  return PostViewModel();
});

final activityViewModelProvider =
    StateNotifierProvider<ActivityViewModel, ActivityState>((ref) {
  return ActivityViewModel();
});

final messageViewModelProvider =
    StateNotifierProvider<MessageViewModel, MessageState>((ref) {
  return MessageViewModel();
});

final communityNotificationsViewModelProvider =
    StateNotifierProvider<CommunityNotificationsViewModel, CommunityNotificationState>((ref) {
  return CommunityNotificationsViewModel();
});

// ---------------------------------------------------------------------------
// Investor Feature ViewModels
// ---------------------------------------------------------------------------
final investorViewModelProvider =
    StateNotifierProvider<InvestorViewModel, InvestorState>((ref) {
  return InvestorViewModel();
});

final pitchDeckViewModelProvider =
    StateNotifierProvider<PitchDeckViewModel, PitchDeckState>((ref) {
  return PitchDeckViewModel();
});

final investorNotificationsViewModelProvider =
    StateNotifierProvider<InvestorNotificationsViewModel, InvestorNotificationState>((ref) {
  return InvestorNotificationsViewModel();
});

final crossConversationViewModelProvider =
    StateNotifierProvider<CrossConversationViewModel, CrossConversationState>((ref) {
  return CrossConversationViewModel();
});

// ---------------------------------------------------------------------------
// Universal Feed — current user's own posts (My Posts screen).
// ---------------------------------------------------------------------------
final userPostsViewModelProvider =
    StateNotifierProvider<UserPostsViewModel, List<HomeFeedPost>>((ref) {
  return UserPostsViewModel();
});
