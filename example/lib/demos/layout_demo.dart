import 'package:division/division.dart';
import 'package:flutter/material.dart';

import 'common.dart';

/// `width`, `height`, the min/max constraints, `padding`, `margin`,
/// `alignment` and `alignmentContent`.
class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Layout',
      children: <Widget>[
        Demo(
          title: 'width / height',
          code: 'ParentStyle()\n'
              '  ..width(160)\n'
              '  ..height(60)',
          child: Parent(
            style: ParentStyle()
              ..width(160)
              ..height(60)
              ..borderRadius(all: 8)
              ..background.color(Colors.blue),
          ),
        ),
        Demo(
          title: 'minWidth / maxWidth / minHeight / maxHeight',
          note: 'The child asks for 400x400 but is clamped by the constraints.',
          code: 'ParentStyle()\n'
              '  ..minWidth(80)\n'
              '  ..maxWidth(200)\n'
              '  ..minHeight(40)\n'
              '  ..maxHeight(70)',
          child: Parent(
            style: ParentStyle()
              ..minWidth(80)
              ..maxWidth(200)
              ..minHeight(40)
              ..maxHeight(70)
              ..borderRadius(all: 8)
              ..background.color(Colors.teal),
            child: const SizedBox(width: 400, height: 400),
          ),
        ),
        Demo(
          title: 'padding',
          note: 'Single sides trump `all`, and both apply together.',
          code: 'ParentStyle()\n'
              '  ..padding(all: 12, bottom: 32)',
          child: Parent(
            style: ParentStyle()
              ..padding(all: 12, bottom: 32)
              ..borderRadius(all: 8)
              ..background.color(Colors.orange),
            child: box(size: 48, color: Colors.deepOrange),
          ),
        ),
        Demo(
          title: 'padding(horizontal:, vertical:)',
          code: 'ParentStyle()\n'
              '  ..padding(horizontal: 32, vertical: 8)',
          child: Parent(
            style: ParentStyle()
              ..padding(horizontal: 32, vertical: 8)
              ..borderRadius(all: 8)
              ..background.color(Colors.orange),
            child: box(size: 48, color: Colors.deepOrange),
          ),
        ),
        Demo(
          title: 'margin',
          note: 'Empty space outside the decoration. Same named parameters as '
              '`padding`.',
          code: 'ParentStyle()\n'
              '  ..margin(left: 40, vertical: 8)',
          child: Parent(
            style: ParentStyle()
              ..background.hex('#eceff1')
              ..borderRadius(all: 8),
            child: Parent(
              style: ParentStyle()
                ..margin(left: 40, vertical: 8)
                ..borderRadius(all: 8)
                ..background.color(Colors.purple),
              child: box(size: 48, color: Colors.purple),
            ),
          ),
        ),
        Demo(
          title: 'alignmentContent',
          note: 'Aligns the child inside this widget.',
          code: 'ParentStyle()\n'
              '  ..height(90)\n'
              '  ..alignmentContent.bottomRight()',
          child: Parent(
            style: ParentStyle()
              ..width(200)
              ..height(90)
              ..borderRadius(all: 8)
              ..background.hex('#eceff1')
              ..alignmentContent.bottomRight(),
            child: box(size: 36, color: Colors.indigo),
          ),
        ),
        Demo(
          title: 'alignmentContent.coordinate',
          note: 'Free positioning from (-1, -1) to (1, 1).',
          code: 'ParentStyle()\n'
              '  ..alignmentContent.coordinate(0.4, -0.6)',
          child: Parent(
            style: ParentStyle()
              ..width(200)
              ..height(90)
              ..borderRadius(all: 8)
              ..background.hex('#eceff1')
              ..alignmentContent.coordinate(0.4, -0.6),
            child: box(size: 36, color: Colors.indigo),
          ),
        ),
        Demo(
          title: 'alignment',
          note: 'Aligns this widget inside its own parent.',
          code: 'ParentStyle()\n'
              '  ..alignment.centerRight()',
          child: SizedBox(
            width: double.infinity,
            child: Parent(
              style: ParentStyle()..alignment.centerRight(),
              child: box(size: 44, color: Colors.pink),
            ),
          ),
        ),
        Demo(
          title: 'Every alignment preset',
          code:
              '..alignmentContent.topLeft()      ..centerLeft()    ..bottomLeft()\n'
              '..alignmentContent.topCenter()    ..center()        ..bottomCenter()\n'
              '..alignmentContent.topRight()     ..centerRight()   ..bottomRight()',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              _alignmentCell(
                  'topLeft', (ParentStyle s) => s.alignmentContent.topLeft()),
              _alignmentCell('topCenter',
                  (ParentStyle s) => s.alignmentContent.topCenter()),
              _alignmentCell(
                  'topRight', (ParentStyle s) => s.alignmentContent.topRight()),
              _alignmentCell('centerLeft',
                  (ParentStyle s) => s.alignmentContent.centerLeft()),
              _alignmentCell(
                  'center', (ParentStyle s) => s.alignmentContent.center()),
              _alignmentCell('centerRight',
                  (ParentStyle s) => s.alignmentContent.centerRight()),
              _alignmentCell('bottomLeft',
                  (ParentStyle s) => s.alignmentContent.bottomLeft()),
              _alignmentCell('bottomCenter',
                  (ParentStyle s) => s.alignmentContent.bottomCenter()),
              _alignmentCell('bottomRight',
                  (ParentStyle s) => s.alignmentContent.bottomRight()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _alignmentCell(String label, void Function(ParentStyle) align) {
    final ParentStyle style = ParentStyle()
      ..width(72)
      ..height(56)
      ..borderRadius(all: 6)
      ..background.hex('#eceff1');
    align(style);

    return Labelled(
      label: label,
      child: Parent(
        style: style,
        child: box(size: 18, color: Colors.indigo),
      ),
    );
  }
}
