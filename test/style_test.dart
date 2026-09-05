import 'dart:math' as math;

import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  group('color helpers', () {
    test('rgb and rgba', () {
      expect(rgb(34, 29, 189), const Color.fromRGBO(34, 29, 189, 1.0));
      expect(rgba(34, 29, 189, 0.5), const Color.fromRGBO(34, 29, 189, 0.5));
    });

    test('hex accepts 6 digits with and without a leading #', () {
      expect(hex('#112233'), const Color(0xFF112233));
      expect(hex('112233'), const Color(0xFF112233));
    });

    test('hex accepts 3, 4 and 8 digit forms', () {
      expect(hex('#abc'), const Color(0xFFAABBCC));
      expect(hex('#8abc'), const Color(0x88AABBCC));
      expect(hex('#80112233'), const Color(0x80112233));
    });

    test('hex is case insensitive', () {
      expect(hex('#AABBCC'), hex('#aabbcc'));
    });

    test('hex compares equal to a plain Color', () {
      // Regression: a Color subclass can never equal a Color, which silently
      // broke decoration diffing and animation.
      expect(hex('#112233') == const Color(0xFF112233), isTrue);
      expect(hex('#112233').runtimeType, Color);
    });

    test('hex rejects malformed input', () {
      expect(() => hex('#12345'), throwsFormatException);
      expect(() => hex('nothex'), throwsFormatException);
      expect(() => hex(''), throwsFormatException);
    });
  });

  group('angle formats', () {
    testWidgets('cycles, degrees and radians agree on a quarter turn',
        (tester) async {
      final ParentStyle cycles = ParentStyle()..rotate(0.25);
      final ParentStyle degrees = ParentStyle(angleFormat: AngleFormat.degree)
        ..rotate(90);
      final ParentStyle radians = ParentStyle(angleFormat: AngleFormat.radians)
        ..rotate(math.pi / 2);

      expect(cycles.exportStyle.rotate, closeTo(math.pi / 2, 1e-9));
      expect(degrees.exportStyle.rotate, closeTo(math.pi / 2, 1e-9));
      expect(radians.exportStyle.rotate, closeTo(math.pi / 2, 1e-9));
    });

    test('clone preserves the angle format', () {
      final ParentStyle style = ParentStyle(angleFormat: AngleFormat.degree);
      final ParentStyle cloned = style.clone()..rotate(180);
      expect(cloned.exportStyle.rotate, closeTo(math.pi, 1e-9));
    });
  });

  group('ParentStyle composition', () {
    test('add copies values into an empty style', () {
      final ParentStyle source = ParentStyle()
        ..width(100)
        ..height(50);
      final ParentStyle target = ParentStyle()..add(source);

      expect(target.exportStyle.width, 100);
      expect(target.exportStyle.height, 50);
    });

    test('add keeps existing values unless override is set', () {
      final ParentStyle source = ParentStyle()..width(100);
      final ParentStyle target = ParentStyle()
        ..width(10)
        ..add(source);

      expect(target.exportStyle.width, 10);
    });

    test('add with override replaces existing values', () {
      final ParentStyle source = ParentStyle()..width(100);
      final ParentStyle target = ParentStyle()
        ..width(10)
        ..add(source, override: true);

      expect(target.exportStyle.width, 100);
    });

    test('clone is independent of its source', () {
      final ParentStyle source = ParentStyle()..width(100);
      final ParentStyle cloned = source.clone()..width(200);

      expect(source.exportStyle.width, 100);
      expect(cloned.exportStyle.width, 200);
    });

    test('clone copies sub-model state', () {
      final ParentStyle source = ParentStyle()
        ..background.color(Colors.red)
        ..alignment.center()
        ..overflow.scrollable(Axis.horizontal);
      final ParentStyle cloned = source.clone();

      expect(cloned.exportStyle.backgroundColor, Colors.red);
      expect(cloned.exportStyle.alignment, Alignment.center);
      expect(cloned.exportStyle.overflowDirection, Axis.horizontal);
    });

    test('a cloned style has its own sub-models', () {
      final ParentStyle source = ParentStyle()..background.color(Colors.red);
      final ParentStyle cloned = source.clone()..background.color(Colors.blue);

      expect(source.exportStyle.backgroundColor, Colors.red);
      expect(cloned.exportStyle.backgroundColor, Colors.blue);
    });
  });

  group('TxtStyle composition', () {
    test('add copies both container and text properties', () {
      final TxtStyle source = TxtStyle()
        ..width(100)
        ..fontSize(20)
        ..bold();
      final TxtStyle target = TxtStyle()..add(source);

      expect(target.exportStyle.width, 100);
      expect(target.exportTextStyle.fontSize, 20);
      expect(target.exportTextStyle.fontWeight, FontWeight.bold);
    });

    test('add tolerates null', () {
      expect(() => TxtStyle()..add(null), returnsNormally);
    });

    test('clone carries the editable configuration', () {
      final TxtStyle source = TxtStyle()
        ..editable(
          placeholder: 'ph',
          obscureText: true,
          keyboardType: TextInputType.number,
        );
      final TxtStyle cloned = source.clone();

      expect(cloned.exportTextStyle.editable, isTrue);
      expect(cloned.exportTextStyle.placeholder, 'ph');
      expect(cloned.exportTextStyle.obscureText, isTrue);
      expect(cloned.exportTextStyle.keyboardType, TextInputType.number);
    });

    test('clone carries the text alignment', () {
      final TxtStyle source = TxtStyle()..textAlign.center();
      expect(source.clone().exportTextStyle.textAlign, TextAlign.center);
    });
  });

  group('alignment and overflow models', () {
    test('alignment starts unset', () {
      // Regression: this used to be a late field that threw when read early.
      expect(ParentStyle().alignment.getAlignment, isNull);
      expect(ParentStyle().exportStyle.alignment, isNull);
    });

    test('alignment setters honour the enable flag', () {
      final ParentStyle style = ParentStyle()
        ..alignment.center()
        ..alignment.topLeft(false);

      expect(style.exportStyle.alignment, Alignment.center);
    });

    test('coordinate alignment', () {
      final ParentStyle style = ParentStyle()..alignment.coordinate(0.5, -0.5);
      expect(style.exportStyle.alignment, const Alignment(0.5, -0.5));
    });

    test('overflow setters honour the enable flag', () {
      final ParentStyle style = ParentStyle()
        ..overflow.hidden()
        ..overflow.scrollable(Axis.horizontal, false);

      expect(style.exportStyle.overflow, isNotNull);
      expect(style.exportStyle.overflowDirection, isNull);
    });
  });

  group('Gestures', () {
    testWidgets('exposes the constructor configuration', (tester) async {
      final Gestures gestures =
          Gestures(behavior: HitTestBehavior.opaque, excludeFromSemantics: true)
            ..onTap(() {});

      await tester.pumpWidget(host(Parent(
        style: ParentStyle()
          ..width(20)
          ..height(20),
        gesture: gestures,
        child: const SizedBox(),
      )));

      final GestureDetector detector =
          tester.widget<GestureDetector>(find.byType(GestureDetector).first);
      expect(detector.behavior, HitTestBehavior.opaque);
      expect(detector.excludeFromSemantics, isTrue);
    });
  });
}
