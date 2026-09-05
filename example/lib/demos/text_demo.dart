import 'package:division/division.dart';
import 'package:flutter/material.dart';

import 'common.dart';

/// Everything `TxtStyle` adds on top of the shared container styling.
class TextDemo extends StatelessWidget {
  const TextDemo({super.key});

  static const String _sample = 'The quick brown fox';

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Text',
      children: <Widget>[
        Demo(
          title: 'bold / italic / fontWeight',
          code: '..bold()\n'
              '..italic()\n'
              '..fontWeight(FontWeight.w300)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Txt(_sample, style: TxtStyle()..bold()),
              Txt(_sample, style: TxtStyle()..italic()),
              Txt(_sample, style: TxtStyle()..fontWeight(FontWeight.w300)),
            ],
          ),
        ),
        Demo(
          title: 'fontSize / textColor',
          code: '..fontSize(22)\n'
              "..textColor(hex('#e91e63'))",
          child: Txt(
            _sample,
            style: TxtStyle()
              ..fontSize(22)
              ..textColor(hex('#e91e63')),
          ),
        ),
        Demo(
          title: 'fontFamily',
          note: 'Families declared in the example\'s pubspec.yaml. '
              '`fontFamilyFallback` takes a list of alternatives.',
          code: "..fontFamily('Roboto')\n"
              "..fontFamily('Battambang', fontFamilyFallback: ['Roboto'])",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Txt(
                _sample,
                style: TxtStyle()
                  ..fontSize(18)
                  ..fontFamily('Roboto'),
              ),
              Txt(
                'ភាសាខ្មែរ · $_sample',
                style: TxtStyle()
                  ..fontSize(18)
                  ..fontFamily('Battambang',
                      fontFamilyFallback: <String>['Roboto']),
              ),
            ],
          ),
        ),
        Demo(
          title: 'letterSpacing / wordSpacing',
          code: '..letterSpacing(3)\n'
              '..wordSpacing(14)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Txt(_sample, style: TxtStyle()..letterSpacing(3)),
              Txt(_sample, style: TxtStyle()..wordSpacing(14)),
            ],
          ),
        ),
        Demo(
          title: 'textDecoration',
          code: '..textDecoration(TextDecoration.underline)\n'
              '..textDecoration(TextDecoration.lineThrough)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Txt(
                _sample,
                style: TxtStyle()..textDecoration(TextDecoration.underline),
              ),
              Txt(
                _sample,
                style: TxtStyle()
                  ..textDecoration(TextDecoration.lineThrough)
                  ..textColor(Colors.black45),
              ),
            ],
          ),
        ),
        Demo(
          title: 'textAlign',
          note: 'left, right, center, justify, start and end.',
          code: '..textAlign.center()\n'
              '..textAlign.right()\n'
              '..textAlign.justify()',
          child: Column(
            children: <Widget>[
              for (final MapEntry<String, void Function(TxtStyle)> entry
                  in <String, void Function(TxtStyle)>{
                'center': (TxtStyle s) => s.textAlign.center(),
                'right': (TxtStyle s) => s.textAlign.right(),
                'justify': (TxtStyle s) => s.textAlign.justify(),
              }.entries)
                _alignedBlock(entry.key, entry.value),
            ],
          ),
        ),
        Demo(
          title: 'maxLines / textOverflow',
          code: '..maxLines(2)\n'
              '..textOverflow(TextOverflow.ellipsis)',
          child: Parent(
            style: ParentStyle()..width(200),
            child: Txt(
              'Division styles widgets with a cascade of small, readable '
              'method calls instead of nested constructors.',
              style: TxtStyle()
                ..maxLines(2)
                ..textOverflow(TextOverflow.ellipsis),
            ),
          ),
        ),
        Demo(
          title: 'textDirection',
          code: '..textDirection(TextDirection.rtl)',
          child: Parent(
            style: ParentStyle()..width(200),
            child: Txt(
              'مرحبا بالعالم',
              style: TxtStyle()
                ..fontSize(18)
                ..textDirection(TextDirection.rtl),
            ),
          ),
        ),
        Demo(
          title: 'textShadow',
          code: '..textShadow(\n'
              '    color: Colors.black45,\n'
              '    blur: 4,\n'
              '    offset: Offset(2, 2),\n'
              '  )',
          child: Txt(
            _sample,
            style: TxtStyle()
              ..fontSize(24)
              ..bold()
              ..textColor(Colors.white)
              ..textShadow(
                color: Colors.black45,
                blur: 4,
                offset: const Offset(2, 2),
              ),
          ),
        ),
        Demo(
          title: 'textElevation',
          note: 'Like `elevation`, but for the glyphs.',
          code: '..textElevation(6, color: Colors.indigo)',
          child: Txt(
            _sample,
            style: TxtStyle()
              ..fontSize(24)
              ..bold()
              ..textColor(Colors.white)
              ..textElevation(6, color: Colors.indigo),
          ),
        ),
        Demo(
          title: 'Container styling on Txt',
          note: 'A `TxtStyle` also accepts every `ParentStyle` method.',
          code: 'TxtStyle()\n'
              '  ..padding(horizontal: 16, vertical: 8)\n'
              '  ..borderRadius(all: 20)\n'
              '  ..background.color(Colors.indigo)\n'
              '  ..textColor(Colors.white)',
          child: Txt(
            'Chip',
            style: TxtStyle()
              ..padding(horizontal: 16, vertical: 8)
              ..borderRadius(all: 20)
              ..background.color(Colors.indigo)
              ..textColor(Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _alignedBlock(String label, void Function(TxtStyle) align) {
    final TxtStyle style = TxtStyle()
      ..width(double.infinity)
      ..margin(bottom: 8)
      ..padding(all: 8)
      ..borderRadius(all: 6)
      ..fontSize(12)
      ..background.hex('#eceff1');
    align(style);

    return Txt('$label — Division styles widgets with a cascade.',
        style: style);
  }
}
