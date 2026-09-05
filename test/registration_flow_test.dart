import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collabsphere/features/startup/view/screens/startup_registration_flow_screen.dart';

void main() {
  testWidgets(
      'Create Startup flow validates, advances all steps and publishes',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: StartupRegistrationFlowScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    Future<void> fillHint(String hint, String value) async {
      await tester.enterText(
        find.widgetWithText(TextFormField, hint),
        value,
      );
      await tester.pump();
    }

    Future<void> next() async {
      await tester.tap(find.text('Next Step'));
      await tester.pumpAndSettle();
    }

    // Step 1 is blocked without required fields.
    await tester.tap(find.text('Next Step'));
    await tester.pumpAndSettle();
    expect(find.text('Create Your Startup'), findsOneWidget);

    // Step 1 — Basic Information.
    await fillHint('e.g. Phoenix Analytics', 'Acme Innovations');
    await fillHint('e.g. FinTech, AI, Health', 'AI');
    await next();
    expect(find.text('Founder Information'), findsOneWidget);

    // Step 2 — Founder Information.
    await fillHint('Enter full name', 'Alex Morgan');
    await fillHint('e.g. CEO & Co-founder', 'CEO & Co-founder');
    await fillHint('name@company.com', 'alex@acme.ai');
    await next();
    expect(find.text('Tell us about your startup'), findsOneWidget);

    // Step 3 — About Startup.
    await fillHint('One sentence describing what you do...',
        'AI analytics for modern teams.');
    await fillHint('What specific pain point are you addressing?',
        'Slow reporting.');
    await fillHint('How does your product solve the problem?',
        'Real-time dashboards.');
    await next();
    expect(find.text('Build Your Brand'), findsOneWidget);

    // Step 4 — Branding (optional).
    await next();
    expect(find.text('Connect Your Startup'), findsOneWidget);

    // Step 5 — Social links (optional).
    await next();
    expect(find.text('Invite Your Team'), findsOneWidget);

    // Step 6 — Team (optional).
    await next();
    expect(find.text('Funding & Investment'), findsOneWidget);

    // Step 7 — Funding.
    await fillHint(
        'Describe how the investment capital will accelerate your business growth...',
        'Hiring engineers.');
    await fillHint('e.g. \$500K', '\$500K');
    await next();
    expect(find.text('Review & Publish'), findsOneWidget);

    // Step 8 — Review shows live data and Edit jumps back.
    expect(find.textContaining('Acme Innovations'), findsWidgets);
    await tester.tap(find.text('Edit').first);
    await tester.pumpAndSettle();
    expect(find.text('Create Your Startup'), findsOneWidget);
    await next();

    // Publish → success screen.
    await tester.tap(find.text('Publish'));
    await tester.pumpAndSettle();
    expect(find.text('Congratulations!'), findsOneWidget);
    expect(find.text('Go to Dashboard'), findsOneWidget);
  });
}
