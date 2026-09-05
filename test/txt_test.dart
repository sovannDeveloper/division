import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  group('Txt rendering', () {
    testWidgets('renders its text', (tester) async {
      await tester.pumpWidget(host(const Txt('hello')));
      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('renders without a style', (tester) async {
      await tester.pumpWidget(host(const Txt('hello')));
      expect(tester.takeException(), isNull);
    });

    testWidgets('applies text styling', (tester) async {
      await tester.pumpWidget(host(Txt(
        'hello',
        style: TxtStyle()
          ..bold()
          ..italic()
          ..fontSize(24)
          ..textColor(Colors.red)
          ..letterSpacing(2)
          ..wordSpacing(3)
          ..textDecoration(TextDecoration.underline),
      )));

      final TextStyle style = tester.widget<Text>(find.text('hello')).style!;
      expect(style.fontWeight, FontWeight.bold);
      expect(style.fontStyle, FontStyle.italic);
      expect(style.fontSize, 24);
      expect(style.color, Colors.red);
      expect(style.letterSpacing, 2);
      expect(style.wordSpacing, 3);
      expect(style.decoration, TextDecoration.underline);
    });

    testWidgets('bold(false) and italic(false) are no-ops', (tester) async {
      await tester.pumpWidget(host(Txt(
        'hello',
        style: TxtStyle()
          ..bold(false)
          ..italic(false),
      )));

      final TextStyle style = tester.widget<Text>(find.text('hello')).style!;
      expect(style.fontWeight, isNull);
      expect(style.fontStyle, FontStyle.normal);
    });

    testWidgets('applies alignment, maxLines and overflow', (tester) async {
      await tester.pumpWidget(host(Txt(
        'hello there this is a long piece of text',
        style: TxtStyle()
          ..width(60)
          ..maxLines(1)
          ..textOverflow(TextOverflow.ellipsis)
          ..textAlign.center(),
      )));

      final Text text = tester.widget<Text>(find.byType(Text));
      expect(text.textAlign, TextAlign.center);
      expect(text.maxLines, 1);
      expect(text.overflow, TextOverflow.ellipsis);
    });

    testWidgets('textElevation produces a shadow', (tester) async {
      await tester.pumpWidget(host(Txt(
        'hello',
        style: TxtStyle()..textElevation(10),
      )));

      expect(
          tester.widget<Text>(find.text('hello')).style!.shadows, hasLength(1));
    });

    testWidgets('container styling applies to Txt too', (tester) async {
      await tester.pumpWidget(host(Txt(
        'hello',
        style: TxtStyle()
          ..padding(all: 8)
          ..background.color(Colors.blue),
      )));

      expect(decorationOf(tester).color, Colors.blue);
    });

    testWidgets('gestures fire on a Txt', (tester) async {
      int taps = 0;
      await tester.pumpWidget(host(Txt(
        'hello',
        gesture: Gestures()..onTap(() => taps++),
      )));

      await tester.tap(find.text('hello'));
      expect(taps, 1);
    });
  });

  group('Txt editable', () {
    testWidgets('shows the given text, not the placeholder', (tester) async {
      await tester.pumpWidget(host(Txt(
        'hello',
        style: TxtStyle()..editable(placeholder: 'type here'),
      )));

      expect(find.text('hello'), findsOneWidget);
      expect(find.text('type here'), findsNothing);
    });

    testWidgets('shows the placeholder only while empty and unfocused',
        (tester) async {
      await tester.pumpWidget(host(Txt(
        '',
        style: TxtStyle()..editable(placeholder: 'type here'),
      )));

      expect(find.text('type here'), findsOneWidget);

      await tester.tap(find.byType(EditableText));
      await tester.pump();
      expect(find.text('type here'), findsNothing);
    });

    testWidgets('accepts input and reports it through onChange',
        (tester) async {
      String? seen;
      await tester.pumpWidget(host(Txt(
        '',
        style: TxtStyle()..editable(onChange: (String v) => seen = v),
      )));

      await tester.enterText(find.byType(EditableText), 'abc');
      expect(seen, 'abc');
    });

    testWidgets('honours obscureText', (tester) async {
      await tester.pumpWidget(host(Txt(
        'secret',
        style: TxtStyle()..editable(obscureText: true),
      )));

      expect(tester.widget<EditableText>(find.byType(EditableText)).obscureText,
          isTrue);
    });

    testWidgets('a cloned editable style keeps placeholder and obscureText',
        (tester) async {
      final TxtStyle base = TxtStyle()
        ..editable(placeholder: 'ph', obscureText: true);

      await tester.pumpWidget(host(Txt('', style: base.clone())));

      expect(tester.takeException(), isNull);
      expect(find.text('ph'), findsOneWidget);
      expect(tester.widget<EditableText>(find.byType(EditableText)).obscureText,
          isTrue);
    });

    testWidgets('an externally supplied FocusNode is not disposed',
        (tester) async {
      final FocusNode focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(host(Txt(
        'a',
        style: TxtStyle()..editable(focusNode: focusNode),
      )));
      await tester.pumpWidget(host(const SizedBox()));

      // Throws a "used after being disposed" assertion if the widget disposed
      // a node it did not create.
      focusNode.requestFocus();
    });

    testWidgets('an internally created FocusNode is disposed', (tester) async {
      await tester.pumpWidget(host(Txt(
        'a',
        style: TxtStyle()..editable(),
      )));
      await tester.pumpWidget(host(const SizedBox()));

      expect(tester.takeException(), isNull);
    });

    testWidgets('onFocusChange fires', (tester) async {
      final List<bool?> events = <bool?>[];
      await tester.pumpWidget(host(Txt(
        '',
        style: TxtStyle()..editable(onFocusChange: events.add),
      )));

      await tester.tap(find.byType(EditableText));
      await tester.pump();
      expect(events, <bool>[true]);
    });

    testWidgets('editable() does not clobber a maxLines set earlier',
        (tester) async {
      await tester.pumpWidget(host(Txt(
        'a',
        style: TxtStyle()
          ..maxLines(4)
          ..editable(),
      )));

      expect(
          tester.widget<EditableText>(find.byType(EditableText)).maxLines, 4);
    });

    testWidgets('a new text value replaces the field contents', (tester) async {
      Widget build(String text) =>
          host(Txt(text, style: TxtStyle()..editable()));

      await tester.pumpWidget(build('one'));
      expect(find.text('one'), findsOneWidget);

      await tester.pumpWidget(build('two'));
      expect(find.text('two'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Txt animation', () {
    testWidgets('animates the font size', (tester) async {
      Widget build(double size) => host(Txt(
            'hello',
            style: TxtStyle()
              ..fontSize(size)
              ..animate(200),
          ));

      await tester.pumpWidget(build(10));
      expect(tester.widget<Text>(find.text('hello')).style!.fontSize, 10);

      await tester.pumpWidget(build(30));
      await tester.pump(const Duration(milliseconds: 100));
      final double mid =
          tester.widget<Text>(find.text('hello')).style!.fontSize!;
      expect(mid, greaterThan(10));
      expect(mid, lessThan(30));

      await tester.pumpAndSettle();
      expect(tester.widget<Text>(find.text('hello')).style!.fontSize, 30);
    });

    testWidgets('animating never mutates the caller\'s style', (tester) async {
      final TxtStyle style = TxtStyle()
        ..fontSize(10)
        ..textColor(Colors.red)
        ..animate(200);

      await tester.pumpWidget(host(Txt('hello', style: style)));
      await tester.pump(const Duration(milliseconds: 80));

      expect(style.exportTextStyle.fontSize, 10);
      expect(style.exportTextStyle.textColor, Colors.red);
    });

    testWidgets('an animated editable field still edits', (tester) async {
      await tester.pumpWidget(host(Txt(
        '',
        style: TxtStyle()
          ..editable(placeholder: 'ph')
          ..animate(100),
      )));

      await tester.enterText(find.byType(EditableText), 'abc');
      await tester.pumpAndSettle();
      expect(find.text('abc'), findsOneWidget);
    });
  });
}
