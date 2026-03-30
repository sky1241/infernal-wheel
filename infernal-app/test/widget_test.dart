import 'package:flutter_test/flutter_test.dart';
import 'package:infernal_wheel/main.dart';

void main() {
  testWidgets('App launches without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const InfernalWheelApp());
    await tester.pumpAndSettle();

    // Verify the app renders the home screen
    expect(find.text('Aujourd\'hui'), findsOneWidget);
  });
}
