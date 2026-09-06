import 'package:flutter/material.dart';

import '../../shared/enums/app_enums.dart';
import '../../features/auth/model/auth_session.dart';
import '../../features/home/view/home_screen.dart';
import '../../features/home/view/home_dashboard_screen.dart';
import '../../features/investor/view/screens/investor_home_screen.dart';
import '../../features/investor/view/screens/investor_verification_flow_screen.dart';
import '../../features/community/view/screens/community_home_screen.dart';
import '../../features/startup/view/screens/startup_landing_screen.dart';

Widget buildDashboardForRole(AuthSession session) {
  final activeRole = session.activeUserRole;

  if (activeRole.isStartupRole) {
    return StartupLandingScreen(selectedRole: activeRole.label);
  }

  switch (activeRole) {
    case UserRole.investor:
      return session.investorVerificationComplete
          ? const InvestorHomeScreen()
          : const InvestorVerificationFlowScreen();
    case UserRole.creator:
    case UserRole.influencer:
      return const CommunityHomeScreen();
    case UserRole.other:
      return const HomeDashboardScreen();
    default:
      return const HomeScreen();
  }
}
