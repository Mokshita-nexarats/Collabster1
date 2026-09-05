import 'dart:convert';

import '../../../shared/enums/app_enums.dart';
import '../../startup/model/startup_models.dart';

class AuthSession {
  const AuthSession({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    required this.role,
    required this.onboardingComplete,
    this.activeRole,
    this.roles,
    this.username,
    this.dateOfBirth,
    this.gender,
    this.country,
    this.city,
    this.profilePhotoLabel,
    this.profilePhotoPath,
    this.themePreference,
    // Startup fields
    this.startupName,
    this.startupIndustry,
    this.startupStage,
    this.startupTagline,
    this.startupLogoPath,
    this.startupCoverPath,
    this.startupCountry,
    this.startupCity,
    this.startupDescription,
    this.startupProblem,
    this.startupSolution,
    this.startupMission,
    this.startupVision,
    this.startupWebsite,
    this.startupIncorporationDate,
    this.startupFounderPhotoPath,
    this.startupFounderName,
    this.startupFounderDesignation,
    this.startupFounderEmail,
    this.startupFounderPhone,
    this.startupFounderLinkedin,
    this.startupFounderBio,
    this.startupSocialWebsite,
    this.startupSocialLinkedin,
    this.startupSocialProductHunt,
    this.startupUseOfFunds,
    this.startupTeamSize,
    this.startupFundingStage,
    this.startupCurrentlyRaising = false,
    this.startupVisibility,
    this.startupTargetAmount,
    this.startupRoundSize,
    this.startupValuation,
    this.startupFundingDeadline,
    this.startupExistingInvestors,
    this.originalStartupName,
    this.originalStartupData,
    this.joinedStartupName,
    this.joinedStartupData,
    this.posts = const [],
  });

  final String fullName;
  final String email;
  final String password;
  final String phone;
  final String role;
  final bool onboardingComplete;
  final String? activeRole;
  final List<String>? roles;
  final String? username;
  final String? dateOfBirth;
  final String? gender;
  final String? country;
  final String? city;
  final String? profilePhotoLabel;
  final String? profilePhotoPath;
  final String? themePreference;
  // Startup fields
  final String? startupName;
  final String? startupIndustry;
  final String? startupStage;
  final String? startupTagline;
  final String? startupLogoPath;
  final String? startupCoverPath;
  final String? startupCountry;
  final String? startupCity;
  final String? startupDescription;
  final String? startupProblem;
  final String? startupSolution;
  final String? startupMission;
  final String? startupVision;
  final String? startupWebsite;
  final String? startupIncorporationDate;
  final String? startupFounderPhotoPath;
  final String? startupFounderName;
  final String? startupFounderDesignation;
  final String? startupFounderEmail;
  final String? startupFounderPhone;
  final String? startupFounderLinkedin;
  final String? startupFounderBio;
  final String? startupSocialWebsite;
  final String? startupSocialLinkedin;
  final String? startupSocialProductHunt;
  final String? startupUseOfFunds;
  final String? startupTeamSize;
  final String? startupFundingStage;
  final bool? startupCurrentlyRaising;
  final String? startupVisibility;
  final String? startupTargetAmount;
  final String? startupRoundSize;
  final String? startupValuation;
  final String? startupFundingDeadline;
  final String? startupExistingInvestors;
  final String? originalStartupName;
  final Map<String, dynamic>? originalStartupData;
  final String? joinedStartupName;
  final Map<String, dynamic>? joinedStartupData;
  final List<StartupPost> posts;

  UserRole get activeUserRole => UserRole.fromString(activeRole ?? role);

  bool get isStartupRole => activeUserRole.isStartupRole;

  List<UserRole> get userRoles {
    if (roles == null || roles!.isEmpty) {
      return [UserRole.fromString(role)];
    }
    return roles!.map(UserRole.fromString).toList();
  }

