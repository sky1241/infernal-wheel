import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infernal_wheel/views/onboarding_screen.dart';
import 'package:infernal_wheel/views/pin_screen.dart';

void main() {
  testWidgets('Onboarding screen renders', (WidgetTester tester) async {
    var continued = false;
    await tester.pumpWidget(MaterialApp(
      home: OnboardingScreen(onContinue: () => continued = true),
    ));

    expect(find.text('InfernalWheel'), findsOneWidget);
    expect(find.text('Commencer'), findsOneWidget);
    expect(find.text('Donnees privees'), findsOneWidget);
    expect(find.text('Zero internet'), findsOneWidget);

    await tester.tap(find.text('Commencer'));
    expect(continued, true);
  });

  testWidgets('PIN screen renders in setup mode', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: PinScreen(isSetup: true, onSuccess: () {}),
    ));

    expect(find.text('InfernalWheel'), findsOneWidget);
    expect(find.text('Choisissez un code PIN (4-6 chiffres)\npour proteger vos donnees'), findsOneWidget);

    // Tap digits
    await tester.tap(find.text('1'));
    await tester.tap(find.text('2'));
    await tester.tap(find.text('3'));
    await tester.tap(find.text('4'));
    await tester.pump();

    // Suivant button should be enabled
    expect(find.text('Suivant'), findsOneWidget);
  });

  testWidgets('PIN screen renders in unlock mode', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: PinScreen(isSetup: false, onSuccess: () {}),
    ));

    expect(find.text('Deverrouillage'), findsOneWidget);
    expect(find.text('Entrez votre code PIN'), findsOneWidget);
    expect(find.text('Deverrouiller'), findsOneWidget);
  });
}
