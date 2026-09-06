import 'package:collabsphere/features/community/view/screens/community_home_screen.dart';
import 'package:collabsphere/features/home/view/collabster_home/collabster_home_body.dart';
import 'package:collabsphere/features/home/view/collabster_home/collabster_home_screen.dart';
import 'package:collabsphere/features/home/view/collabster_home/home_feed_item.dart';
import 'package:collabsphere/features/home/view/collabster_home/widgets/feed_tabs.dart';
import 'package:collabsphere/features/investor/view/screens/investor_home_screen.dart';
import 'package:collabsphere/features/startup/view/screens/idea_phase_dashboard_screen.dart';
import 'package:collabsphere/features/startup/view/screens/startup_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return ProviderScope(
    child: MaterialApp(home: child),
  );
}

void main() {
  testWidgets('Startup dashboard Home renders header + bottom nav',
      (tester) async {
    await tester.pumpWidget(
        _harness(const StartupDashboardScreen(startupName: 'Acme')));
    await tester.pumpAndSettle();

    expect(find.text('Acme'), findsWidgets);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Switch'), findsOneWidget);
    expect(find.text('Profile'), findsNothing);
  });

  testWidgets('Investor Home renders dashboard header + tabs',
      (tester) async {
    await tester.pumpWidget(_harness(const InvestorHomeScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Investor Hub'), findsWidgets);
    expect(find.text('Quick Actions'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Live Deal Flow'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Live Deal Flow'), findsOneWidget);
    expect(find.text('Switch'), findsOneWidget);
    // No feed tabs or connect promo on the investor dashboard.
    expect(find.byType(FeedTabs), findsNothing);
    expect(find.textContaining('Connect Hub'), findsNothing);
  });

  testWidgets('Community Home renders dashboard, not feed',
      (tester) async {
    await tester.pumpWidget(_harness(const CommunityHomeScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Updates from your communities'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Trending posts'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Trending posts'), findsWidgets);
    expect(
      find.byWidgetPredicate((w) => w is CollabsterHomeBody),
      findsNothing,
    );
  });

  testWidgets('Universal feed screen renders for every user',
      (tester) async {
    await tester.pumpWidget(
        _harness(const CollabsterHomeScreen(activeRole: HomeRole.startup)));
    await tester.pumpAndSettle();

    expect(find.text('For You'), findsOneWidget);
    // Create lives in the center + button now (quick cards removed).
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Post to Anyone'), findsOneWidget);
    // Normal notifications entry point for every user.
    expect(find.byIcon(Icons.notifications_none_rounded), findsWidgets);
  });

    testWidgets('Feed bottom nav opens Explore and Messages', (tester) async {
    await tester.pumpWidget(
        _harness(const CollabsterHomeScreen(activeRole: HomeRole.startup)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    expect(find.text('Suggested people'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Messages'));
    await tester.pumpAndSettle();
    // No session in test → all three role chips shown.
    expect(find.text('Startup'), findsOneWidget);
    expect(find.text('Investor'), findsOneWidget);
    expect(find.text('Community'), findsOneWidget);
  });

  testWidgets('Idea-phase dashboard uses Switch tab like other modes',
      (tester) async {
    await tester.pumpWidget(_harness(const IdeaPhaseDashboardScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Switch'), findsOneWidget);
    expect(find.text('Profile'), findsNothing);

    await tester.tap(find.text('Switch'));
    await tester.pumpAndSettle();
    // Role switcher sheet opens (empty without a session, but the route
    // proves the Switch tab is wired, not the old Profile tab).
    expect(find.byType(BottomSheet), findsOneWidget);
  });

  testWidgets('Idea drawer Founder Profile opens profile tab, no Switch Tab',
      (tester) async {
    await tester.pumpWidget(_harness(const IdeaPhaseDashboardScreen()));
    await tester.pumpAndSettle();

    tester
        .state<ScaffoldState>(find.byType(Scaffold).first)
        .openDrawer();
    await tester.pumpAndSettle();

    // Role Switch Tab must not be in this drawer (workspace switcher stays).
    expect(find.text('Switch Tab'), findsNothing);
    expect(find.text('Switch idea workspace'), findsOneWidget);

    await tester.tap(find.text('Founder Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Contact information'), findsOneWidget);
    expect(find.byType(BottomSheet), findsNothing);
  });
}
