
import 'package:flutter_test/flutter_test.dart';

import 'package:valper_app/main.dart';
void main() {
  testWidgets('Splash screen loads with Get Started button', (WidgetTester tester) async {
    await tester.pumpWidget(const ValperApp());

    // Check splash screen welcome text and Get Started button
    expect(find.text('Welcome to VALPER!'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
