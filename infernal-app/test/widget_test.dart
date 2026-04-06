import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infernal_wheel/views/onboarding_screen.dart';

void main() {
  testWidgets('Onboarding screen renders', (WidgetTester tester) async {
    var continued = false;
    await tester.pumpWidget(MaterialApp(
      home: OnboardingScreen(onContinue: () => continued = true),
    ));

    expect(find.text('-1+'), findsOneWidget);
    expect(find.text('Commencer'), findsOneWidget);
    expect(find.text('Donnees privees'), findsOneWidget);

    await tester.tap(find.text('Commencer'));
    expect(continued, true);
  });
}
