import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  group('Parent layout', () {
    testWidgets('applies width and height', (tester) async {
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()
          ..width(120)
          ..height(40),
        child: const SizedBox(),
      )));

      expect(tester.getSize(find.byType(Parent)), const Size(120, 40));
    });

    testWidgets('applies min/max constraints', (tester) async {
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()
          ..minWidth(50)
          ..maxWidth(80)
          ..minHeight(10)
          ..maxHeight(30),
        child: const SizedBox(width: 1000, height: 1000),
      )));

      expect(tester.getSize(find.byType(Parent)), const Size(80, 30));
    });

    testWidgets('padding and margin both take effect', (tester) async {
      const Key inner = Key('inner');
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()
          ..padding(all: 10)
          ..margin(all: 5),
        child: const SizedBox(key: inner, width: 20, height: 20),
      )));

      expect(tester.getSize(find.byType(Parent)), const Size(50, 50));
      expect(tester.getSize(find.byKey(inner)), const Size(20, 20));
    });

    testWidgets('padding sides can be overridden individually', (tester) async {
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()..padding(all: 10, bottom: 30),
        child: const SizedBox(width: 20, height: 20),
      )));

      expect(tester.getSize(find.byType(Parent)), const Size(40, 60));
    });

    testWidgets('renders without a child', (tester) async {
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()
          ..width(30)
          ..height(30)
          ..background.color(Colors.red),
      )));

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(Parent)), const Size(30, 30));
    });

    testWidgets('renders with neither style nor child', (tester) async {
      await tester.pumpWidget(host(const Parent()));
      expect(tester.takeException(), isNull);
    });
  });

  group('Parent decoration', () {
    testWidgets('background color reaches the BoxDecoration', (tester) async {
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()..background.color(const Color(0xFF00FF00)),
        child: const SizedBox(width: 10, height: 10),
      )));

      expect(decorationOf(tester).color, const Color(0xFF00FF00));
    });

    testWidgets('hex/rgb helpers reach the BoxDecoration', (tester) async {
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()..background.hex('#112233'),
        child: const SizedBox(width: 10, height: 10),
      )));

      expect(decorationOf(tester).color, const Color(0xFF112233));
    });

    testWidgets('blend mode is not dropped', (tester) async {
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()
          ..background.color(Colors.red)
          ..background.blendMode(BlendMode.multiply),
        child: const SizedBox(width: 10, height: 10),
      )));

      expect(decorationOf(tester).backgroundBlendMode, BlendMode.multiply);
    });

    testWidgets('border adds to the effective padding', (tester) async {
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()
          ..background.color(Colors.red)
          ..border(all: 4),
        child: const SizedBox(width: 20, height: 20),
      )));

      expect(tester.getSize(find.byType(Parent)), const Size(28, 28));
    });

    testWidgets('borderRadius corners can be set individually', (tester) async {
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()
          ..background.color(Colors.red)
          ..borderRadius(all: 4, topLeft: 12),
        child: const SizedBox(width: 10, height: 10),
      )));

      expect(
        decorationOf(tester).borderRadius,
        const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(4),
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
      );
    });

    testWidgets('circle sets the box shape', (tester) async {
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()
          ..background.color(Colors.red)
          ..circle(),
        child: const SizedBox(width: 10, height: 10),
      )));

      expect(decorationOf(tester).shape, BoxShape.circle);
    });

    testWidgets('elevation produces a box shadow', (tester) async {
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()
          ..background.color(Colors.red)
          ..elevation(10),
        child: const SizedBox(width: 10, height: 10),
      )));

      expect(decorationOf(tester).boxShadow, hasLength(1));
    });

    testWidgets('zero elevation adds no shadow', (tester) async {
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()
          ..background.color(Colors.red)
          ..elevation(0),
        child: const SizedBox(width: 10, height: 10),
      )));

      expect(decorationOf(tester).boxShadow, isNull);
    });

    testWidgets('gradients are applied', (tester) async {
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()
          ..linearGradient(colors: const <Color>[Colors.red, Colors.blue]),
        child: const SizedBox(width: 10, height: 10),
      )));

      expect(decorationOf(tester).gradient, isA<LinearGradient>());
    });

    testWidgets('background.image requires a source', (tester) async {
      expect(() => ParentStyle()..background.image(), throwsArgumentError);
    });
  });

  group('Parent overflow', () {
    testWidgets('scrollable wraps in a scroll view', (tester) async {
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()
          ..height(20)
          ..overflow.scrollable(),
        child: const SizedBox(height: 500, width: 10),
      )));

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('hidden clips', (tester) async {
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()
          ..height(20)
          ..borderRadius(all: 6)
          ..background.color(Colors.red)
          ..overflow.hidden(),
        child: const SizedBox(height: 500, width: 10),
      )));

      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('hidden without a border radius does not crash',
        (tester) async {
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()
          ..height(20)
          ..overflow.hidden(),
        child: const SizedBox(height: 500, width: 10),
      )));

      expect(tester.takeException(), isNull);
    });

    testWidgets('visible overflows its parent', (tester) async {
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()
          ..height(20)
          ..overflow.visible(),
        child: const SizedBox(height: 500, width: 10),
      )));

      expect(find.byType(OverflowBox), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Parent transform and effects', () {
    testWidgets('rotate/scale/offset build a transform', (tester) async {
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()
          ..rotate(0.25)
          ..scale(2)
          ..offset(4, 5),
        child: const SizedBox(width: 10, height: 10),
      )));

      expect(
          find.descendant(
              of: find.byType(Parent), matching: find.byType(Transform)),
          findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('opacity is applied', (tester) async {
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()..opacity(0.5),
        child: const SizedBox(width: 10, height: 10),
      )));

      expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 0.5);
    });

    testWidgets('background blur without a border radius does not crash',
        (tester) async {
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()
          ..width(20)
          ..height(20)
          ..background.blur(6),
        child: const SizedBox(),
      )));

      expect(tester.takeException(), isNull);
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('ripple renders an InkWell', (tester) async {
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()
          ..width(20)
          ..height(20)
          ..ripple(true),
        child: const SizedBox(),
      )));

      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('dash border paints without hanging on zero lengths',
        (tester) async {
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()
          ..width(20)
          ..height(20)
          ..dashBorder(dashLength: 0, gapLength: 0),
        child: const SizedBox(),
      )));

      expect(tester.takeException(), isNull);
    });

    testWidgets('dash border paints normally', (tester) async {
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()
          ..width(40)
          ..height(40)
          ..borderRadius(all: 8)
          ..dashBorder(color: Colors.orange, strokeWidth: 1),
        child: const SizedBox(),
      )));

      expect(tester.takeException(), isNull);
    });
  });

  group('Parent gestures', () {
    testWidgets('onTap fires', (tester) async {
      int taps = 0;
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()
          ..width(50)
          ..height(50),
        gesture: Gestures()..onTap(() => taps++),
        child: const SizedBox(),
      )));

      await tester.tap(find.byType(Parent));
      expect(taps, 1);
    });

    testWidgets('gestures work with a tight style and no child',
        (tester) async {
      int taps = 0;
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()
          ..width(50)
          ..height(50),
        gesture: Gestures()..onTap(() => taps++),
      )));

      expect(tester.takeException(), isNull);
      await tester.tap(find.byType(Parent));
      expect(taps, 1);
    });

    testWidgets('isTap reports both edges of a press', (tester) async {
      final List<bool> states = <bool>[];
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()
          ..width(50)
          ..height(50),
        gesture: Gestures()..isTap(states.add),
        child: const SizedBox(),
      )));

      await tester.tap(find.byType(Parent));
      expect(states, <bool>[true, false]);
    });

    testWidgets('the padding area is tappable', (tester) async {
      // Regression: the detector used to defer to a child that does not hit
      // test, so taps outside the child were silently dropped.
      int taps = 0;
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()..padding(all: 40),
        gesture: Gestures()..onTap(() => taps++),
        child: const SizedBox(width: 10, height: 10),
      )));

      final Offset topLeft = tester.getTopLeft(find.byType(Parent));
      await tester.tapAt(topLeft + const Offset(5, 5));
      expect(taps, 1);
    });

    testWidgets('onLongPress fires', (tester) async {
      int count = 0;
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()
          ..width(50)
          ..height(50),
        gesture: Gestures()..onLongPress(() => count++),
        child: const SizedBox(),
      )));

      await tester.longPress(find.byType(Parent));
      expect(count, 1);
    });
  });

  group('Parent animation', () {
    testWidgets('animates towards the new value', (tester) async {
      Widget build(double width) => host(Parent(
            style: ParentStyle()
              ..width(width)
              ..height(20)
              ..animate(200),
            child: const SizedBox(),
          ));

      await tester.pumpWidget(build(50));
      expect(tester.getSize(find.byType(Parent)).width, 50);

      await tester.pumpWidget(build(150));
      await tester.pump(const Duration(milliseconds: 100));
      final double mid = tester.getSize(find.byType(Parent)).width;
      expect(mid, greaterThan(50));
      expect(mid, lessThan(150));

      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(Parent)).width, 150);
    });

    testWidgets('animating never mutates the caller\'s style', (tester) async {
      final ParentStyle style = ParentStyle()
        ..width(50)
        ..height(50)
        ..background.color(Colors.red)
        ..borderRadius(all: 8)
        ..animate(200);

      await tester
          .pumpWidget(host(Parent(style: style, child: const SizedBox())));
      await tester.pump(const Duration(milliseconds: 80));

      expect(style.exportStyle.width, 50);
      expect(style.exportStyle.decoration?.color, Colors.red);
      expect(style.exportStyle.borderRadius, BorderRadius.circular(8));

      // The same style instance must still render correctly unanimated.
      await tester.pumpWidget(host(Parent(
        style: ParentStyle()..add(style),
        child: const SizedBox(),
      )));
      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(Parent)), const Size(50, 50));
    });

    testWidgets('a duration without a curve does not crash', (tester) async {
      final ParentStyle style = ParentStyle()
        ..width(50)
        ..height(50);
      style.exportStyle.duration = const Duration(milliseconds: 100);

      await tester
          .pumpWidget(host(Parent(style: style, child: const SizedBox())));
      expect(tester.takeException(), isNull);
    });
  });
}
