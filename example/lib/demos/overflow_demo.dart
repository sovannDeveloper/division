import 'package:division/division.dart';
import 'package:flutter/material.dart';

import 'common.dart';

/// `overflow.hidden`, `overflow.scrollable` and `overflow.visible`.
class OverflowDemo extends StatelessWidget {
  const OverflowDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Overflow',
      children: <Widget>[
        Demo(
          title: 'overflow.hidden',
          note: 'Clips the child to the widget\'s shape, border radius '
              'included.',
          code: 'ParentStyle()\n'
              '  ..height(70)\n'
              '  ..borderRadius(all: 16)\n'
              '  ..overflow.hidden()',
          child: Parent(
            style: ParentStyle()
              ..width(200)
              ..height(70)
              ..borderRadius(all: 16)
              ..overflow.hidden(),
            child: Parent(
              style: ParentStyle()
                ..width(400)
                ..height(200)
                ..linearGradient(
                  colors: <Color>[hex('#f9d423'), hex('#ff4e50')],
                ),
            ),
          ),
        ),
        Demo(
          title: 'overflow.scrollable',
          note: 'Wraps the child in a scroll view when it is bigger than the '
              'widget.',
          code: 'ParentStyle()\n'
              '  ..height(90)\n'
              '  ..overflow.scrollable(Axis.vertical)',
          child: Parent(
            style: ParentStyle()
              ..width(200)
              ..height(90)
              ..borderRadius(all: 8)
              ..background.hex('#eceff1')
              ..overflow.scrollable(),
            child: Column(
              children: <Widget>[
                for (int i = 1; i <= 8; i++)
                  Parent(
                    style: ParentStyle()
                      ..margin(all: 6)
                      ..padding(all: 8)
                      ..borderRadius(all: 6)
                      ..background.color(Colors.white),
                    child: Txt('Row $i'),
                  ),
              ],
            ),
          ),
        ),
        Demo(
          title: 'overflow.scrollable(Axis.horizontal)',
          code: 'ParentStyle()\n'
              '  ..overflow.scrollable(Axis.horizontal)',
          child: Parent(
            style: ParentStyle()
              ..width(200)
              ..height(70)
              ..borderRadius(all: 8)
              ..background.hex('#eceff1')
              ..overflow.scrollable(Axis.horizontal),
            child: Row(
              children: <Widget>[
                for (int i = 1; i <= 8; i++)
                  Parent(
                    style: ParentStyle()..margin(all: 6),
                    child: box(size: 48, label: '$i'),
                  ),
              ],
            ),
          ),
        ),
        Demo(
          title: 'overflow.visible',
          note: 'Lets the child paint outside the widget\'s bounds.',
          code: 'ParentStyle()\n'
              '  ..height(50)\n'
              '  ..overflow.visible()',
          child: Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: Parent(
              style: ParentStyle()
                ..width(200)
                ..height(50)
                ..borderRadius(all: 8)
                ..background.hex('#eceff1')
                ..overflow.visible(),
              child: Parent(
                style: ParentStyle()
                  ..width(200)
                  ..height(110)
                  ..borderRadius(all: 8)
                  ..opacity(0.7)
                  ..background.color(Colors.deepPurple),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
