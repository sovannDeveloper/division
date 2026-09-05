import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('the demo page renders every section',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Division'), findsOneWidget);
    expect(find.text('Gradient + elevation'), findsOneWidget);
    expect(find.text('Solid border'), findsOneWidget);
    expect(find.text('Tap me'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping the animated card toggles it',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Tap to expand'), findsOneWidget);

    await tester.tap(find.text('Tap to expand'));
    await tester.pumpAndSettle();

    expect(find.text('Tap to collapse'), findsOneWidget);
  });

  testWidgets('the editable field accepts input', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(EditableText), 'hello');
    await tester.pump();

    expect(find.text('hello'), findsOneWidget);
  });
}
