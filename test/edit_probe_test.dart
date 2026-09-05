import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collabsphere/features/startup/view/screens/startup_registration_flow_screen.dart';
import 'package:collabsphere/core/di/providers.dart';

void main() {
  testWidgets('probe Edit navigation', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: StartupRegistrationFlowScreen()),
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

    await fillHint('e.g. Phoenix Analytics', 'Acme Innovations');
    await fillHint('e.g. FinTech, AI, Health', 'AI');
    await next();
    await fillHint('Enter full name', 'Alex Morgan');
    await fillHint('e.g. CEO & Co-founder', 'CEO');
    await fillHint('name@company.com', 'alex@acme.ai');
    await next();
    await fillHint('One sentence describing what you do...', 'AI analytics.');
    await fillHint(
        'What specific pain point are you addressing?', 'Slow reporting.');
    await fillHint(
        'How does your product solve the problem?', 'Dashboards.');
    await next();
    await next();
    await next();
    await next();
    await fillHint(
        'Describe how the investment capital will accelerate your business growth...',
        'Hiring.');
    await fillHint('e.g. \$500K', '\$500K');
    await next();

    debugPrint(
        'EDIT COUNT: ${find.text('Edit').evaluate().length}');

    final container =
        ProviderScope.containerOf(tester.element(find.byType(Scaffold)));

    final center = tester.getCenter(find.text('Edit').first);
    final result = tester.hitTestOnBinding(center);
    debugPrint('HIT PATH: ${result.path.map((e) => e.target.runtimeType).toList()}');

    final btn = tester.widget<TextButton>(
      find
          .ancestor(
            of: find.text('Edit').first,
            matching: find.byType(TextButton),
          )
          .first,
    );
    debugPrint('BUTTON ENABLED: ${btn.onPressed != null}');
    btn.onPressed!();
    await tester.pumpAndSettle();

    debugPrint(
        'STEP AFTER DIRECT CALLBACK: ${container.read(registrationViewModelProvider).currentStep}');
    debugPrint(
        'CREATE TITLE: ${find.text('Create Your Startup').evaluate().length}');
  });
}
