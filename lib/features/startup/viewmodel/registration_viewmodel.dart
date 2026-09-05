import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/startup_models.dart';
import 'registration_state.dart';

class RegistrationViewModel extends StateNotifier<RegistrationState> {
  RegistrationViewModel() : super(const RegistrationState());

  void loadInitialData() {
    if (state.members.isNotEmpty) return;
    state = state.copyWith(
      members: const [
        StartupMember(
          name: 'Sarah Jenkins',
          role: 'CEO & Co-founder',
          status: 'Active',
          initials: 'SJ',
        ),
        StartupMember(
          name: 'Marcus Zhao',
          role: 'Lead Developer',
          status: 'Invite Sent',
          initials: 'MZ',
        ),
      ],
      socialLinks: const [
        SocialLink(platform: 'Website', url: ''),
        SocialLink(platform: 'LinkedIn', url: ''),
        SocialLink(platform: 'Product Hunt', url: ''),
      ],
    );
  }

  void selectStage(String stage) {
    state = state.copyWith(selectedStage: stage);
  }

  void selectTeamSize(String size) {
    state = state.copyWith(selectedTeamSize: size);
  }

  void selectFundingStage(String stage) {
    state = state.copyWith(selectedFundingStage: stage);
  }

  void selectInviteRole(String role) {
    state = state.copyWith(selectedInviteRole: role);
  }

  void selectVisibility(String visibility) {
    state = state.copyWith(selectedVisibility: visibility);
  }

  void selectSubIndustry(String value) {
    state = state.copyWith(subIndustry: value);
  }

  void selectStartupType(String value) {
    state = state.copyWith(startupType: value);
  }

  void selectBusinessModel(String value) {
    state = state.copyWith(businessModel: value);
  }

  void toggleRaising(bool value) {
    state = state.copyWith(currentlyRaising: value);
  }

  void setYearsOfExperience(double years) {
    state = state.copyWith(yearsOfExperience: years);
  }

  void toggleSkill(String skill) {
    final updatedSkills = Set<String>.from(state.selectedSkills);
    if (updatedSkills.contains(skill)) {
      updatedSkills.remove(skill);
    } else {
      updatedSkills.add(skill);
    }
    state = state.copyWith(selectedSkills: updatedSkills);
  }

  void setCurrentStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  bool goToNextStep() {
    if (state.currentStep < RegistrationState.totalSteps - 1) {
      state = state.copyWith(currentStep: state.currentStep + 1);
      return true;
    }
    return false;
  }

  bool goToPreviousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
      return true;
    }
    return false;
  }

  bool inviteTeamMember(String email, {String? role}) {
    if (email.isEmpty) return false;
    final assignedRole = role ?? state.selectedInviteRole;
    final newMember = StartupMember(
      name: email.split('@').first,
      role: assignedRole,
      status: 'Invite Sent',
      initials: email.isNotEmpty ? email[0].toUpperCase() : 'U',
    );
    state = state.copyWith(members: [newMember, ...state.members]);
    return true;
  }

  void removeTeamMemberAt(int index) {
    if (index < 0 || index >= state.members.length) return;
    final updated = List<StartupMember>.from(state.members)..removeAt(index);
    state = state.copyWith(members: updated);
  }

  void addSocialLink(String platform, String url) {
    if (platform.trim().isEmpty || url.trim().isEmpty) return;
    state = state.copyWith(
      socialLinks: [
        ...state.socialLinks,
        SocialLink(platform: platform.trim(), url: url.trim()),
      ],
    );
  }

  void updateSocialLink(int index, {String? platform, String? url}) {
    if (index < 0 || index >= state.socialLinks.length) return;
    final updated = List<SocialLink>.from(state.socialLinks);
    updated[index] = updated[index].copyWith(platform: platform, url: url);
    state = state.copyWith(socialLinks: updated);
  }

  void removeSocialLinkAt(int index) {
    if (index < 0 || index >= state.socialLinks.length) return;
    final updated = List<SocialLink>.from(state.socialLinks)..removeAt(index);
    state = state.copyWith(socialLinks: updated);
  }
}