  AuthSession copyWith({
    String? fullName,
    String? email,
    String? password,
    String? phone,
    String? role,
    bool? onboardingComplete,
    String? activeRole,
    List<String>? roles,
    String? username,
    String? dateOfBirth,
    String? gender,
    String? country,
    String? city,
    String? profilePhotoLabel,
    String? profilePhotoPath,
    String? themePreference,
    String? startupName,
    String? startupIndustry,
    String? startupStage,
    String? startupTagline,
    String? startupLogoPath,
    String? startupCoverPath,
    String? startupCountry,
    String? startupCity,
    String? startupDescription,
    String? startupProblem,
    String? startupSolution,
    String? startupMission,
    String? startupVision,
    String? startupWebsite,
    String? startupIncorporationDate,
    String? startupFounderPhotoPath,
    String? startupFounderName,
    String? startupFounderDesignation,
    String? startupFounderEmail,
    String? startupFounderPhone,
    String? startupFounderLinkedin,
    String? startupFounderBio,
    String? startupSocialWebsite,
    String? startupSocialLinkedin,
    String? startupSocialProductHunt,
    String? startupUseOfFunds,
    String? startupTeamSize,
    String? startupFundingStage,
    bool? startupCurrentlyRaising,
    String? startupVisibility,
    String? startupTargetAmount,
    String? startupRoundSize,
    String? startupValuation,
    String? startupFundingDeadline,
    String? startupExistingInvestors,
    String? originalStartupName,
    Map<String, dynamic>? originalStartupData,
    String? joinedStartupName,
    Map<String, dynamic>? joinedStartupData,
    bool clearJoinedStartup = false,
    List<StartupPost>? posts,
  }) {
    return AuthSession(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      activeRole: activeRole ?? this.activeRole,
      roles: roles ?? this.roles,
      username: username ?? this.username,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      city: city ?? this.city,
      profilePhotoLabel: profilePhotoLabel ?? this.profilePhotoLabel,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
      themePreference: themePreference ?? this.themePreference,
      startupName: startupName ?? this.startupName,
      startupIndustry: startupIndustry ?? this.startupIndustry,
      startupStage: startupStage ?? this.startupStage,
      startupTagline: startupTagline ?? this.startupTagline,
      startupLogoPath: startupLogoPath ?? this.startupLogoPath,
      startupCoverPath: startupCoverPath ?? this.startupCoverPath,
      startupCountry: startupCountry ?? this.startupCountry,
      startupCity: startupCity ?? this.startupCity,
      startupDescription: startupDescription ?? this.startupDescription,
      startupProblem: startupProblem ?? this.startupProblem,
      startupSolution: startupSolution ?? this.startupSolution,
      startupMission: startupMission ?? this.startupMission,
      startupVision: startupVision ?? this.startupVision,
      startupWebsite: startupWebsite ?? this.startupWebsite,
      startupIncorporationDate: startupIncorporationDate ?? this.startupIncorporationDate,
      startupFounderPhotoPath: startupFounderPhotoPath ?? this.startupFounderPhotoPath,
      startupFounderName: startupFounderName ?? this.startupFounderName,
      startupFounderDesignation: startupFounderDesignation ?? this.startupFounderDesignation,
      startupFounderEmail: startupFounderEmail ?? this.startupFounderEmail,
      startupFounderPhone: startupFounderPhone ?? this.startupFounderPhone,
      startupFounderLinkedin: startupFounderLinkedin ?? this.startupFounderLinkedin,
      startupFounderBio: startupFounderBio ?? this.startupFounderBio,
      startupSocialWebsite: startupSocialWebsite ?? this.startupSocialWebsite,
      startupSocialLinkedin: startupSocialLinkedin ?? this.startupSocialLinkedin,
      startupSocialProductHunt: startupSocialProductHunt ?? this.startupSocialProductHunt,
      startupUseOfFunds: startupUseOfFunds ?? this.startupUseOfFunds,
      startupTeamSize: startupTeamSize ?? this.startupTeamSize,
      startupFundingStage: startupFundingStage ?? this.startupFundingStage,
      startupCurrentlyRaising: startupCurrentlyRaising ?? this.startupCurrentlyRaising,
      startupVisibility: startupVisibility ?? this.startupVisibility,
      startupTargetAmount: startupTargetAmount ?? this.startupTargetAmount,
      startupRoundSize: startupRoundSize ?? this.startupRoundSize,
      startupValuation: startupValuation ?? this.startupValuation,
      startupFundingDeadline: startupFundingDeadline ?? this.startupFundingDeadline,
      startupExistingInvestors: startupExistingInvestors ?? this.startupExistingInvestors,
      originalStartupName: originalStartupName ?? this.originalStartupName,
      originalStartupData: originalStartupData ?? this.originalStartupData,
      joinedStartupName: clearJoinedStartup ? null : (joinedStartupName ?? this.joinedStartupName),
      joinedStartupData: clearJoinedStartup ? null : (joinedStartupData ?? this.joinedStartupData),
      posts: posts ?? this.posts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'phone': phone,
      'role': role,
      'onboardingComplete': onboardingComplete,
      'activeRole': activeRole,
      'roles': roles,
      'username': username,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'country': country,
      'city': city,
      'profilePhotoLabel': profilePhotoLabel,
      'profilePhotoPath': profilePhotoPath,
      'themePreference': themePreference,
      'startupName': startupName,
      'startupIndustry': startupIndustry,
      'startupStage': startupStage,
      'startupTagline': startupTagline,
      'startupLogoPath': startupLogoPath,
      'startupCoverPath': startupCoverPath,
      'startupCountry': startupCountry,
      'startupCity': startupCity,
      'startupDescription': startupDescription,
      'startupProblem': startupProblem,
      'startupSolution': startupSolution,
      'startupMission': startupMission,
      'startupVision': startupVision,
      'startupWebsite': startupWebsite,
      'startupIncorporationDate': startupIncorporationDate,
      'startupFounderPhotoPath': startupFounderPhotoPath,
      'startupFounderName': startupFounderName,
      'startupFounderDesignation': startupFounderDesignation,
      'startupFounderEmail': startupFounderEmail,
      'startupFounderPhone': startupFounderPhone,
      'startupFounderLinkedin': startupFounderLinkedin,
      'startupFounderBio': startupFounderBio,
      'startupSocialWebsite': startupSocialWebsite,
      'startupSocialLinkedin': startupSocialLinkedin,
      'startupSocialProductHunt': startupSocialProductHunt,
      'startupUseOfFunds': startupUseOfFunds,
      'startupTeamSize': startupTeamSize,
      'startupFundingStage': startupFundingStage,
      'startupCurrentlyRaising': startupCurrentlyRaising,
      'startupVisibility': startupVisibility,
      'startupTargetAmount': startupTargetAmount,
      'startupRoundSize': startupRoundSize,
      'startupValuation': startupValuation,
      'startupFundingDeadline': startupFundingDeadline,
      'startupExistingInvestors': startupExistingInvestors,
      'originalStartupName': originalStartupName,
      'originalStartupData': originalStartupData,
      'joinedStartupName': joinedStartupName,
      'joinedStartupData': joinedStartupData,
      'posts': posts.map((p) => p.toJson()).toList(),
    };
  }

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    final roleString = json['role'] as String? ?? 'Professional';
    final activeRoleString = json['activeRole'] as String?;
    final rolesList = (json['roles'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList();

    return AuthSession(
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: roleString,
      onboardingComplete: json['onboardingComplete'] as bool? ?? false,
      activeRole: activeRoleString,
      roles: rolesList,
      username: json['username'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      gender: json['gender'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      profilePhotoLabel: json['profilePhotoLabel'] as String?,
      profilePhotoPath: json['profilePhotoPath'] as String?,
      themePreference: json['themePreference'] as String?,
      startupName: json['startupName'] as String?,
      startupIndustry: json['startupIndustry'] as String?,
      startupStage: json['startupStage'] as String?,
      startupTagline: json['startupTagline'] as String?,
      startupLogoPath: json['startupLogoPath'] as String?,
      startupCoverPath: json['startupCoverPath'] as String?,
      startupCountry: json['startupCountry'] as String?,
      startupCity: json['startupCity'] as String?,
      startupDescription: json['startupDescription'] as String?,
      startupProblem: json['startupProblem'] as String?,
      startupSolution: json['startupSolution'] as String?,
      startupMission: json['startupMission'] as String?,
      startupVision: json['startupVision'] as String?,
      startupWebsite: json['startupWebsite'] as String?,
      startupIncorporationDate: json['startupIncorporationDate'] as String?,
      startupFounderPhotoPath: json['startupFounderPhotoPath'] as String?,
      startupFounderName: json['startupFounderName'] as String?,
      startupFounderDesignation: json['startupFounderDesignation'] as String?,
      startupFounderEmail: json['startupFounderEmail'] as String?,
      startupFounderPhone: json['startupFounderPhone'] as String?,
      startupFounderLinkedin: json['startupFounderLinkedin'] as String?,
      startupFounderBio: json['startupFounderBio'] as String?,
      startupSocialWebsite: json['startupSocialWebsite'] as String?,
      startupSocialLinkedin: json['startupSocialLinkedin'] as String?,
      startupSocialProductHunt: json['startupSocialProductHunt'] as String?,
      startupUseOfFunds: json['startupUseOfFunds'] as String?,
      startupTeamSize: json['startupTeamSize'] as String?,
      startupFundingStage: json['startupFundingStage'] as String?,
      startupCurrentlyRaising: json['startupCurrentlyRaising'] as bool?,
      startupVisibility: json['startupVisibility'] as String?,
      startupTargetAmount: json['startupTargetAmount'] as String?,
      startupRoundSize: json['startupRoundSize'] as String?,
      startupValuation: json['startupValuation'] as String?,
      startupFundingDeadline: json['startupFundingDeadline'] as String?,
      startupExistingInvestors: json['startupExistingInvestors'] as String?,
      originalStartupName: json['originalStartupName'] as String?,
      originalStartupData: (json['originalStartupData'] as Map<String, dynamic>?)?.cast<String, dynamic>(),
      joinedStartupName: json['joinedStartupName'] as String?,
      joinedStartupData: (json['joinedStartupData'] as Map<String, dynamic>?)?.cast<String, dynamic>(),
      posts: (json['posts'] as List<dynamic>?)
              ?.map((e) => StartupPost.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  String toEncodedJson() => jsonEncode(toJson());

  factory AuthSession.fromEncodedJson(String encoded) {
    return AuthSession.fromJson(jsonDecode(encoded) as Map<String, dynamic>);
  }
}
