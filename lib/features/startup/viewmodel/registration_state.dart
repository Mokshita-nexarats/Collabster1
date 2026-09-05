import '../model/startup_models.dart';

class RegistrationState {
  const RegistrationState({
    this.currentStep = 0,
    this.selectedStage = 'Seed',
    this.selectedTeamSize = '1-5',
    this.selectedFundingStage = 'Seed',
    this.selectedInviteRole = 'Founder',
    this.selectedVisibility = 'Public',
    this.currentlyRaising = true,
    this.yearsOfExperience = 5,
    this.selectedSkills = const {'Leadership', 'AI', 'Product'},
    this.members = const [],
    this.socialLinks = const [],
    this.subIndustry = '',
    this.startupType = '',
    this.businessModel = '',
  });

  static const int totalSteps = 8;

  final int currentStep;
  final String selectedStage;
  final String selectedTeamSize;
  final String selectedFundingStage;
  final String selectedInviteRole;
  final String selectedVisibility;
  final bool currentlyRaising;
  final double yearsOfExperience;
  final Set<String> selectedSkills;
  final List<StartupMember> members;
  final List<SocialLink> socialLinks;
  final String subIndustry;
  final String startupType;
  final String businessModel;

  double get progress => (currentStep + 1) / totalSteps;

  static const List<String> skillTags = [
    'Leadership',
    'AI',
    'Marketing',
    'Sales',
    'Engineering',
    'Finance',
    'Design',
    'Operations',
    'Product',
  ];

  static const List<String> fundingStages = [
    'Bootstrapped',
    'Angel',
    'Pre-Seed',
    'Seed',
    'Series A',
    'Series B',
  ];

  static const List<String> visibilityOptions = [
    'Public',
    'Private',
    'Invite Only',
  ];

  RegistrationState copyWith({
    int? currentStep,
    String? selectedStage,
    String? selectedTeamSize,
    String? selectedFundingStage,
    String? selectedInviteRole,
    String? selectedVisibility,
    bool? currentlyRaising,
    double? yearsOfExperience,
    Set<String>? selectedSkills,
    List<StartupMember>? members,
    List<SocialLink>? socialLinks,
    String? subIndustry,
    String? startupType,
    String? businessModel,
  }) {
    return RegistrationState(
      currentStep: currentStep ?? this.currentStep,
      selectedStage: selectedStage ?? this.selectedStage,
      selectedTeamSize: selectedTeamSize ?? this.selectedTeamSize,
      selectedFundingStage: selectedFundingStage ?? this.selectedFundingStage,
      selectedInviteRole: selectedInviteRole ?? this.selectedInviteRole,
      selectedVisibility: selectedVisibility ?? this.selectedVisibility,
      currentlyRaising: currentlyRaising ?? this.currentlyRaising,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      selectedSkills: selectedSkills ?? this.selectedSkills,
      members: members ?? this.members,
      socialLinks: socialLinks ?? this.socialLinks,
      subIndustry: subIndustry ?? this.subIndustry,
      startupType: startupType ?? this.startupType,
      businessModel: businessModel ?? this.businessModel,
    );
  }
}
