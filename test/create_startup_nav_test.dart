import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collabsphere/features/startup/view/screens/startup_landing_screen.dart';
import 'package:collabsphere/features/startup/view/screens/startup_registration_flow_screen.dart';
import 'package:collabsphere/features/startup/view/screens/startup_registration_intro_screen.dart';

void main() {
  testWidgets('Tapping Create Startup opens the registration flow with content',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: StartupLandingScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Create Startup'), findsWidgets);
    await tester.tap(find.text('Create Startup').last);
    await tester.pumpAndSettle();

    expect(find.byType(StartupRegistrationIntroScreen), findsOneWidget);
    expect(find.text('Start Registration'), findsOneWidget);

    await tester.tap(find.text('Start Registration'));
    await tester.pumpAndSettle();

    expect(find.byType(StartupRegistrationFlowScreen), findsOneWidget);
    expect(find.text('Create Your Startup'), findsOneWidget);
    expect(find.text('Startup Name'), findsOneWidget);
  });
}
