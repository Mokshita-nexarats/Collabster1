import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/enums/app_enums.dart';
import '../../startup/model/startup_models.dart';
import '../model/auth_session.dart';
import '../repository/i_auth_repository.dart';
import 'auth_state.dart';

class AuthViewModel extends StateNotifier<AuthState> {
  AuthViewModel(this._repository) : super(const AuthState());

  final IAuthRepository _repository;

  Future<void> loadSession() async {
    state = state.copyWith(status: AuthStatus.loading);
    final session = await _repository.readSession();
    if (session != null) {
      state = state.copyWith(
        status: AuthStatus.authenticated,
        session: session,
      );
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    final session = await _repository.readSession();

    if (session == null) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'No saved account found. Create a new account first.',
      );
      return 'No saved account found. Create a new account first.';
    }

    if (session.email.toLowerCase() != email.toLowerCase() ||
        session.password != password) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Email or password does not match the saved account.',
      );
      return 'Email or password does not match the saved account.';
    }

    await _repository.saveSession(session.copyWith(onboardingComplete: true));
    await _repository.markOnboardingComplete();

    state = state.copyWith(
      status: AuthStatus.authenticated,
      session: session.copyWith(onboardingComplete: true),
    );
    return null;
  }

  Future<void> signUp(AuthSession session) async {
    state = state.copyWith(status: AuthStatus.loading);
    final sessionWithRoles = session.copyWith(
      roles: [session.role],
      activeRole: session.role,
    );
    await _repository.saveSession(sessionWithRoles);
    await _repository.markOnboardingComplete();
    state = state.copyWith(
      status: AuthStatus.authenticated,
      session: sessionWithRoles,
    );
  }

  Future<void> switchRole(UserRole newRole) async {
    final currentSession = state.session;
    if (currentSession == null) return;

    final currentRoles = currentSession.userRoles.map((r) => r.name).toList();
    if (!currentRoles.contains(newRole.name)) {
      currentRoles.add(newRole.name);
    }

    await _repository.updateSession((current) {
      if (current == null) return null;
      return current.copyWith(activeRole: newRole.name, roles: currentRoles);
    });

    final updated = await _repository.readSession();
    if (updated != null) {
      state = state.copyWith(session: updated);
    }
  }

  Future<void> switchStartup({required bool joined}) async {
    final currentSession = state.session;
    if (currentSession == null) return;

    final startupName = joined
        ? currentSession.joinedStartupName
        : currentSession.originalStartupName;
    final startupData = joined
        ? currentSession.joinedStartupData
        : currentSession.originalStartupData;
    if (startupName == null || startupName.trim().isEmpty) return;

    final startupRole = currentSession.userRoles.firstWhere(
      (role) => role.isStartupRole,
      orElse: () => UserRole.company,
    );
    final roles = currentSession.userRoles.map((role) => role.name).toList();
    if (!roles.contains(startupRole.name)) roles.add(startupRole.name);

    String value(String key) => startupData?[key] as String? ?? '';

    await _repository.updateSession((current) {
      if (current == null) return null;
      return current.copyWith(
        activeRole: startupRole.name,
        roles: roles,
        startupName: startupName.trim(),
        startupIndustry: value('startupIndustry'),
        startupStage: value('startupStage'),
        startupTagline: value('startupTagline'),
        startupLogoPath: value('startupLogoPath'),
        startupCoverPath: value('startupCoverPath'),
        startupCountry: value('startupCountry'),
        startupCity: value('startupCity'),
        startupDescription: value('startupDescription'),
        startupProblem: value('startupProblem'),
        startupSolution: value('startupSolution'),
        startupMission: value('startupMission'),
        startupVision: value('startupVision'),
        startupWebsite: value('startupWebsite'),
        startupIncorporationDate: value('startupIncorporationDate'),
        startupFounderPhotoPath: value('startupFounderPhotoPath'),
        startupFounderName: value('startupFounderName'),
        startupFounderDesignation: value('startupFounderDesignation'),
        startupFounderEmail: value('startupFounderEmail'),
        startupFounderPhone: value('startupFounderPhone'),
        startupFounderLinkedin: value('startupFounderLinkedin'),
        startupFounderBio: value('startupFounderBio'),
        startupSocialWebsite: value('startupSocialWebsite'),
        startupSocialLinkedin: value('startupSocialLinkedin'),
        startupSocialProductHunt: value('startupSocialProductHunt'),
        startupUseOfFunds: value('startupUseOfFunds'),
        startupTeamSize: value('startupTeamSize'),
        startupFundingStage: value('startupFundingStage'),
        startupCurrentlyRaising:
            startupData?['startupCurrentlyRaising'] as bool?,
        startupVisibility: value('startupVisibility'),
        startupTargetAmount: value('startupTargetAmount'),
        startupRoundSize: value('startupRoundSize'),
        startupValuation: value('startupValuation'),
        startupFundingDeadline: value('startupFundingDeadline'),
        startupExistingInvestors: value('startupExistingInvestors'),
      );
    });

    final updated = await _repository.readSession();
    if (updated != null) {
      state = state.copyWith(session: updated);
    }
  }

  Future<void> addRole(UserRole newRole) async {
    final currentSession = state.session;
    if (currentSession == null) return;

    final currentRoles = currentSession.userRoles.map((r) => r.name).toList();
    if (currentRoles.contains(newRole.name)) {
      return;
    }

    currentRoles.add(newRole.name);

    await _repository.updateSession((current) {
      if (current == null) return null;
      return current.copyWith(roles: currentRoles);
    });

    final updated = await _repository.readSession();
    if (updated != null) {
      state = state.copyWith(session: updated);
    }
  }

  Future<void> updateStartupData({
    required String startupName,
    String? industry,
    String? stage,
    String? tagline,
    String? logoPath,
    String? coverPath,
    String? country,
    String? city,
    String? description,
    String? problem,
    String? solution,
    String? mission,
    String? vision,
    String? website,
    String? incorporationDate,
    String? founderName,
    String? founderPhotoPath,
    String? founderDesignation,
    String? founderEmail,
    String? founderPhone,
    String? founderLinkedin,
    String? founderBio,
    String? socialWebsite,
    String? socialLinkedin,
    String? socialProductHunt,
    String? useOfFunds,
    String? teamSize,
    String? fundingStage,
    bool? currentlyRaising,
    String? visibility,
    String? targetAmount,
    String? roundSize,
    String? valuation,
    String? fundingDeadline,
    String? existingInvestors,
    String? originalStartupName,
    Map<String, dynamic>? originalStartupData,
    String? joinedStartupName,
    Map<String, dynamic>? joinedStartupData,
    bool clearJoinedStartup = false,
  }) async {
    await _repository.updateSession((current) {
      if (current == null) return null;
      return current.copyWith(
        startupName: startupName,
        startupIndustry: industry,
        startupStage: stage,
        startupTagline: tagline,
        startupLogoPath: logoPath,
        startupCoverPath: coverPath,
        startupCountry: country,
        startupCity: city,
        startupDescription: description,
        startupProblem: problem,
        startupSolution: solution,
        startupMission: mission,
        startupVision: vision,
        startupWebsite: website,
        startupIncorporationDate: incorporationDate,
        startupFounderName: founderName,
        startupFounderPhotoPath: founderPhotoPath,
        startupFounderDesignation: founderDesignation,
        startupFounderEmail: founderEmail,
        startupFounderPhone: founderPhone,
        startupFounderLinkedin: founderLinkedin,
        startupFounderBio: founderBio,
        startupSocialWebsite: socialWebsite,
        startupSocialLinkedin: socialLinkedin,
        startupSocialProductHunt: socialProductHunt,
        startupUseOfFunds: useOfFunds,
        startupTeamSize: teamSize,
        startupFundingStage: fundingStage,
        startupCurrentlyRaising: currentlyRaising,
        startupVisibility: visibility,
        startupTargetAmount: targetAmount,
        startupRoundSize: roundSize,
        startupValuation: valuation,
        startupFundingDeadline: fundingDeadline,
        startupExistingInvestors: existingInvestors,
        originalStartupName: originalStartupName,
        originalStartupData: originalStartupData,
        joinedStartupName: joinedStartupName,
        joinedStartupData: joinedStartupData,
        clearJoinedStartup: clearJoinedStartup,
      );
    });
    final updated = await _repository.readSession();
    if (updated != null) {
      state = state.copyWith(session: updated);
    }
  }

  Future<void> addPost(StartupPost post) async {
    final currentSession = state.session;
    if (currentSession == null) return;

    final updatedPosts = [post, ...currentSession.posts];

    await _repository.updateSession((current) {
      if (current == null) return null;
      return current.copyWith(posts: updatedPosts);
    });

    final updated = await _repository.readSession();
    if (updated != null) {
      state = state.copyWith(session: updated);
    }
  }

  Future<void> updateProfilePhoto(String photoPath) async {
    await _repository.updateSession((current) {
      if (current == null) return null;
      return current.copyWith(
        profilePhotoPath: photoPath,
        profilePhotoLabel: 'Photo uploaded',
      );
    });
    final updated = await _repository.readSession();
    if (updated != null) {
      state = state.copyWith(session: updated);
    }
  }

  Future<void> updateFounderPhoto(String photoPath) async {
    await _repository.updateSession((current) {
      if (current == null) return null;
      return current.copyWith(startupFounderPhotoPath: photoPath);
    });
    final updated = await _repository.readSession();
    if (updated != null) {
      state = state.copyWith(session: updated);
    }
  }

  Future<void> logout() async {
    await _repository.clearSession();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  AuthSession? get currentSession => state.session;
}
