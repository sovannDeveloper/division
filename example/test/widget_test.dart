import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/demos/animation_demo.dart';
import 'package:example/demos/composition_demo.dart';
import 'package:example/demos/decoration_demo.dart';
import 'package:example/demos/editable_demo.dart';
import 'package:example/demos/gesture_demo.dart';
import 'package:example/demos/layout_demo.dart';
import 'package:example/demos/overflow_demo.dart';
import 'package:example/demos/showcase_demo.dart';
import 'package:example/demos/text_demo.dart';
import 'package:example/demos/transform_demo.dart';
import 'package:example/main.dart';

/// Gallery tile title -> the page it opens.
const Map<String, Type> _entries = <String, Type>{
  'Showcase': ShowcaseDemo,
  'Layout': LayoutDemo,
  'Decoration': DecorationDemo,
  'Transform': TransformDemo,
  'Overflow': OverflowDemo,
  'Text': TextDemo,
  'Editable text': EditableDemo,
  'Gestures': GestureDemo,
  'Animation': AnimationDemo,
  'Composition': CompositionDemo,
};

/// Opens a gallery entry and asserts its page is actually on screen.
///
/// `scrollUntilVisible` stops as soon as the tile has been *built*, which for a
/// sliver includes its off-screen cache extent, so the tile still has to be
/// scrolled fully into view before it can be tapped.
Future<void> _openEntry(WidgetTester tester, String title) async {
  await tester.pumpWidget(const MyApp());
  await tester.pumpAndSettle();

  final Finder tile = find.text(title);
  await tester.scrollUntilVisible(tile, 120,
      scrollable: find.byType(Scrollable).first);
  await tester.ensureVisible(tile);
  await tester.pumpAndSettle();

  await tester.tap(tile);
  await tester.pumpAndSettle();

  expect(find.byType(_entries[title]!), findsOneWidget,
      reason: 'tapping "$title" should open ${_entries[title]}');
}

/// Jumps the page's scroll position to the end so every demo is built and laid
/// out, failing on the first exception (a layout overflow included).
///
/// The position is driven directly rather than by dragging, because several
/// demos install their own drag recognizers.
Future<void> _scrollToEnd(WidgetTester tester) async {
  final ScrollableState scrollable =
      tester.state(find.byType(Scrollable).first);

  for (int step = 0; step < 40; step++) {
    final ScrollPosition position = scrollable.position;
    if (position.pixels >= position.maxScrollExtent) return;

    position.jumpTo(math.min(position.pixels + 300, position.maxScrollExtent));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }
}

void main() {
  testWidgets('the gallery lists every demo', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    for (final String title in _entries.keys) {
      await tester.scrollUntilVisible(find.text(title), 120,
          scrollable: find.byType(Scrollable).first);
      expect(find.text(title), findsOneWidget);
    }
  });

  for (final MapEntry<String, Type> entry in _entries.entries) {
    testWidgets('${entry.key} opens and renders every demo without error',
        (WidgetTester tester) async {
      await _openEntry(tester, entry.key);
      expect(tester.takeException(), isNull);

      await _scrollToEnd(tester);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('the showcase Follow button toggles',
      (WidgetTester tester) async {
    await _openEntry(tester, 'Showcase');

    expect(find.text('Follow'), findsOneWidget);
    await tester.tap(find.text('Follow'));
    await tester.pumpAndSettle();
    expect(find.text('Following ✓'), findsOneWidget);
  });

  testWidgets('the showcase tab bar switches tabs',
      (WidgetTester tester) async {
    await _openEntry(tester, 'Showcase');

    await tester.tap(find.text('Stats'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('the animation demo expands and collapses',
      (WidgetTester tester) async {
    await _openEntry(tester, 'Animation');

    expect(find.text('Tap to expand'), findsOneWidget);
    await tester.tap(find.text('Tap to expand'));
    await tester.pumpAndSettle();
    expect(find.text('Tap to collapse'), findsOneWidget);
  });

  testWidgets('the editable demo accepts input', (WidgetTester tester) async {
    await _openEntry(tester, 'Editable text');

    await tester.enterText(find.byType(EditableText).first, 'Grace Hopper');
    await tester.pumpAndSettle();

    expect(find.text('Grace Hopper'), findsWidgets);
  });

  testWidgets('the editable demo shows and hides its placeholder',
      (WidgetTester tester) async {
    await _openEntry(tester, 'Editable text');

    expect(find.text('Your name'), findsOneWidget);

    await tester.enterText(find.byType(EditableText).first, 'typed');
    await tester.pumpAndSettle();

    expect(find.text('Your name'), findsNothing);
  });

  testWidgets('the gesture demo logs a tap', (WidgetTester tester) async {
    await _openEntry(tester, 'Gestures');

    await tester.tap(find.text('Tap, double tap or long press'));
    // The surface also listens for a double tap, so the single tap is only
    // resolved once that timeout expires.
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('onTap'), findsOneWidget);
  });
}
