import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps [child] in the minimum material scaffolding the widgets need.
Widget host(Widget child) => MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );

/// The [BoxDecoration] the widget under test painted.
BoxDecoration decorationOf(WidgetTester tester, {Type of = Object}) {
  final Finder finder = find.descendant(
    of: find.byWidgetPredicate((Widget w) =>
        w.runtimeType.toString() == 'Parent' ||
        w.runtimeType.toString() == 'Txt'),
    matching: find.byType(DecoratedBox),
  );
  return tester.widget<DecoratedBox>(finder.first).decoration as BoxDecoration;
}
