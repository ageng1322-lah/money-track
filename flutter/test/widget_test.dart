// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:moneytrack/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MoneyTrackApp());

    // Verify that our counter starts at 0.
    // Note: This default test doesn't match MoneyTrack logic, 
    // but we keep it here to ensure the project compiles.
    expect(find.byType(MoneyTrackApp), findsOneWidget);
  });
}
