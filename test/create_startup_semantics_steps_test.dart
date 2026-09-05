import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collabsphere/features/startup/view/screens/startup_registration_flow_screen.dart';

void main() {
  testWidgets('Registration flow steps advance with semantics enabled',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: StartupRegistrationFlowScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Open the stage dropdown (overlay + semantics interaction).
    await tester.tap(find.text('Seed').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Growth').last);
    await tester.pumpAndSettle();

    Future<void> fillHint(String hint, String value) async {
      await tester.enterText(
        find.widgetWithText(TextFormField, hint),
        value,
      );
      await tester.pump();
    }

    await fillHint('e.g. Phoenix Analytics', 'Acme Innovations');
    await fillHint('e.g. FinTech, AI, Health', 'AI');
    await tester.tap(find.text('Next Step'));
    await tester.pumpAndSettle();
    expect(find.text('Founder Information'), findsOneWidget);

    handle.dispose();
  });
}
