import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:collabsphere/features/startup/view/screens/company_type_screen.dart';

Future<void> tapNext(WidgetTester tester) async {
  final nextFinder = find.widgetWithText(ElevatedButton, 'Next');
  expect(nextFinder, findsOneWidget);
  await tester.ensureVisible(nextFinder);
  await tester.pumpAndSettle();
  await tester.tap(nextFinder, warnIfMissed: false);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('full stack to partnership with semantics enabled',
      (WidgetTester tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      const MaterialApp(home: CompanyTypeScreen()),
    );
    await tester.pumpAndSettle();

    await tapNext(tester); // -> Basic Information
    expect(find.text('Basic Information'), findsOneWidget);

    await tapNext(tester); // -> PAN & GST Details
    expect(find.text('PAN & GST Details'), findsOneWidget);

    await tapNext(tester); // -> Founder / Owner Details
    expect(find.text('Founder / Owner Details'), findsOneWidget);

    await tapNext(tester); // -> Partnership Details
    expect(find.text('Partnership Details'), findsOneWidget);

    handle.dispose();
  });
}
